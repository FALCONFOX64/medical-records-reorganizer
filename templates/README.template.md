# Medical Records Archive

> **PHI Notice:** This directory contains Protected Health Information (PHI).
> Handle according to HIPAA and applicable law. Do not upload to public services
> or share without appropriate authorization.

## Folder Map

| Path | Purpose |
|------|---------|
| `00_summaries/` | Human-facing canonical summaries (one per topic) |
| `01_source/` | Raw inputs as received, subdivided by kind |
| `02_extracted/` | Structured intermediate data (parsed CCDA, etc.) |
| `03_deliverables/` | Current shareable artifacts (HTML/DOCX/PDF) |
| `04_archive/` | Superseded versions — nothing is deleted |
| `_tools/` | Scripts and local logs |
| `Inbox/` | Landing pad for new incoming files |

## Where to Look

| Question | Start here |
|----------|------------|
| Latest lab results | `03_deliverables/` or `01_source/labs/` |
| Imaging reports | `01_source/imaging/reports/` |
| Visit / clinical notes | `01_source/clinical_notes/` |
| Emergency visits | `01_source/ed_visits/` |
| Portal health summaries (C-CDA) | `01_source/health_summaries_ccda/` |
| Shareable packet for a doctor | `03_deliverables/` |
| Older / replaced versions | `04_archive/<topic>/` |

## Source Document Conventions

- Dated files: `YYYY-MM-DD_<category>_<descriptor>.<ext>`
- Multi-event syntheses keep descriptive original names
- Ambiguous-date paperwork keeps original filenames

## Versioning Policy

- **Current** versions live in `03_deliverables/` (or the appropriate `01_source/` subfolder).
- **Superseded** versions move to `04_archive/<topic>/` — never deleted.
- **Suspected duplicates** move to `04_archive/redundant/` only after explicit confirmation.

## Index

See `MANIFEST.yaml` for machine-readable provenance per file.