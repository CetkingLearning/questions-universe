# Logic master taxonomy – merge summary (FINAL, core types accepted 15 Oct 2026)

## FINAL — core types (Rav, 15 Oct 2026: "yes done. core types.")

- **All 119 core types are accepted as proposed.** The "Core Types (review)" tab came back with no renames, merges or drops. 111 are `accepted`; the 8 CR core types are `shared_verbal` and take the Verbal `V-CR` id.
- **189 rows are all decided:** 1 section · 9 sub-sections · 60 chapters · 119 core types. Status in the table is `accepted` or `shared_verbal`. Nothing is left `proposed`.
- **Word Formation (`L-ML-WRD`) is now the last chapter of Modern Logic,** after Data Sufficiency (sort order only; the IDs are unchanged).
- **Supabase `public.logic_master_taxonomy` and the view `logic_master_taxonomy_chapters`** are built from this CSV (`logic_master_taxonomy.sql`, tested on a throwaway Postgres).

## FINAL — Rav's chapter decisions (sheet remarks, 15 Oct 2026, 5:27 AM)

- **188 rows: 1 section · 9 sub-sections · 60 chapters (all decided) · 118 core types (still proposed at that point; see the top of this file).**
- **CAT DILR (13 chapters):** all kept as is ("Keep in CAT DILR").
- **Traditional Logic (6 chapters):** Direction Sense, Coding-Decoding, Blood Relations, Syllogism, Alphanumeric Series, Number Series.
  - **Alphabet Series is merged into Alphanumeric Series.** `L-TL-ALS` is retired; its 3 core types became `L-TL-ANS-004…006`, and the chapter now holds 120 PYQs.
- **Modern Logic (13 chapters):** the 12 already there, plus **Word Formation moved in from Traditional Logic** (`L-TL-WRD` → `L-ML-WRD`).
- **Puzzles (10 chapters):** all accepted.
- **Critical Reasoning (8 chapters): shared with Verbal > Critical Reasoning.**
  - Questions take the Verbal `V-CR` id: 8 chapters, each with Single Statements `-001` and Passage based `-002`.
  - The `L-CR` rows keep only the CET names, with `shared_with` pointing to the Verbal id.
  - Statement Conclusions and Truth Claim Conclusions both point to `V-CR-TRC`.
  - **Assertion Reasoning → `V-CR-ASR`**, added to Verbal as the 8th CR chapter (Rav, 15 Oct 2026: CET / other exams, not CAT).
- **Abstract Reasoning (10 chapters), two groups** (column `group`):
  - **Traditional Abstract:** Series & Patterns (renamed), Abstract Odd Man Out (was Figure Classification), Abstract Analogies (was Figure Analogy).
  - **Modern Abstract:** Mirror & Water Image, Paper Folding & Cutting, Figure Counting, Dot Concept, Figure Completion, Cubes & Dice, Embedded Figures.
- **Status in the SQL:** chapters are `accepted` (52) or `shared_verbal` (8 CR). Core types were accepted later the same day (see the top of this file).

---

# v2 build notes (15 Oct 2026, 4:30 AM)

Read-only build, same method as Quant. v2 applies Rav's decisions from 15 Oct 2026, 3:55 AM. No Supabase table was created or changed.

Files:
- `master-taxonomy.csv`
- `chapters.csv`
- `master-taxonomy-unmatched.csv` (the full crosswalk)
- `ID-SCHEME.md`
- `logic_master_taxonomy.sql` (prepared, tested on a throwaway Postgres, **not applied**)
- the CAT export `cat-universe/dilr/`

## Rav's decisions (15 Oct 2026)

1. **Keep CAT DILR and CET reasoning separate for now.** No chapter is merged across them. Column `exam_family` marks each row: CAT DILR · CET / NMAT Logical Reasoning · CET Abstract Reasoning.
2. **CET/NMAT Logical Reasoning = four sub-sections:** `L-TL` Traditional Logic · `L-ML` Modern Logic · `L-PZ` Puzzles · `L-CR` Critical Reasoning.
3. **Abstract Reasoning is its own sub-section** (`L-AB`).
4. **Core types come from the CET/NMAT PYQ bank** (`pyq_question_bank`, 1,848 questions). Its sub-topic labels are grouped into core types, all proposed.
5. **Games & Tournaments** is its own CAT chapter (`L-AR-GNT`).
6. **Clocks & Calendars and Data Sufficiency live in Logic only.** The Quant master's `Q-TW-CLK`, `Q-TW-CAL` and `Q-DS-DSF` move to Logic when Quant is regenerated.
7. **All Venn goes to Logic for now.** CAT Venn sets → `L-GR-VEN` (stays under Graphs). CET single-question Venn → `L-ML-VND`. Maths-style Venn may move to Quant later.
8. **The 13 CAT question patterns are tags,** not core types. A `question_pattern` column was added to the CAT DILR export.
9. **Set-question ID format accepted:** `L-AR-WDW-001-C-0001-Q3`.

## master.csv — 189 rows

| Sub-section | Family | Chapters | Core types | CET/NMAT PYQs | CAT questions |
|---|---|---:|---:|---:|---:|
| `L-AR` Arrangement | CAT DILR | 5 | 0 | – | 326 |
| `L-CS` Caselet | CAT DILR | 2 | 0 | – | 166 |
| `L-GR` Graphs | CAT DILR | 4 | 0 | – | 194 |
| `L-SR` Schedule & Routing | CAT DILR | 2 | 0 | – | 168 |
| `L-TL` Traditional Logic | CET/NMAT | 8 | 37 | 592 | – |
| `L-ML` Modern Logic | CET/NMAT | 12 | 29 | 534 | – |
| `L-PZ` Puzzles | CET/NMAT | 10 | 15 | 191 | – |
| `L-CR` Critical Reasoning | CET/NMAT | 8 | 7 | 61 | – |
| `L-AB` Abstract Reasoning | CET Abstract | 10 | 30 | 337 | – |
| **Total** | | **61** | **118** | **1,715** | **854** |

- **From the Bible:** section + the 4 CAT Types + the 12 G Strategy chapters (17 rows, status `from_bible_unfrozen`).
- **Proposed** (172 rows): 5 sub-sections, 49 chapters, 118 core types.
- **The 118 core types:**
  - 8 are existing Arena question buckets. They keep their numbers.
  - 110 were grouped by Claude from the PYQ sub-topic labels. Each core-type row lists the raw sub-topics it holds in `merge_notes`.
- **New CET/NMAT chapters** found only in the PYQ bank: Alphabet Series (78), Word Formation (12), Data Sufficiency (40), Selection & Grouping (15). New Abstract chapters: Figure Classification (67), Figure Analogy (30), Embedded Figures (7).
- **The 1,848 CET/NMAT PYQs:**
  - 1,220 are placed in a core type.
  - 495 are placed at chapter level: 493 have no sub-topic, 2 have a one-off label.
  - 88 are Quant topics, pointed to the Quant master: DI tables / caselet DI 14, TSD 11, P&C 7, equations 7, numbers 7, ratios 7, ages 6, others.
  - 45 still need sorting by eye. They are filed as "Other LR / Other AR" with no usable label.
- **CAT DILR:** 854 actual-CAT rows.
  - 405 are placed in a chapter.
  - 449 rows (92 sets) carry only a type-level label ("Caselet", "Graphs", "Wide / Teeny Arrangement"). They stay in `_unsorted*.csv` until Rav's set-by-set sort.
  - Classification / Calculation Caselets and Traditional Graphs therefore still show 0 CAT questions.

## Crosswalk (master-taxonomy-unmatched.csv) — 1,353 rows

Every source item, with its original ID and the master ID it landed on:
- question_taxonomy 54
- taxonomy_universe_nodes 63
- ck_topic_hierarchy 39 (46 rows, because the buckets point to several chapters)
- cet_question_topics 31
- White Book 12, Tarka cards 4, DILR catalog + strategy map 17
- cetking_cat_taxonomy 4, Arena 27
- iimking raw labels 67
- the 13 patterns
- **1,014 PYQ sub-topic rows** (topic › sub-topic, with question counts)

Status counts: grouped 892 · exact 178 · cross_section 76 · synonym 54 · no_subtopic 39 · new 35 · chapter_pending 22 · bucket 15 · pattern_tag 13 · group_only 11 · needs_sort 5 · other 13. Filter `match_status` not in (exact, grouped) to see the 283 rows that need an eye.

## Judgement calls still open for Rav (in the Sheet)

1. **The 110 grouped core types.** Each is a proposal, e.g. Blood Relations → Family Tree & Counting · Coded Blood Relations · Relation Chain · Pointing / Photograph Relations. Accept, rename, split or merge in `rav_decision`.
2. **Sub-topic re-homing by meaning.** All are listed in the crosswalk with reason "re-homed by meaning":
   - "Dictionary Order" / "Logical Word Sequence" (filed under Order & Ranking) → Sequencing & Ordering
   - "Coded Blood Relations" (filed under Symbols & Notation) → Blood Relations
   - "Wrong Term in Series" (filed under Odd One Out) → Number Series
   - "Two Rows Facing" → Parallel Arrangement
   - Eligibility / selection-criteria items → Decision Making
   - Assertion–Reason items → Assertion Reasoning
   - Team / item selection → Selection & Grouping (new)
   - Clock hands, odd days, time → Clocks & Calendars
   - Painted / cut cubes and dice (also those filed under LR "Other LR") → Abstract Cubes & Dice
   - Missing number in figure / grid → Number Series
3. **NMAT Brown Book names mapped to CET chapters by synonym:** Classification → Odd Man Out · Sequence of words → Sequencing & Ordering · Syllogism I / II → Syllogism · Clocks + Calendars → Clocks & Calendars · Analogy → Analogies · Blood Relation → Blood Relations · Alphabet Test → Alphabet Tests.
4. **Two near-twin chapters, kept apart because the sources keep them apart:** Alphabet Tests (CET Pattern; 0 PYQs tagged) vs Alphabet Series (PYQ bank, 78). Merge?
5. **Arena "Logic › Arrangements"** is CET single-matrix puzzles, not CAT sets. The existing arena map row (related / pending) is left as is.
6. **CAT export placement.** Chapter comes from G Strategy → question type → topic. Sets are never split across files. 42 rows on 9 sets follow their set's dedicated G-Strategy page (`chapter_notes`).
7. **cat_question_id** is still blank in Supabase for DILR. Use `supabase_id`.
