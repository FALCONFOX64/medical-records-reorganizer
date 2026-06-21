#!/usr/bin/env bash
# Launch the medical-records reorganization prompt with a supported LLM CLI.
#
# Usage:
#   ./scripts/run.sh [claude|codex|print|clipboard] [TARGET_DIR]
#
# Examples:
#   cd ~/MedicalRecords && ~/code/medical-records-reorganizer/scripts/run.sh claude
#   ./scripts/run.sh print
#   ./scripts/run.sh clipboard ~/MedicalRecords

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROMPT_FILE="${REPO_ROOT}/PROMPT.md"

MODE="${1:-claude}"
TARGET="${2:-$(pwd)}"

if [[ ! -f "${PROMPT_FILE}" ]]; then
  echo "Error: PROMPT.md not found at ${PROMPT_FILE}" >&2
  exit 1
fi

if [[ ! -d "${TARGET}" ]]; then
  echo "Error: directory does not exist: ${TARGET}" >&2
  exit 1
fi

cd "${TARGET}"

PROMPT_TEXT="$(cat "${PROMPT_FILE}")"

print_banner() {
  cat <<EOF
Medical Records Reorganization
Working directory: ${TARGET}
Prompt source:     ${PROMPT_FILE}
LLM runner:        ${MODE}

PHI reminder: run locally. Do not paste file contents into web tools.
EOF
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

run_claude() {
  if ! has_cmd claude; then
    echo "Error: 'claude' CLI not found. Install Claude Code: https://claude.com/claude-code" >&2
    echo "Fallback: ./scripts/run.sh print" >&2
    exit 1
  fi
  print_banner
  echo ""
  echo "Starting Claude Code interactive session with the reorganization prompt..."
  echo "Approve each phase when Claude pauses."
  echo ""
  # Interactive session — prompt passed as initial message
  exec claude "${PROMPT_TEXT}"
}

run_codex() {
  if has_cmd codex; then
    print_banner
    echo ""
    echo "Starting Codex with the reorganization prompt..."
    exec codex "${PROMPT_TEXT}"
  fi

  if has_cmd npx; then
    print_banner
    echo ""
    echo "Codex CLI not on PATH; trying npx @openai/codex ..."
    exec npx --yes @openai/codex "${PROMPT_TEXT}"
  fi

  echo "Error: Codex CLI not found. Install with: npm install -g @openai/codex" >&2
  echo "Fallback: ./scripts/run.sh print" >&2
  exit 1
}

run_print() {
  print_banner
  echo ""
  echo "----- PROMPT START -----"
  echo "${PROMPT_TEXT}"
  echo "----- PROMPT END -----"
}

run_clipboard() {
  if ! has_cmd pbcopy; then
    echo "Error: pbcopy not available (macOS only). Use: ./scripts/run.sh print" >&2
    exit 1
  fi
  print_banner
  printf '%s' "${PROMPT_TEXT}" | pbcopy
  echo ""
  echo "Prompt copied to clipboard. Paste into your LLM tool and set cwd to:"
  echo "  ${TARGET}"
}

case "${MODE}" in
  claude|cc)
    run_claude
    ;;
  codex|openai)
    run_codex
    ;;
  print|cat|show)
    run_print
    ;;
  clipboard|copy|pbcopy)
    run_clipboard
    ;;
  help|-h|--help)
    cat <<EOF
Usage: $(basename "$0") [MODE] [TARGET_DIR]

Modes:
  claude      Claude Code interactive session (default)
  codex       OpenAI Codex CLI (or npx fallback)
  print       Print prompt to stdout for manual paste
  clipboard   Copy prompt to macOS clipboard (pbcopy)

TARGET_DIR defaults to the current working directory.

Before running:
  ./scripts/init-archive.sh [TARGET_DIR]
EOF
    ;;
  *)
    echo "Error: unknown mode '${MODE}'. Use: claude | codex | print | clipboard" >&2
    exit 1
    ;;
esac