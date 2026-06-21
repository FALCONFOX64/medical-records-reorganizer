I have a directory of medical records that has accumulated over years from multiple providers, patient portals, and one-off scans. It's disorganized — duplicates, inconsistent filenames, mixed file types (PDF, RTF, DOCX, MD, XLSX, XML/CCDA bundles). I want you to help me reorganize it into a clean, durable archive that I can hand to a doctor, lawyer, insurer, or family member without explanation. **Operate from the current working directory.**

**Phase 1 — Inventory (read-only).** Recursively list everything. For each file, infer: date (from filename or content if obvious), document kind, source/provider, and whether it looks like a duplicate of something else. Don't move anything yet. Produce a written inventory and a proposed taxonomy. **Stop and wait for my approval before any moves.**

**Phase 2 — Target structure.** Propose this layout (adjust subfolders under `01_source/` to fit what I actually have):

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
.gitignore            excludes *.pdf / *.PDF if I'm using git (PHI + size)
```

**Phase 3 — Filename normalization.** Rename dated source files to `YYYY-MM-DD_<category>_<descriptor>.<ext>`. Keep multi-event syntheses (e.g., a single doc covering many imaging studies) under their original names. Preserve original names for ambiguous-date paperwork.

**Phase 4 — Execute moves.** If this is a git repo, use `git mv` so history is preserved as renames. If not, ask whether to `git init` first or use plain `mv`. Move in small, reviewable batches; show me each batch before running it.

**Phase 5 — Generate `README.md` and `MANIFEST.yaml`.** README should include: a privacy/PHI notice, the folder map, a "Where to Look" table mapping common questions to file paths, source-document conventions, and a versioning/archive policy (current versions in `03_deliverables/`, superseded versions move to `04_archive/<topic>/`). MANIFEST.yaml should annotate each loose file with a `kind`: `presentation_copy`, `provider_report`, `external_provider_note`, `user_synthesis`, or `paperwork`, and note authoritative source where applicable (e.g., a CCDA bundle that supersedes a loose file).

**Phase 6 (optional) — Duplication audit.** If there are C-CDA bundles, cross-reference loose files against them by date + facility. Produce an `AUDIT_REPORT_<date>.md` with confidence levels (HIGH / MEDIUM / NEEDS PDF READ) and recommendations for `04_archive/redundant/`. Recommendations only — do not move audit candidates without my explicit confirmation.

**Rules throughout:**
- Never delete a file. Superseded → `04_archive/`. Suspected duplicates → `04_archive/redundant/` only after I confirm.
- This is PHI. Don't upload anything to external services or paste contents into web tools.
- Stop and ask before any destructive or hard-to-reverse step.
- Show me a plan before each phase; wait for approval before executing.