# Reading Comprehension — CAT Verbal export

Chapter `V-RC-PAS` (Passage Practice) of the Verbal master taxonomy.
See `reference-bank/verbal/master-taxonomy.csv` and `reference-bank/verbal/id-scheme.md`.

## Files

| File | Rows | What |
|---|---|---|
| `passage-practice-2017.csv` … `-2025.csv` | 510 total | All actual-CAT RC questions, **with full passage text**, one file per CAT year |
| `_practice-not-actual-cat.csv` | 46 | Cetking practice questions written on CAT passages — **not real CAT questions**, never present them as such |

Columns are the same 35 as the Quant export (`cat-universe/quant/**`), plus `context_hash` last.
`context_hash` groups the questions that share one passage — it is the Verbal equivalent of DILR's
`set_title`. It is blank on 58 rows where Supabase has no value.

There is **no 2024 file** — see the gap below.

## Read this before using the data

1. **CAT 2024 Reading Comprehension is completely missing.** Supabase has 52 actual-CAT 2024 Verbal rows
   and **not one** is Reading Comprehension. Roughly 48 RC questions (3 slots × 4 passages × 4 questions)
   were never imported. Do not build a "2024 RC" anything until they are.
2. **CAT 2025 is duplicated** — 186 stored rows for **100 unique questions** (86 exact duplicate rows).
   iimking hosted the same question on several pages and the import took each copy. 2025 is the only year
   with a real duplication problem; 2017-2022 have none. De-duplicate before showing 2025 to students.
   **De-duplicate on question_text + context_text + options, never on question_text alone** — Summary,
   Jumbles, Odd Man Out, Completion and Insertion questions all share one boilerplate stem, so a
   question_text-only key merges genuinely different questions.
3. **424 of these 510 rows have no `question_type`.** The fine RC types (TSPM, Why Mention This, Truth Facts,
   Inference, Weakening Strengthening, Cause Effect Reasoning, Similarity) live in a different table,
   `cat_verbal_pyq_questions` (506 rows, well tagged). Matching the two by passage/question text is an open
   job. Until it is done, every row here sits under `V-RC-PAS` (untyped passage practice), not under its
   real core type.
4. **Answers.** `verify_status` is filled: across all 747 actual-CAT Verbal rows, 679 `match` a second source
   (URL in `verify_source`), 33 `mismatch`, 21 `missing_found`, 12 `not_found`, 2 `not_checked`.
   **Never treat a `mismatch` or `not_found` answer as correct.** Review sheet:
   `reference-bank/verbal/verbal-answer-exceptions-review.csv`.
5. Full per-year coverage against what each CAT paper actually contained:
   `reference-bank/verbal/verbal-coverage-gaps.csv`.

## The old flat file

`cat-universe/verbal/reading-comprehension.csv` (2.3 MB) is the earlier flat export and holds the same
556 rows in the older 29-column layout. These per-year files replace it. It is left in place until
Ravneet says to remove it; `cat-universe/INDEX.md` still points at it.
