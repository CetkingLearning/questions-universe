# Verbal Master Taxonomy — ID scheme

Same shape as Quant's `Q-AR-PER-001`. Set by Ravneet, 15 Oct 2026.

```
V              - RC         - PAS         - 001        [ - E - 0001 ]
section          sub-section   chapter       core type    level  question
```

| Level | Format | Example | Count today |
|---|---|---|---|
| Section | `V` | `V` | 1 |
| Sub-section | `V-XX` (2 letters) | `V-PG` | 8 |
| Chapter | `V-XX-YYY` (3 letters) | `V-PG-JUM` | 43 |
| Core type | `V-XX-YYY-nnn` (3 digits) | `V-PG-JUM-001` | 92 |
| Question | `V-XX-YYY-nnn-L-nnnn` | `V-PG-JUM-001-E-0001` | documented, not generated |

Difficulty letters in a question ID: `L0` Level 0 · `E` Easy · `M` Medium · `H` Hard · `C` CAT level.
Same five names as Quant and the bank — never "Level 1–4".

## Sub-section codes

| Code | Sub-section | Is it a G Strategy family? |
|---|---|---|
| `V-RC` | Reading Comprehension | No — passage-level reading skill |
| `V-SM` | Summary | **Yes** — `shabda_shortcuts` slug `verbal-summary` |
| `V-PG` | Paragraph | **Yes** — `verbal-paragraph` |
| `V-EV` | Evidence | **Yes** — `verbal-evidence` (legacy name "Direct RC") |
| `V-CR` | Critical Reasoning | **Yes** — `verbal-critical-reasoning` |
| `V-VO` | Vocabulary | No — CET / NMAT side |
| `V-GR` | Grammar | No — CET / NMAT side |
| `V-GN` | Verbal General | No — strategy/intro videos only |

Ravneet's prompt listed `VO Vocabulary/Grammar if needed` as one code. Split into **two** here (`V-VO`, `V-GR`)
because they are 11 and 9 separate chapters with separate books and separate test sets. **Say the word and they merge.**

## Chapter codes

| Sub-section | Chapters |
|---|---|
| `V-RC` | `PAS` Passage Practice · `FUN` Passage Fundamentals · `DET` Detail & Fact-Based · `VIC` Vocabulary in Context · `EXC` Except Based |
| `V-SM` | `SUM` Non-RC Summary · `TSP` TSPM based |
| `V-PG` | `JUM` Para Jumbles · `OMO` Odd Man Out · `COM` Para Completion & Sentence Insertion · `JOI` Sentence Joining & Matching |
| `V-EV` | `WMT` Why Mention This · `TRF` Truth & Facts based |
| `V-CR` | **8 chapters, restructured by Rav 15 Oct 2026:** `ARG` Arguments · `ASR` Assertion Reasoning (8th chapter, added 15 Oct 2026 — CET / other exams, not CAT) · `ASM` Assumptions · `CEF` Cause Effect Reasoning · `COA` Course of Action · `INF` Inference Based Questions · `SIM` Similarity · `TRC` Truth Claim Conclusions. **Each one has exactly 2 core types: `-001` Single Statements and `-002` Passage based.** Retired: `WST` Strength/Weaken and `FLW` Flaw & Paradox, both folded into `ARG-002`. See `CR-RESTRUCTURE.md`. |
| `V-VO` | `SYN` `OWS` `IDM` `SPL` `ROT` `FIB` `CLZ` `CTX` `WRL` `HFW` `UNT` |
| `V-GR` | `SVA` `SIP` `ERR` `FOS` `VCE` `SPH` `POS` `GFB` `UNT` |
| `V-GN` | `INT` Strategy & Intro |

## Rules

1. **An ID is permanent.** Once Ravneet freezes a chapter, its core-type IDs never change, never get reused,
   and never renumber when something is inserted. New core types take the next free number in that chapter.
2. **Nothing above the core type is ever skipped.** Every question hangs off a core type, every core type off a
   chapter, every chapter off a sub-section.
3. **The existing Supabase IDs stay.** `taxonomy_universe_nodes.taxonomy_code` (TX_…), `question_taxonomy.id`,
   `ck_topic_hierarchy.id`, book chapter ids and Arena mapping ids are all preserved and recorded in
   `master.csv → source_ids_and_evidence`. The V- id is a new *additional* key, not a replacement — the
   foreign keys (`question_bank.taxonomy_id`, `taxonomy_question_links`, `dyntube_videos.hierarchy_id`,
   `cet_question_taxonomy_map`, `vocabulary_question_type_bank`) keep pointing where they point.
4. **Raw labels are never overwritten.** iimking's "Parajumbles", NMAT's "Cloze Tests", the CAT sheet's "TSPM"
   all stay in their own columns; the V- id is what everything joins on.

## Axes that are NOT levels

These are tags on a question or a passage, not steps in the tree. They live in their own columns:

`rc_non` (RC / Non RC) · `reading_ease` (Easy / Medium / Moderate / Hard — Medium and Moderate stay distinct)
· `essay_type` (passage subject: Business & Economics, History & Geography, Philosophy, Science & Tech,
Social Studies) · `g_strategy_type_of_mistake` (option-elimination: Opposites, Out of Scope, Distorted facts,
Partial reasoning …) · `is_except` (question form) · `cat_level` (CAT Easy / CAT Medium / CAT Hard, which is
separate from Arena's Level 0 → CAT level) · `arena_difficulty` / `arena_ready`.

A question can sit under exactly one core type and carry any number of these.
