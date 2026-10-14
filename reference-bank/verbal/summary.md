# Verbal Master Taxonomy — summary

Built 15 Oct 2026 from the ChatGPT Supabase handover (read-only discovery, 15 Oct) plus live SELECTs on
Cetking Learn `suqcijtpfeaystltekfn`. Mirrors what was done for Quant on 15 Oct 2026.

**Status: `from_bible_unfrozen`. Nothing is frozen, nothing was written to Supabase, no production row changed.**

## What came out

| Level | Count |
|---|---|
| Section | 1 (`V`) |
| Sub-sections | 8 |
| Chapters | 43 |
| Core types | **92** |

Of the 92 core types: 55 `exact` (live rows or CAT PYQ rows prove them) · 9 `synonym` (same question, another
source's wording — NMAT Brown Book mostly) · 24 `bible_only` (in the Verbal Bible, nothing built yet) ·
3 `placeholder` (untyped containers that retire once their questions are tagged) · 1 `batch` (a test batch,
not a real core type). 25 are flagged `proposed_addition` for you to accept or reject.

## The honest headline: Verbal is not Quant

| | Quant | Verbal |
|---|---|---|
| Bible taxonomy | 33 chapters → **447 core types**, enumerated, supplied by you | ~340 core types but the Bible itself says these are **estimated, not enumerated** |
| CAT IDs | 69 paper + 570 sequence assigned | **none** — `cat_question_id` NULL on all 747 |
| Cetking chapters on CAT rows | `ck_chapter` filled, 7 unassigned | **`ck_chapter` empty on all 859** |
| Answers verified | 2025 verified by you; others match a second source | **0 of 747 verified.** No Career Launcher cross-check was ever run on Verbal |
| Fine typing of CAT rows | by chapter | **424 of 510 RC rows have no question type at all** |

So this master is the **first real enumeration of Verbal**, not a merge into an existing authority. That is why
25 rows are proposals rather than facts.

## The one structural decision this forced

Your four promoted sections — **Summary · Paragraph · Evidence · Critical Reasoning** — are G Strategy
*families*, and three of them (Summary's TSPM half, Evidence, Critical Reasoning) are asked **on a passage**,
while Paragraph and Summary's other half are **Non-RC**. A tree cannot put the same question under both
"Reading Comprehension" and "Evidence".

Resolved as: **the four families are the sub-sections** (`V-SM` `V-PG` `V-EV` `V-CR`), and **RC vs Non-RC is a
tag** (`rc_non`) carried on every core type — which is exactly how your own 506-row sheet stores it, and what
`cetking_cat_taxonomy` already calls a `source_group`. `V-RC` then holds only what is genuinely passage-level
and type-less: untyped passage practice, the Bible's reading-skill chapters, and the Except form.

The Arena mapping notes in Supabase already said this in different words — *"Evidence is a solving family
within RC not synonymous with RC"*, *"RC summary part of Summary strategy"*. Those four pending mappings are
yours to approve.

## What each source contributed

| Source | Items | Where they went |
|---|---|---|
| `taxonomy_universe_nodes` (Verbal) | 74 | 74 matched. **27 are duplicate pairs** — the same core type filed once under sub-section `Vocabulary` and again under `Vocabulary Usage` / `Vocabulary Builder` / `Idioms & Phrases`. One node (`TX_171DF40A497AFFC03EF6`) has sub-section and topic **swapped**. |
| `question_taxonomy` (Verbal 21 + Language Skills 13) | 34 | 34 matched. The 13 Language Skills rows are NMAT Brown Book 2026 labels — kept, tagged, mapped to the same core types as their Cetking twins. |
| `ck_topic_hierarchy` (Verbal) | 25 | 25 matched. 12 are `source=rav` (the real CAT types); 13 are `source=proposed`. **These rows must survive** — `dyntube_videos.hierarchy_id` points at them. |
| Arena (`cetking_cat_arena_taxonomy_map`) | 5 Verbal | 5 matched; 4 still `pending` approval, 1 approved (Critical Reasoning, exact). |
| `cat_verbal_pyq_questions` | 506 rows, 11 labels | 11 labels → 11 core types, all `exact`. This is the clean, well-tagged source. |
| `cat_import_questions` (Verbal) | 859 rows / 747 actual CAT, 19 raw labels | 18 labels mapped; **the 20th is blank on 424 rows** — the one real gap. |
| Verbal White Book (book 3) | 11 chapters | all 11 mapped to a chapter. Every CAT core type with ≥27 PYQ rows has a book chapter, **except Similarity (12 rows, no chapter)**. |
| `shabda_shortcuts` | 4 | = the 4 G Strategy sub-sections. Slugs unchanged, so /shabda keeps working. |
| `cetking_cat_taxonomy` | 6 Verbal | 4 strategy families → sub-sections; RC / Non RC → the `rc_non` tag. |
| `lms_topics`, `test_taxonomy`, `tests_by_section`, `questions` | 6 / 15 / 25 paths / 418 Qs | mapped at chapter or sub-section level; `test_taxonomy` has `Paragraph-Based` and `Paragraph-based` as two rows — merge. |
| Verbal Bible (memory) | 5 sub-sections, 29 chapters | base for 24 `bible_only` core types. Its Grammar (82 types) and Vocabulary (66 types) lists are far bigger than anything built — only the chapters with live rows were promoted. |

Nothing was dropped. `sources-unmatched.csv` lists all 234 source items with status `matched` / `UNMATCHED` /
`NOTE`, each with its original ID.

## Links that must not break

Verified foreign keys, all preserved (the `V-` id is an *additional* key, not a replacement):
`question_bank.taxonomy_id` → `question_taxonomy.id` (delete restricted) · `taxonomy_question_links`
(→ `taxonomy_universe_nodes.id`, `question_bank.id`, `questions.id`) · `dyntube_videos.hierarchy_id` →
`ck_topic_hierarchy.id` · `cet_question_taxonomy_map` · `vocabulary_question_type_bank.taxonomy_id` ·
`cetking_cat_arena_taxonomy_map.cat_taxonomy_id`. Plus the `shabda_shortcut_*` views, which read
`book_universe_chapter_pages` → `book_universe_chapters` + `book_universe_books`.

## Open decisions for Ravneet

1. **`V-VO` + `V-GR` split** — your prompt gave one code for "Vocabulary/Grammar"; this uses two. Merge?
2. **TSPM** — CAT tags it as one label (44 rows); Cetking's own tests split it into Tone / Scope / Purpose
   (3 nodes, 50 questions). Keep 4 core types, or 1?
3. **Spelling** — the Bible puts it under Vocabulary; `ck_topic_hierarchy` puts it under Grammar & Usage.
4. **Sentence Insertion** — separate core type (8 iimking rows) or inside Completion (CAT has no separate label)?
5. **"Argument" (5 rows) and "Keywords" (3 rows)** — iimking's own words. Argument → Weakening Strengthening,
   or standalone `V-CR-ARG`? Keywords → Why Mention This?
6. **The 25 `proposed_addition` rows** — accept, reject, or park.
7. **Roots & Prefixes batches** — 5 nodes are test batches (Roots D&E, F&G, H&I, Life & People), not core types.
8. **Verbal answer verification** — 0 of 747 verified. Run the second-source check like Quant, or you do 2025 first?
9. **The 424 untagged RC rows** — tag them against the 506-row master before or after the Sheet is frozen?
10. **Verbal CAT IDs** — Quant got `CAT-2025-S1-QA-031` style IDs. Same for Verbal (`-VA-`)?

## Files

| File | What |
|---|---|
| `master.csv` | 144 rows, one per level, with all flags, counts and `rav_decision` / `rav_notes` blank |
| `chapters.csv` | 43 chapters, one row each |
| `sources-unmatched.csv` | all 234 source items with status and original ID |
| `id-scheme.md` | the `V-XX-YYY-nnn` scheme and the axes that are not levels |
| `verbal_master_taxonomy.sql` | ready to run when you say "create the taxonomy table" — not run |
