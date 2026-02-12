#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only process plan files
PLANS_DIR="${QMD_PLANS_DIR:-.claude/plans}"
PLANS_DIR="${PLANS_DIR%/}"

if [[ -z "$FILE_PATH" ]] || [[ "$FILE_PATH" != *"${PLANS_DIR}/"* ]] || [[ "$FILE_PATH" != *.md ]]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0

command -v qmd &>/dev/null || exit 0

if [[ "${QMD_PLAN_SYNC_VERBOSE:-0}" == "1" ]]; then
  qmd update
  qmd embed
else
  qmd update 2>/dev/null
  qmd embed 2>/dev/null
fi

exit 0
