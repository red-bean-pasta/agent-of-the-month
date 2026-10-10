#!/usr/bin/env bash

set -eu -o pipefail

Script_Dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Repo_Root="$(cd "$Script_Dir/.." && pwd)"
Skills_Root="$Repo_Root/skills"

Dry_Run=false
List_Only=false
Force=false
Auto_All=false
declare -a Selected_Skills=()
declare -a Excluded_Skills=()
declare -a Skills_To_Sync=()
declare -a Target_Names=()
declare -a Target_Paths=()

# ANSI color codes
R=$'\e[31m'
G=$'\e[32m'
B=$'\e[34m'
Y=$'\e[33m'
C=$'\e[36m'
I=$'\e[0m'

Info()    { echo >&2 "${B}INFO:${I} $*"; }
Success() { echo >&2 "${G}SUCCESS:${I} $*"; }
Warn()    { echo >&2 "${Y}WARNING:${I} $*"; }
Die()     { echo >&2 "${R}ERROR:${I} $*"; exit 1; }

Tilde()   { echo "${1/#"$HOME"/\~}"; }

PrintHelp() {
  cat >&2 <<EOF
Usage: $(basename "$0") [OPTIONS]

Scan AI agent state directories on Linux or sync directly to specified paths,
synchronizing skills/.

Options:
  -h, --help            Show this help message and exit
  -n, --dry-run         Show actions without copying any files
  -l, --list            Scan and print detected agent state directories and exit
  -f, --force           Overwrite existing skills in target directories
  -a, --all             Install to all detected agents in auto-scan mode
  -s, --skill [SKILL...] Specific skill(s) to sync (defaults to all under skills/)
  -e, --exclude [SKILL...]  Skill(s) to exclude from sync
  -d, --dest  [PATH...]  Explicit target directory/directories (skips auto-scan)
EOF
}

ParseArgs() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help)    PrintHelp; exit 0 ;;
      -n | --dry-run) Dry_Run=true; shift ;;
      -l | --list)    List_Only=true; shift ;;
      -f | --force)   Force=true; shift ;;
      -a | --all)     Auto_All=true; shift ;;
      -s | --skill | --skills)
        shift
        local count=0
        while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
          Selected_Skills+=("$1"); ((count++)) || true; shift
        done
        (( count > 0 )) || Die "Option -s requires at least one skill name."
        ;;
      -e | --exclude | --ignore)
        shift
        local count=0
        while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
          Excluded_Skills+=("$1"); ((count++)) || true; shift
        done
        (( count > 0 )) || Die "Option -e requires at least one skill name."
        ;;
      -d | --dest | --dir | --target)
        shift
        local count=0
        while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
          local expanded="${1/#\~/"$HOME"}"
          local clean_path="${expanded%/}"
          if [[ "$(basename "$clean_path")" != "skills" ]]; then
            Warn "Target '$(Tilde "$clean_path")' does not end in 'skills/'. Skills will be installed directly into this directory."
          fi
          Target_Names+=("$1")
          Target_Paths+=("$clean_path")
          ((count++)) || true; shift
        done
        (( count > 0 )) || Die "Option -d requires at least one target directory."
        ;;
      --) shift; while [[ $# -gt 0 ]]; do Target_Names+=("$1"); Target_Paths+=("${1/#\~/"$HOME"}"); shift; done; break ;;
      -*) Die "Unknown option: $1\n$(PrintHelp)" ;;
      *)  Die "Unexpected argument: $1. Use -s to specify skills and -d to specify targets." ;;
    esac
  done
}

AddCandidate() {
  local name="$1" path="${2%/}"
  local existing
  for existing in "${Target_Paths[@]:-}"; do
    [[ "$existing" == "$path" ]] && return 0
  done
  Target_Names+=("$name")
  Target_Paths+=("$path")
}

ScanStateDirectories() {
  [[ -d "$HOME/.codex" ]] && AddCandidate "Codex" "$HOME/.codex/skills"
  [[ -d "$HOME/.claude" ]] && AddCandidate "Claude" "$HOME/.claude/skills"
  [[ -d "$HOME/.copilot" ]] && AddCandidate "GitHub Copilot" "$HOME/.copilot/skills"
  if [[ -d "$HOME/.gemini/config" || -d "$HOME/.gemini" ]]; then
    AddCandidate "Antigravity" "$HOME/.gemini/config/skills"
  fi
}

CollectSkillsToSync() {
  [[ -d "$Skills_Root" ]] || Die "Skills directory not found at $Skills_Root"

  if (( ${#Selected_Skills[@]} == 0 )); then
    local skill_path
    for skill_path in "$Skills_Root"/*; do
      [[ -d "$skill_path" ]] && Skills_To_Sync+=("$(basename "$skill_path")")
    done
    (( ${#Skills_To_Sync[@]} > 0 )) || Die "No skills found under $Skills_Root"
  else
    local s missing=0
    for s in "${Selected_Skills[@]}"; do
      if [[ ! -d "$Skills_Root/$s" ]]; then
        echo >&2 "${R}ERROR:${I} Skill '$s' not found under $(Tilde "$Skills_Root")"
        missing=1
      elif [[ ! " ${Skills_To_Sync[*]:-} " =~ " ${s} " ]]; then
        Skills_To_Sync+=("$s")
      fi
    done
    (( missing == 0 )) || exit 1
  fi

  # Apply exclusion (forgiving: unfound excluded skills are ignored)
  if (( ${#Excluded_Skills[@]} > 0 )); then
    local -a filtered=()
    for s in "${Skills_To_Sync[@]}"; do
      local excluded=false
      local ex
      for ex in "${Excluded_Skills[@]}"; do
        if [[ "$s" == "$ex" ]]; then
          excluded=true
          break
        fi
      done
      if [[ "$excluded" == false ]]; then
        filtered+=("$s")
      fi
    done
    Skills_To_Sync=("${filtered[@]:-}")
  fi
}

SyncSkillDir() {
  local src="$1" dst="$2"
  if [[ "$Dry_Run" == true ]]; then
    echo >&2 "  [dry-run] mkdir -p \"$dst\""
    echo >&2 "  [dry-run] rsync -ac --delete \"$src/\" \"$dst/\""
  else
    mkdir -p "$dst"
    if command -v rsync >/dev/null 2>&1; then
      rsync -ac --delete "$src/" "$dst/"
    else
      rm -rf "${dst:?}" && cp -r "$src" "$dst"
    fi
  fi
}

CopySkillsToTarget() {
  local name="$1" dest_skills="$2"

  Info "Installing skills to ${name} -> $(Tilde "$dest_skills")"

  local skill
  for skill in "${Skills_To_Sync[@]}"; do
    local src="$Skills_Root/$skill"
    local dst="$dest_skills/$skill"

    if [[ -d "$dst" ]]; then
      if [[ "$Force" != true ]]; then
        Warn "Skill '${skill}' already exists at $(Tilde "$dst"); skipping."
        continue
      fi
      Warn "Skill '${skill}' already exists at $(Tilde "$dst"); overwriting (-f specified)."
    fi

    SyncSkillDir "$src" "$dst"
  done

  Success "Processed skills for ${name} ($(Tilde "$dest_skills"))"
}

PromptTargetSelection() {
  local total=${#Target_Names[@]}
  (( total > 0 )) || { Warn "No agent state directories detected on this machine."; exit 0; }

  echo >&2 "Available installation targets:"
  local i
  for (( i=0; i<total; i++ )); do
    echo >&2 "  ${C}$(( i + 1 ))${I}. ${Target_Names[$i]}: $(Tilde "${Target_Paths[$i]}")/"
  done
  echo >&2 "  ${C}a${I}. All"
  echo >&2 "  ${C}q${I}. Quit without installing"
  echo >&2 ""

  local choice=""
  read -rp "Where would you install the skills to: " choice >&2 || true
  echo "$choice"
}

Main() {
  ParseArgs "$@"
  CollectSkillsToSync

  local choice=""
  if (( ${#Target_Paths[@]} > 0 )); then
    # Explicit target mode: auto-scan is disabled, -a takes no effect
    local p
    for p in "${Target_Paths[@]}"; do
      [[ -d "$p" ]] || Die "Target directory does not exist: $(Tilde "$p")"
    done
    choice="a"
  else
    ScanStateDirectories
    if [[ "$Auto_All" == true ]]; then
      choice="a"
    fi
  fi

  if [[ "$List_Only" == true ]]; then
    echo >&2 "Detected agent state directories:"
    local i
    for (( i=0; i<${#Target_Names[@]}; i++ )); do
      echo >&2 "  ${Target_Names[$i]}: $(Tilde "${Target_Paths[$i]}")/"
    done
    exit 0
  fi

  if [[ -z "$choice" ]]; then
    choice="$(PromptTargetSelection)"
  fi

  local normalized="${choice//,/ }"
  local raw_tokens=($normalized)
  (( ${#raw_tokens[@]} > 0 )) || { echo >&2 "Operation cancelled. Exiting."; exit 0; }

  # If q is specified anywhere, exit
  for token in "${raw_tokens[@]}"; do
    if [[ "$token" =~ ^(q|Q|quit)$ ]]; then
      echo >&2 "Operation cancelled. Exiting."
      exit 0
    fi
  done

  # If a is specified anywhere, select all
  local has_all=false
  for token in "${raw_tokens[@]}"; do
    if [[ "$token" =~ ^(a|A|all)$ ]]; then
      has_all=true
      break
    fi
  done

  local targets=()
  if [[ "$has_all" == true ]]; then
    for (( i=0; i<${#Target_Names[@]}; i++ )); do targets+=("$i"); done
  else
    for token in "${raw_tokens[@]}"; do
      if [[ "$token" =~ ^[0-9]+$ ]] && (( token >= 1 && token <= ${#Target_Names[@]} )); then
        local idx=$(( token - 1 ))
        if [[ ! " ${targets[*]:-} " =~ " ${idx} " ]]; then
          targets+=("$idx")
        fi
      else
        Die "Invalid selection: '$token'. Please run again."
      fi
    done
  fi

  echo >&2 ""
  local idx
  for idx in "${targets[@]}"; do
    CopySkillsToTarget "${Target_Names[$idx]}" "${Target_Paths[$idx]}"
  done

  echo >&2 ""
  Success "All skill synchronization tasks completed."
}

Main "$@"
