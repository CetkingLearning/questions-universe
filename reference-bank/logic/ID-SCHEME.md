# Logic (DILR) master taxonomy – ID scheme

Same shape as Quant (`Q-AR-PER-001`). Every level of the Logic taxonomy gets a short, human-readable ID, built left to right, so any ID tells you exactly where it sits.

## Levels

| Level | Pattern | Example |
|---|---|---|
| Section | `L` | `L` = Logic (CAT calls it DILR; MBA CET calls it Logical Reasoning + Abstract Reasoning) |
| Sub-section | `L-` + 2 letters | `L-AR` = Arrangement |
| Chapter | sub-section ID + `-` + 3 letters | `L-AR-WDW` = Wide Wordy |
| Core type | chapter ID + `-` + 3-digit number | `L-AB-CBD-004` = Painted Cubes |
| Question (future) | core type ID + `-` + level code + `-` + 4-digit number | `L-AR-WDW-001-C-0001` |

## Sub-section codes

CAT DILR (the four promoted Types = the Logic "Bible", dilr-world + CONTENT-UNIVERSES §12):
`L-AR` Arrangement · `L-CS` Caselet · `L-GR` Graphs (incl. Venn) · `L-SR` Schedule & Routing

Proposed (exist only in Supabase sources, for Rav to accept / reject):
`L-LR` Logical Reasoning (CET / NMAT style, single questions) · `L-AB` Abstract Reasoning (MBA CET; alias Visual Reasoning)

## Chapter codes

Arrangement: `WDW` Wide Wordy, `WDN` Wide Numbers, `TNW` Teeny Wordy, `TNN` Teeny Numbers, `GNT` Games & Tournaments (proposed)
Caselet: `CLS` Classification Caselets, `CAL` Calculation Caselets
Graphs: `TRD` Traditional Graphs, `TAB` Tables & Fill in the blanks, `ADV` Advanced Graphs (students never see "Graphs Modern"), `VEN` Venn
Schedule & Routing: `RTM` Routes & Maps, `SCH` Scheduling

Logical Reasoning (`L-LR`, all proposed; the CET group is kept in the `lr_group` column, it is not an ID level):
- Traditional Logic: `DIR` Direction Sense, `COD` Coding-Decoding, `BLR` Blood Relations, `SYL` Syllogism, `ANS` Alphanumeric Series, `NSR` Number Series
- Modern Logic: `SYM` Symbol-Based Maths, `VND` Venn Diagram (single-question), `SEQ` Sequencing & Ordering, `ODD` Odd Man Out, `ANL` Analogies, `DCM` Decision Making, `ORK` Order & Ranking, `INO` Input Output, `ALT` Alphabet Tests, `CLC` Clocks & Calendars, `CIQ` Coded Inequalities
- Puzzles: `MTX` Matrix Arrangement, `CDS` CAT DILR Set, `FBS` Floor Box Schedule, `SCB` Scheduling Based, `CIR` Circular Arrangement, `LIN` Linear Arrangement, `PAR` Parallel Arrangement, `NPZ` Number Puzzles (proposed, NMAT), `TNL` Truth & Lies (proposed)
- Critical Reasoning (the CET / NMAT LR kind — NOT CAT Verbal CR, which is `V-CR` in the Verbal master): `SAS` Statement Assumptions, `SCN` Statement Conclusions, `ASR` Assertion Reasoning, `SAR` Statement Arguments, `SIN` Statement & Inferences, `COA` Course of Action, `CEF` Cause Effect, `TCC` Truth Claim Conclusions (proposed)

Abstract Reasoning (`L-AB`, all proposed): `ASP` Abstract Series & Patterns, `MWI` Mirror & Water Image, `PFC` Paper Folding & Cutting, `FGC` Figure Counting, `DOT` Dot Concept, `FCM` Figure Completion, `CBD` Cubes & Dice

## Core-type numbering

- The Logic Bible (dilr-world + CONTENT-UNIVERSES) defines Types and G Strategies, i.e. sub-sections and chapters. It defines **no core types**, so no core type is "from the Bible". Nothing was invented to fill the gap.
- The only core types in the master are the 8 Arena sub-topics that already exist as question buckets (`L-LR-MTX-001` Single Matrix Puzzles, `L-LR-CEF-001/002` Paragraph / Statements Based, `L-LR-COD-001` Short Letters, `L-AB-CBD-001…004` Cube Placed / Folding Cube / Half Painted Cubes / Painted Cubes). All are `proposed_addition = yes`.
- When Rav defines core types for a CAT chapter they take `001`, `002`, … in the order he lists them (like the Quant Bible's sort_order). Numbers are permanent once accepted; a rejected number is retired, never reused.
- CONTENT-UNIVERSES §14 lists 13 question **patterns** (Fixed-Answer Deductions, Identification / Classification, Counting Valid Configurations, Calculation Deductions, Optimization, Yes/No or Determinability Checks, Comparison / Ranking, Matrix Grid Filling, Scheduling Matrix, Group Distribution, Venn Diagrams, Range / Possibility, Necessarily True / False). They are cross-cutting and are listed in the Unmatched-Proposed sheet as `pattern_tag`; Rav decides whether they become core types under each chapter (e.g. `L-AR-WDW-001` Fixed-Answer Deductions) or stay a separate tag on every set. The same rule as Quant applies: Question Type and Question Pattern stay separate.

## Question and set IDs (future – documented, not generated)

`<core type ID>-<level>-<serial>` where level is `L0` (foundation), `E` (easy), `M` (medium), `H` (hard), `C` (CAT level) and serial is a 4-digit running number within that core type + level. Difficulty names everywhere: Level 0 · Easy · Medium · Hard · CAT level.

DILR is set-based (CONTENT-UNIVERSES §14: Set ID → shared context → question IDs). Proposal for Rav: the serial identifies the **set** and a `-Q<n>` suffix the question inside it, e.g. `L-AR-WDW-001-C-0001-Q3` = Wide Wordy › core type 001 › CAT level › set 0001 › question 3. Until a CAT chapter has core types, sets attach at chapter level with core `000` (`L-AR-WDW-000-C-0001-Q3`) — Rav to confirm or change before any ID is printed.

Existing CAT PYQs keep their separate PYQ Historical ID (`CAT-2025-S1-DILR-001`) and their `supabase_id`; the master ID is a classification, not a replacement.

## Five examples

1. `L-AR-WDW` – Logic › Arrangement › Wide Wordy (Bible chapter; White Book ch.3 pp.22–34; 64 CAT rows / 12 sets in cat_import_questions).
2. `L-GR-VEN` – Logic › Graphs › Venn (Bible chapter; ck_topic_hierarchy "Venn Diagrams" and White Book ch.12 "Venn Diagrams" are synonyms; the Tarka card still shows Venn with Routes/Scheduling).
3. `L-AR-GNT` – Logic › Arrangement › Games & Tournaments – a *proposed chapter* (ck_topic_hierarchy proposed + 16 iimking CAT questions), not one of the 12 G Strategies.
4. `L-LR-CEF-002` – Logic › Logical Reasoning › Cause Effect › Statements Based – a *proposed core type* from an Arena test bucket (10 questions); CET group Critical Reasoning.
5. `L-AB-CBD-004` – Logic › Abstract Reasoning › Cubes & Dice › Painted Cubes – a *proposed core type* (Arena, 14 questions, 2 tests).
