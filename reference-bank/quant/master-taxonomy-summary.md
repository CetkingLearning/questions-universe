# Quant master taxonomy – merge summary (15 Oct 2026)

Read-only build. Files in `/home/claude/taxo/`: `master.csv`, `sources-unmatched.csv`, `id-scheme.md`, `summary.md` (+ `build.py` and raw source dumps `src_b.tsv`, `src_c.txt`, `src_e.tsv`).

## Sources used

| Src | Where | Rows |
|---|---|---|
| A | Bible `bible-taxonomy.csv` (base) | 447 core types, 33 chapters, all `from_bible_unfrozen` |
| B | `public.question_taxonomy` (Quant / Quantitative Skills / Quantitative Aptitude) | 116 rows: 89 Quant, 25 NMAT Brown Book ("Quantitative Skills"), 2 CET pattern ("Quantitative Aptitude > Quantitative Reasoning") |
| C | `public.taxonomy_universe_nodes` (section_name='Quant') | 216 rows: 3 parent nodes (Arithmetic, Modern Maths, Equations) + 213 leaves. Columns: taxonomy_code, section_name, sub_section_name, topic_name, subtopic_name, core_type_name, canonical_path, status, source_refs, metadata |
| D | `public.cat_import_questions` (section='Quant', is_actual_cat) | 24 (subsection, chapter) buckets, 885 questions (7 Algebra questions have no ck_chapter) |
| E | Arena / War Room: `public.tests` (section_name='Quant') joined to `public.questions` on test_id | 5 Arena sub-sections, **14 topics, 35 subtopics, 495 questions** |

Arena note: `cetking_cat_arena_taxonomy_map` (11 rows) only maps Arena *sub-sections* (Arithmetic, Equations, Modern Maths, Numbers, TSDW + Logic/Verbal) to CAT taxonomy ids; it has no topic/subtopic list. The real Arena structure is `tests.sub_section_name / topic_name / sub_topic_name` with counts from `questions`. `saz_student_topic_progress` has the same 12 Quant topic names (student level only) and was used as a cross-check. universe_nodes (C) already mirrors every Arena subtopic, so Arena adds no new names, only question counts.

## master.csv

- 533 rows: 1 section, 7 subsections, 34 chapters (33 Bible + 1 proposed `Q-DS-DCM` Data Comparison), 491 core types.
- Core types: 447 Bible + 44 proposed additions.
- Of 447 Bible core types, 74 also appear in a Supabase source (25 exact-name, 49 synonym); 373 are Bible-only.
- Flags: 90 core types present in question_taxonomy, 118 in universe_nodes, 30 in Arena (plus chapter-level-only hits on Ages, Partnership, Equations from Arena and NMAT/CET chapter names on 20+ chapters).
- 39 rows carry playbook_rule / killer move from question_taxonomy (Averages 15, Mixtures 12, Surds & Indices 12).
- `cat_questions_in_chapter` on chapter rows (Equations = 95 Equations + 49 Quadratic because the Bible merges them). Chapters with 0 CAT questions in D: Ages, Partnership, Simplification, Pipes, Clocks, Calendars, Algebra (identities), Statistics, DI, DS, DCM.
- `arena_questions` on core-type rows (per Arena subtopic) and rolled up on chapter rows.

## Match results per source

| Status | B | C | E (Arena) |
|---|---|---|---|
| exact | 22 | 94 | 15 |
| synonym | 37 | 79 | 17 |
| new (proposed) | 32 | 12 | 0 (the 12 Arena-only names already exist in C, counted there) |
| chapter-level only | 25 | 28 | 3 |
| parent node | – | 3 | – |

C is heavily duplicated: most core types appear twice (`topic > core` and `topic > topic > core`), so 216 C rows collapse to ~118 distinct core types.

## Proposed additions (44 core types + 1 chapter) by chapter

Equations 7 (Integer Factor Pair Optimization, Distinct Natural Number Equation Minimum, Linear Equations and Max-Min, No Solution Condition, Integer Roots Parameter, Quadratic Extrema Parameter, X Maro) · Averages 4 (Pairwise A-B-C, Three Number Average Constraints, Applied Average Cases, Change in Average) · Progressions 4 (Iterative Series, Series Approximately, Cyclic Series, AP-GP Series) · Functions 3 (Greatest Integer Function Sets, f(x)g(x) based, Iterative Functions) · Mixtures 3 (Adding Impurity / Dilution, Transfer Between Mixtures / Vessels, Milk Water Replacement) · Geometry 3 (Regular Hexagon Midpoint Area Ratio, Isosceles Triangle Similarity Extension, Triangle Altitudes and Area) · Interest 2 (Simple Interest to Compound Interest, SI & CI Combined) · Ratios 2 (Ratio Table / Income Expenditure, Land Allocation Ratio) · Logarithms 2 (Integer Logarithm Inequality Count, Log Product Telescoping) · Surds 2 (Square Root Basics, Power Comparison / Ordering) · Numbers 2 (Digit Conditions and Factors, Consecutive Odd Balance Point) · Time & Work 2 (Team Work Replacement, Scheduling & Efficiency) · 1 each: Percentages (Percentage Max-Min), Profit & Loss (Discount Savings Profit), TSD (Speed Time AP-GP), Inequalities (Two Variables), Maxima & Minima (Integer Squared Difference Minimum), PnC (Sandwich Order Counting), Mensuration (Tangential Right Trapezium Area), Coordinate Geometry (Parallelogram Diagonal Intercept).
Source split: 32 from question_taxonomy + universe_nodes (the CAT "Breakup / X Maro / Vedic / Visual" strategy rows), 12 from universe_nodes + Arena.
Proposed chapter: `Q-DS-DCM` Data Comparison (CET pattern, from B+C).

## Judgement calls to check (all recorded in merge_notes / sources-unmatched reason)

1. Chapter re-homing by meaning: "Digit Conditions and Factors" (src "PnC & Factors") -> Numbers; "x + 1/x and x - 1/x Identities" and "Reciprocal Powers" (src Surds / "Powers and Identities") -> Algebra > Reciprocal Expressions; "Rhombus Diagonals and Area" and "Tangential Right Trapezium Area" (src Quadrilaterals) -> Mensuration; Triangles/Polygons core types -> Geometry; "Logs and Indices" -> Logarithms; Arena "Ratios > Partnership" -> Partnership chapter; Arena "Algebra > Nature of Roots / X Maro" -> Equations.
2. Synonyms that merge an Arena/Supabase bucket into one Bible core type: "Combined & Weighted Average" -> Combined Average; "Negative / Fractional Indices" -> Negative Indices; "Surd Simplification & Operations" -> Surd Simplification; "Factors Count Sum" -> Number of Factors; "Percentage Change" -> Net Percentage Change; "Compound Instalments / Present Value" -> EMI – Reducing Balance; "Prime-Factor Exponent Balancing" -> Integer Base–Exponent Cases; Arena "Inequality > Basics" and "Linear Inequalities" -> Linear.
3. "Change in Average" (Arena, 18 q) is a bucket over Bible AVG-005/006/007 (Addition/Removal/Replacement of member); left as proposed rather than forced onto one.
4. "X Maro" is a Cetking technique name, not a question type; kept as proposed for Ravneet to decide.
5. universe_nodes oddities: "Interest > Arithmetic > Simple Interest" has sub-section and topic swapped; "2 Variables" vs "Two Variables" and "Iterative functions" vs "Iterative Functions" treated as the same; Arena-style topics "Factorials", "Factors", "Others" fold into Number System.
6. NMAT Brown Book rows (B, 25) and CET "Quantitative Reasoning" rows (B, 2) are chapter names, not core types; attached to the chapter row (`in_question_taxonomy` = their uuid, merge_notes = "NMAT Brown Book chapter(s): ...", i.e. source_detail NMAT Brown Book). "Coordinate & Trig" attached to Coordinate Geometry only; "Average and Ages" to Averages only; "HCF LCM Simplification" and "Remainder, Last Digits" to Number System.
7. Bible chapters with no Supabase presence anywhere: Simplification, Clocks, Calendars, Statistics, Trigonometry (D has 8 CAT Trig questions but no taxonomy rows).
8. Three Bible rows have LaTeX-ish names (`x+y,\ xy`, `x-y,\ xy`, `x+\frac{k}{x}`); kept verbatim.

## sources-unmatched.csv

245 rows: every B/C/E row that was not an exact-name core-type match: synonym 133, new 44, chapter_only 56, parent_node 3, exact-after-normalisation 9. Each row has proposed chapter id/name, the master_id it landed on, and the reason.
