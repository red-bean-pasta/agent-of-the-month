#!/usr/bin/env bash

set -eu -o pipefail

Script_Dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Repo_Root="$(cd "$Script_Dir/.." && pwd)"

# ANSI color codes
R=$'\e[0;31m'
G=$'\e[0;32m'
B=$'\e[0;34m'
Y=$'\e[0;33m'
C=$'\e[0;36m'
I=$'\e[0m' # Reset/Init

declare -a Agent_Names=()
declare -a Agent_Paths=()
declare -a Agent_Has_Rules=()
declare -a Agent_Rule_Details=()

Dry_Run=false
List_Only=false
Auto_Mode=""
declare -a Explicit_Paths=()

PrintHelp() {
  cat >&2 <<EOF
Usage: $(basename "$0") [OPTIONS] [PATH...]

Scan AI agent state directories on Linux or sync directly to specified paths,
synchronizing AGENTS.md and skills/.

Arguments:
  [PATH...]             Explicit target directories (skips auto-scan, defaults to -a)

Options:
  -h, --help            Show this help message and exit
  -n, --dry-run         Show actions without copying any files
  -l, --list            Scan and print detected agent state directories and exit
  -a, --all             Install to all target directories without prompting
  -w, --without-rules   Install only to target directories without existing rules without prompting
EOF
}

Log() {
  echo >&2 "$@"
}

LogInfo() {
  echo >&2 "${B}INFO:${I} $*"
}

LogSuccess() {
  echo >&2 "${G}SUCCESS:${I} $*"
}

LogWarning() {
  echo >&2 "${Y}WARNING:${I} $*"
}

LogError() {
  echo >&2 "${R}ERROR:${I} $*"
}

Trim() {
  if [[ -n "${1+x}" ]]; then
    sed -E 's/^[[:space:]]+//;s/[[:space:]]+$//' <<< "$1"
  elif [[ ! -t 0 ]]; then
    sed -E 's/^[[:space:]]+//;s/[[:space:]]+$//'
  fi
}

FormatTilde() {
  local p="$1"
  if [[ "$p" == "$HOME"* ]]; then
    echo "~${p#"$HOME"}"
  else
    echo "$p"
  fi
}

ExpandTilde() {
  local p="$1"
  if [[ "$p" == "~"* ]]; then
    echo "$HOME${p#\~}"
  else
    echo "$p"
  fi
}

ParseArgs() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help)
        PrintHelp
        exit 0
        ;;
      -n | --dry-run)
        Dry_Run=true
        shift
        ;;
      -l | --list)
        List_Only=true
        shift
        ;;
      -a | --all)
        Auto_Mode="all"
        shift
        ;;
      -w | --without-rules)
        Auto_Mode="without-rules"
        shift
        ;;
      --)
        shift
        while [[ $# -gt 0 ]]; do
          Explicit_Paths+=("$1")
          shift
        done
        break
        ;;
      -*)
        LogError "Unknown option: $1"
        PrintHelp
        exit 1
        ;;
      *)
        Explicit_Paths+=("$1")
        shift
        ;;
    esac
  done
}

AddAgentCandidate() {
  local name="$1"
  local path="$2"

  # Normalize path removing trailing slash for consistency
  path="${path%/}"

  # Avoid duplicate paths
  local existing
  for existing in "${Agent_Paths[@]:-}"; do
    if [[ "$existing" == "$path" ]]; then
      return 0
    fi
  done

  Agent_Names+=("$name")
  Agent_Paths+=("$path")
}

ScanStateDirectories() {
  # OpenAI Codex
  if [[ -d "$HOME/.codex" ]]; then
    AddAgentCandidate "Codex" "$HOME/.codex"
  fi

  # Claude Code CLI
  if [[ -d "$HOME/.claude" ]]; then
    AddAgentCandidate "Claude" "$HOME/.claude"
  fi

  # GitHub Copilot CLI
  if [[ -d "$HOME/.copilot" ]]; then
    AddAgentCandidate "GitHub Copilot" "$HOME/.copilot"
  fi

  # Google Antigravity
  if [[ -d "$HOME/.gemini/config" ]] || [[ -d "$HOME/.gemini" ]]; then
    AddAgentCandidate "Antigravity" "$HOME/.gemini/config"
  fi

  if [[ -d "$HOME/.gemini/antigravity-acp" ]]; then
    LogWarning "Antigravity ACP cannot be synced globally; rules must be project-level: sync-rules.sh <project-repo>"
  fi
}

InspectDirectoryRules() {
  local dir="$1"
  local found=()

  if [[ ! -d "$dir" ]]; then
    echo "none"
    return 0
  fi

  # Check for conventional agent rule files
  local file
  for file in "AGENT.md" "AGENTS.md" "CLAUDE.md" "GEMINI.md" ".cursorrules"; do
    if [[ -f "$dir/$file" ]]; then
      found+=("$file")
    fi
  done

  # Check for rule directories
  local rule_dir
  for rule_dir in "rules" "instructions"; do
    if [[ -d "$dir/$rule_dir" ]] && [[ -n "$(ls -A "$dir/$rule_dir" 2>/dev/null)" ]]; then
      found+=("$rule_dir/")
    fi
  done

  # Check for skill directories
  if [[ -d "$dir/skills" ]] && [[ -n "$(ls -A "$dir/skills" 2>/dev/null)" ]]; then
    found+=("skills/")
  elif [[ -d "$dir/.agents/skills" ]] && [[ -n "$(ls -A "$dir/.agents/skills" 2>/dev/null)" ]]; then
    found+=(".agents/skills/")
  fi

  # Check for any .mdc files
  if compgen -G "$dir/*.mdc" >/dev/null 2>&1; then
    found+=("*.mdc")
  fi

  if (( ${#found[@]} > 0 )); then
    echo "${found[*]}"
  else
    echo "none"
  fi
}

AnalyzeRules() {
  local i path details
  for (( i=0; i<${#Agent_Paths[@]}; i++ )); do
    path="${Agent_Paths[$i]}"
    details=$(InspectDirectoryRules "$path")
    if [[ "$details" != "none" ]]; then
      Agent_Has_Rules+=("true")
      Agent_Rule_Details+=("$details")
    else
      Agent_Has_Rules+=("false")
      Agent_Rule_Details+=("")
    fi
  done
}

DisplayScanResults() {
  Log "Scan result:"
  local i name path formatted_path
  for (( i=0; i<${#Agent_Names[@]}; i++ )); do
    name="${Agent_Names[$i]}"
    path="${Agent_Paths[$i]}"
    formatted_path="$(FormatTilde "$path")/"
    Log "  ${name}: ${formatted_path}"
  done
  Log ""
}

DisplayExistingRules() {
  local has_any=false
  local i
  for (( i=0; i<${#Agent_Names[@]}; i++ )); do
    if [[ "${Agent_Has_Rules[$i]}" == "true" ]]; then
      has_any=true
      break
    fi
  done

  if [[ "$has_any" == true ]]; then
    Log "Found rules at:"
    for (( i=0; i<${#Agent_Names[@]}; i++ )); do
      if [[ "${Agent_Has_Rules[$i]}" == "true" ]]; then
        Log "  ${Agent_Names[$i]} (${Agent_Rule_Details[$i]})"
      fi
    done
    Log ""
  fi
}

PromptTargetSelection() {
  local total=${#Agent_Names[@]}
  if (( total == 0 )); then
    LogWarning "No agent state directories detected on this machine."
    exit 0
  fi

  Log "Available installation targets:"
  local i idx
  for (( i=0; i<total; i++ )); do
    idx=$(( i + 1 ))
    local rule_badge=""
    if [[ "${Agent_Has_Rules[$i]}" == "true" ]]; then
      rule_badge=" ${Y}[has rules: ${Agent_Rule_Details[$i]}]${I}"
    fi
    Log "  ${C}${idx}${I}. ${Agent_Names[$i]}${rule_badge}"
  done

  Log "  ${C}a${I}. All"
  Log "  ${C}w${I}. All without rules"
  Log "  ${C}q${I}. Quit without installing"
  Log ""

  local choice=""
  if [[ -t 0 ]]; then
    read -rp "Where would you install the rules to: " choice >&2
  elif read -r choice; then
    :
  elif [[ -e /dev/tty ]]; then
    read -rp "Where would you install the rules to: " choice < /dev/tty >&2
  else
    LogError "No input stream available for prompt."
    exit 1
  fi

  choice=$(Trim "$choice")
  echo "$choice"
}

DetermineSkillsDir() {
  local target_path="$1"
  if [[ -d "$target_path/.agents" ]] || [[ -d "$target_path/.git" ]]; then
    echo "$target_path/.agents/skills"
  else
    echo "$target_path/skills"
  fi
}

CopyRulesToTarget() {
  local target_name="$1"
  local target_path="$2"
  local skills_dir
  skills_dir="$(DetermineSkillsDir "$target_path")"

  LogInfo "Installing to ${target_name} -> $(FormatTilde "$target_path")"

  if [[ "$Dry_Run" == true ]]; then
    Log "  [dry-run] mkdir -p \"$target_path\""
    Log "  [dry-run] cp \"$Repo_Root/AGENTS.md\" \"$target_path/AGENTS.md\""
    if [[ -d "$Repo_Root/skills" ]]; then
      local skill_path
      for skill_path in "$Repo_Root/skills"/*; do
        if [[ -d "$skill_path" ]]; then
          local skill_name
          skill_name="$(basename "$skill_path")"
          Log "  [dry-run] mkdir -p \"$skills_dir/$skill_name\""
          Log "  [dry-run] rsync -ac --delete \"$skill_path/\" \"$skills_dir/$skill_name/\""
        fi
      done
    fi
    return 0
  fi

  mkdir -p "$target_path"
  cp "$Repo_Root/AGENTS.md" "$target_path/AGENTS.md"

  if [[ -d "$Repo_Root/skills" ]]; then
    local skill_path
    for skill_path in "$Repo_Root/skills"/*; do
      if [[ -d "$skill_path" ]]; then
        local skill_name
        skill_name="$(basename "$skill_path")"
        mkdir -p "$skills_dir/$skill_name"
        if command -v rsync >/dev/null 2>&1; then
          rsync -ac --delete "$skill_path/" "$skills_dir/$skill_name/"
        else
          rm -rf "$skills_dir/$skill_name"
          cp -r "$skill_path" "$skills_dir/$skill_name"
        fi
      fi
    done
  fi

  LogSuccess "Successfully installed rules and skills to ${target_name} ($(FormatTilde "$target_path"))"
}

ExecuteInstall() {
  local choice="$1"
  local total=${#Agent_Names[@]}

  if [[ "$choice" =~ ^(q|Q|quit)$ || -z "$choice" ]]; then
    Log "Operation cancelled. Exiting."
    exit 0
  fi

  local targets_to_install=()

  if [[ "$choice" =~ ^(a|A)$ ]]; then
    local i; for (( i=0; i<total; i++ )); do
      targets_to_install+=("$i")
    done
  elif [[ "$choice" =~ ^(w|W)$ ]]; then
    local i; for (( i=0; i<total; i++ )); do
      if [[ "${Agent_Has_Rules[$i]}" == "false" ]]; then
        targets_to_install+=("$i")
      fi
    done
    if (( ${#targets_to_install[@]} == 0 )); then
      LogWarning "All discovered targets already have rules. No targets selected."
      exit 0
    fi
  elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= total )); then
    local selected_idx=$(( choice - 1 ))
    targets_to_install+=("$selected_idx")
  else
    LogError "Invalid selection: '$choice'. Please run again."
    exit 1
  fi

  Log ""
  local target_idx
  for target_idx in "${targets_to_install[@]}"; do
    CopyRulesToTarget "${Agent_Names[$target_idx]}" "${Agent_Paths[$target_idx]}"
  done

  Log ""
  LogSuccess "All rule synchronization tasks completed."
}

Main() {
  ParseArgs "$@"

  # Validate source files exist
  if [[ ! -f "$Repo_Root/AGENTS.md" ]]; then
    LogError "AGENTS.md not found at $Repo_Root/AGENTS.md"
    exit 1
  fi

  if [[ ! -d "$Repo_Root/skills" ]]; then
    LogError "skills/ directory not found at $Repo_Root/skills"
    exit 1
  fi

  if (( ${#Explicit_Paths[@]} > 0 )); then
    # Path mode: validate that all specified directories exist before any installation
    local p expanded
    for p in "${Explicit_Paths[@]}"; do
      expanded=$(ExpandTilde "$p")
      if [[ ! -d "$expanded" ]]; then
        LogError "Target directory does not exist: $p ($expanded)"
        exit 1
      fi
    done

    # Add validated paths as targets
    for p in "${Explicit_Paths[@]}"; do
      expanded=$(ExpandTilde "$p")
      AddAgentCandidate "$p" "$expanded"
    done

    # Path mode defaults to -a (all) unless another auto-mode was specified
    if [[ -z "$Auto_Mode" ]]; then
      Auto_Mode="all"
    fi
  else
    ScanStateDirectories
  fi

  AnalyzeRules

  DisplayScanResults
  DisplayExistingRules

  if [[ "$List_Only" == true ]]; then
    exit 0
  fi

  local choice=""
  if [[ "$Auto_Mode" == "all" ]]; then
    choice="a"
  elif [[ "$Auto_Mode" == "without-rules" ]]; then
    choice="w"
  else
    choice=$(PromptTargetSelection)
  fi

  ExecuteInstall "$choice"
}

Main "$@"
