# Quant master taxonomy – ID scheme

Every level of the Quant taxonomy gets a short, human-readable ID. IDs are built left to right, so any ID tells you exactly where it sits.

## Levels

| Level | Pattern | Example |
|---|---|---|
| Section | `Q` | `Q` = Quant |
| Sub-section | `Q-` + 2 letters | `Q-AR` = Arithmetic |
| Chapter | sub-section ID + `-` + 3 letters | `Q-AR-PER` = Percentages |
| Core type | chapter ID + `-` + 3-digit number | `Q-AR-PER-001` = Percentage Basics |
| Question (future) | core type ID + `-` + level code + `-` + 4-digit number | `Q-AR-PER-001-E-0001` |

## Sub-section codes

`Q-AR` Arithmetic · `Q-TW` TS&W (Time, Speed & Work) · `Q-AL` Algebra · `Q-NU` Numbers · `Q-MM` Modern Maths · `Q-GM` Geo Mensu · `Q-DS` DI/DS

## Chapter codes

Arithmetic: `PER` Percentages, `PNL` Profit Loss & Discount, `INT` Simple & Compound Interest, `RAT` Ratios & Proportion, `AVG` Averages, `MIX` Mixtures & Alligation, `AGE` Ages, `PRT` Partnership, `SIM` Simplification
TS&W: `TSD` Time Speed Distance, `TNW` Time & Work, `PIP` Pipes & Cisterns, `CLK` Clocks, `CAL` Calendars
Algebra: `EQN` Equations (linear + quadratic), `ALG` Algebra (identities/expressions), `INQ` Inequalities, `FNC` Functions, `MXM` Maxima & Minima, `PRG` Progressions AP/GP, `LOG` Logarithms, `SRD` Surds & Indices
Numbers: `NUM` Number System
Modern Maths: `PNC` Permutation & Combination, `PRB` Probability, `SET` Set Theory / Venn, `STA` Statistics
Geo Mensu: `GEO` Geometry, `MEN` Mensuration, `COG` Coordinate Geometry, `TRG` Trigonometry
DI/DS: `DIN` Data Interpretation, `DSF` Data Sufficiency, `DCM` Data Comparison (proposed – CET pattern, only in Supabase sources)

## Core-type numbering

- Numbers follow the Bible's `sort_order` inside each chapter: `001`, `002`, … in the order the Bible lists them.
- Core types that are NOT in the Bible (found only in `question_taxonomy`, `taxonomy_universe_nodes` or Arena) get the next free number after the Bible's last one in that chapter, e.g. Percentages has 28 Bible core types, so the proposed "Percentage Max-Min" becomes `Q-AR-PER-029`.
- Numbers are permanent once Ravneet accepts them. If a proposed row is rejected its number is simply retired (not reused), so IDs already printed anywhere never change meaning.

## Question IDs (future – documented, not generated)

`<core type ID>-<level>-<serial>` where level is one of `L0` (foundation), `E` (easy), `M` (medium), `H` (hard), `C` (CAT-level), and serial is a 4-digit running number within that core type + level.

## Five examples

1. `Q-AR-PER-001` – Quant › Arithmetic › Percentages › Percentage Basics (Bible QB-P-001).
2. `Q-TW-TNW-012` – Quant › TS&W › Time & Work › Mandays (Arena also has a "Mandays" topic; it maps here).
3. `Q-AL-SRD-015` – Quant › Algebra › Surds & Indices › Square Root Basics – a *proposed addition* (exists only in question_taxonomy / universe nodes), numbered after the Bible's 14 Surds core types.
4. `Q-DS-DCM` – Quant › DI/DS › Data Comparison – a *proposed chapter* (CET pattern) with no core types yet.
5. `Q-AR-PER-001-E-0001` – the first Easy question under Percentage Basics (future question ID; nothing generated yet).
