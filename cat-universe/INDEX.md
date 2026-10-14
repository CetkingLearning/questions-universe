# CAT Questions Universe — CSV export

Read-only export of Supabase table `public.cat_import_questions` (project `suqcijtpfeaystltekfn`), 2,782 rows, one CSV per section + topic (Quant and DILR: per Cetking master chapter). Exported 15 Oct 2026.

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

**DILR files are now organised by Logic master chapter (15 Oct 2026)**: `dilr/<sub-section>/<chapter>.csv`, replacing the old per-topic files (`arrangements.csv`, `caselets.csv`, …; the old topic is kept in `topic_raw`). Chapter ids and names come from `reference-bank/logic/master-taxonomy.csv`.

- **Sets stay together.** `set_key` (= Supabase `context_hash`) is the same for every question of one set, rows of a set are contiguous, and a set is never split across files. Where one iimking page labelled a set only by type and a dedicated G-Strategy page gave the chapter, the whole set follows the dedicated page (`ck_chapter_source` = `set_majority`, reason in `chapter_notes`).
- **Unsorted = Rav's open item.** iimking only says "Caselet", "Graphs", "Wide Arrangement" or "Teeny Arrangement" for 449 actual-CAT rows (92 sets). They sit in `_unsorted*.csv` with `ck_chapter` blank until Rav sorts them set by set (Classification vs Calculation caselet, Traditional vs Advanced graph, Wordy vs Numbers). `ck_subsection` is always filled.
- **Duplicates across pages.** The same CAT set often appears on 2–3 iimking pages (slot paper page, G-Strategy page, full-slot PDF page), so 120 rows repeat a question that is already in the file: `dup_of` holds the `supabase_id` of the first copy — skip rows with a non-blank `dup_of` when counting or seeding ladders. 56 rows come from trashed WordPress posts (`from_trashed_page` = y); they are kept but never decide a set's chapter.
- **Columns:** the Quant header (35 columns, same order) + 5 extra at the end: `set_key`, `master_chapter_id` (L-AR-WDW …), `chapter_notes`, `dup_of`, `from_trashed_page`. `ai_answer*` are blank (no AI answers were produced for DILR). `cat_question_id` is still blank in Supabase for DILR; the label shown is computed where year/slot/question_no exist and can repeat — use `supabase_id`.
- **Answers:** `verify_status` = `match` on 785 rows, `mismatch` 29, `missing_found` 29, `not_checked` 23 (Supabase, 15 Oct 2026). Check before trusting.

### Arrangement (L-AR) — 326 rows

| File | Chapter | Rows | Actual CAT | Sets | Distinct Qs | Duplicate rows | Verified answer | With images | Years |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `dilr/arrangement/_unsorted-teeny.csv` | Arrangement — Teeny, wordy/numbers not sorted | 30 | 30 | 6 | 30 | 0 | 24 | 25 | 2020–2024 |
| `dilr/arrangement/_unsorted-wide.csv` | Arrangement — Wide, wordy/numbers not sorted | 56 | 56 | 11 | 55 | 1 | 50 | 46 | 2020–2024 |
| `dilr/arrangement/_unsorted-wordy.csv` | Arrangement — Wordy, wide/teeny not sorted | 16 | 16 | 4 | 16 | 0 | 14 | 8 | 2018–2019 |
| `dilr/arrangement/_unsorted.csv` | Arrangement — type only | 67 | 67 | 16 | 66 | 1 | 65 | 47 | 2017–2023 |
| `dilr/arrangement/games-and-tournaments.csv` | Games & Tournaments (L-AR-GNT, proposed) | 16 | 16 | 4 | 16 | 0 | 16 | 12 | 2017–2021 |
| `dilr/arrangement/teeny-numbers.csv` | Teeny Numbers (L-AR-TNN) | 39 | 39 | 4 | 21 | 18 | 39 | 16 | 2020–2025 |
| `dilr/arrangement/teeny-wordy.csv` | Teeny Wordy (L-AR-TNW) | 12 | 12 | 3 | 12 | 0 | 10 | 8 | 2019–2021 |
| `dilr/arrangement/wide-numbers.csv` | Wide Numbers (L-AR-WDN) | 26 | 26 | 5 | 21 | 5 | 23 | 8 | 2019–2025 |
| `dilr/arrangement/wide-wordy.csv` | Wide Wordy (L-AR-WDW) | 64 | 64 | 12 | 46 | 18 | 57 | 16 | 2019–2025 |

### Caselet (L-CS) — 166 rows

| File | Chapter | Rows | Actual CAT | Sets | Distinct Qs | Duplicate rows | Verified answer | With images | Years |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `dilr/caselet/_unsorted.csv` | Caselet — Classification / Calculation not sorted | 166 | 166 | 30 | 135 | 31 | 155 | 106 | 2006–2025 |

### Graphs (L-GR) — 194 rows

| File | Chapter | Rows | Actual CAT | Sets | Distinct Qs | Duplicate rows | Verified answer | With images | Years |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `dilr/graphs/_unsorted.csv` | Graphs — Traditional / Advanced / Tables not sorted | 114 | 114 | 25 | 105 | 9 | 109 | 103 | 2017–2025 |
| `dilr/graphs/advanced-graphs.csv` | Advanced Graphs (L-GR-ADV) | 16 | 16 | 2 | 8 | 8 | 16 | 16 | 2025–2025 |
| `dilr/graphs/tables-and-fill-in-the-blanks.csv` | Tables & Fill in the blanks (L-GR-TAB) | 8 | 8 | 2 | 8 | 0 | 7 | 8 | 2020–2024 |
| `dilr/graphs/venn.csv` | Venn (L-GR-VEN) | 56 | 56 | 13 | 54 | 2 | 50 | 52 | 2017–2024 |

### Schedule & Routing (L-SR) — 168 rows

| File | Chapter | Rows | Actual CAT | Sets | Distinct Qs | Duplicate rows | Verified answer | With images | Years |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `dilr/schedule-and-routing/routes-and-maps.csv` | Routes & Maps (L-SR-RTM) | 88 | 88 | 14 | 65 | 23 | 79 | 78 | 2017–2025 |
| `dilr/schedule-and-routing/scheduling.csv` | Scheduling (L-SR-SCH) | 80 | 80 | 17 | 76 | 4 | 71 | 64 | 2017–2025 |

### Not actual CAT — 12 rows

| File | Chapter | Rows | Actual CAT | Sets | Distinct Qs | Duplicate rows | Verified answer | With images | Years |
|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| `dilr/_practice-not-cat.csv` | Practice / not actual CAT | 12 | 0 | 2 | 12 | 0 | 0 | 6 | 2006–2020 |
