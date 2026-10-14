# CAT Questions Universe — CSV export

Read-only export of Supabase table `public.cat_import_questions` (project `suqcijtpfeaystltekfn`), 2,782 rows, one CSV per section + topic (Quant: per Cetking chapter). Exported 15 Oct 2026.

## How to use (Rajat)

1. Open the topic file you need (e.g. `quant/geo-mensu/geometry.csv`).
2. Filter `is_actual_cat = True` to keep only real CAT questions, then copy the rows you want.
3. Paste those rows into ChatGPT as the seed for the ladder.
4. `supabase_id` (last column, always present and unique) is the ID to put in `parent_cat_id` for any ladder question you create. `cat_question_id` (e.g. `CAT-2024-S2-QA-015`) is a human-readable label only — it is blank on many rows and sometimes repeats, so never use it as the link.

Option columns: `option_a`–`option_d` hold the option text (keys A–D). If a question had 5 or 6 options, options E/F are appended to `option_d` separated by ` || `. TITA questions have blank options; the answer is in `correct_answer`.

## Caveats (read before trusting cat_question_id)

- `cat_question_id` is only filled when `is_actual_cat`, `exam_year`, `exam_slot` **and** `question_no` are all present. In the Supabase data `question_no` is NULL on most rows (only 945 of 2,782 have it), so only **596** rows carry a `cat_question_id`; the other 1,890 actual-CAT rows have a blank ID — use `supabase_id` for those.
- Where `question_no` exists it is **not unique** within a year/slot (DILR/RC numbering restarts per set, and some slots were imported from more than one source page), so 104 `cat_question_id` values repeat across rows (e.g. `CAT-2025-S1-DILR-001` appears 5 times). When two rows share an ID, use `supabase_id` to be exact.
- 42 questions had 5–6 options: E/F are appended to `option_d` with ` || `.
- 14 rows are marked `answer_type = mcq` but have no options; 34 rows have an empty `question_text` (usually a DILR/RC row whose text lives in `context_text`).
- `image_urls` is joined with ` | `; `has_images` shows whether the question depends on a figure.

## Quant (QA) — 1057 rows, 885 actual CAT

**Quant files are now organised by Cetking chapter (15 Oct 2026)**: `quant/<sub-section>/<chapter>.csv`, replacing the old per-topic files. Rows with `is_actual_cat` = False or unset go to `quant/_practice-not-cat.csv`; actual-CAT rows with no chapter yet go to `_unassigned.csv`.

- `ai_answer` is Claude's **unverified** answer where the source had none — treat it as a hint, not truth. `ai_answer_status` shows `ai_unverified`, `needs_image` or `needs_human`.
- 246 CAT rows (mostly 1991–2008 and "yearly" uploads) have no exam slot, so no `cat_question_id` — use `supabase_id`.
- Column order is new (35 columns): `cat_question_id, cat_id_source, ck_subsection, ck_chapter, ck_chapter_source, topic_raw, is_actual_cat, ... , ai_answer, ai_answer_status, ai_answer_notes, verify_status, ... , supabase_id`. Rows are sorted by `exam_year` (newest first), `exam_slot`, `cat_question_id`.
- Count columns: *Verified* = `verify_status` is `match`; *Source answer, unchecked* = answer from the source site but not verified (`not_checked`, `mismatch`, etc.); *AI-only* = no source answer, Claude's guess in `ai_answer`; *Needs answer* = `needs_image` / `needs_human`.

### Algebra — 316 rows

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/algebra/_unassigned.csv` | (unassigned) | 7 | 3 | 2 | 0 | 2 | 6 |
| `quant/algebra/equations.csv` | Equations | 95 | 49 | 0 | 45 | 1 | 5 |
| `quant/algebra/functions.csv` | Functions | 31 | 23 | 0 | 3 | 5 | 10 |
| `quant/algebra/inequalities.csv` | Inequalities | 30 | 30 | 0 | 0 | 0 | 3 |
| `quant/algebra/logarithms.csv` | Logarithms | 28 | 16 | 1 | 2 | 9 | 12 |
| `quant/algebra/maxima-minima.csv` | Maxima Minima | 19 | 18 | 0 | 1 | 0 | 1 |
| `quant/algebra/progressions.csv` | Progressions | 34 | 28 | 2 | 1 | 3 | 7 |
| `quant/algebra/quadratic-equations.csv` | Quadratic Equations | 49 | 41 | 4 | 2 | 2 | 5 |
| `quant/algebra/surds-and-indices.csv` | Surds & Indices | 23 | 18 | 2 | 1 | 2 | 2 |

### Arithmetic — 151 rows

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/arithmetic/averages.csv` | Averages | 22 | 22 | 0 | 0 | 0 | 0 |
| `quant/arithmetic/interest.csv` | Interest | 18 | 17 | 0 | 0 | 1 | 1 |
| `quant/arithmetic/mixtures.csv` | Mixtures | 25 | 20 | 0 | 0 | 5 | 8 |
| `quant/arithmetic/percentages.csv` | Percentages | 40 | 39 | 0 | 0 | 1 | 2 |
| `quant/arithmetic/profit-and-loss.csv` | Profit & Loss | 24 | 23 | 1 | 0 | 0 | 1 |
| `quant/arithmetic/ratios.csv` | Ratios | 22 | 20 | 0 | 2 | 0 | 4 |

### Geo & Mensuration (Geo Mensu) — 218 rows

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/geo-mensu/coordinate-geometry.csv` | Coordinate Geometry | 23 | 9 | 3 | 1 | 10 | 13 |
| `quant/geo-mensu/geometry.csv` | Geometry | 138 | 61 | 43 | 13 | 21 | 59 |
| `quant/geo-mensu/mensuration.csv` | Mensuration | 49 | 7 | 24 | 4 | 14 | 31 |
| `quant/geo-mensu/trigonometry.csv` | Trigonometry | 8 | 3 | 5 | 0 | 0 | 5 |

### Modern Maths — 70 rows

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/modern-maths/pnc.csv` | PnC | 54 | 10 | 22 | 3 | 19 | 22 |
| `quant/modern-maths/probability.csv` | Probability | 5 | 0 | 5 | 0 | 0 | 1 |
| `quant/modern-maths/sets.csv` | Sets | 11 | 4 | 6 | 0 | 1 | 1 |

### Numbers — 57 rows

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/numbers/numbers.csv` | Numbers | 57 | 55 | 1 | 1 | 0 | 9 |

### Time, Speed & Work (TS&W) — 73 rows

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/ts-and-w/time-and-work.csv` | Time & Work | 34 | 26 | 1 | 2 | 5 | 5 |
| `quant/ts-and-w/time-speed-distance.csv` | Time Speed Distance | 39 | 30 | 0 | 0 | 9 | 19 |

### Not actual CAT

| File | Chapter | Rows | Verified answer | Source answer, unchecked | AI-only answer (unverified) | Needs answer (image/human) | With images |
|---|---|---:|---:|---:|---:|---:|---:|
| `quant/_practice-not-cat.csv` | Practice / not actual CAT | 172 | 0 | 172 | 0 | 0 | 22 |

## Verbal (VARC) — 859 rows, 747 actual CAT

| File | Topic | Rows | Actual CAT | With images | Years |
|---|---|---:|---:|---:|---|
| `verbal/critical-reasoning.csv` | Critical Reasoning | 61 | 45 | 0 | 2017–2025 |
| `verbal/odd-one-out.csv` | Odd One Out | 59 | 59 | 0 | 2017–2025 |
| `verbal/para-completion-and-sentence-insertion.csv` | Para Completion & Sentence Insertion | 41 | 34 | 0 | 2022–2025 |
| `verbal/para-jumbles.csv` | Para Jumbles | 48 | 43 | 0 | 2017–2025 |
| `verbal/para-summary.csv` | Para Summary | 94 | 56 | 0 | 2017–2025 |
| `verbal/reading-comprehension.csv` | Reading Comprehension | 556 | 510 | 0 | 2017–2025 |

## DILR — 866 rows, 854 actual CAT

| File | Topic | Rows | Actual CAT | With images | Years |
|---|---|---:|---:|---:|---|
| `dilr/arrangements.csv` | Arrangements | 320 | 320 | 184 | 2017–2025 |
| `dilr/caselets.csv` | Caselets | 167 | 155 | 101 | 2006–2025 |
| `dilr/fill-in-the-blanks.csv` | Fill in the Blanks | 8 | 8 | 8 | 2020–2024 |
| `dilr/games-and-tournaments.csv` | Games & Tournaments | 16 | 16 | 12 | 2017–2021 |
| `dilr/graphs-and-tables.csv` | Graphs & Tables | 129 | 129 | 118 | 2017–2025 |
| `dilr/routes-and-maps.csv` | Routes & Maps | 78 | 78 | 68 | 2017–2025 |
| `dilr/scheduling.csv` | Scheduling | 100 | 100 | 84 | 2017–2025 |
| `dilr/venn-diagrams.csv` | Venn Diagrams | 48 | 48 | 44 | 2018–2024 |

