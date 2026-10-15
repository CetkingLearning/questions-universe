# Equations — production plan (Ravneet, 15 Oct 2026)

Rajat builds this with ChatGPT. Read `LADDER.md` and `WORKFLOW.md` too. Nothing is live until Ravneet approves.

## Scope — 17 core types only
Chapter **Q-AL-EQN Equations**. Ravneet opened the full chapter on 15 Oct 2026: all four topics are in scope — Q-AL-EQN-01 Linear Equations, Q-AL-EQN-02 Quadratic Equations & Roots, Q-AL-EQN-03 Equation Word Problems, Q-AL-EQN-04 Integer Solutions & Techniques (30 core types in all).

**Q-AL-EQN-01 Linear Equations (8)**
Linear – One Variable · Linear – Two Variables · Linear – Three Variables · Fraction Equations · Reciprocal Equations · Ratio Equations · Linear Equations and Max-Min · No Solution Condition

**Q-AL-EQN-03 Equation Word Problems (9)**
Statement Equations · Other Equation Applications · Digit Equations · Numerator–Denominator · Heads and Legs · Coins and Denominations · Correct–Wrong Marks · Distribution and Sharing · Transfer and Shifting

Ages, Ratios and Percentages are separate chapters — do not pull them in.

## The five levels — one pipeline for the chapter
| Level | What it is | Source |
|---|---|---|
| **Level 0** | the bare mechanic: what an equation is, transposition, one clear unknown | generated |
| **Easy** | solving: one / two / three variable, fractions, reciprocal, ratio — the topic 01 core types | the 37 Bible questions seed this |
| **Medium** | word problems: digits, heads & legs, coins, correct/wrong marks, sharing, transfer — the topic 03 core types | Bible + generated |
| **Hard** | multiple constraints, non-obvious equation forming, integer restrictions, efficient elimination | generated |
| **CAT level** | the 23 real CAT questions in `cat-universe/quant/algebra/equations.csv` | never generated, never edited |

Difficulty is judged by the **reasoning required**, not by big numbers, long wording or ugly arithmetic.

## Options rule (Ravneet, 15 Oct 2026)
These questions serve every exam, so the number of options changes by level:
- **Level 0 → two options A, B only** (Ravneet, 15 Oct 2026). Level 0 checks whether the bare idea has landed, so it is a straight either/or: the right answer and the one misconception that matters. `option_c`, `option_d`, `option_e` stay empty. Whoever builds a register or a worksheet from it reduces or renames nothing — the two options are already what he needs.
- **Easy, Medium → five options A–E** (CET / NMAT / SNAP pattern)
- **Hard and CAT level → four options A–D** (CAT pattern)
- **TITA only at CAT level** (Ravneet, 15 Oct 2026). Level 0, Easy, Medium and Hard are all multiple choice — no TITA anywhere below CAT level.
Exactly one option is correct. Equivalent forms must never compete (e.g. $\sqrt{45}$ and $3\sqrt{5}$).
The Level 0 distractor is never a careless-arithmetic slip — it is the single wrong idea a student actually holds (sign dropped, place value reversed, divided instead of multiplied). `option_mistakes` carries one entry only.

## Exam scope on every question
- `exam_scope = CET` → Level 0, Easy, Medium. A CET student's bank must be complete without anything above Medium.
- `exam_scope = CAT` → all five levels.

## Targets for the first bank
Per core type: **1 Level 0 · 2 Easy · 2 Medium · 1 Hard** (only where a genuine Hard exists).
17 core types ≈ **100 questions**, all linked up to the CAT questions by `parent_cat_id` (= the CAT question's `supabase_id`).

## The 37 Bible questions
`reference-bank/quant/linear-and-simple-equations-bible.csv` — classify each one into its core type **first**, then use it as a reference for level and style. Never copy its wording, never change its row.

## Start with a pilot
Build **one core type only — `Linear – Two Variables`** — all its levels, then stop. Ravneet reviews. Then the rest of topic 01, then topic 03.

## Every question must carry
`question_code` · `core_type` (from the list above) · `master_chapter_id = Q-AL-EQN` · `topic_id` · `difficulty_level` (zero/easy/medium/hard/cat) · `exam_scope` · stem · options per the rule above (or TITA answer) · `correct_option` + `correct_answer` · full verified solution · shortcut line · `concept_note` (which concepts it combines) · `source_type = original` · `parent_cat_id` · `status = draft`.

Maths in LaTeX: `$\sqrt{45}$`, `$2^{19}$`, `$\frac{a}{b}$` — never plain `2^19` or `sqrt(45)`.
Never label a generated question as an actual CAT question. Flag anything doubtful with `concept_note` starting "CHECK:".
