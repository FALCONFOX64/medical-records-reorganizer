# Medical Records Reorganization — Claude Code Prompt

A copy-paste prompt for Claude Code that takes a messy directory of medical records and produces a clean, durable archive — one you could hand to a doctor, lawyer, insurer, or family member without explanation.

## How to use it

1. Install Claude Code (https://claude.com/claude-code) and open a terminal.
2. `cd` into the directory of medical records.
3. *(Recommended)* If it isn't already a git repo, run `git init` so file moves preserve rename history. No remote needed.
4. Start Claude Code and paste the prompt below (or run `./scripts/run.sh claude` from this repo).
5. Approve each phase before Claude moves on. Claude will stop and wait between phases.

### Quick-run scripts (optional)

This repo includes scripts to bootstrap the folder structure and launch the prompt with one command:

```bash
git clone https://github.com/FALCONFOX64/medical-records-reorganizer.git
./medical-records-reorganizer/scripts/init-archive.sh ~/MedicalRecords
cd ~/MedicalRecords
../medical-records-reorganizer/scripts/run.sh claude
```

Or all-in-one:

```bash
./medical-records-reorganizer/scripts/quickstart.sh ~/MedicalRecords claude
```

| Command | What it does |
|---------|----------------|
| `./scripts/run.sh claude` | Starts Claude Code with the prompt |
| `./scripts/run.sh codex` | Starts OpenAI Codex CLI (or `npx` fallback) |
| `./scripts/run.sh print` | Prints prompt to stdout for manual paste |
| `./scripts/run.sh clipboard` | Copies prompt to macOS clipboard |

## Notes before you start

- **PHI / privacy.** These files contain Protected Health Information. Run Claude Code locally — don't paste contents into web tools or upload to external services.
- **Nothing gets deleted.** Superseded versions move to `04_archive/`. Suspected duplicates only move after you confirm.
- **Optional audit phase.** If you have C-CDA / "Health Summary" bundles exported from a patient portal (Kaiser MyChart, Epic MyChart, etc.), Claude can cross-reference loose files against them to flag redundancies. If you don't have those, skip Phase 6.

---

## The prompt

Copy from [`PROMPT.md`](PROMPT.md), or paste this:

> I have a directory of medical records that has accumulated over years from multiple providers, patient portals, and one-off scans. It's disorganized — duplicates, inconsistent filenames, mixed file types (PDF, RTF, DOCX, MD, XLSX, XML/CCDA bundles). I want you to help me reorganize it into a clean, durable archive that I can hand to a doctor, lawyer, insurer, or family member without explanation. **Operate from the current working directory.**
>
> **Phase 1 — Inventory (read-only).** Recursively list everything. For each file, infer: date (from filename or content if obvious), document kind, source/provider, and whether it looks like a duplicate of something else. Don't move anything yet. Produce a written inventory and a proposed taxonomy. **Stop and wait for my approval before any moves.**
>
> **Phase 2 — Target structure.** Propose this layout (adjust subfolders under `01_source/` to fit what I actually have):
>
> ```
> 00_summaries/         human-facing canonical summaries (one per topic)
> 01_source/            raw inputs as received, subdivided by kind
>   labs/               lab result exports / trend PDFs
>   imaging/
>     reports/          curated notes
>     scans/            provider scan/report PDFs
>   clinical_notes/     provider visit notes
>   ed_visits/          emergency-department transcripts
>   health_summaries_ccda/   C-CDA / IHE_XDM bundles, one folder per export
>   timelines/          long-form synthesized timelines
>   misc/               records-request paperwork, one-offs
> 02_extracted/         structured intermediate data (parsed CCDA, etc.)
> 03_deliverables/      current shareable artifacts (HTML/DOCX/PDF)
> 04_archive/           superseded versions — never delete, only move here
> _tools/               any scripts or logs
> Inbox/                landing pad for new incoming files
> README.md             folder map + "where to look" table
> MANIFEST.yaml         machine-readable index with provenance per file
> .gitignore            excludes *.pdf / *.PDF if I'm using git (PHI + size)
> ```
>
> **Phase 3 — Filename normalization.** Rename dated source files to `YYYY-MM-DD_<category>_<descriptor>.<ext>`. Keep multi-event syntheses (e.g., a single doc covering many imaging studies) under their original names. Preserve original names for ambiguous-date paperwork.
>
> **Phase 4 — Execute moves.** If this is a git repo, use `git mv` so history is preserved as renames. If not, ask whether to `git init` first or use plain `mv`. Move in small, reviewable batches; show me each batch before running it.
>
> **Phase 5 — Generate `README.md` and `MANIFEST.yaml`.** README should include: a privacy/PHI notice, the folder map, a "Where to Look" table mapping common questions to file paths, source-document conventions, and a versioning/archive policy (current versions in `03_deliverables/`, superseded versions move to `04_archive/<topic>/`). MANIFEST.yaml should annotate each loose file with a `kind`: `presentation_copy`, `provider_report`, `external_provider_note`, `user_synthesis`, or `paperwork`, and note authoritative source where applicable (e.g., a CCDA bundle that supersedes a loose file).
>
> **Phase 6 (optional) — Duplication audit.** If there are C-CDA bundles, cross-reference loose files against them by date + facility. Produce an `AUDIT_REPORT_<date>.md` with confidence levels (HIGH / MEDIUM / NEEDS PDF READ) and recommendations for `04_archive/redundant/`. Recommendations only — do not move audit candidates without my explicit confirmation.
>
> **Rules throughout:**
> - Never delete a file. Superseded → `04_archive/`. Suspected duplicates → `04_archive/redundant/` only after I confirm.
> - This is PHI. Don't upload anything to external services or paste contents into web tools.
> - Stop and ask before any destructive or hard-to-reverse step.
> - Show me a plan before each phase; wait for approval before executing.

---

## What you'll end up with

- A numbered, predictable folder tree where anyone can find the current version of anything in under 30 seconds.
- ISO-dated filenames (`2025-06-20_imaging_bronchoscopy_flexible.pdf`) that sort chronologically in any tool.
- A `README.md` that explains the archive to a stranger.
- A `MANIFEST.yaml` that lets future-Claude (or any tool) understand provenance without re-reading every file.
- Full audit trail — nothing deleted, every supersession traceable.

## Repository contents

```
PROMPT.md                        # The prompt (plain text for CLI runners)
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