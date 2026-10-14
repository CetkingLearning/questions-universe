-- =====================================================================================
-- public.logic_master_taxonomy  —  Cetking Master Taxonomy, section LOGIC (DILR + CET/NMAT LR + Abstract)
-- Prepared 15 Oct 2026 by Claude. NOT APPLIED. Same columns as the planned quant_master_taxonomy
-- (core_id, section, subsection, chapter, core_type, sort_order, status, frozen_at, frozen_by, source)
-- + level / parent_id / lr_group / proposed because the Logic master has rows at every level
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
  subsection   text,                                     -- Arrangement · Caselet · Graphs · Schedule & Routing · Logical Reasoning (CET / NMAT style) · Abstract Reasoning
  chapter      text,                                     -- Wide Wordy, Venn, Syllogism …
  core_type    text,                                     -- only the 8 proposed Arena sub-topics for now
  lr_group     text,                                     -- CET group for L-LR rows: Traditional Logic · Modern Logic · Puzzles · Critical Reasoning
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
-- Rows (69): generated from reference-bank/logic/master-taxonomy.csv — rav_decision blank = not yet accepted
-- ---------------------------------------------------------------------------------------
insert into public.logic_master_taxonomy
  (core_id, level, parent_id, section, subsection, chapter, core_type, lr_group, sort_order, status, proposed, source)
values
  ('L', 'section', null, 'Logic', null, null, null, null, 1, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR', 'subsection', 'L', 'Logic', 'Arrangement', null, null, null, 2, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-WDW', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Wide Wordy', null, null, 3, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-WDN', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Wide Numbers', null, null, 4, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-TNW', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Teeny Wordy', null, null, 5, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-TNN', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Teeny Numbers', null, null, 6, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-AR-GNT', 'chapter', 'L-AR', 'Logic', 'Arrangement', 'Games & Tournaments', null, null, 7, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-CS', 'subsection', 'L', 'Logic', 'Caselet', null, null, null, 8, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-CS-CLS', 'chapter', 'L-CS', 'Logic', 'Caselet', 'Classification Caselets', null, null, 9, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-CS-CAL', 'chapter', 'L-CS', 'Logic', 'Caselet', 'Calculation Caselets', null, null, 10, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR', 'subsection', 'L', 'Logic', 'Graphs', null, null, null, 11, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-TRD', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Traditional Graphs', null, null, 12, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-TAB', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Tables & Fill in the blanks', null, null, 13, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-ADV', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Advanced Graphs', null, null, 14, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-GR-VEN', 'chapter', 'L-GR', 'Logic', 'Graphs', 'Venn', null, null, 15, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR', 'subsection', 'L', 'Logic', 'Schedule & Routing', null, null, null, 16, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR-RTM', 'chapter', 'L-SR', 'Logic', 'Schedule & Routing', 'Routes & Maps', null, null, 17, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-SR-SCH', 'chapter', 'L-SR', 'Logic', 'Schedule & Routing', 'Scheduling', null, null, 18, 'from_bible_unfrozen', false, 'Bible (dilr-world + CONTENT-UNIVERSES §12)'),
  ('L-LR', 'subsection', 'L', 'Logic', 'Logical Reasoning (CET / NMAT style)', null, null, null, 19, 'proposed', true, 'Puzzles group ← question_taxonomy:270c1e7e, taxonomy_universe_nodes:3977ff7e, lms_topics:ac835839, ck_topic_hierarchy:c6d02871; Modern Logic group ← taxonomy_universe_nodes:a5da5846, lms_topics:3a1c1eff, questions_path:Logic > Modern Logic; Critical Reasoning group ← taxonomy_universe_nodes:0b152648'),
  ('L-LR-DIR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Direction Sense', null, 'Traditional Logic', 20, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Direction Sense")'),
  ('L-LR-COD', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Coding-Decoding', null, 'Traditional Logic', 21, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Coding Decoding")'),
  ('L-LR-COD-001', 'core_type', 'L-LR-COD', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Coding-Decoding', 'Short Letters', 'Traditional Logic', 22, 'proposed', true, 'Arena tests "Logic > Traditional Logic > Coding Decoding > Short Letters" (1 test, 6 Qs); universe node ea7edd3c'),
  ('L-LR-BLR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Blood Relations', null, 'Traditional Logic', 23, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Blood Relation")'),
  ('L-LR-SYL', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Syllogism', null, 'Traditional Logic', 24, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Syllogism I"); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Syllogism II")'),
  ('L-LR-ANS', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Alphanumeric Series', null, 'Traditional Logic', 25, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic)'),
  ('L-LR-NSR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Number Series', null, 'Traditional Logic', 26, 'proposed', true, 'question_taxonomy CET Pattern (Traditional Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Number Series")'),
  ('L-LR-SYM', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Symbol-Based Maths', null, 'Modern Logic', 27, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic)'),
  ('L-LR-VND', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Venn Diagram (single-question)', null, 'Modern Logic', 28, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Venn Diagram")'),
  ('L-LR-SEQ', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Sequencing & Ordering', null, 'Modern Logic', 29, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Sequence of words")'),
  ('L-LR-ODD', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Odd Man Out', null, 'Modern Logic', 30, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Classification")'),
  ('L-LR-ANL', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Analogies', null, 'Modern Logic', 31, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Analogy")'),
  ('L-LR-DCM', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Decision Making', null, 'Modern Logic', 32, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Decision Making")'),
  ('L-LR-ORK', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Order & Ranking', null, 'Modern Logic', 33, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic)'),
  ('L-LR-INO', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Input Output', null, 'Modern Logic', 34, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Input Output")'),
  ('L-LR-ALT', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Alphabet Tests', null, 'Modern Logic', 35, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Alphabet Test")'),
  ('L-LR-CLC', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Clocks & Calendars', null, 'Modern Logic', 36, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Clocks"); question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Calendars")'),
  ('L-LR-CIQ', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Coded Inequalities', null, 'Modern Logic', 37, 'proposed', true, 'question_taxonomy CET Pattern (Modern Logic); question_taxonomy NMAT Brown Book 2026 (Reasoning II: "Coded Inequalities")'),
  ('L-LR-MTX', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Matrix Arrangement', null, 'Puzzles', 38, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-MTX-001', 'core_type', 'L-LR-MTX', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Matrix Arrangement', 'Single Matrix Puzzles', 'Puzzles', 39, 'proposed', true, 'Arena tests "Logic > Arrangements > Matrix based Puzzles > Single Matrix Puzzles" (3 tests, 14 Qs); universe node de678490'),
  ('L-LR-CDS', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'CAT DILR Set', null, 'Puzzles', 40, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-FBS', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Floor Box Schedule', null, 'Puzzles', 41, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-SCB', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Scheduling Based', null, 'Puzzles', 42, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-CIR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Circular Arrangement', null, 'Puzzles', 43, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-LIN', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Linear Arrangement', null, 'Puzzles', 44, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-PAR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Parallel Arrangement', null, 'Puzzles', 45, 'proposed', true, 'question_taxonomy CET Pattern (Puzzles)'),
  ('L-LR-SAS', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Statement Assumptions', null, 'Critical Reasoning', 46, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Assumptions")'),
  ('L-LR-SCN', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Statement Conclusions', null, 'Critical Reasoning', 47, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Conclusions")'),
  ('L-LR-ASR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Assertion Reasoning', null, 'Critical Reasoning', 48, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning)'),
  ('L-LR-SAR', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Statement Arguments', null, 'Critical Reasoning', 49, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Statement Arguments")'),
  ('L-LR-SIN', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Statement & Inferences', null, 'Critical Reasoning', 50, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning)'),
  ('L-LR-COA', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Course of Action', null, 'Critical Reasoning', 51, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Course of Action")'),
  ('L-LR-CEF', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Cause Effect', null, 'Critical Reasoning', 52, 'proposed', true, 'question_taxonomy CET Pattern (Critical Reasoning); question_taxonomy NMAT Brown Book 2026 (Critical Reasoning: "Cause Effect")'),
  ('L-LR-CEF-001', 'core_type', 'L-LR-CEF', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Cause Effect', 'Paragraph Based', 'Critical Reasoning', 53, 'proposed', true, 'Arena tests "Logic > Critical Reasoning > Cause Effect > Paragraph Based" (2 tests, 12 Qs); universe node f2bc3bef; test_topic_map 2 rows'),
  ('L-LR-CEF-002', 'core_type', 'L-LR-CEF', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Cause Effect', 'Statements Based', 'Critical Reasoning', 54, 'proposed', true, 'Arena tests "Logic > Critical Reasoning > Cause Effect > Statements Based" (1 test, 10 Qs); universe node 01018ad6; test_topic_map 1 row'),
  ('L-LR-NPZ', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Number Puzzles', null, 'Puzzles', 55, 'proposed', true, 'question_taxonomy NMAT Brown Book 2026 (Reasoning I: "Number Puzzles")'),
  ('L-LR-TNL', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Truth & Lies', null, 'Puzzles', 56, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-LR-TCC', 'chapter', 'L-LR', 'Logic', 'Logical Reasoning (CET / NMAT style)', 'Truth Claim Conclusions', null, 'Critical Reasoning', 57, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-AB', 'subsection', 'L', 'Logic', 'Abstract Reasoning', null, null, null, 58, 'proposed', true, 'Supabase sources — see master-taxonomy.csv'),
  ('L-AB-ASP', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Abstract Series & Patterns', null, null, 59, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-MWI', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Mirror & Water Image', null, null, 60, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-PFC', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Paper Folding & Cutting', null, null, 61, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-FGC', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Counting', null, null, 62, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-DOT', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Dot Concept', null, null, 63, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-FCM', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Figure Completion', null, null, 64, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-CBD', 'chapter', 'L-AB', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', null, null, 65, 'proposed', true, 'ck_topic_hierarchy "Visual Reasoning" (source=proposed)'),
  ('L-AB-CBD-001', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Cube Placed', null, 66, 'proposed', true, 'Arena "Logic > Abstract Reasoning > Cubes > Cube Placed" (1 test, 7 Qs); universe node 2101b97e (section Abstract)'),
  ('L-AB-CBD-002', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Folding Cube', null, 67, 'proposed', true, 'Arena "… > Cubes > Folding Cube" (1 test, 6 Qs); universe node 9a94effb'),
  ('L-AB-CBD-003', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Half Painted Cubes', null, 68, 'proposed', true, 'Arena "… > Cubes > Half Painted Cubes" (1 test, 8 Qs); universe node 707c5763'),
  ('L-AB-CBD-004', 'core_type', 'L-AB-CBD', 'Logic', 'Abstract Reasoning', 'Cubes & Dice', 'Painted Cubes', null, 69, 'proposed', true, 'Arena "… > Cubes > Painted Cubes" (2 tests, 14 Qs); universe node af384932')
on conflict (core_id) do nothing;

-- Chapter view with the CAT question counts (same idea as quant_master_taxonomy_chapters).
-- DILR rows in cat_import_questions have no ck_chapter yet, so the count comes from the chapter names in the
-- GitHub export (ck_chapter column) once that is written back; until then it counts by g_strategy_official.
create or replace view public.logic_master_taxonomy_chapters as
select t.core_id, t.subsection, t.chapter, t.lr_group, t.status, t.proposed,
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
-- select level, count(*) from public.logic_master_taxonomy group by 1;            -- section 1 · subsection 6 · chapter 54 · core_type 8
-- select * from public.logic_master_taxonomy_chapters;                             -- 54 chapters, CAT counts on the 12 Bible ones
-- select core_id, chapter from public.logic_master_taxonomy where proposed and level='chapter' order by sort_order;  -- 42 proposed chapters

-- ---------------------------------------------------------------------------------------
-- Control Room registration (fill actor/session id when running)
-- ---------------------------------------------------------------------------------------
-- insert into control_room.sessions (actor, agent_type, purpose, status) values ('Claude (Rav present)', 'claude', 'Create public.logic_master_taxonomy from reference-bank/logic/master-taxonomy.csv', 'active') returning id;
-- insert into control_room.change_requests (session_id, title, rationale, affected_objects, proposed_action, status, risk_level)
--   values ('<session id>', 'logic_master_taxonomy table + chapters view', 'Logic master taxonomy (15 Oct 2026) — one taxonomy per section with an ID at every level',
--           '{"public.logic_master_taxonomy","public.logic_master_taxonomy_chapters"}', 'create table + insert 69 rows + create view; additive, no existing object touched', 'planned', 'low');
-- after running: update control_room.change_requests set status='done', verification_notes='69 rows; counts verified', completed_at=now() where id='<request id>';
--                update control_room.sessions set status='finished', finished_at=now(), notes='handover: table created, nothing else changed' where id='<session id>';
