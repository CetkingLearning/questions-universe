# Equations — Independent Audit of 180 Questions

**File audited:** `/home/claude/qu-repo/chapters/equations/questions.csv` (180 rows, 38 columns, not modified)
**Method:** every question solved cold from question text + options only, before reading the supplied solution; sympy and brute-force enumeration used for all counting and optimisation items; options machine-checked for value-equality after LaTeX normalisation; 25 parent CAT rows pulled from `cat_import_questions` in Supabase.

## Verdict

The mathematics is sound. I solved all 180 cold and got the keyed answer in 180 cases — **zero wrong answers**, which for a 180-question first draft is genuinely unusual and reflects real care. Options are also clean: no duplicate-value traps (I specifically tested surd/fraction/decimal equivalences), no double-correct options except one, correct counts (5 for zero/easy/medium, 4 for hard), and `option_mistakes` keys match the wrong letters exactly in all 166 MCQs. Housekeeping is near-spotless — LaTeX all renders, "Rs" used throughout, no rupee glyph, no blank required fields, `exam_scope` and `question_code` correct on every row. **Where the file is weak is not arithmetic — it is pedagogy and originality.** Nine of the thirty Hard questions are the parent CAT question with new names and numbers rather than a new rung; a further seven Hard questions are off-type (an integer-optimisation or simple-interest problem dropped into a linear-equations ladder); and roughly a dozen Mediums are an Easy with bigger numbers. Two core types — **X Maro** and **Linear – Three Variables** — do not step up in idea at all, and X Maro is largely a grab-bag of questions that belong to four other core types. Fixing this is rewriting ~25 questions, not re-keying answers.

## Counts

| Severity | Category | Count |
|---|---|---|
| 1 | Wrong answers | **0** |
| 2 | Broken options | **2** (1 ambiguous/double-correct, 1 text mismatch) |
| 3 | Misplaced levels | **16 questions across 13 core types** |
| 4 | Duplicates / near-duplicates | **17 pairs or clusters** (9 of them Hard-is-a-CAT-reskin) |
| 5 | Parent link problems | **8 stretched or wrong links** + 11 rows whose parent sits in chapter "Quadratic Equations" |
| 6 | Housekeeping | **1 real defect** + 5 structural/metadata notes |

---

# 1. Wrong answers — CLEAN

**No mismatches.** All 180 keyed answers agree with my independent solution. Items I brute-forced rather than trusted algebra on, all confirmed: `Q-AL-EQN-04-002-H-0001` (min = 14, witness a=5 with {2,6,7}); `Q-AL-EQN-04-002-M-0002` (least = 8); `Q-AL-EQN-04-001-E-0002` (4 arrangements: 4×12, 6×8, 8×6, 12×4); `Q-AL-EQN-02-008-H-0001` (5 values: x = 1, 2, 3, 4, 5 — exponent-zero, base-one and base-minus-one cases all handled); `Q-AL-EQN-02-009-H-0001` (k = −3, −2, 6, 7); `Q-AL-EQN-01-003-H-0001`, `Q-AL-EQN-01-007-M-0001`, `Q-AL-EQN-01-002-H-0001`, `Q-AL-EQN-03-007-H-0001`, `Q-AL-EQN-01-007-H-0001`, `Q-AL-EQN-04-003-H-0001` (all integer-constrained extrema, all confirmed by enumeration).

One answer is correct but the question is ambiguous — see item 2.1.

# 2. Broken options

**2.1 `Q-AL-EQN-02-004-M-0002` — two defensible answers.**
"The roots of a quadratic equation are two consecutive even integers whose product is 48. The equation is". Keyed **C** `x²−14x+48=0` (roots 6, 8). But **−8 and −6 are also two consecutive even integers with product 48**, giving `x²+14x+48=0`, which is sitting right there as **option A**. A sharp student picks A and is not wrong. Fix: add "positive" to the stem, or drop option A.

**2.2 `Q-AL-EQN-01-002-M-0001` — `correct_answer` text does not match the option.**
`option_e` = "Rs 50", `correct_answer` = "50". Every other money row carries the "Rs " prefix in `correct_answer`. Will break any exact-match grader. Set `correct_answer` to "Rs 50".

Everything else in this category is clean: exactly one correct option in all 166 MCQs (I evaluated every option, not just the keyed one); no two options equal in value anywhere — I specifically checked the surd and fraction sets (e.g. `Q-AL-EQN-02-002-M-0002`, where option C `(10+√76)/3` is **not** equal to the key `(5+√19)/3` because the denominator is 3 and not 6 — the trap works as intended); option counts 5/5/5/4 correct on all 180; `option_e` blank on all 30 Hards; all 14 TITA rows have no options, a populated `correct_answer`, an empty `correct_option` and no `option_mistakes`.

# 3. Misplaced levels

**Core types where a Medium is really an Easy** (same idea, bigger numbers or one more term — should move down, with a genuinely new idea written to replace it):

- **Linear – Three Variables** — `003-M-0002` (add the two equations → x+y+z) is the *same* trick as `003-E-0001` (add the three pair-sums → x+y+z), and arguably easier because it uses two equations instead of three. Move M2 to Easy; the ladder currently has no real medium.
- **Reciprocal Equations** — `005-M-0002` (two taps + one outlet) is `005-E-0002` (two workers) with a minus sign. Move to Easy.
- **Ratio Equations** — `006-M-0002` (Rs 3600 in 2:3:7, Chetan minus the other two) is a one-line parts computation, easier in idea than `006-M-0001` (ratio changes when 4 girls join). Move to Easy.
- **Heads and Legs** — `005-M-0002` (ostriches 6 more than deer) is the same two-variable-plus-relation idea as `005-E-0001` and `005-E-0002`. Move to Easy. `005-M-0001` (three vehicle types with cars given) is the real Medium.
- **Integer Factor Pair Optimization** — levels are inverted. `001-M-0002` (min x+y for xy=120) is an Easy; `001-M-0001` (1/x+1/y=1/4 → (x−4)(y−4)=16, Simon's trick) is the hardest *idea* in the whole core type and is a better Hard than `001-H-0001` (which is just divisor-listing under a perimeter cap).
- **Equation from Roots** — `004-M-0002` (consecutive even integers, product 48) is a weaker idea than `004-E-0002` (surd conjugate roots) and carries the ambiguity in 2.1. Move down or replace.
- **Integer Roots Parameter** — `009-M-0001` (count k for x²−8x+k integer roots) is `009-E-0001` (count k for x²−6x+k) with 6 changed to 8. Not a level; it is the same question. Replace outright.
- **Quadratic Formula** — `002-E-0002` (2x²+3x−2=0 → 1/2, −2) is *easier* than `002-E-0001` (x²−4x−1=0 → 2±√5) and does not use the quadratic formula at all; it factorises, so it belongs in Quadratic Factorisation. Swap the two Easies and replace E2 with a non-factorisable one.

**Core types where the Hard is off-type** (correct and hard, but testing a different core type's idea — the ladder loses its spine at the top):

- **Linear – Two Variables** `002-H-0001` — two-denomination Diophantine extremum. Belongs in Linear Equations and Max-Min or Coins and Denominations.
- **Linear – Three Variables** `003-H-0001` — 30 articles / three prices / max bags. Belongs in Linear Equations and Max-Min (where the same template already sits at Medium — see 4.5).
- **Fraction Equations** `004-H-0001` — simple-interest accumulation. A fraction-of-capital *dressing*, but the concept being tested is SI, not fraction equations.
- **Other Equation Applications** `002-H-0001` — same simple-interest template again.
- **Statement Equations** `001-H-0001` — 3x+7y=100, max x+y. That is X Maro / integer-solution work, not statement translation.
- **Transformed Roots** `007-H-0001` — is `007-E-0002` run backwards, using the very equation that appears as a distractor in E2. Not a new rung.

**Two core types with no working ladder at all:**

- **X Maro** — this is the worst core type in the file. `003-L0-0001` is a plain one-variable solve (3x−7=2x+5) that needs no option-substitution, so it does not teach the core skill. `003-E-0002` ((x+y)/(y−x) from x/y=4/7) is ratio manipulation, not X Maro. `003-M-0001` (20 coins, Rs 1/Rs 5, total 64) is a routine 2×2 solve and is an Easy, duplicating Coins and Denominations. `003-M-0002` and `003-H-0001` are duplicates of other core types' questions (see 4.3, 4.1). Only `003-E-0001` actually is X Maro. **Recommend rebuilding this core type from scratch**, with the L0 being a question that is genuinely faster by substituting options than by solving.
- **Linear – Three Variables** — as above: E1 and M2 are the same trick, and the Hard is off-type, so the six questions cover two ideas, not six.

**Core types whose ladders are genuinely well-built** (no change needed): No Solution Condition (the best in the file — L0 → find k → find the exception value of c → k²=36 with one root rejected → TITA → must-be-true), Numerator–Denominator (the Hard correctly changes the *question type* from "find it" to "count them"), Digit Equations, Transfer and Shifting, Reducible Equations, Nature of Roots, Sum/Product of Roots, Common Roots, Quadratic Factorisation, Linear – One Variable, Correct–Wrong Marks, Distinct Natural Number Equation Minimum, Quadratic Extrema Parameter.

# 4. Duplicates and near-duplicates

**4.1 Marks-scheme cluster — three Hards from one CAT parent.**
`Q-AL-EQN-01-007-H-0001` (60 Q, +4/−1, unattempted > wrong, max correct = **33**) and `Q-AL-EQN-03-007-H-0001` (60 Q, +4/−1/+2, wrong < unattempted, max correct = **33**) are the same question with the same answer — the only change is that unattempted questions earn 2 instead of 0. `Q-AL-EQN-04-003-H-0001` (50 Q, +4/−1, attempted > 40, min correct = 34) is the third sibling. Keep one; all three trace to CAT-2022-S2-QA-015.

**4.2 Simple-interest pair — same CAT question twice.**
`Q-AL-EQN-01-004-H-0001` (¼ at 8%, ⅓ at 12%, rest 6% → 12 years) and `Q-AL-EQN-03-002-H-0001` (⅕ at 9%, ¼ at 8%, rest 2% → 21 years). Identical template, both reskins of CAT-2022-S2-QA-018 (Mr Pinto). Keep one.

**4.3 `3x+7y=100` twice.**
`Q-AL-EQN-03-001-H-0001` (max x+y = 32) and `Q-AL-EQN-04-003-M-0002` (y as large as possible, x+y = 16). Same equation, opposite end of the same solution list.

**4.4 Two-denomination extremum pair.**
`Q-AL-EQN-01-002-H-0001` (Rs 20 / Rs 50, total 730, max Rs-50 count) and `Q-AL-EQN-03-006-H-0001` (Rs 2 / Rs 5, total 143, max coins). Same parity-plus-extremum idea.

**4.5 "30 items, three prices" template at two different levels.**
`Q-AL-EQN-01-003-H-0001` (30 articles at 15/40/90 = Rs 1050, max bags = 7) and `Q-AL-EQN-01-007-M-0001` (30 items at 10/25/40 = Rs 600, max cards = 9). Identical structure; one is keyed Hard, the other Medium, which also makes the level assignment indefensible.

**4.6 "20 coins, two denominations" twice, both answering 11.**
`Q-AL-EQN-04-003-M-0001` (Rs 1 / Rs 5, total 64 → 11) and `Q-AL-EQN-03-006-E-0001` (Rs 2 / Rs 5, total 73 → 11).

**4.7 Count-k-for-integer-roots twice.**
`Q-AL-EQN-02-009-E-0001` (x²−6x+k → 3) and `Q-AL-EQN-02-009-M-0001` (x²−8x+k → 4). Pure number change.

**4.8 Same equation asked twice in a row.**
`Q-AL-EQN-02-008-L0-0001` and `Q-AL-EQN-02-008-E-0001` both use x⁴−5x²+4=0 (first "what does it become", then "how many real roots"). Defensible as a deliberate L0→E pair, but a student sees the same object twice.

**4.9 Work-rate pair.** `Q-AL-EQN-01-005-E-0002` (1/12 + 1/18) and `Q-AL-EQN-01-005-M-0002` (1/15 + 1/10 − 1/30) — one extra term.

**4.10 Transformed-roots inverse pair.** `Q-AL-EQN-02-007-E-0002` (shift by −2 → x²−2x−3) and `Q-AL-EQN-02-007-H-0001` (given x²−10x+21, recover p, q) — and x²−10x+21 is itself option B in E2.

**4.11–4.17 Hard-is-a-CAT-reskin.** Seven more Hards (beyond 4.1 and 4.2) are the parent CAT question with new numbers or names rather than a new rung:

| Question | Parent | What changed |
|---|---|---|
| `Q-AL-EQN-02-002-H-0001` | CAT-2021-S2-QA-020 (2+√3 a root, a,b,c rational) | essentially verbatim; asks b²/ac instead |
| `Q-AL-EQN-02-005-H-0001` | CAT-2022-S3-QA-003 (no real roots + two distinct real roots) | 2x²+kx+5 → x²+kx+9; x²+(k−5)x+1 → x²+(k−1)x+1 |
| `Q-AL-EQN-02-008-H-0001` | CAT-2020-S2-QA-016 ((x²−5x+7)^(x+1)=1) | base +5 instead of +7, exponent made quadratic |
| `Q-AL-EQN-04-002-H-0001` | CAT-2025-S2-QA-034 (a+b+c+d=46, min of (a−b)²+…) | sum 46 → 20, integers → distinct naturals |
| `Q-AL-EQN-03-008-H-0001` | CAT-2023-S2-QA-037 (shared among n, Rs 352; two get Rs 506) | Rs 480; three get Rs 700 |
| `Q-AL-EQN-01-006-H-0001` | CAT-2021-S2-QA-008 (Anil, Bobby, Chintu profit share) | names changed to Anil, Bhavesh, Chirag |
| `Q-AL-EQN-02-010-M-0002` | CAT-2017-S2-QA-032 (min sum of squares of roots) | x²+(a+3)x−(a+5) → x²−(k+1)x+(k−3) — and it sits at **Medium**, so a CAT question is being served as a CET-scope Medium |

Net: **9 of the 30 Hards are reskins of their own parent.** A Hard that is the parent with new numbers gives the student nothing the parent would not, and if the parent is later shown in class the Hard is burnt.

# 5. Parent link problems

All 25 parent IDs resolve, all are `section = Quant`. 28 blank parents (as allowed, not flagged). Problems:

**Stretched or wrong links:**

| Rows | Parent | Why it is a stretch |
|---|---|---|
| `Q-AL-EQN-01-005-*` (all 6, Reciprocal Equations) | `604766a6` CAT-2021-S3-QA-015, 64 shirts in two sizes | A two-variable linear/integer problem. Nothing reciprocal about it. Wrong parent for the whole core type. |
| `Q-AL-EQN-04-001-*` (5 rows, Integer Factor Pair Optimization) | `604766a6` same shirts question | Not a factor-pair question. Wrong parent for the whole core type. |
| `Q-AL-EQN-03-005-*` (all 6, Heads and Legs) | `da0c7e37` CAT-2025-S1-QA-005, stocks at Rs 120/90/150 | A three-variable price/portfolio problem, not a heads-and-legs count. Weak fit for the whole core type. |
| `Q-AL-EQN-03-001-*` (6, Statement Equations) | `8a93781e` CAT-2020-S1-QA-008, A + mean(B,C) = 5 | Defensible for the Easies; but the Hard `001-H-0001` is 3x+7y=100, which this parent does not resemble. |
| `Q-AL-EQN-03-002-H-0001` | `53f1a676` CAT-2021-S1-QA-009, Amal buys pens at Rs 8 | **Wrong parent.** This question is a clone of the Pinto simple-interest question `48d9c793`, not of the Amal pens question. Repoint it (or delete it per 4.2). |
| `Q-AL-EQN-02-001-L0-0001` … `-M-0002` (5, Quadratic Factorisation) | `28aa36bf` CAT-2019-S1-QA-035, \|x²−x−6\| = x+2 | A modulus equation. Factorisation appears only as a sub-step. Stretch for a whole core type; `137290de` (already used by the Hard) or a plain factorisation PYQ fits better. |
| `Q-AL-EQN-04-002-M-0002` | `55bc0d96` (sharing among n people) | Off — this row is "four distinct naturals ≤ 15 summing to 50". Should point at `c4dc0e31` like its five siblings. |
| `Q-AL-EQN-04-003-M-0001` | `da0c7e37` (stocks) | The row is "20 coins, Rs 1 and Rs 5, total 64". Stretch. |

**Chapter mismatch:** 11 of the 25 parents have `ck_chapter = "Quadratic Equations"`, not `"Equations"` — covering **60 rows** (all of topic `Q-AL-EQN-02`). Topically these are the right parents (quadratic core types pointing at quadratic PYQs), so this is a *chapter-scoping* decision rather than 60 bad links: either the quadratic half of this file belongs in a separate `quadratic-equations` chapter, or `ck_chapter` on those CAT rows needs to be reconciled with this chapter's scope. Worth a decision before this ships, because it will decide where 60 questions live. The parents in question: `12402d96`, `137290de`, `28aa36bf`, `28e43558`, `4f089605`, `51afc537`, `741b6900`, `83bef475`, `871c9b38`, `9434bb70`, `a4de7fc9`, `d1773950`.

**Links that are genuinely good** (noting these so they are not re-worked): `ce24ca20` → Linear – One Variable; `34b4cc8b` → Linear – Three Variables; `ca0a7ee8` → No Solution Condition; `9c8b2054` → Ratio Equations; `4b9eee53` → Correct–Wrong Marks; `55bc0d96` → Distribution and Sharing; `c4dc0e31` → Distinct Natural Number Minimum; `4f089605` → Quadratic Formula; `9434bb70` → Nature of Roots; `12402d96` and `741b6900` → Common Roots; `28e43558` → Sum/Product of Roots; `51afc537`, `9e67f0f6`, `a4de7fc9` → Reducible Equations; `137290de` → Integer Roots Parameter; `871c9b38` → Equation from Roots; `d1773950` and `83bef475` → Quadratic Extrema Parameter; `48d9c793` → Fraction Equations.

# 6. Housekeeping

**Real defect (1):** `Q-AL-EQN-01-002-M-0001` — `correct_answer` = "50" but `option_e` = "Rs 50". (Also listed at 2.2.)

**Clean across all 180 rows:** LaTeX balanced (`$` count even in every text field) and every macro used is a real one (`\frac`, `\sqrt`, `\pm`, `\ne`, `\alpha`, `\beta`, `\le`, `\ge`, `\to`, `\Rightarrow`, `\equiv`, `\pmod`, `\bmod`, `\in`, `\cup`, `\gcd`, `\cdot`) — nothing will fail to render. No `₹` glyph and no "Rs." form; "Rs " used consistently. `exam_scope` correct on every row (CET on all 150 zero/easy/medium, CAT on all 30 hard). `question_code` level segment matches `difficulty_level` on all 180; `question_code` prefix matches `topic_id` on all 180; each core type maps to exactly one `topic_id` + sequence pair. `option_mistakes` is valid JSON with keys exactly the wrong letters in all 166 MCQs and absent on all 14 TITAs. No blanks in `question_text`, `solution`, `concept_note` or `shortcut_solution`.

**Structural notes (not row defects, but they will block ingest or review):**

1. `id` is blank on all 180 rows.
2. **The blueprint is not met.** `blueprint.md` specifies 15 questions per core type (L0 ×1, Easy ×4, Medium ×5, Hard ×5) with a golden spine of 4 per type. The file delivers **6 per core type (1 / 2 / 2 / 1)** — 180 against a blueprint target of 450. Either the blueprint needs re-freezing at 6, or this is 40% of the chapter.
3. `blueprint.md` is still the unfilled template (taxonomy version "v1 (frozen on `<date>` by Ravneet)", core-type row still `<core type>`).
4. `taxonomy.csv` contains **headers only** — no core_type rows, so nothing in this file is validated against a taxonomy, and `playbook.md` is an empty skeleton (master line, one concept, master formula all blank).
5. `reviews.csv` contains headers only — no review has been logged for any of the 180.
6. Eleven columns are empty in all 180 rows: `difficulty_dna`, `is_golden`, `solution_method`, `concept_reveal`, `formula_name`, `formula_mathjax`, `secondary_skills`, `source_exam`, `source_year`, `source_slot`, `source_reference`, `is_verbatim_pyq`. `difficulty_dna` and `is_golden` in particular are what the blueprint's golden-spine column depends on.

---

## What I would fix first

1. **The nine reskin Hards** (4.1, 4.2, 4.11–4.17). These are the questions that justify the chapter existing at CAT level, and right now a third of them add nothing to the parent.
2. **Rebuild X Maro** (section 3) — five of its six questions belong to other core types.
3. **The ambiguity in `Q-AL-EQN-02-004-M-0002`** — one word ("positive") fixes it.
4. **The seventeen duplicate pairs** — deleting one from each collapses ~15 slots that can be refilled with genuine rungs.
5. The one-character fix in `Q-AL-EQN-01-002-M-0001`.
