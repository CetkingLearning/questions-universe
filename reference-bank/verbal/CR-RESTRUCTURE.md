# Critical Reasoning — restructured to 7 chapters × 2 core types

Ravneet, 15 Oct 2026 (sheet remarks + chat). Applied to Supabase the same night.

## The shape

Seven chapters. Inside every one, exactly two core types: **Single Statements** and **Passage based**.
Every CR question is one of those two forms, so `V-CR` now has 14 core types and nothing else.

| Chapter | Single Statements | Passage based | White Book |
|---|---|---|---|
| Arguments | `V-CR-ARG-001` | `V-CR-ARG-002` | ch 6 (p41–49) |
| Assumptions | `V-CR-ASM-001` | `V-CR-ASM-002` | — |
| Cause Effect Reasoning | `V-CR-CEF-001` | `V-CR-CEF-002` | ch 5 (p35–40) |
| Course of Action | `V-CR-COA-001` | `V-CR-COA-002` | — |
| Inference Based Questions | `V-CR-INF-001` | `V-CR-INF-002` | ch 2 (p10–20) |
| Similarity | `V-CR-SIM-001` | `V-CR-SIM-002` | — |
| Truth Claim Conclusions | `V-CR-TRC-001` | `V-CR-TRC-002` | — |

## What was merged away

| Retired | Into | Why |
|---|---|---|
| `V-CR-WST` Strength / Weaken Arguments (whole chapter) | **Arguments · Passage based** | Ravneet set WST-001's chapter to "Arguments" and its form to "Passage based" |
| `V-CR-FLW` Flaw & Paradox (whole chapter, 2 core types) | **Arguments · Passage based** | "Merge into Strength / Weaken Arguments" |
| Must-Be-True | **Inference** | "Merge both into Inference" |
| Identify Conclusion / Premise | **Arguments · Single Statements** | "Merge both into one Arguments Single Statements" |
| Necessary Assumption | **Assumptions · Single Statements** | "Merge both into Assumptions" |

Chapter count went 9 → 7; core types 13 → 14. Nothing was frozen, so retiring the two chapter codes
cost nothing — this is exactly why the taxonomy was left `from_bible_unfrozen`.

## How the questions were assigned

**By whether the question actually sits on a passage**, not by the Single/Passage label written next to
each ID in the sheet. The reason: the sheet marks `V-CR-CEF-001` and `V-CR-INF-001` as "Single
Statements", but those IDs carry the CAT PYQ questions, and **all 188 CAT PYQ Critical Reasoning
questions have a passage**. Read literally, the labels would have filed 188 passage questions as
standalone statements. The blank rows Ravneet added for the missing counterparts (Cause Effect ·
Passage based, Course of Action · Passage based, Similarity · Single Statements, Truth Claim
Conclusions · Passage based) show he was filling in the 7 × 2 grid, not assigning questions.

**Flagged for his confirmation. If the labels were meant literally, the mapping flips.**

### 249 questions mapped

| Core type | Rows | From |
|---|---:|---|
| `V-CR-INF-002` Inference · Passage based | 118 | 98 PYQ + 20 iimking |
| `V-CR-CEF-002` Cause Effect · Passage based | 57 | 44 PYQ + 13 iimking |
| `V-CR-ARG-002` Arguments · Passage based | 34 | 34 PYQ (the old Weakening Strengthening) |
| `V-CR-CEF-001` Cause Effect · Single Statements | 12 | iimking, no passage |
| `V-CR-SIM-002` Similarity · Passage based | 12 | 12 PYQ |
| `V-CR-ARG-001` Arguments · Single Statements | 9 | iimking "Argument", none has a passage |
| `V-CR-TRC-001` Truth Claim Conclusions · Single Statements | 6 | iimking, no passage |
| `V-CR-INF-001` Inference · Single Statements | 1 | iimking, no passage |

Stored as `ck_core_id` (+ `ck_tag_source = 'cr_restructure_15oct2026'`) on `cat_import_questions` and
`cat_verbal_pyq_questions`. Additive: `question_type`, `shortcut` and `g_strategy_official` keep their
raw source labels, and no answer, passage or option was touched.

Useful side effect: it settles an open question. The 9 iimking rows labelled **"Argument"** have no
passage at all, so they are Arguments · Single Statements — **not** the Weakening Strengthening rows
they had been provisionally mapped to.

## Still open

- **~136 more CR questions are hiding in the 424 untyped Reading Comprehension rows** — by text match
  against the 506-row master: Inference 53, Weakening Strengthening 38, Cause Effect 32, Similarity 13.
  They are **not** tagged here; they need the wider tagging (`TAGGING-PLAN.md`) approved first. With them,
  Inference · Passage based would reach ~171 and Arguments · Passage based ~72.
- **Similarity**: one sheet remark said "merge into Strength / Weaken Arguments", but Ravneet listed
  Similarity among the 7 chapters, so it stays its own chapter. Confirm.
- **The card-key bug** (`CARD-KEY-BUG.md`) must be fixed before any of this tagging reaches the
  Veda/Shabda/Tarka cards, or roughly a hundred questions get silently collapsed away.
- The Google Sheet still shows the old 9-chapter CR. Ravneet said he will update the sheet himself at
  the end; `master-taxonomy.csv` and `chapters.csv` here are already the new shape.
