# Equations — the CAT bible for this chapter (corrected 15 Oct 2026)

`equations.csv` holds **the 23 real CAT Equations questions** — and only those. Use this file, nothing else, when building the Equations ladder.

## What changed (and why the old file was wrong)
The earlier export had **95** questions under "Equations". Ravneet went through all 95 by hand on 15 Oct 2026 and found only 23 are actually Equations. The other 72 belonged to other chapters (Mixtures 11, Interest 8, Averages 8, Mensuration 7, Ratios 5, Percentages 4, Time & Work 4, Profit & Loss 3, and so on), and 8 were duplicates, now permanently removed from Supabase. Those 72 are no longer in this file.

## Every one of the 23 now has
- a **real CAT ID** (`CAT-2021-S1-QA-003` style) — matched against the actual CAT paper, not import order
- the **correct answer**: option letter in `correct_option`, option text in `correct_answer` (TITA rows have `correct_answer` only)
- a **full solution** in Cetking style, LaTeX maths
- the Cetking chapter IDs: `master_chapter_id = Q-AL-EQN`, sub-section Algebra
- `g_strategy_official` — the G Strategy tag. **Do not change these.** They are deliberate (a question on the X Maro page is an X Maro question). Ravneet reviews them himself.
- `supabase_id` — the permanent link. Put it in `parent_cat_id` on every ladder question you build.

## Rules
- Never edit these 23 rows. They are the CAT-level top of each ladder.
- Build Level 0 / Easy / Medium / Hard underneath each one in `chapters/equations/questions.csv` (see LADDER.md).
- 3 of the 23 have a figure (`has_images = true`, see `image_urls`).
