# Verbal tagging plan — unlock the 538 invisible questions

Prepared 15 Oct 2026. **Nothing has been run.** Say "run the Verbal tagging" and this executes.

## The problem, in one line

Shabda's CAT Qs tab shows **76 questions out of 747**, because the view `cat_card_questions` needs a
G Strategy that matches `cat_card_map`, and only **73 distinct Verbal questions carry one**.

| Shabda card | Questions showing today |
|---|---|
| Critical Reasoning | 57 |
| Evidence | 13 |
| Summary | 5 |
| **Paragraph** | **1** |

There are **602 distinct eligible questions** (answered, not `mismatch`, not `not_found`). So **538 are sitting
in Supabase invisible to students purely for want of a tag.** This is not a duplication problem and not an
answer problem — both of those are already handled (see STATUS.md).

## The fix, and the proof it works

`cat_verbal_pyq_questions` (506 rows) is the clean, well-tagged source: every row carries
`g_strategy_question` (one of the 11 core types) and `cetking_g_strategy_section` (one of the 4 families).
`cat_import_questions` has the questions students actually see but is barely tagged.

Matching the two on the first 60 letters of the question text (lower-cased, letters only):

| | Rows |
|---|---|
| Import rows that match a PYQ row | **396** |
| …of those, **unambiguous** (all matching PYQ rows agree on the core type) | **384** |
| …that would gain a **question type** they do not have | **249** |
| …that would gain a **G Strategy** they do not have | **335** |
| Ambiguous — matching rows disagree, needs a human | **12** |

For the 424 untyped Reading Comprehension rows specifically: **255 match, 248 unambiguously**, and they land
exactly on the taxonomy's core types —

`Inference 53 · Why Mention This 45 · Truth Facts 44 · Weakening Strengthening 38 · Cause Effect Reasoning 32 · TSPM 21 · Similarity 13 · Jumbled 2`

**Passages do not match between the tables** (0 of 747) — the two imports formatted passage text differently.
So the question text is the only usable key. That is why the ambiguity check matters and why the 12
disagreements are held back rather than guessed.

## What the migration would do

Additive only. **No existing column is overwritten; no answer is touched; no row is deleted.**

Three new columns on `cat_import_questions`:

| Column | Holds |
|---|---|
| `ck_core_type` | the core type from the PYQ table (`Inference`, `Why Mention This`, …) |
| `ck_g_section` | the G Strategy family (`Summary` / `Paragraph` / `Evidence` / `Critical Reasoning`) |
| `ck_tag_source` | `pyq_text_match_15oct` — so every tag is traceable and reversible |

The raw `question_type`, `shortcut` and `g_strategy_official` columns keep whatever they already say, per the
standing rule that raw source labels are never overwritten.

Only the **384 unambiguous** matches are written. The 12 ambiguous rows get
`ck_tag_source = 'ambiguous_needs_rav'` and no tag.

## The one decision before it runs

`cat_card_questions` currently joins on `COALESCE(g_strategy_official, shortcut)`. For the newly tagged
questions to reach the cards, that view must also look at `ck_g_section` — **a view change, which is a
student-facing change and needs your "go live".** Two options:

1. **Tag now, change the view later** — safe, nothing student-facing moves until you look at the tags.
   The 384 tags sit in Supabase for your review. *This is the recommended order.*
2. **Tag and switch the view in one go** — Shabda's cards jump from 76 to roughly 450–600 questions
   immediately, with Paragraph going from 1 to a real number. Faster, but students see it the same hour.

Either way `cat_card_map` needs rows for any family/strategy value that does not already exist in it — worth
checking at the same time, since Paragraph showing only 1 question suggests its mapping is thin.

## What this does not fix

- The **176 untyped RC rows that have no match** in the PYQ table (the PYQ set covers 2019–2025 and only 506
  rows). They stay under `V-RC-PAS` until tagged another way.
- **CAT 2024 Reading Comprehension**, which is absent from the import entirely (~48 questions). Tagging
  cannot conjure questions that were never imported — see `verbal-coverage-gaps.csv`.
