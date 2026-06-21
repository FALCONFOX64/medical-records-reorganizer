# Medical Records Reorganization — LLM Prompt Kit

A copy-paste prompt and bootstrap scripts for reorganizing a messy directory of medical records into a clean, durable archive — one you could hand to a doctor, lawyer, insurer, or family member without explanation.

Works with **Claude Code**, **OpenAI Codex**, or any LLM tool (paste the prompt manually).

## Quick start

```bash
# 1. Clone this repo (or copy scripts into your records folder)
git clone https://github.com/FALCONFOX64/medical-records-reorganizer.git
cd medical-records-reorganizer

# 2. Bootstrap your medical records directory
./scripts/init-archive.sh ~/MedicalRecords

# 3. Launch with your LLM CLI
cd ~/MedicalRecords
~/path/to/medical-records-reorganizer/scripts/run.sh claude
```

Or in one step:

```bash
./scripts/quickstart.sh ~/MedicalRecords claude
```

## LLM runners

| Command | What it does |
|---------|----------------|
| `./scripts/run.sh claude` | Starts Claude Code with the prompt (interactive) |
| `./scripts/run.sh codex` | Starts OpenAI Codex CLI (or `npx` fallback) |
| `./scripts/run.sh print` | Prints prompt to stdout for manual paste |
| `./scripts/run.sh clipboard` | Copies prompt to macOS clipboard (`pbcopy`) |

All runners operate on the **current working directory** (or pass a target dir as the second argument).

## How to use it (manual)

1. Install an LLM coding agent ([Claude Code](https://claude.com/claude-code), Codex, Cursor, etc.).
2. `cd` into the directory of medical records.
3. *(Recommended)* Run `./scripts/init-archive.sh` to scaffold folders and `git init` (no remote needed).
4. Run `./scripts/run.sh claude` or paste `PROMPT.md` into your tool.
5. Approve each phase before the LLM moves on. It will stop and wait between phases.

## Notes before you start

- **PHI / privacy.** These files contain Protected Health Information. Run your LLM agent **locally** — don't paste contents into web tools or upload to external services.
- **Nothing gets deleted.** Superseded versions move to `04_archive/`. Suspected duplicates only move after you confirm.
- **Optional audit phase.** If you have C-CDA / "Health Summary" bundles exported from a patient portal (Kaiser MyChart, Epic MyChart, etc.), the LLM can cross-reference loose files against them to flag redundancies. If you don't have those, skip Phase 6.

## Target archive structure

```
00_summaries/         human-facing canonical summaries (one per topic)
01_source/            raw inputs as received, subdivided by kind
  labs/               lab result exports / trend PDFs
  imaging/
    reports/          curated notes
    scans/            provider scan/report PDFs
  clinical_notes/     provider visit notes
  ed_visits/          emergency-department transcripts
  health_summaries_ccda/   C-CDA / IHE_XDM bundles, one folder per export
  timelines/          long-form synthesized timelines
  misc/               records-request paperwork, one-offs
02_extracted/         structured intermediate data (parsed CCDA, etc.)
03_deliverables/      current shareable artifacts (HTML/DOCX/PDF)
04_archive/           superseded versions — never delete, only move here
_tools/               any scripts or logs
Inbox/                landing pad for new incoming files
README.md             folder map + "where to look" table
MANIFEST.yaml         machine-readable index with provenance per file
.gitignore            excludes *.pdf / *.PDF if using git (PHI + size)
```

## The prompt

The full copy-paste prompt lives in [`PROMPT.md`](PROMPT.md). It guides the LLM through six phases:

1. **Inventory** (read-only) — catalog everything, propose taxonomy
2. **Target structure** — confirm folder layout
3. **Filename normalization** — `YYYY-MM-DD_<category>_<descriptor>.<ext>`
4. **Execute moves** — `git mv` when possible, batch by batch with approval
5. **Generate README + MANIFEST** — human and machine-readable indexes
6. **Duplication audit** (optional) — cross-reference C-CDA bundles

## What you'll end up with

- A numbered, predictable folder tree where anyone can find the current version of anything in under 30 seconds.
- ISO-dated filenames (`2025-06-20_imaging_bronchoscopy_flexible.pdf`) that sort chronologically in any tool.
- A `README.md` that explains the archive to a stranger.
- A `MANIFEST.yaml` that lets future LLM sessions (or any tool) understand provenance without re-reading every file.
- Full audit trail — nothing deleted, every supersession traceable.

## Repository contents

```
PROMPT.md                        # The reorganization prompt
README.md                        # This file
scripts/
  init-archive.sh                # Scaffold folders, .gitignore, git init
  run.sh                         # Launch prompt with Claude / Codex / print / clipboard
  quickstart.sh                  # init + run in one command
templates/
  .gitignore                     # PHI + PDF exclusions
  README.template.md             # Starter README for your archive
  MANIFEST.template.yaml         # Starter manifest schema
```

## License

MIT — use and adapt freely. Handle PHI responsibly.