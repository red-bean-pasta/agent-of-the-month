#!/usr/bin/env bash

set -eu -o pipefail

Target_Dir="${1:-.aiassistant}"

mkdir -p "$Target_Dir/notebook"
mkdir -p "$Target_Dir/historybook"
mkdir -p "$Target_Dir/tmp"

if [[ ! -f "$Target_Dir/README.md" ]]; then
  Script_Dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  Template_Path="$Script_Dir/../resources/templates/readme.md"
  if [[ -f "$Template_Path" ]]; then
    cp "$Template_Path" "$Target_Dir/README.md"
  fi
fi

echo "Initialized .aiassistant memory layout at: $Target_Dir"
