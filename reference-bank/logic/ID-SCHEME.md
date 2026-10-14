# Logic master taxonomy – ID scheme (decided by Rav, 15 Oct 2026)

Same shape as Quant (`Q-AR-PER-001`). Every level gets a short, human-readable ID, built left to right, so any ID tells you exactly where it sits.

## Levels

| Level | Pattern | Example |
|---|---|---|
| Section | `L` | `L` = Logic |
| Sub-section | `L-` + 2 letters | `L-AR` = Arrangement |
| Chapter | sub-section ID + `-` + 3 letters | `L-AR-WDW` = Wide Wordy |
| Core type | chapter ID + `-` + 3-digit number | `L-TL-BLR-002` = Pointing / Photograph Relations |
| Question (future) | core type ID + `-` + level + `-` + 4-digit number | `L-TL-BLR-002-E-0001` |
| DILR set question (future) | … + `-Q` + number inside the set | `L-AR-WDW-001-C-0001-Q3` |

Difficulty names and level codes: Level 0 `L0` · Easy `E` · Medium `M` · Hard `H` · CAT level `C`.

## Three families — kept separate (Rav, 15 Oct 2026)

CAT DILR logic is a different thing from CET/NMAT reasoning, so they sit in separate sub-sections and are never merged chapter-to-chapter. A later merge will be decided by Rav. Column `exam_family` on every row says which family it belongs to.

| Family | Sub-sections |
|---|---|
| **CAT DILR** (the Logic "Bible": 4 Types → 12 G Strategies) | `L-AR` Arrangement · `L-CS` Caselet · `L-GR` Graphs (incl. Venn) · `L-SR` Schedule & Routing |
| **CET / NMAT Logical Reasoning** (four sub-sections = the CET paper headings) | `L-TL` Traditional Logic · `L-ML` Modern Logic · `L-PZ` Puzzles · `L-CR` Critical Reasoning |
| **CET Abstract Reasoning** | `L-AB` Abstract Reasoning |

## Chapter codes

- **Arrangement:** `WDW` Wide Wordy, `WDN` Wide Numbers, `TNW` Teeny Wordy, `TNN` Teeny Numbers, `GNT` Games & Tournaments
- **Caselet:** `CLS` Classification Caselets, `CAL` Calculation Caselets
- **Graphs:** `TRD` Traditional Graphs, `TAB` Tables & Fill in the blanks, `ADV` Advanced Graphs, `VEN` Venn
- **Schedule & Routing:** `RTM` Routes & Maps, `SCH` Scheduling
- **Traditional Logic:** `DIR` Direction Sense, `COD` Coding-Decoding, `BLR` Blood Relations, `SYL` Syllogism, `ANS` Alphanumeric Series, `NSR` Number Series, `ALS` Alphabet Series, `WRD` Word Formation
- **Modern Logic:** `SYM` Symbol-Based Maths, `VND` Venn Diagram (single question), `SEQ` Sequencing & Ordering, `ODD` Odd Man Out, `ANL` Analogies, `DCM` Decision Making, `ORK` Order & Ranking, `INO` Input Output, `ALT` Alphabet Tests, `CLC` Clocks & Calendars, `CIQ` Coded Inequalities, `DSF` Data Sufficiency
- **Puzzles:** `MTX` Matrix Arrangement, `CDS` CAT DILR Set, `FBS` Floor Box Schedule, `SCB` Scheduling Based, `CIR` Circular Arrangement, `LIN` Linear Arrangement, `PAR` Parallel Arrangement, `NPZ` Number Puzzles, `TNL` Truth & Lies, `SEL` Selection & Grouping
- **Critical Reasoning:** CET/NMAT style only. CAT Verbal CR is `V-CR` in the Verbal master. `SAS` Statement Assumptions, `SCN` Statement Conclusions, `ASR` Assertion Reasoning, `SAR` Statement Arguments, `SIN` Statement & Inferences, `COA` Course of Action, `CEF` Cause Effect, `TCC` Truth Claim Conclusions
- **Abstract Reasoning:** `ASP` Abstract Series & Patterns, `MWI` Mirror & Water Image, `PFC` Paper Folding & Cutting, `FGC` Figure Counting, `DOT` Dot Concept, `FCM` Figure Completion, `CBD` Cubes & Dice, `FCL` Figure Classification, `FAN` Figure Analogy, `EMB` Embedded Figures

## Ownership rules (Rav, 15 Oct 2026)

- **Clocks & Calendars:** Logic only (`L-ML-CLC`). The Quant Bible's Clocks (`Q-TW-CLK`) and Calendars (`Q-TW-CAL`) move to Logic when the Quant master is regenerated.
- **Data Sufficiency:** Logic only (`L-ML-DSF`), even though some DS questions are quant-style. The Quant master's `Q-DS-DSF` moves here.
- **Venn:** all Venn questions go to Logic for now. CAT DILR Venn sets are `L-GR-VEN`; CET/NMAT single-question Venn is `L-ML-VND`. Maths-style Venn may move to Quant later.
- **Other Quant topics** found inside the CET/NMAT LR question bank (TSD, P&C, ratios, DI tables…) point to the Quant master IDs and are not duplicated in Logic.

## Core-type numbering

- **CAT DILR chapters have no core types yet.** The Bible stops at the 12 G Strategies. Core types arrive when Rav sorts the CAT sets. Until then a set attaches with core `000`, e.g. `L-AR-WDW-000-C-0001-Q3`.
- **Arena buckets keep the numbers they already had:** `L-TL-COD-001` Short Letters, `L-PZ-MTX-001` Single Matrix Puzzles, `L-CR-CEF-001/002` Paragraph / Statements Based, `L-AB-CBD-001…004` Cube Placed / Folding Cube / Half Painted / Painted Cubes.
- **CET/NMAT core types** (110) were grouped from the ~900 sub-topic labels in `pyq_question_bank`. They are numbered in a fixed teaching order inside each chapter, after the Arena ones. All are `proposed` until Rav accepts them.
- **Numbers are permanent once accepted.** A rejected number is retired, never reused.
- **CAT question patterns are tags, not core types** (Rav, 15 Oct 2026). The 13 patterns from CONTENT-UNIVERSES §14 (Fixed-Answer Deductions … Necessarily True / False) go in the `question_pattern` column of every CAT DILR question.

## Five examples

1. `L-AR-WDW` – Logic › Arrangement › Wide Wordy (CAT DILR; White Book ch.3 pp.22–34).
2. `L-GR-VEN` – Logic › Graphs › Venn (CAT DILR Venn sets; the Tarka card still bundles it with Routes/Scheduling).
3. `L-TL-BLR-002` – Logic › Traditional Logic › Blood Relations › Pointing / Photograph Relations (CET/NMAT).
4. `L-ML-DSF-005` – Logic › Modern Logic › Data Sufficiency › Quant-style DS (Logic only, per Rav).
5. `L-AR-WDW-001-C-0001-Q3` – question 3 of the first CAT-level Wide Wordy set under core type 001 (future ID; nothing generated yet).
