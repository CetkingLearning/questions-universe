-- =====================================================================================
-- public.logic_master_taxonomy  —  Cetking Master Taxonomy, section LOGIC (DILR + CET/NMAT LR + Abstract)
-- Prepared 15 Oct 2026 by Claude. NOT APPLIED. Same columns as the planned quant_master_taxonomy
-- (core_id, section, subsection, chapter, core_type, sort_order, status, frozen_at, frozen_by, source)
-- + level / parent_id / exam_family / proposed because the Logic master has rows at every level
-- (the Bible defines Types and G Strategies but no core types).
--
-- Control Room (schema control_room): before running, register a session + change request
-- (see the INSERTs at the end), run, verify with the SELECTs, then record the handover.
-- Rav: say "create the taxonomy table" and Claude runs this with you present.
-- =====================================================================================

create table if not exists public.logic_master_taxonomy (
  core_id      text primary key,                         -- master_id at any level: L, L-AR, L-AR-WDW, L-AB-CBD-004
  level        text not null check (level in ('section','subsection','chapter','core_type')),
  parent_id    text references public.logic_master_taxonomy(core_id),
  section      text not null default 'Logic',
  subsection   text,                                     -- Arrangement · Caselet · Graphs · Schedule & Routing (CAT DILR) · Traditional Logic · Modern Logic · Puzzles · Critical Reasoning (CET/NMAT) · Abstract Reasoning
  chapter      text,                                     -- Wide Wordy, Venn, Syllogism …
  core_type    text,                                     -- 118 proposed (8 Arena buckets + 110 grouped from CET/NMAT PYQ sub-topics)
  exam_family  text,                                     -- CAT DILR · CET / NMAT Logical Reasoning · CET Abstract Reasoning (kept separate, Rav 15 Oct 2026)
  sort_order   integer not null,
  status       text not null default 'from_bible_unfrozen'
               check (status in ('from_bible_unfrozen','proposed','accepted','rejected','frozen')),
  proposed     boolean not null default false,            -- true = found only in Supabase sources (question_taxonomy / universe_nodes / Arena / ck_topic_hierarchy …)
  source       text,                                     -- where the row comes from (Bible / which tables)
  frozen_at    timestamptz,
  frozen_by    text,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
comment on table public.logic_master_taxonomy is 'Cetking Master Taxonomy — Logic (DILR). One row per level with an ID at every level (see questions-universe/reference-bank/logic/ID-SCHEME.md). Rows stay from_bible_unfrozen / proposed until Rav freezes a chapter.';
create index if not exists logic_master_taxonomy_parent_idx on public.logic_master_taxonomy(parent_id);
create index if not exists logic_master_taxonomy_level_idx on public.logic_master_taxonomy(level, sort_order);

-- Row-level security like the other read-only catalog tables: anyone can read, nobody writes through the API.
alter table public.logic_master_taxonomy enable row level security;
drop policy if exists logic_master_taxonomy_read on public.logic_master_taxonomy;
create policy logic_master_taxonomy_read on public.logic_master_taxonomy for select using (true);

-- ---------------------------------------------------------------------------------------
-- Rows (189): generated from reference-bank/logic/master-taxonomy.csv — rav_decision blank = not yet accepted
-- ---------------------------------------------------------------------------------------
insert into public.logic_master_taxonomy
  (core_id, level, parent_id, section, subsection, chapter, core_type, exam_family, sort_order, status, proposed, source)
values
  ('L', 'section', null, 'Logic', null, null, null, 'all', 1, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR', 'subsection', 'L', 'Logic', 'Arrangement', null, null, 'CAT DILR', 2, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-WDW', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Wide Wordy', null, 'CAT DILR', 3, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-WDN', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Wide Numbers', null, 'CAT DILR', 4, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-TNW', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Teeny Wordy', null, 'CAT DILR', 5, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-TNN', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Teeny Numbers', null, 'CAT DILR', 6, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-GNT', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Games & Tournaments', null, 'CAT DILR', 7, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-CS', 'subsection', 'L', 'Logic', 'Caselet', null, null, 'CAT DILR', 8, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-CS-CLS', 'chapter', 'L-CS', 'Logic', 'Caselet', 'Classification Caselets', null, 'CAT DILR', 9, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-CS-CAL', 'chapter', 'L-CS', 'Logic', 'Caselet', 'Calculation Caselets', null, 'CAT DILR', 10, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR', 'subsection', 'L', 'Logic', 'Graphs', null, null, 'CAT DILR', 11, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-TRD', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Traditional Graphs', null, 'CAT DILR', 12, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-TAB', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Tables & Fill in the blanks', null, 'CAT DILR', 13, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-ADV', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Advanced Graphs', null, 'CAT DILR', 14, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-VEN', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Venn', null, 'CAT DILR', 15, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR', 'subsection', 'L', 'Logic', 'Schedule & Routing', null, null, 'CAT DILR', 16, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR-RTM', 'chapter', 'L-SR', 'Logic', 'Schedule & Routing', 'Routes & Maps', null, 'CAT DILR', 17, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR-SCH', 'chapter', 'L-SR', 'Logic', 'Schedule & Routing', 'Scheduling', null, 'CAT DILR', 18, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-TL', 'subsection', 'L', 'Logic', 'Traditional Logic', null, null, 'CET / NMAT Logical Reasoning', 19, 'proposed', true, 'Traditional Logic group ← lms_topics:38c7acac'),
  ('L-TL-DIR', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Direction Sense', null, 'CET / NMAT Logical Reasoning', 20, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Direction Sense"); pyq_question_bank'),
  ('L-TL-DIR-001', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Rotated / Coded Directions', 'CET / NMAT Logical Reasoning', 21, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-002', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Angle & Degree Turns', 'CET / NMAT Logical Reasoning', 22, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-003', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Direction in Seating / Clock', 'CET / NMAT Logical Reasoning', 23, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-004', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Shortest Distance & Displacement', 'CET / NMAT Logical Reasoning', 24, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-005', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Relative Direction & Position', 'CET / NMAT Logical Reasoning', 25, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-006', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Final Direction after Turns', 'CET / NMAT Logical Reasoning', 26, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Coding-Decoding', null, 'CET / NMAT Logical Reasoning', 27, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Coding Decoding"); pyq_question_bank'),
  ('L-TL-COD-001', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Short Letters', 'CET / NMAT Logical Reasoning', 28, 'proposed', true, 'Arena tests "Logic > Traditional Logic > Coding Decoding > Short Letters" (1 test, 6 Qs); universe node ea7edd3c'),
  ('L-TL-COD-002', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Symbol Coding', 'CET / NMAT Logical Reasoning', 29, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-003', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Word / Sentence Coding', 'CET / NMAT Logical Reasoning', 30, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-004', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Substitution Coding', 'CET / NMAT Logical Reasoning', 31, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-005', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Letter ↔ Number Coding', 'CET / NMAT Logical Reasoning', 32, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-006', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Letter Shift Coding', 'CET / NMAT Logical Reasoning', 33, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Blood Relations', null, 'CET / NMAT Logical Reasoning', 34, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Blood Relation"); pyq_question_bank'),
  ('L-TL-BLR-001', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Coded Blood Relations', 'CET / NMAT Logical Reasoning', 35, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR-002', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Pointing / Photograph Relations', 'CET / NMAT Logical Reasoning', 36, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR-003', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Family Tree & Counting', 'CET / NMAT Logical Reasoning', 37, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR-004', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Relation Chain', 'CET / NMAT Logical Reasoning', 38, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Syllogism', null, 'CET / NMAT Logical Reasoning', 39, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Syllogism I"); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Syllogism II"); pyq_question_bank'),
  ('L-TL-SYL-001', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Individual Membership', 'CET / NMAT Logical Reasoning', 40, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-002', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Either-Or / Complementary Pair', 'CET / NMAT Logical Reasoning', 41, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-003', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Possibility Conclusions', 'CET / NMAT Logical Reasoning', 42, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-004', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Chain (3–4 statements)', 'CET / NMAT Logical Reasoning', 43, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-005', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Two-Statement Syllogism', 'CET / NMAT Logical Reasoning', 44, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Alphanumeric Series', null, 'CET / NMAT Logical Reasoning', 45, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); pyq_question_bank'),
  ('L-TL-ANS-001', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Position-based Questions', 'CET / NMAT Logical Reasoning', 46, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-002', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Condition Counting', 'CET / NMAT Logical Reasoning', 47, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-003', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Alphanumeric Term Series', 'CET / NMAT Logical Reasoning', 48, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Number Series', null, 'CET / NMAT Logical Reasoning', 49, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Number Series"); pyq_question_bank'),
  ('L-TL-NSR-001', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Wrong Term', 'CET / NMAT Logical Reasoning', 50, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-002', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Missing Number in Figure / Grid', 'CET / NMAT Logical Reasoning', 51, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-003', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Digit-based Series', 'CET / NMAT Logical Reasoning', 52, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-004', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Repeating / Cyclic Series', 'CET / NMAT Logical Reasoning', 53, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-005', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Alternating / Interleaved Series', 'CET / NMAT Logical Reasoning', 54, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-006', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Powers & Special Numbers', 'CET / NMAT Logical Reasoning', 55, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-007', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Difference Series', 'CET / NMAT Logical Reasoning', 56, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-008', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Multiply / Operation Series', 'CET / NMAT Logical Reasoning', 57, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ALS', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Alphabet Series', null, 'CET / NMAT Logical Reasoning', 58, 'proposed', true, 'pyq_question_bank'),
  ('L-TL-ALS-001', 'core_type', 'L-TL-ALS', 'Logic', 'Traditional Logic', 'Alphabet Series', 'Letter Matrix & Counting', 'CET / NMAT Logical Reasoning', 59, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ALS-002', 'core_type', 'L-TL-ALS', 'Logic', 'Traditional Logic', 'Alphabet Series', 'Alphabet Position & Rearrangement', 'CET / NMAT Logical Reasoning', 60, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ALS-003', 'core_type', 'L-TL-ALS', 'Logic', 'Traditional Logic', 'Alphabet Series', 'Letter Series', 'CET / NMAT Logical Reasoning', 61, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-WRD', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Word Formation', null, 'CET / NMAT Logical Reasoning', 62, 'proposed', true, 'pyq_question_bank'),
  ('L-TL-WRD-001', 'core_type', 'L-TL-WRD', 'Logic', 'Traditional Logic', 'Word Formation', 'Anagram & Word Count', 'CET / NMAT Logical Reasoning', 63, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-WRD-002', 'core_type', 'L-TL-WRD', 'Logic', 'Traditional Logic', 'Word Formation', 'Word from Given Letters / Positions', 'CET / NMAT Logical Reasoning', 64, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML', 'subsection', 'L', 'Logic', 'Modern Logic', null, null, 'CET / NMAT Logical Reasoning', 65, 'proposed', true, 'Modern Logic group ← taxonomy_universe_nodes:a5da5846, lms_topics:3a1c1eff, questions_path:Logic > Modern Logic'),
  ('L-ML-SYM', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Symbol-Based Maths', null, 'CET / NMAT Logical Reasoning', 66, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); pyq_question_bank'),
  ('L-ML-SYM-001', 'core_type', 'L-ML-SYM', 'Logic', 'Modern Logic', 'Symbol-Based Maths', 'Sign / Number Interchange', 'CET / NMAT Logical Reasoning', 67, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-SYM-002', 'core_type', 'L-ML-SYM', 'Logic', 'Modern Logic', 'Symbol-Based Maths', 'Symbol / Operator Substitution (BODMAS)', 'CET / NMAT Logical Reasoning', 68, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-VND', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', null, 'CET / NMAT Logical Reasoning', 69, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Venn Diagram"); pyq_question_bank'),
  ('L-ML-VND-001', 'core_type', 'L-ML-VND', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', 'Classes to Diagram', 'CET / NMAT Logical Reasoning', 70, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-VND-002', 'core_type', 'L-ML-VND', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', 'Region Reading', 'CET / NMAT Logical Reasoning', 71, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-VND-003', 'core_type', 'L-ML-VND', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', 'Venn Counting', 'CET / NMAT Logical Reasoning', 72, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-SEQ', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Sequencing & Ordering', null, 'CET / NMAT Logical Reasoning', 73, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Sequence of words"); pyq_question_bank'),
  ('L-ML-SEQ-001', 'core_type', 'L-ML-SEQ', 'Logic', 'Modern Logic', 'Sequencing & Ordering', 'Dictionary Order', 'CET / NMAT Logical Reasoning', 74, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-SEQ-002', 'core_type', 'L-ML-SEQ', 'Logic', 'Modern Logic', 'Sequencing & Ordering', 'Logical Word Sequence', 'CET / NMAT Logical Reasoning', 75, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ODD', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Odd Man Out', null, 'CET / NMAT Logical Reasoning', 76, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Classification"); pyq_question_bank'),
  ('L-ML-ODD-001', 'core_type', 'L-ML-ODD', 'Logic', 'Modern Logic', 'Odd Man Out', 'Letter Odd One', 'CET / NMAT Logical Reasoning', 77, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ODD-002', 'core_type', 'L-ML-ODD', 'Logic', 'Modern Logic', 'Odd Man Out', 'Number Odd One', 'CET / NMAT Logical Reasoning', 78, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ODD-003', 'core_type', 'L-ML-ODD', 'Logic', 'Modern Logic', 'Odd Man Out', 'Word / Meaning Odd One', 'CET / NMAT Logical Reasoning', 79, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ANL', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Analogies', null, 'CET / NMAT Logical Reasoning', 80, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Analogy"); pyq_question_bank'),
  ('L-ML-ANL-001', 'core_type', 'L-ML-ANL', 'Logic', 'Modern Logic', 'Analogies', 'Letter Analogy', 'CET / NMAT Logical Reasoning', 81, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ANL-002', 'core_type', 'L-ML-ANL', 'Logic', 'Modern Logic', 'Analogies', 'Number Analogy', 'CET / NMAT Logical Reasoning', 82, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ANL-003', 'core_type', 'L-ML-ANL', 'Logic', 'Modern Logic', 'Analogies', 'Word Analogy', 'CET / NMAT Logical Reasoning', 83, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DCM', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Decision Making', null, 'CET / NMAT Logical Reasoning', 84, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Decision Making"); pyq_question_bank'),
  ('L-ML-DCM-001', 'core_type', 'L-ML-DCM', 'Logic', 'Modern Logic', 'Decision Making', 'Eligibility / Selection Criteria', 'CET / NMAT Logical Reasoning', 85, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ORK', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Order & Ranking', null, 'CET / NMAT Logical Reasoning', 86, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); pyq_question_bank'),
  ('L-ML-ORK-001', 'core_type', 'L-ML-ORK', 'Logic', 'Modern Logic', 'Order & Ranking', 'Comparison Chain', 'CET / NMAT Logical Reasoning', 87, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ORK-002', 'core_type', 'L-ML-ORK', 'Logic', 'Modern Logic', 'Order & Ranking', 'Position & Rank in a Row', 'CET / NMAT Logical Reasoning', 88, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-INO', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Input Output', null, 'CET / NMAT Logical Reasoning', 89, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Input Output"); pyq_question_bank'),
  ('L-ML-INO-001', 'core_type', 'L-ML-INO', 'Logic', 'Modern Logic', 'Input Output', 'Password Rearrangement', 'CET / NMAT Logical Reasoning', 90, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-INO-002', 'core_type', 'L-ML-INO', 'Logic', 'Modern Logic', 'Input Output', 'Digit Sorting Machine', 'CET / NMAT Logical Reasoning', 91, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-INO-003', 'core_type', 'L-ML-INO', 'Logic', 'Modern Logic', 'Input Output', 'Word–Number Arrangement Steps', 'CET / NMAT Logical Reasoning', 92, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ALT', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Alphabet Tests', null, 'CET / NMAT Logical Reasoning', 93, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Alphabet Test")'),
  ('L-ML-CLC', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Clocks & Calendars', null, 'CET / NMAT Logical Reasoning', 94, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Clocks"); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Calendars"); pyq_question_bank'),
  ('L-ML-CLC-001', 'core_type', 'L-ML-CLC', 'Logic', 'Modern Logic', 'Clocks & Calendars', 'Clock Hands & Angles', 'CET / NMAT Logical Reasoning', 95, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CLC-002', 'core_type', 'L-ML-CLC', 'Logic', 'Modern Logic', 'Clocks & Calendars', 'Time Calculation', 'CET / NMAT Logical Reasoning', 96, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CLC-003', 'core_type', 'L-ML-CLC', 'Logic', 'Modern Logic', 'Clocks & Calendars', 'Calendar & Odd Days', 'CET / NMAT Logical Reasoning', 97, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CIQ', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Coded Inequalities', null, 'CET / NMAT Logical Reasoning', 98, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Coded Inequalities"); pyq_question_bank'),
  ('L-ML-CIQ-001', 'core_type', 'L-ML-CIQ', 'Logic', 'Modern Logic', 'Coded Inequalities', 'Coded / Symbol Inequality', 'CET / NMAT Logical Reasoning', 99, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CIQ-002', 'core_type', 'L-ML-CIQ', 'Logic', 'Modern Logic', 'Coded Inequalities', 'Direct Inequality Chain', 'CET / NMAT Logical Reasoning', 100, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Data Sufficiency', null, 'CET / NMAT Logical Reasoning', 101, 'proposed', true, 'pyq_question_bank'),
  ('L-ML-DSF-001', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Arrangement & Ranking DS', 'CET / NMAT Logical Reasoning', 102, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-002', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Age DS', 'CET / NMAT Logical Reasoning', 103, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-003', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Direction / Coding DS', 'CET / NMAT Logical Reasoning', 104, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-004', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Quant-style DS', 'CET / NMAT Logical Reasoning', 105, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-005', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Statement Combination DS', 'CET / NMAT Logical Reasoning', 106, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ', 'subsection', 'L', 'Logic', 'Puzzles', null, null, 'CET / NMAT Logical Reasoning', 107, 'proposed', true, 'Puzzles group ← question_taxonomy:270c1e7e, taxonomy_universe_nodes:3977ff7e, lms_topics:ac835839, ck_topic_hierarchy:c6d02871'),
  ('L-PZ-MTX', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Matrix Arrangement', null, 'CET / NMAT Logical Reasoning', 108, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-MTX-001', 'core_type', 'L-PZ-MTX', 'Logic', 'Puzzles', 'Matrix Arrangement', 'Single Matrix Puzzles', 'CET / NMAT Logical Reasoning', 109, 'proposed', true, 'Arena tests "Logic > Arrangements > Matrix based Puzzles > Single Matrix Puzzles" (3 tests, 14 Qs); universe node de678490'),
  ('L-PZ-MTX-002', 'core_type', 'L-PZ-MTX', 'Logic', 'Puzzles', 'Matrix Arrangement', 'Multi-attribute Matching', 'CET / NMAT Logical Reasoning', 110, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-CDS', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'CAT DILR Set', null, 'CET / NMAT Logical Reasoning', 111, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-PZ-FBS', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Floor Box Schedule', null, 'CET / NMAT Logical Reasoning', 112, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-FBS-001', 'core_type', 'L-PZ-FBS', 'Logic', 'Puzzles', 'Floor Box Schedule', 'Box / Stack Puzzles', 'CET / NMAT Logical Reasoning', 113, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-SCB', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Scheduling Based', null, 'CET / NMAT Logical Reasoning', 114, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-SCB-001', 'core_type', 'L-PZ-SCB', 'Logic', 'Puzzles', 'Scheduling Based', 'Day / Slot Scheduling', 'CET / NMAT Logical Reasoning', 115, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-CIR', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Circular Arrangement', null, 'CET / NMAT Logical Reasoning', 116, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-CIR-001', 'core_type', 'L-PZ-CIR', 'Logic', 'Puzzles', 'Circular Arrangement', 'Polygon / Compass Seating', 'CET / NMAT Logical Reasoning', 117, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-CIR-002', 'core_type', 'L-PZ-CIR', 'Logic', 'Puzzles', 'Circular Arrangement', 'Circular Seating Facing Centre', 'CET / NMAT Logical Reasoning', 118, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-LIN', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Linear Arrangement', null, 'CET / NMAT Logical Reasoning', 119, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-LIN-001', 'core_type', 'L-PZ-LIN', 'Logic', 'Puzzles', 'Linear Arrangement', 'Queue & Position Counting', 'CET / NMAT Logical Reasoning', 120, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-LIN-002', 'core_type', 'L-PZ-LIN', 'Logic', 'Puzzles', 'Linear Arrangement', 'Order of Arrival / Stops', 'CET / NMAT Logical Reasoning', 121, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-LIN-003', 'core_type', 'L-PZ-LIN', 'Logic', 'Puzzles', 'Linear Arrangement', 'Single Row Seating', 'CET / NMAT Logical Reasoning', 122, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-PAR', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Parallel Arrangement', null, 'CET / NMAT Logical Reasoning', 123, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-PAR-001', 'core_type', 'L-PZ-PAR', 'Logic', 'Puzzles', 'Parallel Arrangement', 'Two Rows Facing', 'CET / NMAT Logical Reasoning', 124, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-NPZ', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Number Puzzles', null, 'CET / NMAT Logical Reasoning', 125, 'proposed', true, 'question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Number Puzzles"); pyq_question_bank'),
  ('L-PZ-NPZ-001', 'core_type', 'L-PZ-NPZ', 'Logic', 'Puzzles', 'Number Puzzles', 'Scores & Tournaments', 'CET / NMAT Logical Reasoning', 126, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-NPZ-002', 'core_type', 'L-PZ-NPZ', 'Logic', 'Puzzles', 'Number Puzzles', 'Counting / Pigeonhole', 'CET / NMAT Logical Reasoning', 127, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-NPZ-003', 'core_type', 'L-PZ-NPZ', 'Logic', 'Puzzles', 'Number Puzzles', 'Digit & Number Arrangement', 'CET / NMAT Logical Reasoning', 128, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-TNL', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Truth & Lies', null, 'CET / NMAT Logical Reasoning', 129, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-PZ-SEL', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Selection & Grouping', null, 'CET / NMAT Logical Reasoning', 130, 'proposed', true, 'pyq_question_bank'),
  ('L-PZ-SEL-001', 'core_type', 'L-PZ-SEL', 'Logic', 'Puzzles', 'Selection & Grouping', 'Combination Counting', 'CET / NMAT Logical Reasoning', 131, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-SEL-002', 'core_type', 'L-PZ-SEL', 'Logic', 'Puzzles', 'Selection & Grouping', 'Team / Item Selection with Conditions', 'CET / NMAT Logical Reasoning', 132, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR', 'subsection', 'L', 'Logic', 'Critical Reasoning', null, null, 'CET / NMAT Logical Reasoning', 133, 'proposed', true, 'Critical Reasoning group ← taxonomy_universe_nodes:0b152648, questions_path:Logic > Critical Reasoning'),
  ('L-CR-SAS', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement Assumptions', null, 'CET / NMAT Logical Reasoning', 134, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Assumptions"); pyq_question_bank'),
  ('L-CR-SAS-001', 'core_type', 'L-CR-SAS', 'Logic', 'Critical Reasoning', 'Statement Assumptions', 'Implicit Assumptions', 'CET / NMAT Logical Reasoning', 135, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SCN', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement Conclusions', null, 'CET / NMAT Logical Reasoning', 136, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Conclusions"); pyq_question_bank'),
  ('L-CR-SCN-001', 'core_type', 'L-CR-SCN', 'Logic', 'Critical Reasoning', 'Statement Conclusions', 'Fact Check / Must Be True', 'CET / NMAT Logical Reasoning', 137, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SCN-002', 'core_type', 'L-CR-SCN', 'Logic', 'Critical Reasoning', 'Statement Conclusions', 'Conclusion from Statements', 'CET / NMAT Logical Reasoning', 138, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-ASR', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Assertion Reasoning', null, 'CET / NMAT Logical Reasoning', 139, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); pyq_question_bank'),
  ('L-CR-ASR-001', 'core_type', 'L-CR-ASR', 'Logic', 'Critical Reasoning', 'Assertion Reasoning', 'Assertion–Reason (fact based)', 'CET / NMAT Logical Reasoning', 140, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SAR', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement Arguments', null, 'CET / NMAT Logical Reasoning', 141, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Arguments"); pyq_question_bank'),
  ('L-CR-SIN', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement & Inferences', null, 'CET / NMAT Logical Reasoning', 142, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); pyq_question_bank'),
  ('L-CR-SIN-001', 'core_type', 'L-CR-SIN', 'Logic', 'Critical Reasoning', 'Statement & Inferences', 'Inference / Support from Paragraph', 'CET / NMAT Logical Reasoning', 143, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-COA', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Course of Action', null, 'CET / NMAT Logical Reasoning', 144, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Course of Action"); pyq_question_bank'),
  ('L-CR-CEF', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Cause Effect', null, 'CET / NMAT Logical Reasoning', 145, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Cause Effect"); pyq_question_bank'),
  ('L-CR-CEF-001', 'core_type', 'L-CR-CEF', 'Logic', 'Critical Reasoning', 'Cause Effect', 'Paragraph Based', 'CET / NMAT Logical Reasoning', 146, 'proposed', true, 'Arena tests "Logic > Critical Reasoning > Cause Effect > Paragraph Based" (2 tests, 12 Qs); universe node f2bc3bef; test_topic_map 2 rows'),
  ('L-CR-CEF-002', 'core_type', 'L-CR-CEF', 'Logic', 'Critical Reasoning', 'Cause Effect', 'Statements Based', 'CET / NMAT Logical Reasoning', 147, 'proposed', true, 'Arena tests "Logic > Critical Reasoning > Cause Effect > Statements Based" (1 test, 10 Qs); universe node 01018ad6; test_topic_map 1 row'),
  ('L-CR-TCC', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Truth Claim Conclusions', null, 'CET / NMAT Logical Reasoning', 148, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-AB', 'subsection', 'L', 'Logic', 'Abstract Reasoning', null, null, 'CET Abstract Reasoning', 149, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-AB-ASP', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', null, 'CET Abstract Reasoning', 150, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-ASP-001', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', 'Odd / Wrong Figure in Series', 'CET Abstract Reasoning', 151, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-002', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', 'Matrix Series', 'CET Abstract Reasoning', 152, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-003', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', 'Rotation Series', 'CET Abstract Reasoning', 153, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-004', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', 'Movement / Position Series', 'CET Abstract Reasoning', 154, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-005', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', 'Count / Element Change Series', 'CET Abstract Reasoning', 155, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-006', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', 'Repeating Cycle Series', 'CET Abstract Reasoning', 156, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-MWI', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', null, 'CET Abstract Reasoning', 157, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-MWI-001', 'core_type', 'L-AB-MWI', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', 'Clock Mirror Time', 'CET Abstract Reasoning', 158, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-MWI-002', 'core_type', 'L-AB-MWI', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', 'Water Image', 'CET Abstract Reasoning', 159, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-MWI-003', 'core_type', 'L-AB-MWI', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', 'Mirror Image', 'CET Abstract Reasoning', 160, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-PFC', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Paper Folding & Cutting', null, 'CET Abstract Reasoning', 161, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-PFC-001', 'core_type', 'L-AB-PFC', 'Logic', 'Abstract Reasoning', 'Paper Folding & Cutting', 'Paper Folding / Transparent Sheet', 'CET Abstract Reasoning', 162, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FGC', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Counting', null, 'CET Abstract Reasoning', 163, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-FGC-001', 'core_type', 'L-AB-FGC', 'Logic', 'Abstract Reasoning', 'Figure Counting', 'Counting Triangles', 'CET Abstract Reasoning', 164, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FGC-002', 'core_type', 'L-AB-FGC', 'Logic', 'Abstract Reasoning', 'Figure Counting', 'Counting Squares & Rectangles', 'CET Abstract Reasoning', 165, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FGC-003', 'core_type', 'L-AB-FGC', 'Logic', 'Abstract Reasoning', 'Figure Counting', 'Lines, Circles & Sectors', 'CET Abstract Reasoning', 166, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-DOT', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Dot Concept', null, 'CET Abstract Reasoning', 167, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-DOT-001', 'core_type', 'L-AB-DOT', 'Logic', 'Abstract Reasoning', 'Dot Concept', 'Dot Placement', 'CET Abstract Reasoning', 168, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Completion', null, 'CET Abstract Reasoning', 169, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-FCM-001', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Form Figure from Pieces', 'CET Abstract Reasoning', 170, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM-002', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Figure Matrix Completion', 'CET Abstract Reasoning', 171, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM-003', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Missing Part / Quadrant', 'CET Abstract Reasoning', 172, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM-004', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Rule-based Completion', 'CET Abstract Reasoning', 173, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-CBD', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', null, 'CET Abstract Reasoning', 174, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-CBD-001', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Cube Placed', 'CET Abstract Reasoning', 175, 'proposed', true, 'Arena "Logic > Abstract Reasoning > Cubes > Cube Placed" (1 test, 7 Qs); universe node 2101b97e (section Abstract)'),
  ('L-AB-CBD-002', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Folding Cube', 'CET Abstract Reasoning', 176, 'proposed', true, 'Arena "… > Cubes > Folding Cube" (1 test, 6 Qs); universe node 9a94effb'),
  ('L-AB-CBD-003', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Half Painted Cubes', 'CET Abstract Reasoning', 177, 'proposed', true, 'Arena "… > Cubes > Half Painted Cubes" (1 test, 8 Qs); universe node 707c5763'),
  ('L-AB-CBD-004', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Painted Cubes', 'CET Abstract Reasoning', 178, 'proposed', true, 'Arena "… > Cubes > Painted Cubes" (2 tests, 14 Qs); universe node af384932'),
  ('L-AB-CBD-005', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Counting Cubes in a Stack', 'CET Abstract Reasoning', 179, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-CBD-006', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Dice / Cube Opposite Faces', 'CET Abstract Reasoning', 180, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCL', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Classification', null, 'CET Abstract Reasoning', 181, 'proposed', true, 'pyq_question_bank'),
  ('L-AB-FCL-001', 'core_type', 'L-AB-FCL', 'Logic', 'Abstract Reasoning', 'Figure Classification', 'Grouping into Classes', 'CET Abstract Reasoning', 182, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCL-002', 'core_type', 'L-AB-FCL', 'Logic', 'Abstract Reasoning', 'Figure Classification', 'Symmetry / Mirror / Rotation Odd One', 'CET Abstract Reasoning', 183, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCL-003', 'core_type', 'L-AB-FCL', 'Logic', 'Abstract Reasoning', 'Figure Classification', 'Odd Figure Out', 'CET Abstract Reasoning', 184, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FAN', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Analogy', null, 'CET Abstract Reasoning', 185, 'proposed', true, 'pyq_question_bank'),
  ('L-AB-FAN-001', 'core_type', 'L-AB-FAN', 'Logic', 'Abstract Reasoning', 'Figure Analogy', 'Rotation / Reflection Analogy', 'CET Abstract Reasoning', 186, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FAN-002', 'core_type', 'L-AB-FAN', 'Logic', 'Abstract Reasoning', 'Figure Analogy', 'Element Change Analogy', 'CET Abstract Reasoning', 187, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-EMB', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Embedded Figures', null, 'CET Abstract Reasoning', 188, 'proposed', true, 'pyq_question_bank'),
  ('L-AB-EMB-001', 'core_type', 'L-AB-EMB', 'Logic', 'Abstract Reasoning', 'Embedded Figures', 'Hidden / Embedded Shape', 'CET Abstract Reasoning', 189, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)')
on conflict (core_id) do nothing;

-- Chapter view with the CAT question counts (same idea as quant_master_taxonomy_chapters).
-- DILR rows in cat_import_questions have no ck_chapter yet, so the count comes from the chapter names in the
-- GitHub export (ck_chapter column) once that is written back; until then it counts by g_strategy_official.
create or replace view public.logic_master_taxonomy_chapters as
select t.core_id, t.subsection, t.chapter, t.exam_family, t.status, t.proposed,
       (select count(*) from public.cat_import_questions q
         where q.section = 'DILR' and q.is_actual_cat
           and (coalesce(q.ck_chapter, '') = t.chapter
                or (q.ck_chapter is null and (q.g_strategy_official = t.chapter
                    or (t.chapter = 'Venn' and q.g_strategy_official = 'Venn Diagram')
                    or (t.chapter = 'Tables & Fill in the blanks' and q.g_strategy_official = 'Fill in the blanks'))))) as cat_questions
from public.logic_master_taxonomy t
where t.level = 'chapter'
order by t.sort_order;

-- ---------------------------------------------------------------------------------------
-- Verify
-- ---------------------------------------------------------------------------------------
-- select level, count(*) from public.logic_master_taxonomy group by 1;            -- section 1 · subsection 9 · chapter 61 · core_type 118
-- select * from public.logic_master_taxonomy_chapters;                             -- 61 chapters, CAT counts on the 12 Bible ones
-- select core_id, chapter from public.logic_master_taxonomy where proposed and level='chapter' order by sort_order;  -- 49 proposed chapters

-- ---------------------------------------------------------------------------------------
-- Control Room registration (fill actor/session id when running)
-- ---------------------------------------------------------------------------------------
-- insert into control_room.sessions (actor, agent_type, purpose, status) values ('Claude (Rav present)', 'claude', 'Create public.logic_master_taxonomy from reference-bank/logic/master-taxonomy.csv', 'active') returning id;
-- insert into control_room.change_requests (session_id, title, rationale, affected_objects, proposed_action, status, risk_level)
--   values ('<session id>', 'logic_master_taxonomy table + chapters view', 'Logic master taxonomy (15 Oct 2026) — one taxonomy per section with an ID at every level',
--           '{"public.logic_master_taxonomy","public.logic_master_taxonomy_chapters"}', 'create table + insert 189 rows + create view; additive, no existing object touched', 'planned', 'low');
-- after running: update control_room.change_requests set status='done', verification_notes='189 rows; counts verified', completed_at=now() where id='<request id>';
--                update control_room.sessions set status='finished', finished_at=now(), notes='handover: table created, nothing else changed' where id='<session id>';
