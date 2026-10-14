# The CAT Ladder — how every question set is built (Ravneet, 15 Oct 2026)

Every real CAT question in `cat-universe/` is the top of a ladder. Rajat builds the four rungs below it so a student climbs from the bare idea to the actual CAT question without a jump.

| Level | Name | What is in the question | Interest example |
|---|---|---|---|
| 0 | **Level 0** | Foundation — the bare idea before any formula | What does "interest" mean; 10% of 1000 |
| 1 | **Easy** | One concept, one formula; find P / R / T, same thing different ways | Simple interest only |
| 2 | **Medium** | Two concepts meet, simply | SI + CI, or CI compounded half-yearly |
| 3 | **Hard** | Three concepts meet, harder | SI + CI + percentage change in one question |
| 4 | **CAT level** | Everything mixed — the real CAT question (from `cat-universe/`, never rewritten) | SI + ratios + percentages + … |

## Rules
1. Start from a real CAT question in `cat-universe/<section>/<topic>.csv`. Copy its `supabase_id` (the long code in the last column — always present, always unique) into `parent_cat_id` of every rung you create under it. `cat_question_id` (e.g. `CAT-2024-S3-QA-004`) is a human label and is blank on many rows, so never use it as the link. Never edit the CAT question itself.
2. Work backwards: what three concepts does the CAT question combine? → Hard uses three of them; Medium uses two; Easy uses one; Level 0 is the idea behind that one.
3. Each rung must be genuinely simpler in *idea*, not just smaller numbers. A number change is a variant, not a new level.
4. Naming is fixed: `Level 0`, `Easy`, `Medium`, `Hard`, `CAT level` — in `questions.csv` use `difficulty_level` = zero / easy / medium / hard / cat.
5. Same chapter names students know (Equations, Interest, Averages…). Core Type and DNA cell (`difficulty_dna`) are still filled where the chapter has a frozen taxonomy; if it doesn't yet (Equations), leave `core_type` blank and Ravneet will freeze it from the ladders you build.
6. Every rung needs: stem, options (MCQ) or numeric answer (TITA), full solution with the answer verified, shortcut line, `concept_note` saying which concepts it combines, `source_type = original`, `status = draft`.
7. Output goes in `chapters/<chapter>/questions.csv` on a branch → pull request. Ravneet and Claude audit; nothing is live until Ravneet approves.

## Starting chapter
**Equations** — CAT questions are in `cat-universe/quant/linear-and-simple-equations.csv` and `cat-universe/quant/quadratic-and-polynomials.csv`. Begin with `is_actual_cat = true` rows, most recent year first.
