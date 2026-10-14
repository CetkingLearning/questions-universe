# Reference Bank

This folder stores reference questions separately from the canonical CAT export and from newly created ChatGPT questions.

## Source categories

1. **CAT table** — canonical source remains `cat-universe/`. Preserve its existing `supabase_id`, question metadata, and source provenance. Do not relabel CAT rows as Bible or ChatGPT-created.
2. **Bible/reference questions** — `quant/linear-and-simple-equations-bible.csv` contains 37 supplied reference questions for Linear & Simple Equations. Difficulty is classified as `easy`, `medium`, or `hard`. These are reference material, not CAT PYQs.
3. **ChatGPT-created questions (Rajat)** — live in `chapters/<chapter>/questions.csv` (see LADDER.md and WORKFLOW.md) and keep `source_type = original` in the canonical question schema. Do not mix them into the CAT export.

## Instructions for Claude

- Keep the three sources identifiable and separately traceable.
- Use the Bible file as a reference bank when updating the Quant area; do not append these rows into `cat-universe/quant/algebra/equations.csv`, which is the CAT export.
- Preserve the provided baseline IDs (`BIBLE-LSE-001` through `BIBLE-LSE-037`) as reference IDs, not Supabase IDs.
- Some source issues are deliberately flagged in `source_notes`; review them before reuse rather than silently changing the supplied reference record.
- This PR adds a reference CSV only. It does not change Supabase or publish anything live.

## Bible taxonomy (added 15 Oct 2026)

`quant/bible-taxonomy.csv` — the Cetking Quant Bible chapter → Core Type list (447 core types, 33 chapters) supplied by Ravneet. Columns: `core_id_provisional` (QB-<chapter>-<nn>, provisional until Ravneet freezes), `ck_subsection`, `chapter` (Bible name), `cat_export_chapter` (the matching folder/file name under `cat-universe/quant/`, where it differs), `core_type`, `sort_order`, `status`.
- Status is `from_bible_unfrozen`: this is the Bible's list as supplied, not yet frozen per chapter. Rajat tags each ladder question with the `core_type` it belongs to (put the text in `core_type` in questions.csv); Ravneet freezes per chapter later.
- Chapters with no CAT counterpart yet (Ages, Partnership, Simplification, Clocks, Calendars, Pipes & Cisterns, Statistics, DI, DS) exist only in the Bible for now.
