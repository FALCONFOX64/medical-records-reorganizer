#!/usr/bin/env bash
# Bootstrap a medical-records directory for LLM-guided reorganization.
# Usage: ./scripts/init-archive.sh [TARGET_DIR]
#   TARGET_DIR defaults to the current working directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TARGET="${1:-$(pwd)}"

if [[ ! -d "${TARGET}" ]]; then
  echo "Error: directory does not exist: ${TARGET}" >&2
  exit 1
fi

cd "${TARGET}"

echo "Initializing medical records archive in: ${TARGET}"

# Folder scaffold (Phase 2 target structure)
DIRS=(
  "00_summaries"
  "01_source/labs"
  "01_source/imaging/reports"
  "01_source/imaging/scans"
  "01_source/clinical_notes"
  "01_source/ed_visits"
  "01_source/health_summaries_ccda"
  "01_source/timelines"
  "01_source/misc"
  "02_extracted"
  "03_deliverables"
  "04_archive/redundant"
  "_tools/logs"
  "Inbox"
)

for dir in "${DIRS[@]}"; do
  mkdir -p "${dir}"
done

# .gitignore (PHI + large files)
if [[ ! -f .gitignore ]]; then
  cp "${REPO_ROOT}/templates/.gitignore" .gitignore
  echo "Created .gitignore"
else
  echo ".gitignore already exists — left unchanged"
fi

# Optional starter docs (only if missing)
if [[ ! -f README.md ]]; then
  cp "${REPO_ROOT}/templates/README.template.md" README.md
  echo "Created README.md from template"
fi

if [[ ! -f MANIFEST.yaml ]]; then
  cp "${REPO_ROOT}/templates/MANIFEST.template.yaml" MANIFEST.yaml
  echo "Created MANIFEST.yaml from template"
fi

# Git init for rename history (recommended, no remote required)
if [[ ! -d .git ]]; then
  git init -q
  git add .gitignore README.md MANIFEST.yaml Inbox/.gitkeep 2>/dev/null || true
  touch Inbox/.gitkeep _tools/logs/.gitkeep
  git add Inbox/.gitkeep _tools/logs/.gitkeep 2>/dev/null || true
  git commit -q -m "Initialize medical records archive scaffold" 2>/dev/null || true
  echo "Initialized git repository (local only, no remote)"
else
  touch Inbox/.gitkeep _tools/logs/.gitkeep 2>/dev/null || true
  echo "Git repository already present — left unchanged"
fi

cat <<EOF

Archive scaffold ready.

Next steps:
  1. Move or copy your existing medical files into this directory (or work here in place).
  2. Run the reorganization prompt with your LLM CLI:

       ${REPO_ROOT}/scripts/run.sh claude
       ${REPO_ROOT}/scripts/run.sh print    # copy prompt to clipboard / stdout

  3. Approve each phase before the LLM executes moves.

EOF