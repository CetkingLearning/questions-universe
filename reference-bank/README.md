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

## Master taxonomy — merged (15 Oct 2026)

`quant/master-taxonomy.csv` — ONE merged Quant taxonomy, 533 rows: 1 section · 7 sub-sections · 34 chapters · 491 core types (447 Bible + 44 proposed additions found only in Supabase question_taxonomy / taxonomy_universe_nodes / Arena). Every level has an ID (`Q` → `Q-AR` → `Q-AR-PER` → `Q-AR-PER-001`, see `ID-SCHEME.md`). `rav_decision` is blank until Ravneet finalises in the Google Sheet "Cetking Master Taxonomy — Quant"; after that this file is regenerated and becomes the source of truth for `public.quant_master_taxonomy` in Supabase. `master-taxonomy-unmatched.csv` lists every source item and where it landed; `master-taxonomy-summary.md` has the counts and judgement calls.

## Verbal (15 Oct 2026)

- **Taxonomy:** the Verbal master taxonomy lives at `reference-bank/verbal/master.csv` (one row per level; the chapter list is `reference-bank/verbal/chapters.csv`).
- **CAT Verbal export:** `cat-universe/verbal/<sub-section>/<chapter>.csv` — the 747 actual-CAT Verbal rows in 8 files under `summary/`, `paragraph/`, `critical-reasoning/` and `reading-comprehension/`. `ck_subsection` / `ck_chapter` come from the Verbal master taxonomy (`ck_chapter_source` = `verbal_master_15oct`). One extra last column, `context_hash`, keeps the questions of one passage together. Reading Comprehension is a metadata-only `_index.csv` for now (see `cat-universe/verbal/reading-comprehension/README.md`). The 112 practice (non-CAT) Verbal rows are not exported; they stay in Supabase.
- **IDs:** Verbal chapter folders follow the V- id scheme in `reference-bank/verbal/id-scheme.md` (V-SM Summary, V-PG Paragraph, V-CR Critical Reasoning, V-RC Reading Comprehension).
- **No `cat_question_id` yet:** Verbal CAT questions have no `cat_question_id` (the column is blank; numbering them is a separate job that has not been approved). Use `supabase_id`.
- **Check Verbal answers before using them:** Rajat must not treat a Verbal answer as correct without checking it. In Supabase the 747 Verbal CAT rows have `verify_status` = `match` on 679, `mismatch` on 33, `missing_found` on 21, `not_found` on 12 and `not_checked` on 2; 21 rows have no stored answer at all, and no Verbal row has an `ai_answer`. The `verify_source` URL for each row is in Supabase, not in the CSV.
