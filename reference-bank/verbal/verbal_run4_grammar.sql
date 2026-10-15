-- ===========================================================================
--  Cetking Verbal — RUN 4 : GRAMMAR
--
--  Rav, 15 Oct 2026: "These six are question formats, not grammar concepts.
--  So we should add a separate layer called Question Type, rather than making
--  them chapters or subchapters."
--
--  So this run does two separate things:
--    A. rebuilds Grammar as 5 chapters → 19 subchapters (concept axis)
--    B. creates the shared Verbal Question Type Registry, QT01–QT06
--       (exam-format axis) — section-wide, not Grammar-only, so CAT/CET/
--       SNAP/NMAT/XAT/CMAT share one set of format ids.
--
--  Core Rules are NOT created here — see the note at the end.
--  One transaction, all-or-nothing, self-asserting.
-- ===========================================================================

begin;

-- ---------------------------------------------------------------- preflight
do $$
declare n int;
begin
  select count(*) into n from public.verbal_master_taxonomy where master_id = 'V-GR';
  if n <> 1 then raise exception 'ABORT: the Grammar subsection V-GR is missing. Run the earlier files first.'; end if;

  -- No question may point at a Grammar id that this file will NOT recreate.
  -- Checked against the id list below rather than against tag_source, so the
  -- guard holds however the tag got there, and the file stays re-runnable.
  select count(*) into n from (
    select ck_core_id from public.cat_import_questions     where ck_core_id like 'V-GR%'
    union all select ck_core_id from public.cat_verbal_pyq_questions where ck_core_id like 'V-GR%'
    union all select ck_core_id from public.questions              where ck_core_id like 'V-GR%'
  ) z where z.ck_core_id not in (
    'V-GR-VRB', 'V-GR-VRB-SVA', 'V-GR-VRB-TNS', 'V-GR-VRB-CND',
    'V-GR-VRB-INF', 'V-GR-STR', 'V-GR-STR-MOD', 'V-GR-STR-PRN',
    'V-GR-STR-PAR', 'V-GR-STR-NEG', 'V-GR-USG', 'V-GR-USG-PRP',
    'V-GR-USG-CNJ', 'V-GR-USG-ART', 'V-GR-USG-CCW', 'V-GR-DSC',
    'V-GR-DSC-ADJ', 'V-GR-DSC-ADV', 'V-GR-DSC-CMP', 'V-GR-SPT',
    'V-GR-SPT-SPI', 'V-GR-SPT-VCE', 'V-GR-SPT-DIS', 'V-GR-SPT-FOS',
    'V-GR-UNT', 'V-GR-UNT-001'
  );
  if n > 0 then
    raise exception 'ABORT: % questions are tagged to Grammar ids this reshape would delete; remap them first.', n;
  end if;

  -- run 5 builds cet_verbal_tag_map with a foreign key onto Grammar ids, so once
  -- that exists this reshape cannot delete them. Stop with instructions rather
  -- than drop a map Rav may have edited by hand.
  if exists (select 1 from information_schema.tables
              where table_schema='public' and table_name='cet_verbal_tag_map') then
    raise exception 'ABORT: public.cet_verbal_tag_map references the Grammar ids this file replaces.%'
      ' If you have NOT hand-edited that map:  drop table public.cet_verbal_tag_map;  then run this file,'
      ' then verbal_run5_cet_alignment.sql again (it rebuilds the map).%'
      ' If you HAVE edited it, keep a copy first:  create table cet_verbal_tag_map_backup as select * from public.cet_verbal_tag_map;',
      chr(10), chr(10);
  end if;
end $$;

-- =========================================================================
--  PART A — Grammar concept tree: 5 chapters → 19 subchapters
-- =========================================================================

alter table public.verbal_master_taxonomy add column if not exists target_questions int;
comment on column public.verbal_master_taxonomy.target_questions is
  'Rav''s standardized practice target for this node. A target, NOT a verified existing count.';

-- children before parents (self-referential FK)
delete from public.verbal_master_taxonomy where level='core_type' and master_id like 'V-GR-%';
delete from public.verbal_master_taxonomy where level='subtopic'  and master_id like 'V-GR-%';
delete from public.verbal_master_taxonomy where level='chapter'   and master_id like 'V-GR-%';

insert into public.verbal_master_taxonomy
  (master_id, parent_id, level, name, section_id, subsection_id, subsection_name,
   chapter_id, chapter_name, chapter_code, topic_id, topic_no, topic_name,
   sort_order, target_questions, in_bible, match_status, status, source, notes)
values
  ('V-GR-VRB', 'V-GR', 'chapter', 'Verb Grammar', 'V', 'V-GR', 'Grammar',
   'V-GR-VRB', 'Verb Grammar', 'G01', null, null, null,
   1, 60, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G01 — 4 subchapters × 15 target questions = 60'),
  ('V-GR-VRB-SVA', 'V-GR-VRB', 'subtopic', 'Subject–Verb Agreement', 'V', 'V-GR', 'Grammar',
   'V-GR-VRB', 'Verb Grammar', 'G01', 'V-GR-VRB-SVA', 1, 'Subject–Verb Agreement',
   2, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G01.01 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-VRB-TNS', 'V-GR-VRB', 'subtopic', 'Tenses & Sequence of Tenses', 'V', 'V-GR', 'Grammar',
   'V-GR-VRB', 'Verb Grammar', 'G01', 'V-GR-VRB-TNS', 2, 'Tenses & Sequence of Tenses',
   3, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G01.02 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-VRB-CND', 'V-GR-VRB', 'subtopic', 'Conditionals', 'V', 'V-GR', 'Grammar',
   'V-GR-VRB', 'Verb Grammar', 'G01', 'V-GR-VRB-CND', 3, 'Conditionals',
   4, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G01.03 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-VRB-INF', 'V-GR-VRB', 'subtopic', 'Infinitives & Participles', 'V', 'V-GR', 'Grammar',
   'V-GR-VRB', 'Verb Grammar', 'G01', 'V-GR-VRB-INF', 4, 'Infinitives & Participles',
   5, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G01.04 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-STR', 'V-GR', 'chapter', 'Sentence Structure', 'V', 'V-GR', 'Grammar',
   'V-GR-STR', 'Sentence Structure', 'G02', null, null, null,
   6, 60, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G02 — 4 subchapters × 15 target questions = 60'),
  ('V-GR-STR-MOD', 'V-GR-STR', 'subtopic', 'Modifiers & Misplaced Modifiers', 'V', 'V-GR', 'Grammar',
   'V-GR-STR', 'Sentence Structure', 'G02', 'V-GR-STR-MOD', 1, 'Modifiers & Misplaced Modifiers',
   7, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G02.01 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-STR-PRN', 'V-GR-STR', 'subtopic', 'Pronouns', 'V', 'V-GR', 'Grammar',
   'V-GR-STR', 'Sentence Structure', 'G02', 'V-GR-STR-PRN', 2, 'Pronouns',
   8, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G02.02 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-STR-PAR', 'V-GR-STR', 'subtopic', 'Parallelism', 'V', 'V-GR', 'Grammar',
   'V-GR-STR', 'Sentence Structure', 'G02', 'V-GR-STR-PAR', 3, 'Parallelism',
   9, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G02.03 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-STR-NEG', 'V-GR-STR', 'subtopic', 'Negatives, Inversion & Constructions', 'V', 'V-GR', 'Grammar',
   'V-GR-STR', 'Sentence Structure', 'G02', 'V-GR-STR-NEG', 4, 'Negatives, Inversion & Constructions',
   10, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G02.04 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-USG', 'V-GR', 'chapter', 'Grammar Usage', 'V', 'V-GR', 'Grammar',
   'V-GR-USG', 'Grammar Usage', 'G03', null, null, null,
   11, 60, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G03 — 4 subchapters × 15 target questions = 60'),
  ('V-GR-USG-PRP', 'V-GR-USG', 'subtopic', 'Prepositions', 'V', 'V-GR', 'Grammar',
   'V-GR-USG', 'Grammar Usage', 'G03', 'V-GR-USG-PRP', 1, 'Prepositions',
   12, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G03.01 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-USG-CNJ', 'V-GR-USG', 'subtopic', 'Conjunctions & Connectors', 'V', 'V-GR', 'Grammar',
   'V-GR-USG', 'Grammar Usage', 'G03', 'V-GR-USG-CNJ', 2, 'Conjunctions & Connectors',
   13, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G03.02 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-USG-ART', 'V-GR-USG', 'subtopic', 'Articles & Determiners', 'V', 'V-GR', 'Grammar',
   'V-GR-USG', 'Grammar Usage', 'G03', 'V-GR-USG-ART', 3, 'Articles & Determiners',
   14, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G03.03 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-USG-CCW', 'V-GR-USG', 'subtopic', 'Commonly Confused Words', 'V', 'V-GR', 'Grammar',
   'V-GR-USG', 'Grammar Usage', 'G03', 'V-GR-USG-CCW', 4, 'Commonly Confused Words',
   15, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G03.04 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-DSC', 'V-GR', 'chapter', 'Descriptive Grammar', 'V', 'V-GR', 'Grammar',
   'V-GR-DSC', 'Descriptive Grammar', 'G04', null, null, null,
   16, 60, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G04 — 3 subchapters × 20 target questions = 60'),
  ('V-GR-DSC-ADJ', 'V-GR-DSC', 'subtopic', 'Adjectives', 'V', 'V-GR', 'Grammar',
   'V-GR-DSC', 'Descriptive Grammar', 'G04', 'V-GR-DSC-ADJ', 1, 'Adjectives',
   17, 20, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G04.01 — target 20 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-DSC-ADV', 'V-GR-DSC', 'subtopic', 'Adverbs', 'V', 'V-GR', 'Grammar',
   'V-GR-DSC', 'Descriptive Grammar', 'G04', 'V-GR-DSC-ADV', 2, 'Adverbs',
   18, 20, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G04.02 — target 20 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-DSC-CMP', 'V-GR-DSC', 'subtopic', 'Comparison Rules', 'V', 'V-GR', 'Grammar',
   'V-GR-DSC', 'Descriptive Grammar', 'G04', 'V-GR-DSC-CMP', 3, 'Comparison Rules',
   19, 20, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G04.03 — target 20 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-SPT', 'V-GR', 'chapter', 'Speech & Transformation', 'V', 'V-GR', 'Grammar',
   'V-GR-SPT', 'Speech & Transformation', 'G05', null, null, null,
   20, 60, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G05 — 4 subchapters × 15 target questions = 60'),
  ('V-GR-SPT-SPI', 'V-GR-SPT', 'subtopic', 'Speech Identification', 'V', 'V-GR', 'Grammar',
   'V-GR-SPT', 'Speech & Transformation', 'G05', 'V-GR-SPT-SPI', 1, 'Speech Identification',
   21, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G05.01 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-SPT-VCE', 'V-GR-SPT', 'subtopic', 'Active–Passive Voice', 'V', 'V-GR', 'Grammar',
   'V-GR-SPT', 'Speech & Transformation', 'G05', 'V-GR-SPT-VCE', 2, 'Active–Passive Voice',
   22, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G05.02 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-SPT-DIS', 'V-GR-SPT', 'subtopic', 'Direct–Indirect Speech', 'V', 'V-GR', 'Grammar',
   'V-GR-SPT', 'Speech & Transformation', 'G05', 'V-GR-SPT-DIS', 3, 'Direct–Indirect Speech',
   23, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G05.03 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-SPT-FOS', 'V-GR-SPT', 'subtopic', 'Figures of Speech', 'V', 'V-GR', 'Grammar',
   'V-GR-SPT', 'Speech & Transformation', 'G05', 'V-GR-SPT-FOS', 4, 'Figures of Speech',
   24, 15, true, 'new', 'rav_approved_15oct2026', 'rav_grammar_sheet_15oct2026',
   'G05.04 — target 15 questions. Core Rules still to be loaded from the Grammar Bible.'),
  ('V-GR-UNT', 'V-GR', 'chapter', 'Grammar (untyped)', 'V', 'V-GR', 'Grammar',
   'V-GR-UNT', 'Grammar (untyped)', 'G99', null, null, null,
   25, null, false, 'placeholder', 'holding_bucket', 'cetking_live_questions',
   'Holding bucket. 12 live Grammar questions carry no subchapter yet. Not one of Rav''s 5 chapters.'),
  ('V-GR-UNT-001', 'V-GR-UNT', 'core_type', 'Grammar (untyped)', 'V', 'V-GR', 'Grammar',
   'V-GR-UNT', 'Grammar (untyped)', 'G99', null, null, null,
   26, null, false, 'placeholder', 'holding_bucket', 'cetking_live_questions',
   'Leaf for the 12 untyped live Grammar questions.');

-- ------------------------------------------------------------- assertions A
do $$
declare n int;
begin
  select count(*) into n from public.verbal_master_taxonomy
   where level='chapter' and master_id like 'V-GR-%' and master_id <> 'V-GR-UNT';
  if n <> 5 then raise exception 'ABORT: % Grammar chapters, expected 5.', n; end if;

  select count(*) into n from public.verbal_master_taxonomy
   where level='subtopic' and master_id like 'V-GR-%';
  if n <> 19 then raise exception 'ABORT: % Grammar subchapters, expected 19.', n; end if;

  -- every subchapter hangs off a real chapter
  select count(*) into n from public.verbal_master_taxonomy c
   where c.master_id like 'V-GR-%' and c.parent_id is not null
     and not exists (select 1 from public.verbal_master_taxonomy p where p.master_id = c.parent_id);
  if n > 0 then raise exception 'ABORT: % Grammar rows have a dangling parent.', n; end if;

  -- his arithmetic: 4*15 + 4*15 + 4*15 + 3*20 + 4*15 = 300
  select coalesce(sum(target_questions),0) into n from public.verbal_master_taxonomy
   where level='subtopic' and master_id like 'V-GR-%';
  if n <> 300 then raise exception 'ABORT: subchapter targets sum to %, expected 300.', n; end if;
end $$;

-- =========================================================================
--  PART B — the shared Verbal Question Type Registry (exam-format axis)
--
--  Rav: "Make the six Question Types part of a shared Verbal Question Type
--  Registry, not exclusively the Grammar subsection." So this table is
--  section-wide and carries no Grammar foreign key.
-- =========================================================================

create table if not exists public.verbal_question_type_registry (
  question_type_id text primary key,
  name             text not null unique,
  reference_code   text,
  reference_code_verified boolean not null default false,
  replaces_taxonomy_id    text,
  bible_source     text,
  typical_subsections text[],
  sort_order       int  not null,
  is_active        boolean not null default true,
  notes            text,
  created_at       timestamptz not null default now()
);

comment on table public.verbal_question_type_registry is
  'Verbal exam-format axis, shared across ALL Verbal subsections and all exams (CAT/CET/SNAP/NMAT/XAT/CMAT). Independent of the concept axis in verbal_master_taxonomy: the same grammar rule can be asked in any of these formats. reference_code holds Rav''s supplied codes verbatim; reference_code_verified is false because they match nothing in question_taxonomy (which has zero Grammar rows) — confirm their origin before relying on them.';

-- upsert, never delete: once questions reference a QT id, deleting it would
-- break their foreign key. This keeps the file re-runnable after run 5.

insert into public.verbal_question_type_registry
  (question_type_id, name, reference_code, replaces_taxonomy_id, bible_source,
   typical_subsections, sort_order, notes)
values
  ('QT01', 'Sentence Improvement', '77', 'V-GR-SIP', 'Bible G1 Sentence Improvement',
   array['Grammar'], 1, 'Grammar format.'),
  ('QT02', 'Multiple Sentence Improvement', '79', null, 'Bible G1 subchapter 1B Multiple',
   array['Grammar'], 2, 'Grammar format.'),
  ('QT03', 'Phrase Replacement', '80', null, 'Bible G2 Phrase & Segment Replacement',
   array['Grammar'], 3, 'Grammar format.'),
  ('QT04', 'Grammar Error Spotting', '81', 'V-GR-ERR', 'Bible G3 Error Spotting',
   array['Grammar'], 4, 'Grammar format.'),
  ('QT05', 'Fragment Continuation', '84', null, 'Bible G8 Fragment & Logical Continuation',
   array['Grammar'], 5, 'Grammar format.'),
  ('QT06', 'Fill in the Blanks', '85', 'V-GR-GFB', 'Bible G9 Fill in the Blanks (Grammar-Function)',
   array['Grammar','Vocabulary','Reading Comprehension'], 6, 'Rav: "Fill in the Blanks might belong to grammar, vocabulary, or contextual verbal ability depending on what is being tested. The Question Type can stay the same while its concept mapping changes." Vocabulary FIB already maps to V-VO-CTX-SCO-001.')
on conflict (question_type_id) do update set
  name = excluded.name,
  reference_code = excluded.reference_code,
  replaces_taxonomy_id = excluded.replaces_taxonomy_id,
  bible_source = excluded.bible_source,
  typical_subsections = excluded.typical_subsections,
  sort_order = excluded.sort_order,
  notes = excluded.notes;

-- link columns: a question carries BOTH a concept id and a format id
alter table public.questions                add column if not exists ck_question_type text
  references public.verbal_question_type_registry(question_type_id);
alter table public.cat_import_questions     add column if not exists ck_question_type text
  references public.verbal_question_type_registry(question_type_id);
alter table public.cat_verbal_pyq_questions add column if not exists ck_question_type text
  references public.verbal_question_type_registry(question_type_id);

-- Grammar's leaf is the subchapter until Core Rules land, so record which
-- level a tag points at. Backfilled to 'core_type' for everything tagged so far.
alter table public.questions add column if not exists ck_tag_level text;
update public.questions set ck_tag_level = 'core_type'
 where ck_core_id is not null and ck_tag_level is null;

-- =========================================================================
--  PART C — tag the 37 live Grammar questions
-- =========================================================================

-- 25 Subject–Verb Agreement questions → G01.01 subchapter
update public.questions
   set ck_core_id = 'V-GR-VRB-SVA', ck_tag_level = 'subtopic',
       ck_tag_source = 'grammar_restructure_15oct2026'
 where section_name = 'Verbal' and sub_section_name = 'Subject Verb Agreement'
   and topic_name = 'Grammar' and sub_topic_name = 'SVA';

-- 12 questions with no subchapter at all → the holding bucket
update public.questions
   set ck_core_id = 'V-GR-UNT-001', ck_tag_level = 'core_type',
       ck_tag_source = 'grammar_restructure_15oct2026'
 where section_name = 'Verbal' and topic_name = 'Grammar'
   and sub_section_name is null and sub_topic_name is null;

-- ----------------------------------------------------------- assertions B+C
do $$
declare n int;
begin
  select count(*) into n from public.verbal_question_type_registry;
  if n <> 6 then raise exception 'ABORT: % question types, expected 6.', n; end if;

  select count(*) into n from public.questions where ck_tag_source = 'grammar_restructure_15oct2026';
  if n <> 37 then raise exception 'ABORT: tagged % Grammar questions, expected 37.', n; end if;

  select count(*) into n from public.questions where ck_core_id = 'V-GR-VRB-SVA';
  if n <> 25 then raise exception 'ABORT: SVA got %, expected 25.', n; end if;

  select count(*) into n from public.questions where ck_core_id = 'V-GR-UNT-001';
  if n <> 12 then raise exception 'ABORT: untyped bucket got %, expected 12.', n; end if;

  -- no Grammar question left untagged
  select count(*) into n from public.questions
   where section_name='Verbal' and (topic_name ilike '%grammar%' or sub_section_name ilike '%grammar%')
     and ck_core_id is null;
  if n > 0 then raise exception 'ABORT: % Grammar questions left untagged.', n; end if;

  -- every tag resolves to a real node at the level it claims
  select count(*) into n from public.questions q
   where q.ck_tag_source = 'grammar_restructure_15oct2026'
     and not exists (select 1 from public.verbal_master_taxonomy t
                      where t.master_id = q.ck_core_id and t.level = q.ck_tag_level);
  if n > 0 then raise exception 'ABORT: % Grammar tags do not resolve at their stated level.', n; end if;
end $$;

-- ---------------------------------------------------------- what you will see
select 'Grammar chapters'            as item, count(*)::text as n from public.verbal_master_taxonomy
  where level='chapter' and master_id like 'V-GR-%' and master_id <> 'V-GR-UNT'
union all select 'Grammar subchapters', count(*)::text from public.verbal_master_taxonomy
  where level='subtopic' and master_id like 'V-GR-%'
union all select 'target questions', sum(target_questions)::text from public.verbal_master_taxonomy
  where level='subtopic' and master_id like 'V-GR-%'
union all select 'question types in registry', count(*)::text from public.verbal_question_type_registry
union all select 'live Grammar questions tagged', count(*)::text from public.questions
  where ck_tag_source='grammar_restructure_15oct2026';

commit;

-- ===========================================================================
--  STILL OPEN — Core Rules
--
--  You wrote "Core Rule: Grammar Bible rules". The Bible structure I hold
--  lists core TYPES grouped under the six FORMAT chapters (G1 Sentence
--  Improvement, G3 Error Spotting, ...), not RULES under your 19 concept
--  subchapters. Writing 300 rules from that would mean inventing them, so I
--  have not. Send the Grammar Bible rule list and I will load it as the
--  core_type level under these 19 subchapters.
-- ===========================================================================

-- --------------------------------------------------------------------- undo
-- update public.questions set ck_core_id=null, ck_tag_level=null, ck_tag_source=null
--  where ck_tag_source='grammar_restructure_15oct2026';
-- drop table if exists public.verbal_question_type_registry cascade;
-- then re-run reference-bank/verbal/verbal_master_taxonomy_RESHAPE_rc.sql to restore the old 9 chapters.
