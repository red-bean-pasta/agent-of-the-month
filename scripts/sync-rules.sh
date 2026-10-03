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

PrintHelp() {
  cat >&2 <<EOF
Usage: $(basename "$0") [OPTIONS]

Scan AI agent state directories on Linux and synchronize AGENT.md and subrules/.

Options:
  -h, --help      Show this help message and exit
  -n, --dry-run   Show actions without copying any files
  -l, --list      Scan and print detected agent state directories and exit
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
      *)
        LogError "Unknown option: $1"
        PrintHelp
        exit 1
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
  # 1. OpenAI Codex
  if [[ -d "$HOME/.codex" ]]; then
    AddAgentCandidate "Codex" "$HOME/.codex"
  fi

  # 2. Google Antigravity CLI
  if [[ -d "$HOME/.gemini/antigravity-cli" ]]; then
    AddAgentCandidate "Antigravity CLI" "$HOME/.gemini/antigravity-cli"
  fi

  # 3. Google Antigravity ACP
  if [[ -d "$HOME/.gemini/antigravity-acp" ]]; then
    AddAgentCandidate "Antigravity ACP" "$HOME/.gemini/antigravity-acp"
  fi

  # 4. Google Antigravity Global Config
  if [[ -d "$HOME/.gemini/config" ]]; then
    AddAgentCandidate "Antigravity Global Config" "$HOME/.gemini/config"
  fi

  # 5. Legacy Gemini CLI (if separate directory exists)
  if [[ -d "$HOME/.gemini/gemini" ]]; then
    AddAgentCandidate "Gemini CLI" "$HOME/.gemini/gemini"
  fi

  # 6. Claude Code CLI
  if [[ -d "$HOME/.claude" ]]; then
    AddAgentCandidate "Claude" "$HOME/.claude"
  fi

  # 7. GitHub Copilot CLI
  if [[ -d "$HOME/.copilot" ]]; then
    AddAgentCandidate "GitHub Copilot" "$HOME/.copilot"
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
  for rule_dir in "subrules" "rules" "instructions"; do
    if [[ -d "$dir/$rule_dir" ]] && [[ -n "$(ls -A "$dir/$rule_dir" 2>/dev/null)" ]]; then
      found+=("$rule_dir/")
    fi
  done

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
  Log "  ${C}n${I}. All without rules"
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

CopyRulesToTarget() {
  local target_name="$1"
  local target_path="$2"

  LogInfo "Installing to ${target_name} -> $(FormatTilde "$target_path")"

  if [[ "$Dry_Run" == true ]]; then
    Log "  [dry-run] mkdir -p \"$target_path\""
    Log "  [dry-run] cp \"$Repo_Root/AGENT.md\" \"$target_path/AGENT.md\""
    Log "  [dry-run] rsync -ac --delete \"$Repo_Root/subrules/\" \"$target_path/subrules/\""
    return 0
  fi

  mkdir -p "$target_path"
  cp "$Repo_Root/AGENT.md" "$target_path/AGENT.md"

  if command -v rsync >/dev/null 2>&1; then
    mkdir -p "$target_path/subrules"
    rsync -ac --delete "$Repo_Root/subrules/" "$target_path/subrules/"
  else
    rm -rf "$target_path/subrules"
    cp -r "$Repo_Root/subrules" "$target_path/subrules"
  fi

  LogSuccess "Successfully installed rules to ${target_name} ($(FormatTilde "$target_path"))"
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
  elif [[ "$choice" =~ ^(n|N)$ ]]; then
    local i; for (( i=0; i<total; i++ )); do
      if [[ "${Agent_Has_Rules[$i]}" == "false" ]]; then
        targets_to_install+=("$i")
      fi
    done
    if (( ${#targets_to_install[@]} == 0 )); then
      LogWarning "All discovered agents already have rules. No targets selected."
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
  if [[ ! -f "$Repo_Root/AGENT.md" ]]; then
    LogError "AGENT.md not found at $Repo_Root/AGENT.md"
    exit 1
  fi

  if [[ ! -d "$Repo_Root/subrules" ]]; then
    LogError "subrules/ directory not found at $Repo_Root/subrules"
    exit 1
  fi

  ScanStateDirectories
  AnalyzeRules

  DisplayScanResults
  DisplayExistingRules

  if [[ "$List_Only" == true ]]; then
    exit 0
  fi

  local choice
  choice=$(PromptTargetSelection)
  ExecuteInstall "$choice"
}

Main "$@"
