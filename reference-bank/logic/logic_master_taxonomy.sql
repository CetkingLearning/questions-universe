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
  exam_family  text,
  grp          text,                                     -- Abstract group: Traditional Abstract · Modern Abstract
  shared_with  text,                                     -- CR rows: the Verbal V-CR id the question actually takes (Rav: CR shared with Verbal)                                     -- CAT DILR · CET / NMAT Logical Reasoning · CET Abstract Reasoning (kept separate, Rav 15 Oct 2026)
  sort_order   integer not null,
  status       text not null default 'from_bible_unfrozen'
               check (status in ('from_bible_unfrozen','proposed','accepted','shared_verbal','rejected','frozen')),
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
-- Rows (188): generated from reference-bank/logic/master-taxonomy.csv — rav_decision blank = not yet accepted
-- ---------------------------------------------------------------------------------------
insert into public.logic_master_taxonomy
  (core_id, level, parent_id, section, subsection, chapter, core_type, exam_family, grp, shared_with, sort_order, status, proposed, source)
values
  ('L', 'section', null, 'Logic', null, null, null, 'all', null, null, 1, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR', 'subsection', 'L', 'Logic', 'Arrangement', null, null, 'CAT DILR', null, null, 2, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-WDW', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Wide Wordy', null, 'CAT DILR', null, null, 3, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-WDN', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Wide Numbers', null, 'CAT DILR', null, null, 4, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-TNW', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Teeny Wordy', null, 'CAT DILR', null, null, 5, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-TNN', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Teeny Numbers', null, 'CAT DILR', null, null, 6, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-GNT', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Games & Tournaments', null, 'CAT DILR', null, null, 7, 'accepted', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-CS', 'subsection', 'L', 'Logic', 'Caselet', null, null, 'CAT DILR', null, null, 8, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-CS-CLS', 'chapter', 'L-CS', 'Logic', 'Caselet', 'Classification Caselets', null, 'CAT DILR', null, null, 9, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-CS-CAL', 'chapter', 'L-CS', 'Logic', 'Caselet', 'Calculation Caselets', null, 'CAT DILR', null, null, 10, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR', 'subsection', 'L', 'Logic', 'Graphs', null, null, 'CAT DILR', null, null, 11, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-TRD', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Traditional Graphs', null, 'CAT DILR', null, null, 12, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-TAB', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Tables & Fill in the blanks', null, 'CAT DILR', null, null, 13, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-ADV', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Advanced Graphs', null, 'CAT DILR', null, null, 14, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-VEN', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Venn', null, 'CAT DILR', null, null, 15, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR', 'subsection', 'L', 'Logic', 'Schedule & Routing', null, null, 'CAT DILR', null, null, 16, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR-RTM', 'chapter', 'L-SR', 'Logic', 'Schedule & Routing', 'Routes & Maps', null, 'CAT DILR', null, null, 17, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR-SCH', 'chapter', 'L-SR', 'Logic', 'Schedule & Routing', 'Scheduling', null, 'CAT DILR', null, null, 18, 'accepted', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-TL', 'subsection', 'L', 'Logic', 'Traditional Logic', null, null, 'CET Logical Reasoning', null, null, 19, 'accepted', true, 'Traditional Logic group ← lms_topics:38c7acac'),
  ('L-TL-DIR', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Direction Sense', null, 'CET Logical Reasoning', null, null, 20, 'accepted', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Direction Sense"); pyq_question_bank'),
  ('L-TL-DIR-001', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Rotated / Coded Directions', 'CET Logical Reasoning', null, null, 21, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-002', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Angle & Degree Turns', 'CET Logical Reasoning', null, null, 22, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-003', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Direction in Seating / Clock', 'CET Logical Reasoning', null, null, 23, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-004', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Shortest Distance & Displacement', 'CET Logical Reasoning', null, null, 24, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-005', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Relative Direction & Position', 'CET Logical Reasoning', null, null, 25, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-DIR-006', 'core_type', 'L-TL-DIR', 'Logic', 'Traditional Logic', 'Direction Sense', 'Final Direction after Turns', 'CET Logical Reasoning', null, null, 26, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Coding-Decoding', null, 'CET Logical Reasoning', null, null, 27, 'accepted', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Coding Decoding"); pyq_question_bank'),
  ('L-TL-COD-001', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Short Letters', 'CET Logical Reasoning', null, null, 28, 'proposed', true, 'Arena tests "Logic > Traditional Logic > Coding Decoding > Short Letters" (1 test, 6 Qs); universe node ea7edd3c'),
  ('L-TL-COD-002', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Symbol Coding', 'CET Logical Reasoning', null, null, 29, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-003', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Word / Sentence Coding', 'CET Logical Reasoning', null, null, 30, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-004', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Substitution Coding', 'CET Logical Reasoning', null, null, 31, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-005', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Letter ↔ Number Coding', 'CET Logical Reasoning', null, null, 32, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-COD-006', 'core_type', 'L-TL-COD', 'Logic', 'Traditional Logic', 'Coding-Decoding', 'Letter Shift Coding', 'CET Logical Reasoning', null, null, 33, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Blood Relations', null, 'CET Logical Reasoning', null, null, 34, 'accepted', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Blood Relation"); pyq_question_bank'),
  ('L-TL-BLR-001', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Coded Blood Relations', 'CET Logical Reasoning', null, null, 35, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR-002', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Pointing / Photograph Relations', 'CET Logical Reasoning', null, null, 36, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR-003', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Family Tree & Counting', 'CET Logical Reasoning', null, null, 37, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-BLR-004', 'core_type', 'L-TL-BLR', 'Logic', 'Traditional Logic', 'Blood Relations', 'Relation Chain', 'CET Logical Reasoning', null, null, 38, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Syllogism', null, 'CET Logical Reasoning', null, null, 39, 'accepted', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Syllogism I"); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Syllogism II"); pyq_question_bank'),
  ('L-TL-SYL-001', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Individual Membership', 'CET Logical Reasoning', null, null, 40, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-002', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Either-Or / Complementary Pair', 'CET Logical Reasoning', null, null, 41, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-003', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Possibility Conclusions', 'CET Logical Reasoning', null, null, 42, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-004', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Chain (3–4 statements)', 'CET Logical Reasoning', null, null, 43, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-SYL-005', 'core_type', 'L-TL-SYL', 'Logic', 'Traditional Logic', 'Syllogism', 'Two-Statement Syllogism', 'CET Logical Reasoning', null, null, 44, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Alphanumeric Series', null, 'CET Logical Reasoning', null, null, 45, 'accepted', true, 'question_taxonomy CET Pattern (Traditional Logic); pyq_question_bank'),
  ('L-TL-ANS-001', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Position-based Questions', 'CET Logical Reasoning', null, null, 46, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-002', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Condition Counting', 'CET Logical Reasoning', null, null, 47, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-003', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Alphanumeric Term Series', 'CET Logical Reasoning', null, null, 48, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-004', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Letter Matrix & Counting', 'CET Logical Reasoning', null, null, 49, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-005', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Alphabet Position & Rearrangement', 'CET Logical Reasoning', null, null, 50, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-ANS-006', 'core_type', 'L-TL-ANS', 'Logic', 'Traditional Logic', 'Alphanumeric Series', 'Letter Series', 'CET Logical Reasoning', null, null, 51, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR', 'chapter', 'L-TL', 'Logic', 'Traditional Logic', 'Number Series', null, 'CET Logical Reasoning', null, null, 52, 'accepted', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Number Series"); pyq_question_bank'),
  ('L-TL-NSR-001', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Wrong Term', 'CET Logical Reasoning', null, null, 53, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-002', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Missing Number in Figure / Grid', 'CET Logical Reasoning', null, null, 54, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-003', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Digit-based Series', 'CET Logical Reasoning', null, null, 55, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-004', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Repeating / Cyclic Series', 'CET Logical Reasoning', null, null, 56, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-005', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Alternating / Interleaved Series', 'CET Logical Reasoning', null, null, 57, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-006', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Powers & Special Numbers', 'CET Logical Reasoning', null, null, 58, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-007', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Difference Series', 'CET Logical Reasoning', null, null, 59, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-TL-NSR-008', 'core_type', 'L-TL-NSR', 'Logic', 'Traditional Logic', 'Number Series', 'Multiply / Operation Series', 'CET Logical Reasoning', null, null, 60, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-WRD', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Word Formation', null, 'CET Logical Reasoning', null, null, 61, 'accepted', true, 'pyq_question_bank'),
  ('L-ML-WRD-001', 'core_type', 'L-ML-WRD', 'Logic', 'Modern Logic', 'Word Formation', 'Anagram & Word Count', 'CET Logical Reasoning', null, null, 62, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-WRD-002', 'core_type', 'L-ML-WRD', 'Logic', 'Modern Logic', 'Word Formation', 'Word from Given Letters / Positions', 'CET Logical Reasoning', null, null, 63, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML', 'subsection', 'L', 'Logic', 'Modern Logic', null, null, 'CET Logical Reasoning', null, null, 64, 'accepted', true, 'Modern Logic group ← taxonomy_universe_nodes:a5da5846, lms_topics:3a1c1eff, questions_path:Logic > Modern Logic'),
  ('L-ML-SYM', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Symbol-Based Maths', null, 'CET Logical Reasoning', null, null, 65, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); pyq_question_bank'),
  ('L-ML-SYM-001', 'core_type', 'L-ML-SYM', 'Logic', 'Modern Logic', 'Symbol-Based Maths', 'Sign / Number Interchange', 'CET Logical Reasoning', null, null, 66, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-SYM-002', 'core_type', 'L-ML-SYM', 'Logic', 'Modern Logic', 'Symbol-Based Maths', 'Symbol / Operator Substitution (BODMAS)', 'CET Logical Reasoning', null, null, 67, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-VND', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', null, 'CET Logical Reasoning', null, null, 68, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Venn Diagram"); pyq_question_bank'),
  ('L-ML-VND-001', 'core_type', 'L-ML-VND', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', 'Classes to Diagram', 'CET Logical Reasoning', null, null, 69, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-VND-002', 'core_type', 'L-ML-VND', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', 'Region Reading', 'CET Logical Reasoning', null, null, 70, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-VND-003', 'core_type', 'L-ML-VND', 'Logic', 'Modern Logic', 'Venn Diagram (single-question)', 'Venn Counting', 'CET Logical Reasoning', null, null, 71, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-SEQ', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Sequencing & Ordering', null, 'CET Logical Reasoning', null, null, 72, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Sequence of words"); pyq_question_bank'),
  ('L-ML-SEQ-001', 'core_type', 'L-ML-SEQ', 'Logic', 'Modern Logic', 'Sequencing & Ordering', 'Dictionary Order', 'CET Logical Reasoning', null, null, 73, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-SEQ-002', 'core_type', 'L-ML-SEQ', 'Logic', 'Modern Logic', 'Sequencing & Ordering', 'Logical Word Sequence', 'CET Logical Reasoning', null, null, 74, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ODD', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Odd Man Out', null, 'CET Logical Reasoning', null, null, 75, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Classification"); pyq_question_bank'),
  ('L-ML-ODD-001', 'core_type', 'L-ML-ODD', 'Logic', 'Modern Logic', 'Odd Man Out', 'Letter Odd One', 'CET Logical Reasoning', null, null, 76, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ODD-002', 'core_type', 'L-ML-ODD', 'Logic', 'Modern Logic', 'Odd Man Out', 'Number Odd One', 'CET Logical Reasoning', null, null, 77, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ODD-003', 'core_type', 'L-ML-ODD', 'Logic', 'Modern Logic', 'Odd Man Out', 'Word / Meaning Odd One', 'CET Logical Reasoning', null, null, 78, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ANL', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Analogies', null, 'CET Logical Reasoning', null, null, 79, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Analogy"); pyq_question_bank'),
  ('L-ML-ANL-001', 'core_type', 'L-ML-ANL', 'Logic', 'Modern Logic', 'Analogies', 'Letter Analogy', 'CET Logical Reasoning', null, null, 80, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ANL-002', 'core_type', 'L-ML-ANL', 'Logic', 'Modern Logic', 'Analogies', 'Number Analogy', 'CET Logical Reasoning', null, null, 81, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ANL-003', 'core_type', 'L-ML-ANL', 'Logic', 'Modern Logic', 'Analogies', 'Word Analogy', 'CET Logical Reasoning', null, null, 82, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DCM', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Decision Making', null, 'CET Logical Reasoning', null, null, 83, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Decision Making"); pyq_question_bank'),
  ('L-ML-DCM-001', 'core_type', 'L-ML-DCM', 'Logic', 'Modern Logic', 'Decision Making', 'Eligibility / Selection Criteria', 'CET Logical Reasoning', null, null, 84, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ORK', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Order & Ranking', null, 'CET Logical Reasoning', null, null, 85, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); pyq_question_bank'),
  ('L-ML-ORK-001', 'core_type', 'L-ML-ORK', 'Logic', 'Modern Logic', 'Order & Ranking', 'Comparison Chain', 'CET Logical Reasoning', null, null, 86, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ORK-002', 'core_type', 'L-ML-ORK', 'Logic', 'Modern Logic', 'Order & Ranking', 'Position & Rank in a Row', 'CET Logical Reasoning', null, null, 87, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-INO', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Input Output', null, 'CET Logical Reasoning', null, null, 88, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Input Output"); pyq_question_bank'),
  ('L-ML-INO-001', 'core_type', 'L-ML-INO', 'Logic', 'Modern Logic', 'Input Output', 'Password Rearrangement', 'CET Logical Reasoning', null, null, 89, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-INO-002', 'core_type', 'L-ML-INO', 'Logic', 'Modern Logic', 'Input Output', 'Digit Sorting Machine', 'CET Logical Reasoning', null, null, 90, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-INO-003', 'core_type', 'L-ML-INO', 'Logic', 'Modern Logic', 'Input Output', 'Word–Number Arrangement Steps', 'CET Logical Reasoning', null, null, 91, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-ALT', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Alphabet Tests', null, 'CET Logical Reasoning', null, null, 92, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Alphabet Test")'),
  ('L-ML-CLC', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Clocks & Calendars', null, 'CET Logical Reasoning', null, null, 93, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Clocks"); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Calendars"); pyq_question_bank'),
  ('L-ML-CLC-001', 'core_type', 'L-ML-CLC', 'Logic', 'Modern Logic', 'Clocks & Calendars', 'Clock Hands & Angles', 'CET Logical Reasoning', null, null, 94, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CLC-002', 'core_type', 'L-ML-CLC', 'Logic', 'Modern Logic', 'Clocks & Calendars', 'Time Calculation', 'CET Logical Reasoning', null, null, 95, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CLC-003', 'core_type', 'L-ML-CLC', 'Logic', 'Modern Logic', 'Clocks & Calendars', 'Calendar & Odd Days', 'CET Logical Reasoning', null, null, 96, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CIQ', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Coded Inequalities', null, 'CET Logical Reasoning', null, null, 97, 'accepted', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Coded Inequalities"); pyq_question_bank'),
  ('L-ML-CIQ-001', 'core_type', 'L-ML-CIQ', 'Logic', 'Modern Logic', 'Coded Inequalities', 'Coded / Symbol Inequality', 'CET Logical Reasoning', null, null, 98, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-CIQ-002', 'core_type', 'L-ML-CIQ', 'Logic', 'Modern Logic', 'Coded Inequalities', 'Direct Inequality Chain', 'CET Logical Reasoning', null, null, 99, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF', 'chapter', 'L-ML', 'Logic', 'Modern Logic', 'Data Sufficiency', null, 'CET Logical Reasoning', null, null, 100, 'accepted', true, 'pyq_question_bank'),
  ('L-ML-DSF-001', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Arrangement & Ranking DS', 'CET Logical Reasoning', null, null, 101, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-002', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Age DS', 'CET Logical Reasoning', null, null, 102, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-003', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Direction / Coding DS', 'CET Logical Reasoning', null, null, 103, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-004', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Quant-style DS', 'CET Logical Reasoning', null, null, 104, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-ML-DSF-005', 'core_type', 'L-ML-DSF', 'Logic', 'Modern Logic', 'Data Sufficiency', 'Statement Combination DS', 'CET Logical Reasoning', null, null, 105, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ', 'subsection', 'L', 'Logic', 'Puzzles', null, null, 'CET Logical Reasoning', null, null, 106, 'accepted', true, 'Puzzles group ← question_taxonomy:270c1e7e, taxonomy_universe_nodes:3977ff7e, lms_topics:ac835839, ck_topic_hierarchy:c6d02871'),
  ('L-PZ-MTX', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Matrix Arrangement', null, 'CET Logical Reasoning', null, null, 107, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-MTX-001', 'core_type', 'L-PZ-MTX', 'Logic', 'Puzzles', 'Matrix Arrangement', 'Single Matrix Puzzles', 'CET Logical Reasoning', null, null, 108, 'proposed', true, 'Arena tests "Logic > Arrangements > Matrix based Puzzles > Single Matrix Puzzles" (3 tests, 14 Qs); universe node de678490'),
  ('L-PZ-MTX-002', 'core_type', 'L-PZ-MTX', 'Logic', 'Puzzles', 'Matrix Arrangement', 'Multi-attribute Matching', 'CET Logical Reasoning', null, null, 109, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-CDS', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'CAT DILR Set', null, 'CET Logical Reasoning', null, null, 110, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-PZ-FBS', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Floor Box Schedule', null, 'CET Logical Reasoning', null, null, 111, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-FBS-001', 'core_type', 'L-PZ-FBS', 'Logic', 'Puzzles', 'Floor Box Schedule', 'Box / Stack Puzzles', 'CET Logical Reasoning', null, null, 112, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-SCB', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Scheduling Based', null, 'CET Logical Reasoning', null, null, 113, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-SCB-001', 'core_type', 'L-PZ-SCB', 'Logic', 'Puzzles', 'Scheduling Based', 'Day / Slot Scheduling', 'CET Logical Reasoning', null, null, 114, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-CIR', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Circular Arrangement', null, 'CET Logical Reasoning', null, null, 115, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-CIR-001', 'core_type', 'L-PZ-CIR', 'Logic', 'Puzzles', 'Circular Arrangement', 'Polygon / Compass Seating', 'CET Logical Reasoning', null, null, 116, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-CIR-002', 'core_type', 'L-PZ-CIR', 'Logic', 'Puzzles', 'Circular Arrangement', 'Circular Seating Facing Centre', 'CET Logical Reasoning', null, null, 117, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-LIN', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Linear Arrangement', null, 'CET Logical Reasoning', null, null, 118, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-LIN-001', 'core_type', 'L-PZ-LIN', 'Logic', 'Puzzles', 'Linear Arrangement', 'Queue & Position Counting', 'CET Logical Reasoning', null, null, 119, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-LIN-002', 'core_type', 'L-PZ-LIN', 'Logic', 'Puzzles', 'Linear Arrangement', 'Order of Arrival / Stops', 'CET Logical Reasoning', null, null, 120, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-LIN-003', 'core_type', 'L-PZ-LIN', 'Logic', 'Puzzles', 'Linear Arrangement', 'Single Row Seating', 'CET Logical Reasoning', null, null, 121, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-PAR', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Parallel Arrangement', null, 'CET Logical Reasoning', null, null, 122, 'accepted', true, 'question_taxonomy CET Pattern (Puzzles); pyq_question_bank'),
  ('L-PZ-PAR-001', 'core_type', 'L-PZ-PAR', 'Logic', 'Puzzles', 'Parallel Arrangement', 'Two Rows Facing', 'CET Logical Reasoning', null, null, 123, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-NPZ', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Number Puzzles', null, 'CET Logical Reasoning', null, null, 124, 'accepted', true, 'question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Number Puzzles"); pyq_question_bank'),
  ('L-PZ-NPZ-001', 'core_type', 'L-PZ-NPZ', 'Logic', 'Puzzles', 'Number Puzzles', 'Scores & Tournaments', 'CET Logical Reasoning', null, null, 125, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-NPZ-002', 'core_type', 'L-PZ-NPZ', 'Logic', 'Puzzles', 'Number Puzzles', 'Counting / Pigeonhole', 'CET Logical Reasoning', null, null, 126, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-NPZ-003', 'core_type', 'L-PZ-NPZ', 'Logic', 'Puzzles', 'Number Puzzles', 'Digit & Number Arrangement', 'CET Logical Reasoning', null, null, 127, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-TNL', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Truth & Lies', null, 'CET Logical Reasoning', null, null, 128, 'accepted', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-PZ-SEL', 'chapter', 'L-PZ', 'Logic', 'Puzzles', 'Selection & Grouping', null, 'CET Logical Reasoning', null, null, 129, 'accepted', true, 'pyq_question_bank'),
  ('L-PZ-SEL-001', 'core_type', 'L-PZ-SEL', 'Logic', 'Puzzles', 'Selection & Grouping', 'Combination Counting', 'CET Logical Reasoning', null, null, 130, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-PZ-SEL-002', 'core_type', 'L-PZ-SEL', 'Logic', 'Puzzles', 'Selection & Grouping', 'Team / Item Selection with Conditions', 'CET Logical Reasoning', null, null, 131, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR', 'subsection', 'L', 'Logic', 'Critical Reasoning', null, null, 'CET Logical Reasoning', null, 'V-CR', 132, 'shared_verbal', true, 'Critical Reasoning group ← taxonomy_universe_nodes:0b152648, questions_path:Logic > Critical Reasoning'),
  ('L-CR-SAS', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement Assumptions', null, 'CET Logical Reasoning', null, 'V-CR-ASM', 133, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Assumptions"); pyq_question_bank'),
  ('L-CR-SAS-001', 'core_type', 'L-CR-SAS', 'Logic', 'Critical Reasoning', 'Statement Assumptions', 'Implicit Assumptions', 'CET Logical Reasoning', null, 'V-CR-ASM-001', 134, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SCN', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement Conclusions', null, 'CET Logical Reasoning', null, 'V-CR-TRC', 135, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Conclusions"); pyq_question_bank'),
  ('L-CR-SCN-001', 'core_type', 'L-CR-SCN', 'Logic', 'Critical Reasoning', 'Statement Conclusions', 'Fact Check / Must Be True', 'CET Logical Reasoning', null, 'V-CR-INF-001', 136, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SCN-002', 'core_type', 'L-CR-SCN', 'Logic', 'Critical Reasoning', 'Statement Conclusions', 'Conclusion from Statements', 'CET Logical Reasoning', null, 'V-CR-TRC-001', 137, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-ASR', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Assertion Reasoning', null, 'CET Logical Reasoning', null, 'V-CR-ASR', 138, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); pyq_question_bank'),
  ('L-CR-ASR-001', 'core_type', 'L-CR-ASR', 'Logic', 'Critical Reasoning', 'Assertion Reasoning', 'Assertion–Reason (fact based)', 'CET Logical Reasoning', null, 'V-CR-ASR-001', 139, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SAR', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement Arguments', null, 'CET Logical Reasoning', null, 'V-CR-ARG', 140, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Arguments"); pyq_question_bank'),
  ('L-CR-SAR-001', 'core_type', 'L-CR-SAR', 'Logic', 'Critical Reasoning', 'Statement Arguments', 'Strong / Weak Arguments', 'CET Logical Reasoning', null, 'V-CR-ARG-001', 141, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-SIN', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Statement & Inferences', null, 'CET Logical Reasoning', null, 'V-CR-INF', 142, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); pyq_question_bank'),
  ('L-CR-SIN-001', 'core_type', 'L-CR-SIN', 'Logic', 'Critical Reasoning', 'Statement & Inferences', 'Inference / Support from Paragraph', 'CET Logical Reasoning', null, 'V-CR-INF-002', 143, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-CR-COA', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Course of Action', null, 'CET Logical Reasoning', null, 'V-CR-COA', 144, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Course of Action"); pyq_question_bank'),
  ('L-CR-CEF', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Cause Effect', null, 'CET Logical Reasoning', null, 'V-CR-CEF', 145, 'shared_verbal', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Cause Effect"); pyq_question_bank'),
  ('L-CR-CEF-001', 'core_type', 'L-CR-CEF', 'Logic', 'Critical Reasoning', 'Cause Effect', 'Paragraph Based', 'CET Logical Reasoning', null, 'V-CR-CEF-002', 146, 'proposed', true, 'Arena tests "Logic > Critical Reasoning > Cause Effect > Paragraph Based" (2 tests, 12 Qs); universe node f2bc3bef; test_topic_map 2 rows'),
  ('L-CR-CEF-002', 'core_type', 'L-CR-CEF', 'Logic', 'Critical Reasoning', 'Cause Effect', 'Statements Based', 'CET Logical Reasoning', null, 'V-CR-CEF-001', 147, 'proposed', true, 'Arena tests "Logic > Critical Reasoning > Cause Effect > Statements Based" (1 test, 10 Qs); universe node 01018ad6; test_topic_map 1 row'),
  ('L-CR-TCC', 'chapter', 'L-CR', 'Logic', 'Critical Reasoning', 'Truth Claim Conclusions', null, 'CET Logical Reasoning', null, 'V-CR-TRC', 148, 'shared_verbal', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-AB', 'subsection', 'L', 'Logic', 'Abstract Reasoning', null, null, 'CET Abstract Reasoning', null, null, 149, 'accepted', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-AB-ASP', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Series & Patterns', null, 'CET Abstract Reasoning', 'Traditional Abstract', null, 150, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-ASP-001', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Series & Patterns', 'Odd / Wrong Figure in Series', 'CET Abstract Reasoning', 'Traditional Abstract', null, 151, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-002', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Series & Patterns', 'Matrix Series', 'CET Abstract Reasoning', 'Traditional Abstract', null, 152, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-003', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Series & Patterns', 'Rotation Series', 'CET Abstract Reasoning', 'Traditional Abstract', null, 153, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-004', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Series & Patterns', 'Movement / Position Series', 'CET Abstract Reasoning', 'Traditional Abstract', null, 154, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-005', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Series & Patterns', 'Count / Element Change Series', 'CET Abstract Reasoning', 'Traditional Abstract', null, 155, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-ASP-006', 'core_type', 'L-AB-ASP', 'Logic', 'Abstract Reasoning', 'Series & Patterns', 'Repeating Cycle Series', 'CET Abstract Reasoning', 'Traditional Abstract', null, 156, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCL', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Abstract Odd Man Out', null, 'CET Abstract Reasoning', 'Traditional Abstract', null, 157, 'accepted', true, 'pyq_question_bank'),
  ('L-AB-FCL-001', 'core_type', 'L-AB-FCL', 'Logic', 'Abstract Reasoning', 'Abstract Odd Man Out', 'Grouping into Classes', 'CET Abstract Reasoning', 'Traditional Abstract', null, 158, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCL-002', 'core_type', 'L-AB-FCL', 'Logic', 'Abstract Reasoning', 'Abstract Odd Man Out', 'Symmetry / Mirror / Rotation Odd One', 'CET Abstract Reasoning', 'Traditional Abstract', null, 159, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCL-003', 'core_type', 'L-AB-FCL', 'Logic', 'Abstract Reasoning', 'Abstract Odd Man Out', 'Odd Figure Out', 'CET Abstract Reasoning', 'Traditional Abstract', null, 160, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FAN', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Abstract Analogies', null, 'CET Abstract Reasoning', 'Traditional Abstract', null, 161, 'accepted', true, 'pyq_question_bank'),
  ('L-AB-FAN-001', 'core_type', 'L-AB-FAN', 'Logic', 'Abstract Reasoning', 'Abstract Analogies', 'Rotation / Reflection Analogy', 'CET Abstract Reasoning', 'Traditional Abstract', null, 162, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FAN-002', 'core_type', 'L-AB-FAN', 'Logic', 'Abstract Reasoning', 'Abstract Analogies', 'Element Change Analogy', 'CET Abstract Reasoning', 'Traditional Abstract', null, 163, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-MWI', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 164, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-MWI-001', 'core_type', 'L-AB-MWI', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', 'Clock Mirror Time', 'CET Abstract Reasoning', 'Modern Abstract', null, 165, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-MWI-002', 'core_type', 'L-AB-MWI', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', 'Water Image', 'CET Abstract Reasoning', 'Modern Abstract', null, 166, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-MWI-003', 'core_type', 'L-AB-MWI', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', 'Mirror Image', 'CET Abstract Reasoning', 'Modern Abstract', null, 167, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-PFC', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Paper Folding & Cutting', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 168, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-PFC-001', 'core_type', 'L-AB-PFC', 'Logic', 'Abstract Reasoning', 'Paper Folding & Cutting', 'Paper Folding / Transparent Sheet', 'CET Abstract Reasoning', 'Modern Abstract', null, 169, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FGC', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Counting', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 170, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-FGC-001', 'core_type', 'L-AB-FGC', 'Logic', 'Abstract Reasoning', 'Figure Counting', 'Counting Triangles', 'CET Abstract Reasoning', 'Modern Abstract', null, 171, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FGC-002', 'core_type', 'L-AB-FGC', 'Logic', 'Abstract Reasoning', 'Figure Counting', 'Counting Squares & Rectangles', 'CET Abstract Reasoning', 'Modern Abstract', null, 172, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FGC-003', 'core_type', 'L-AB-FGC', 'Logic', 'Abstract Reasoning', 'Figure Counting', 'Lines, Circles & Sectors', 'CET Abstract Reasoning', 'Modern Abstract', null, 173, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-DOT', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Dot Concept', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 174, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-DOT-001', 'core_type', 'L-AB-DOT', 'Logic', 'Abstract Reasoning', 'Dot Concept', 'Dot Placement', 'CET Abstract Reasoning', 'Modern Abstract', null, 175, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Completion', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 176, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-FCM-001', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Form Figure from Pieces', 'CET Abstract Reasoning', 'Modern Abstract', null, 177, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM-002', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Figure Matrix Completion', 'CET Abstract Reasoning', 'Modern Abstract', null, 178, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM-003', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Missing Part / Quadrant', 'CET Abstract Reasoning', 'Modern Abstract', null, 179, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-FCM-004', 'core_type', 'L-AB-FCM', 'Logic', 'Abstract Reasoning', 'Figure Completion', 'Rule-based Completion', 'CET Abstract Reasoning', 'Modern Abstract', null, 180, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-CBD', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 181, 'accepted', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed); pyq_question_bank'),
  ('L-AB-CBD-001', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Cube Placed', 'CET Abstract Reasoning', 'Modern Abstract', null, 182, 'proposed', true, 'Arena "Logic > Abstract Reasoning > Cubes > Cube Placed" (1 test, 7 Qs); universe node 2101b97e (section Abstract)'),
  ('L-AB-CBD-002', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Folding Cube', 'CET Abstract Reasoning', 'Modern Abstract', null, 183, 'proposed', true, 'Arena "… > Cubes > Folding Cube" (1 test, 6 Qs); universe node 9a94effb'),
  ('L-AB-CBD-003', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Half Painted Cubes', 'CET Abstract Reasoning', 'Modern Abstract', null, 184, 'proposed', true, 'Arena "… > Cubes > Half Painted Cubes" (1 test, 8 Qs); universe node 707c5763'),
  ('L-AB-CBD-004', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Painted Cubes', 'CET Abstract Reasoning', 'Modern Abstract', null, 185, 'proposed', true, 'Arena "… > Cubes > Painted Cubes" (2 tests, 14 Qs); universe node af384932'),
  ('L-AB-CBD-005', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Counting Cubes in a Stack', 'CET Abstract Reasoning', 'Modern Abstract', null, 186, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-CBD-006', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Dice / Cube Opposite Faces', 'CET Abstract Reasoning', 'Modern Abstract', null, 187, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)'),
  ('L-AB-EMB', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Embedded Figures', null, 'CET Abstract Reasoning', 'Modern Abstract', null, 188, 'accepted', true, 'pyq_question_bank'),
  ('L-AB-EMB-001', 'core_type', 'L-AB-EMB', 'Logic', 'Abstract Reasoning', 'Embedded Figures', 'Hidden / Embedded Shape', 'CET Abstract Reasoning', 'Modern Abstract', null, 189, 'proposed', true, 'pyq_question_bank sub-topics (grouped by Claude, 15 Oct 2026)')
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
-- select level, count(*) from public.logic_master_taxonomy group by 1;            -- section 1 · subsection 9 · chapter 60 · core_type 118
-- select * from public.logic_master_taxonomy_chapters;                             -- 60 chapters, CAT counts on the 12 Bible ones
-- select core_id, chapter from public.logic_master_taxonomy where status='proposed' and level='chapter' order by sort_order;  -- 0 proposed chapters (all 60 decided by Rav 15 Oct 2026; 118 core types still proposed)

-- ---------------------------------------------------------------------------------------
-- Control Room registration (fill actor/session id when running)
-- ---------------------------------------------------------------------------------------
-- insert into control_room.sessions (actor, agent_type, purpose, status) values ('Claude (Rav present)', 'claude', 'Create public.logic_master_taxonomy from reference-bank/logic/master-taxonomy.csv', 'active') returning id;
-- insert into control_room.change_requests (session_id, title, rationale, affected_objects, proposed_action, status, risk_level)
--   values ('<session id>', 'logic_master_taxonomy table + chapters view', 'Logic master taxonomy (15 Oct 2026) — one taxonomy per section with an ID at every level',
--           '{"public.logic_master_taxonomy","public.logic_master_taxonomy_chapters"}', 'create table + insert 188 rows + create view; additive, no existing object touched', 'planned', 'low');
-- after running: update control_room.change_requests set status='done', verification_notes='188 rows; counts verified', completed_at=now() where id='<request id>';
--                update control_room.sessions set status='finished', finished_at=now(), notes='handover: table created, nothing else changed' where id='<session id>';
