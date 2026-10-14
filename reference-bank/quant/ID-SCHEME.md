# Quant master taxonomy – ID scheme (v2, 5 levels, 15 Oct 2026)

Every level of the Quant taxonomy gets a short, human-readable ID. IDs are built left to right, so any ID tells you exactly where it sits. The sub-topic (core type) ID is the full chain: section → sub-section → chapter → topic → core type.

## Levels

| Level | Pattern | Example |
|---|---|---|
| Section | `Q` | `Q` = Quant |
| Sub-section | `Q-` + 2 letters | `Q-AR` = Arithmetic |
| Chapter | sub-section ID + `-` + 3 letters | `Q-AR-PER` = Percentages |
| Topic (new) | chapter ID + `-` + 2-digit number | `Q-AR-PER-01` = Percentage Basics |
| Sub-topic = core type | topic ID + `-` + 3-digit number | `Q-AR-PER-01-001` = Percentage Basics (the core type) |
| Question (future) | core type ID + `-` + level code + `-` + 4-digit number | `Q-AR-PER-01-001-E-0001` |

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

## Topics (the new level)

- A topic is a teacher's "section of the chapter", grouped by solution structure (e.g. Averages: Read Total / Mix Totals / Repair Total; Time & Work: Fundamentals / Left Work / Scheduling & Efficiency / Mandays & Wages).
- 3–5 topics per chapter (4 is the target); a chapter with ≤5 core types may have 1–2.
- Where Arena (War Room) already had sub_topics for a chapter, they became the topics; Arena's names are kept in `topic_aliases`.
- Topic numbers are `01`, `02`, … in teaching order inside the chapter.

## Core-type numbering

- Core types are numbered `001`, `002`, … **inside their topic**, in Bible order (the Bible's `sort_order`, which is also the v1 order).
- Core types that are NOT in the Bible (proposed additions) keep their position after the Bible core types of the same topic.
- Every v1 ID (e.g. `Q-AR-PER-006`) is kept in the `old_core_type_id` column so anything printed with a v1 ID can still be traced.
- Numbers are permanent once Ravneet accepts them. If a proposed row is rejected its number is retired (not reused).

## Question IDs (future – documented, not generated)

`<core type ID>-<level>-<serial>` where level is one of `L0` (foundation), `E` (easy), `M` (medium), `H` (hard), `C` (CAT-level), and serial is a 4-digit running number within that core type + level.

## Five examples (one per level)

1. `Q` – Section: Quant.
2. `Q-AR` – Sub-section: Quant › Arithmetic.
3. `Q-AR-PER` – Chapter: Quant › Arithmetic › Percentages.
4. `Q-AR-PER-02` – Topic: Quant › Arithmetic › Percentages › Percentage Change (Arena alias "Percentages > Percentage Change").
5. `Q-AR-PER-02-003` – Sub-topic / core type: Quant › Arithmetic › Percentages › Percentage Change › Successive Change (v1 id `Q-AR-PER-006`, Bible QB-P-006).
