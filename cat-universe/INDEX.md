# CAT Questions Universe — CSV export

Read-only export of Supabase table `public.cat_import_questions` (project `suqcijtpfeaystltekfn`), 2,782 rows, one CSV per section + topic. Exported 15 Oct 2026.

## How to use (Rajat)

1. Open the topic file you need (e.g. `quant/geometry.csv`).
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

| File | Topic | Rows | Actual CAT | With images | Years |
|---|---|---:|---:|---:|---|
| `quant/algebra.csv` | Algebra | 91 | 88 | 9 | 2020–2025 |
| `quant/averages-and-mixtures.csv` | Averages & Mixtures | 54 | 47 | 8 | 2017–2025 |
| `quant/coordinate-geometry.csv` | Coordinate Geometry | 22 | 19 | 14 | 1991–2025 |
| `quant/functions-and-graphs.csv` | Functions & Graphs | 27 | 24 | 9 | 2017–2025 |
| `quant/geometry.csv` | Geometry | 191 | 137 | 79 | 2003–2025 |
| `quant/inequalities-and-modulus.csv` | Inequalities & Modulus | 21 | 17 | 3 | 2017–2025 |
| `quant/linear-and-simple-equations.csv` | Linear & Simple Equations | 120 | 90 | 5 | 2020–2025 |
| `quant/logarithms-and-indices.csv` | Logarithms & Indices | 40 | 32 | 14 | 2017–2025 |
| `quant/maxima-and-minima.csv` | Maxima & Minima | 14 | 13 | 0 | 2024–2025 |
| `quant/mensuration.csv` | Mensuration | 51 | 49 | 31 | 1993–2024 |
| `quant/number-system.csv` | Number System | 60 | 50 | 9 | 2017–2025 |
| `quant/percentages.csv` | Percentages | 44 | 40 | 2 | 2017–2025 |
| `quant/permutation-combination-and-probability.csv` | Permutation, Combination & Probability | 62 | 59 | 23 | 1991–2025 |
| `quant/profit-and-loss.csv` | Profit & Loss | 29 | 24 | 1 | 2017–2025 |
| `quant/progressions.csv` | Progressions | 30 | 26 | 7 | 2018–2025 |
| `quant/quadratic-and-polynomials.csv` | Quadratic & Polynomials | 41 | 38 | 5 | 2017–2025 |
| `quant/ratio-and-variation.csv` | Ratio & Variation | 39 | 22 | 4 | 2018–2025 |
| `quant/set-theory.csv` | Set Theory | 12 | 11 | 1 | 2000–2025 |
| `quant/simple-and-compound-interest.csv` | Simple & Compound Interest | 22 | 18 | 1 | 2018–2025 |
| `quant/time-and-work.csv` | Time & Work | 37 | 34 | 5 | 2017–2025 |
| `quant/time-speed-and-distance.csv` | Time, Speed & Distance | 42 | 39 | 19 | 2018–2025 |
| `quant/trigonometry.csv` | Trigonometry | 8 | 8 | 5 | 1999–2025 |

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

