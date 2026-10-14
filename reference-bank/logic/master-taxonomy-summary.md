# Logic (DILR) master taxonomy – merge summary (15 Oct 2026)

Read-only build, same method as Quant (15 Oct 2026). Files: `master.csv`, `sources-unmatched.csv` (full crosswalk, every source item), `id-scheme.md`, `summary.md`, plus the CAT export `cat-universe/dilr/`. Build script: `build.py` + `export.py` (scratchpad). No Supabase table was created or changed.

## Sources used

| Src | Where | Rows |
|---|---|---|
| A | Logic "Bible" = memory dilr-world + CONTENT-UNIVERSES §11–14 (4 Types, 12 G Strategies, 558-row historical counts, 13 question patterns). No Bible file was pasted, so the Bible has **no core types**. | 4 sub-sections, 12 chapters |
| B | `public.question_taxonomy` section "Logical Reasoning" | 54: 31 CET Pattern (sub-sections Traditional Logic 6 · Modern Logic 11 · Puzzles 7 · Critical Reasoning 7) + 23 NMAT Brown Book 2026 (Reasoning I 10 · Reasoning II 8 · Critical Reasoning 5). All chapter-level names (chapter_name = core_type); none is a CAT DILR item |
| C | `public.taxonomy_universe_nodes` section "Logic" (59) + "Abstract" (4) | 63: 49 mirror B one-to-one (source_refs → question_taxonomy id), 10 Arena-derived (4 parent nodes, 6 test paths), 4 Abstract Cubes |
| D | `public.cat_import_questions` section "DILR" | 866 rows (854 actual CAT, 12 practice), 168 sets by context_hash (117 titled), ≈734 distinct questions (120 rows are the same question on a second iimking page), 56 rows from trashed WordPress posts (`__trashed-*`). `ck_chapter` was empty for all DILR rows |
| E | Arena / War Room: `public.tests` ⋈ `public.questions` (section Logic), `test_taxonomy`, `test_topic_map`, `lms_topics`, live `questions` paths, `cetking_cat_arena_taxonomy_map` | 9 test buckets / 83 questions: Abstract Cubes 35 · Matrix puzzles 14 · Cause Effect 22 · Coding Decoding 12; 5 test_taxonomy rows; 4 MBA CET LMS groups; 1 arena map row (Logic › Arrangements → CAT Arrangement, related/pending) |
| F | `public.ck_topic_hierarchy` world "DILR" (FK target of `dyntube_videos.hierarchy_id`) | 39: 12 `source=rav` (the 12 G Strategies under the old Arrangement/Calculations split) + 27 `proposed` (CET Logic 13, CET Puzzles 5, Visual Reasoning 7, Games & Tournaments 1, Strategy & Intro 1) |
| G | `public.cet_question_topics` section Logical Reasoning (codes `CET_LR_*`) | 31 = the 31 CET Pattern rows of B, one to one |
| H | `public.cat_dilr_type_catalog` (5) + `cat_dilr_strategy_type_map` (12) + `cat_dilr_summary_strategy_year_pivot` (historical counts) | 4 Types + Unassigned placeholder; 12 strategies → 12 chapters |
| I | `public.cetking_cat_taxonomy` section Logic (4, expected_questions 5/8/4/5 = 22) | = the 4 sub-sections |
| J | DILR G Strategy — White Book (book 2, `book_universe_chapters` via `tarka_shortcut_chapters`) 12 chapters + 4 `tarka_shortcuts` cards | 12 chapters → 12 master chapters (4 title variants); Tarka card "Routes, Maps, Scheduling & Venn" bundles Venn with L-SR |

## master.csv

- **69 rows: 1 section · 6 sub-sections · 54 chapters · 8 core types.**
- From the Bible: section + 4 sub-sections + 12 chapters (17 rows, `in_bible = y`). Everything else is `proposed_addition = yes` (52 rows): 2 sub-sections, 42 chapters, 8 core types.
- CAT side: 1 proposed chapter `L-AR-GNT` Games & Tournaments. The 12 Bible chapters all match `ck_topic_hierarchy` (rav), the White Book and the strategy map; `L-GR-VEN` by synonym (Venn Diagrams), the rest exact.
- `L-LR` Logical Reasoning (CET / NMAT): 31 CET chapters (every one backed by B + C + G; 21 also by F) + 3 proposed (Number Puzzles — NMAT + F; Truth & Lies — F only; Truth Claim Conclusions — test_taxonomy only). CET group kept in `lr_group`.
- `L-AB` Abstract Reasoning: 7 proposed chapters (F "Visual Reasoning"); Cubes & Dice has 4 core types from Arena (35 questions).
- 8 core types in total, all Arena sub-topics that already hold questions; the CAT chapters have **no core types yet** (nothing invented).
- `historical_cat_questions_2017_2025` on the 12 CAT chapters (558-row dataset: Calculation Caselets 121 … Advanced Graphs 20, Teeny Wordy 20).
- `cat_questions_in_chapter` / `cat_sets_in_chapter` from D (actual CAT rows, incl. cross-page duplicates): Arrangement 326 / 65 sets, Caselet 166 / 30, Graphs 194 / 42, Schedule & Routing 168 / 31 = 854. Only 405 rows could be placed in a chapter from their labels (Wide Wordy 64, Wide Numbers 26, Teeny Wordy 12, Teeny Numbers 39, Games & Tournaments 16, Tables & FIB 8, Advanced Graphs 16, Venn 56, Routes & Maps 88, Scheduling 80); **449 rows / 92 sets carry only a type-level label** ("Caselet", "Graphs", "Wide / Teeny Arrangement") and sit in `_unsorted*.csv` until Rav sorts them set by set (his open item of 10 Oct 2026). Both Caselet chapters and Traditional Graphs therefore show no CAT count yet.
- `in_*` columns carry the source IDs (question_taxonomy uuid, universe node uuid, ck_topic_hierarchy uuid, CET topic code, cetking_cat_taxonomy uuid, White Book chapter + pages, Tarka slug) so nothing has to be re-matched later; `merge_notes` records every judgement call.

## Match results per source (crosswalk, 339 rows)

| Status | Rows | Meaning |
|---|---:|---|
| exact | 178 | same name |
| synonym | 53 | explicit, domain-aware variant (Venn Diagrams → Venn; Caselets Classification → Classification Caselets; NMAT Alphabet Test → Alphabet Tests; Syllogism I/II → Syllogism; Coded Inequality → Coded Inequalities …) |
| new | 35 | source items that became proposed rows (8 core types, 12 chapters, counted once per source) |
| chapter_pending | 22 | iimking labels that only say the Type ("Caselet", "Graphs", "Wide Arrangement") |
| bucket | 15 | ck_topic_hierarchy video buckets spanning 2–3 chapters (Alphabet, Ranking & Sequence; Analogy & Classification; Series; Floor & Scheduling; Linear & Circular; Matrix & Parallel) + the Tarka Routes/Scheduling/Venn card |
| pattern_tag | 13 | CONTENT-UNIVERSES §14 question patterns (cross-cutting) |
| group_only | 11 | NMAT "Puzzles", LMS/Arena groups (Traditional Logic, Modern Logic, Puzzles, Critical Reasoning) — groups, not chapters |
| not_a_core_type | 4 | Arena "PYQ" sub-topic = test label |
| no_label | 3 | iimking rows with no topic / g_strategy / question_type |
| cross_section | 1 | ck "CET Logic › Data Sufficiency" → already Q-DS-DSF in the Quant master |
| related_pending | 1 | arena map Logic › Arrangements → CAT Arrangement (Arena "Arrangements" = CET matrix puzzles) |
| parent_node · section_only · placeholder | 3 | universe parent node "Abstract"; ck "DILR General › Strategy & Intro"; catalog "Unassigned" |

No source item was dropped: B 54/54, C 63/63, F 39/39, G 31/31, H 17/17, I 4/4, J 16/16, Arena 9 buckets + 5 + 4 + 2 + 6 paths + 1 map, D raw labels 67 distinct, patterns 13.

## Judgement calls to check (all recorded in merge_notes / crosswalk reason)

1. **Venn under Graphs** (`L-GR-VEN`), as the 15 Oct 2026 prompt and CONTENT-UNIVERSES §12 say. dilr-world (7 Oct) put Venn in expected Set 5 with Routes & Scheduling, and the live Tarka card + White Book ch.12 still bundle it there. The master follows the latest instruction; the card/book mapping is recorded as a bucket, not changed.
2. **One `L-LR` sub-section with a `lr_group` column** (Traditional Logic / Modern Logic / Puzzles / Critical Reasoning), per the prompt ("LR other CET-style LR if needed"). Alternative for Rav: four sub-sections `L-TL` / `L-ML` / `L-PZ` / `L-CR` instead — the IDs would change from `L-LR-SYL` to `L-TL-SYL`. Decide before IDs are printed anywhere.
3. **`L-AB` Abstract Reasoning** proposed as its own sub-section (MBA CET has 25 Abstract questions; Arena, universe_nodes, ck_topic_hierarchy and lms_topics all carry it). Rav: accept, or fold under `L-LR`?
4. **Critical Reasoning placement by exam:** CAT CR (Inference, Weakening Strengthening, Cause Effect Reasoning, Similarity) belongs to the Verbal master (`V-CR`, CAT VARC). CET / NMAT CR (Statement Assumptions … Cause Effect) is in the LR section of those exams and sits here under `L-LR`. CET "Cause Effect" and CAT Verbal "Cause Effect Reasoning" are different question styles and keep separate IDs; cross-reference noted on `L-LR-CEF`.
5. **Clocks / Calendars / Data Sufficiency** exist in both masters: Quant Bible has Clocks (Q-TW-CLK), Calendars (Q-TW-CAL), Data Sufficiency (Q-DS-DSF); CET LR / NMAT list them as reasoning chapters. `L-LR-CLC` keeps the CET chapter (B, C, F, G all have it); Data Sufficiency is **not** duplicated in Logic (crosswalk row → Q-DS-DSF). Rav decides which section owns these for CET pages.
6. **Synonyms that merge NMAT names into CET chapters:** Classification → Odd Man Out; Sequence of words → Sequencing & Ordering; Syllogism I + II → Syllogism; Clocks + Calendars → Clocks & Calendars; Analogy → Analogies; Blood Relation → Blood Relations; Alphabet Test → Alphabet Tests; Coding Decoding → Coding-Decoding. NMAT ids are kept on the chapter row (`in_question_taxonomy`), chapter number from the Brown Book in the crosswalk.
7. **Games & Tournaments** (`L-AR-GNT`): proposed from ck_topic_hierarchy + 16 iimking questions (4 sets, 2017–2021). In Rav's 558-row dataset such sets were filed under existing strategies (likely Scheduling / Teeny Numbers). Accept as chapter, or merge?
8. **Arena "Logic › Arrangements"** holds CET single-matrix puzzles (14 Qs), not CAT Wide/Teeny sets; the existing arena map row (related / pending) is left as is and flagged. Arena "Coding Decoding › PYQ" is a test label, not a core type.
9. **ck_topic_hierarchy buckets** (video groupings such as "Alphabet, Ranking & Sequence") are attached to every chapter they span and are not chapters; `dyntube_videos.hierarchy_id` keeps pointing at them, so nothing breaks.
10. **CAT export placement:** chapter from `g_strategy_official` → `question_type` → `topic` (most specific wins); rows of one set (same `context_hash`) must land in one file — 42 rows on 9 sets were moved to their set's chapter, with the dedicated G-Strategy / type page trusted over the slot-paper page labelled by AI, and trashed pages never deciding. The rows say so in `chapter_notes`. One tie could not be resolved by trust (CAT 2019 "Vendors" set: Graphs page vs Caselet page) — it follows the majority (Caselet) and is flagged.
11. Historical counts (558 dataset) and iimking counts (854 rows) do not match and are not meant to — the iimking rows include duplicates across pages and older papers; both are shown.
12. `cat_question_id` is still blank in Supabase for DILR (only Quant got the 15 Oct sequence IDs); the export keeps the label computed on 15 Oct where year/slot/question_no exist. `supabase_id` remains the only safe link.

## sources-unmatched.csv

339 rows — the full crosswalk: every B / C / E / F / G / H / I / J item plus every raw iimking label and the 13 patterns, with `matched_master_id`, `match_status`, proposed chapter id/name and the reason. Filter `match_status` ≠ exact to see only what needs Rav's eye (161 rows); `new` (35) are the proposed additions.
