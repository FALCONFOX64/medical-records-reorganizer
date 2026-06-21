#!/usr/bin/env bash
# One-command setup + launch for a medical records directory.
# Usage: ./scripts/quickstart.sh [TARGET_DIR] [LLM_MODE]
#
# Example:
#   ./scripts/quickstart.sh ~/MedicalRecords claude

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${1:-$(pwd)}"
MODE="${2:-claude}"

mkdir -p "${TARGET}"
"${SCRIPT_DIR}/init-archive.sh" "${TARGET}"
"${SCRIPT_DIR}/run.sh" "${MODE}" "${TARGET}"