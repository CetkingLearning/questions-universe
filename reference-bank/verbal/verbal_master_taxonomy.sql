-- ============================================================================
-- Cetking Universe — VERBAL MASTER TAXONOMY
-- Prepared 15 Oct 2026. DO NOT RUN until Ravneet says "create the taxonomy table".
-- Same shape as the planned public.quant_master_taxonomy (STATUS.md, 15 Oct 2026).
-- Control Room procedure (schema control_room) is built into this file: step 1
-- registers the session and change request, step 4 records the handover.
-- Nothing here touches an existing table, view, or row. Additive only.
-- ============================================================================

begin;

-- ─── STEP 1 · Control Room: register session + change request ───────────────
insert into control_room.sessions (actor, agent_type, purpose, status, notes)
values ('claude', 'opus', 'Create public.verbal_master_taxonomy (additive) and load 144 rows from the 15 Oct Verbal merge',
        'active', 'Verbal master taxonomy — merge of verbal-bible, question_taxonomy, taxonomy_universe_nodes, Arena map, cat_verbal_pyq_questions (506) and cat_import_questions (747 actual CAT Verbal). Source of truth file: reference-bank/verbal/master-taxonomy.csv in CetkingLearning/questions-universe.');

insert into control_room.change_requests (session_id, title, rationale, affected_objects, proposed_action, status, risk_level, rollback_notes)
select s.id,
  'Verbal master taxonomy: new table public.verbal_master_taxonomy + 144 rows',
  'Rav rule 15 Oct 2026: one master taxonomy per section, an ID at every level, everything in the Universe revolves around it. Quant done; this is Verbal.',
  array['public.verbal_master_taxonomy','public.verbal_master_taxonomy_chapters'],
  'CREATE TABLE + CREATE VIEW + INSERT 144 rows. No existing object altered. No row in any other table touched.',
  'in_progress', 'low',
  'drop view public.verbal_master_taxonomy_chapters; drop table public.verbal_master_taxonomy;'
from control_room.sessions s where s.actor='claude' and s.status='active'
order by s.started_at desc limit 1;

-- ─── STEP 2 · the table ──────────────────────────────────────────────────────
create table if not exists public.verbal_master_taxonomy (
  core_id            text primary key,          -- V · V-PG · V-PG-JUM · V-PG-JUM-001
  level              text not null check (level in ('section','subsection','chapter','core_type')),
  parent_id          text references public.verbal_master_taxonomy(core_id),
  section            text not null default 'Verbal',
  subsection         text,
  chapter            text,
  core_type          text,
  mother_core_type   text,                      -- the G Strategy family (Summary / Paragraph / Evidence / Critical Reasoning)
  rc_non             text check (rc_non in ('RC','Non RC') or rc_non is null),
  sort_order         integer not null,
  in_bible           boolean not null default false,
  in_question_taxonomy boolean not null default false,
  in_universe_nodes  boolean not null default false,
  in_arena           boolean not null default false,
  in_cat_pyq         boolean not null default false,   -- cat_verbal_pyq_questions (506)
  in_cat_import      boolean not null default false,   -- cat_import_questions (747 actual CAT)
  match_status       text not null check (match_status in ('exact','synonym','bible_only','placeholder','batch','new')),
  proposed_addition  boolean not null default false,
  cat_questions_in_chapter integer default 0,
  cat_pyq_in_core_type     integer default 0,
  white_book_chapter text,
  source_refs        text,                      -- original TX_ codes / question_taxonomy ids / evidence
  status             text not null default 'from_bible_unfrozen',
  frozen_at          timestamptz,
  frozen_by          text,
  source             text not null default 'verbal_merge_15oct2026',
  rav_decision       text,
  rav_notes          text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);

comment on table public.verbal_master_taxonomy is
  'THE master Verbal taxonomy for all of Cetking Universe (Rav, 15 Oct 2026). Every Verbal question, test, mock, handout, book and page revolves around this. Rows stay from_bible_unfrozen until Rav freezes a chapter. The V- core_id is an ADDITIONAL key: existing taxonomy_universe_nodes.taxonomy_code, question_taxonomy.id and ck_topic_hierarchy.id keep their own foreign keys.';

create index if not exists verbal_master_taxonomy_level_idx      on public.verbal_master_taxonomy(level);
create index if not exists verbal_master_taxonomy_parent_idx     on public.verbal_master_taxonomy(parent_id);
create index if not exists verbal_master_taxonomy_subsection_idx on public.verbal_master_taxonomy(subsection);
create index if not exists verbal_master_taxonomy_mother_idx     on public.verbal_master_taxonomy(mother_core_type);

alter table public.verbal_master_taxonomy enable row level security;
drop policy if exists verbal_master_taxonomy_read on public.verbal_master_taxonomy;
create policy verbal_master_taxonomy_read on public.verbal_master_taxonomy for select using (true);
-- writes: service role only (no insert/update/delete policy), same as the rest of the content tables.

-- ─── STEP 3 · the 144 rows (parents before children) ────────────────────────

-- section (1)
insert into public.verbal_master_taxonomy (core_id, level, parent_id, subsection, chapter, core_type, mother_core_type, rc_non, sort_order, in_bible, in_question_taxonomy, in_universe_nodes, in_arena, in_cat_pyq, in_cat_import, match_status, proposed_addition, cat_questions_in_chapter, cat_pyq_in_core_type, white_book_chapter, source_refs) values
  ('V', 'section', NULL, NULL, NULL, NULL, NULL, NULL, 1, true, true, true, true, true, true, 'exact', false, 747, 506, NULL, 'Verbal section across all sources')
on conflict (core_id) do nothing;

-- subsection (8)
insert into public.verbal_master_taxonomy (core_id, level, parent_id, subsection, chapter, core_type, mother_core_type, rc_non, sort_order, in_bible, in_question_taxonomy, in_universe_nodes, in_arena, in_cat_pyq, in_cat_import, match_status, proposed_addition, cat_questions_in_chapter, cat_pyq_in_core_type, white_book_chapter, source_refs) values
  ('V-RC', 'subsection', 'V', 'Reading Comprehension', NULL, NULL, NULL, NULL, 2, true, true, true, true, true, true, 'exact', false, 424, 92, NULL, 'Passage-level reading skill. Not a G Strategy family.'),
  ('V-SM', 'subsection', 'V', 'Summary', NULL, NULL, 'Summary', NULL, 19, true, false, true, true, true, true, 'exact', false, 56, 98, NULL, 'G Strategy family 1 (shabda_shortcuts verbal-summary).'),
  ('V-PG', 'subsection', 'V', 'Paragraph', NULL, NULL, 'Paragraph', NULL, 28, true, true, true, true, true, true, 'exact', false, 136, 110, NULL, 'G Strategy family 2 (verbal-paragraph).'),
  ('V-EV', 'subsection', 'V', 'Evidence', NULL, NULL, 'Evidence', NULL, 41, true, false, true, true, true, true, 'exact', false, 0, 110, NULL, 'G Strategy family 3 (verbal-evidence). Legacy name "Direct RC".'),
  ('V-CR', 'subsection', 'V', 'Critical Reasoning', NULL, NULL, 'Critical Reasoning', NULL, 46, true, false, true, true, true, true, 'exact', false, 45, 188, NULL, 'G Strategy family 4 (verbal-critical-reasoning).'),
  ('V-VO', 'subsection', 'V', 'Vocabulary', NULL, NULL, NULL, NULL, 69, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'CET / NMAT side. No CAT PYQ rows.'),
  ('V-GR', 'subsection', 'V', 'Grammar', NULL, NULL, NULL, NULL, 123, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'CET / NMAT side. No CAT PYQ rows.'),
  ('V-GN', 'subsection', 'V', 'Verbal General', NULL, NULL, NULL, NULL, 142, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'Strategy & intro. Videos only, no questions.')
on conflict (core_id) do nothing;

-- chapter (43)
insert into public.verbal_master_taxonomy (core_id, level, parent_id, subsection, chapter, core_type, mother_core_type, rc_non, sort_order, in_bible, in_question_taxonomy, in_universe_nodes, in_arena, in_cat_pyq, in_cat_import, match_status, proposed_addition, cat_questions_in_chapter, cat_pyq_in_core_type, white_book_chapter, source_refs) values
  ('V-RC-PAS', 'chapter', 'V-RC', 'Reading Comprehension', 'Passage Practice (untyped RC)', NULL, NULL, NULL, 3, true, true, true, true, false, true, 'exact', false, 424, 0, NULL, 'Whole-passage practice where no fine type is tagged yet.'),
  ('V-RC-FUN', 'chapter', 'V-RC', 'Reading Comprehension', 'Passage Fundamentals', NULL, NULL, NULL, 6, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible RC1. No live rows yet.'),
  ('V-RC-DET', 'chapter', 'V-RC', 'Reading Comprehension', 'Detail & Fact-Based', NULL, NULL, NULL, 10, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible RC3. CAT-side equivalent is Evidence > Truth Facts.'),
  ('V-RC-VIC', 'chapter', 'V-RC', 'Reading Comprehension', 'Vocabulary in Context', NULL, NULL, NULL, 14, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible RC5.'),
  ('V-RC-EXC', 'chapter', 'V-RC', 'Reading Comprehension', 'Except Based Questions', NULL, NULL, NULL, 17, false, false, false, false, true, false, 'exact', false, 0, 92, 'Verbal — White Book ch 7 (p50–57)', 'MODIFIER chapter: a question FORM that rides on any RC core type (Rav, 7 Oct 2026). Verbal White Book ch 7.'),
  ('V-SM-SUM', 'chapter', 'V-SM', 'Summary', 'Non-RC Summary', NULL, 'Summary', NULL, 20, true, false, true, true, true, true, 'exact', false, 56, 54, 'Verbal — White Book ch 8 (p58–66)', 'Verbal White Book ch 8.'),
  ('V-SM-TSP', 'chapter', 'V-SM', 'Summary', 'TSPM based (Tone · Scope · Purpose · Main idea)', NULL, 'Summary', NULL, 22, true, false, true, true, true, false, 'exact', false, 0, 44, 'Verbal — White Book ch 1 (p2–9)', 'Verbal White Book ch 1. The RC half of the Summary family.'),
  ('V-PG-JUM', 'chapter', 'V-PG', 'Paragraph', 'Para Jumbles', NULL, 'Paragraph', NULL, 29, true, true, true, true, true, true, 'exact', false, 43, 47, 'Verbal — White Book ch 10 (p73–80)', 'Verbal White Book ch 10.'),
  ('V-PG-OMO', 'chapter', 'V-PG', 'Paragraph', 'Odd Man Out', NULL, 'Paragraph', NULL, 33, true, false, true, true, true, true, 'exact', false, 59, 36, 'Verbal — White Book ch 9 (p67–72)', 'Verbal White Book ch 9.'),
  ('V-PG-COM', 'chapter', 'V-PG', 'Paragraph', 'Para Completion & Sentence Insertion', NULL, 'Paragraph', NULL, 35, true, false, false, true, true, true, 'exact', false, 34, 27, 'Verbal — White Book ch 11 (p81–86)', 'Verbal White Book ch 11.'),
  ('V-PG-JOI', 'chapter', 'V-PG', 'Paragraph', 'Sentence Joining & Matching (CET)', NULL, 'Paragraph', NULL, 38, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible PB5/PB6. CET/NMAT style, no CAT rows.'),
  ('V-EV-WMT', 'chapter', 'V-EV', 'Evidence', 'Why Mention This', NULL, 'Evidence', NULL, 42, false, false, true, true, true, false, 'exact', false, 0, 57, 'Verbal — White Book ch 3 (p21–30)', 'Verbal White Book ch 3 "Meaning of this".'),
  ('V-EV-TRF', 'chapter', 'V-EV', 'Evidence', 'Truth & Facts based', NULL, 'Evidence', NULL, 44, false, false, true, true, true, false, 'exact', false, 0, 53, 'Verbal — White Book ch 4 (p31–34)', 'Verbal White Book ch 4.'),
  ('V-CR-INF', 'chapter', 'V-CR', 'Critical Reasoning', 'Inference Based Questions', NULL, 'Critical Reasoning', NULL, 47, true, false, true, true, true, true, 'exact', false, 15, 98, 'Verbal — White Book ch 2 (p10–20)', 'Verbal White Book ch 2. Biggest single CAT Verbal type.'),
  ('V-CR-WST', 'chapter', 'V-CR', 'Critical Reasoning', 'Strength / Weaken Arguments', NULL, 'Critical Reasoning', NULL, 50, true, false, true, true, true, true, 'exact', false, 5, 34, 'Verbal — White Book ch 6 (p41–49)', 'Verbal White Book ch 6.'),
  ('V-CR-CEF', 'chapter', 'V-CR', 'Critical Reasoning', 'Cause Effect Reasoning', NULL, 'Critical Reasoning', NULL, 52, false, false, true, true, true, true, 'exact', false, 25, 44, 'Verbal — White Book ch 5 (p35–40)', 'Verbal White Book ch 5.'),
  ('V-CR-SIM', 'chapter', 'V-CR', 'Critical Reasoning', 'Similarity', NULL, 'Critical Reasoning', NULL, 54, true, false, true, true, true, false, 'exact', false, 0, 12, NULL, 'Smallest CAT Verbal type. No White Book chapter yet.'),
  ('V-CR-TRC', 'chapter', 'V-CR', 'Critical Reasoning', 'Truth Claim Conclusions', NULL, 'Critical Reasoning', NULL, 56, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'Live Cetking test chapter, no CAT PYQ label.'),
  ('V-CR-ASM', 'chapter', 'V-CR', 'Critical Reasoning', 'Assumptions', NULL, 'Critical Reasoning', NULL, 58, true, false, true, false, false, false, 'exact', true, 0, 0, NULL, 'Verbal Bible CR1. Hierarchy row exists (proposed).'),
  ('V-CR-COA', 'chapter', 'V-CR', 'Critical Reasoning', 'Course of Action', NULL, 'Critical Reasoning', NULL, 61, true, false, true, false, false, false, 'exact', true, 0, 0, NULL, 'Verbal Bible CR5. CET style.'),
  ('V-CR-ARG', 'chapter', 'V-CR', 'Critical Reasoning', 'Arguments (standalone)', NULL, 'Critical Reasoning', NULL, 63, true, false, true, false, false, false, 'exact', true, 0, 0, NULL, 'Verbal Bible CR1/CR5 + hierarchy "Arguments" (proposed). Non-passage CR.'),
  ('V-CR-FLW', 'chapter', 'V-CR', 'Critical Reasoning', 'Flaw & Paradox', NULL, 'Critical Reasoning', NULL, 66, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible CR3. No rows anywhere.'),
  ('V-VO-SYN', 'chapter', 'V-VO', 'Vocabulary', 'Synonyms & Antonyms', NULL, NULL, NULL, 70, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'Live Cetking + NMAT Brown Book.'),
  ('V-VO-OWS', 'chapter', 'V-VO', 'Vocabulary', 'One-Word Substitution', NULL, NULL, NULL, 76, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'Live: 3 sub-types × 18 questions each.'),
  ('V-VO-IDM', 'chapter', 'V-VO', 'Vocabulary', 'Idioms & Phrases', NULL, NULL, NULL, 81, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'Live: 3 sub-types × 18 questions.'),
  ('V-VO-SPL', 'chapter', 'V-VO', 'Vocabulary', 'Spelling', NULL, NULL, NULL, 87, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-VO-ROT', 'chapter', 'V-VO', 'Vocabulary', 'Roots & Prefixes', NULL, NULL, NULL, 92, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'Live: 5 test batches, 48 questions.'),
  ('V-VO-FIB', 'chapter', 'V-VO', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', NULL, NULL, NULL, 96, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-VO-CLZ', 'chapter', 'V-VO', 'Vocabulary', 'Cloze', NULL, NULL, NULL, 103, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-VO-CTX', 'chapter', 'V-VO', 'Vocabulary', 'Contextual Meaning & Usage', NULL, NULL, NULL, 106, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-VO-WRL', 'chapter', 'V-VO', 'Vocabulary', 'Word Relationships', NULL, NULL, NULL, 115, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-VO-HFW', 'chapter', 'V-VO', 'Vocabulary', 'High Frequency Words', NULL, NULL, NULL, 119, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-VO-UNT', 'chapter', 'V-VO', 'Vocabulary', 'Vocabulary (untyped)', NULL, NULL, NULL, 121, false, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'Container: questions tagged only "Vocabulary".'),
  ('V-GR-SVA', 'chapter', 'V-GR', 'Grammar', 'Subject Verb Agreement', NULL, NULL, NULL, 124, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-GR-SIP', 'chapter', 'V-GR', 'Grammar', 'Sentence Improvement', NULL, NULL, NULL, 126, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-GR-ERR', 'chapter', 'V-GR', 'Grammar', 'Spotting Error', NULL, NULL, NULL, 128, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-GR-FOS', 'chapter', 'V-GR', 'Grammar', 'Figures of Speech', NULL, NULL, NULL, 130, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, NULL),
  ('V-GR-VCE', 'chapter', 'V-GR', 'Grammar', 'Voice (Active–Passive)', NULL, NULL, NULL, 132, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible G4. CET style.'),
  ('V-GR-SPH', 'chapter', 'V-GR', 'Grammar', 'Speech (Direct–Indirect)', NULL, NULL, NULL, 134, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible G5. CET style.'),
  ('V-GR-POS', 'chapter', 'V-GR', 'Grammar', 'Parts of Speech & Modifiers', NULL, NULL, NULL, 136, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'Verbal Bible G6.'),
  ('V-GR-GFB', 'chapter', 'V-GR', 'Grammar', 'Grammar Fill in the Blanks', NULL, NULL, NULL, 138, true, false, true, false, false, false, 'exact', true, 0, 0, NULL, 'Verbal Bible G9.'),
  ('V-GR-UNT', 'chapter', 'V-GR', 'Grammar', 'Grammar (untyped)', NULL, NULL, NULL, 140, false, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'Container: questions tagged only "Grammar".'),
  ('V-GN-INT', 'chapter', 'V-GN', 'Verbal General', 'Strategy & Intro', NULL, NULL, NULL, 143, false, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'Videos only.')
on conflict (core_id) do nothing;

-- core_type (92)
insert into public.verbal_master_taxonomy (core_id, level, parent_id, subsection, chapter, core_type, mother_core_type, rc_non, sort_order, in_bible, in_question_taxonomy, in_universe_nodes, in_arena, in_cat_pyq, in_cat_import, match_status, proposed_addition, cat_questions_in_chapter, cat_pyq_in_core_type, white_book_chapter, source_refs) values
  ('V-RC-PAS-001', 'core_type', 'V-RC-PAS', 'Reading Comprehension', 'Passage Practice (untyped RC)', 'RC Passage set (untyped)', NULL, 'RC', 4, true, true, true, true, false, true, 'exact', false, 424, 0, NULL, 'bible=RC6; question_taxonomy=Language Skills|Reading|Reading Comprehension I & II; universe_nodes=TX_884905C672C10CC6F2AD, TX_40AF871CFB2CC9C90F64; arena=Verbal|Reading Comprehension; 424 actual-CAT rows in cat_import_questions have topic=Reading Comprehension and NO question_type. Must be tagged against the 506-row master before they can sit under a fine core type.'),
  ('V-RC-PAS-002', 'core_type', 'V-RC-PAS', 'Reading Comprehension', 'Passage Practice (untyped RC)', 'RC Passage (labelled RC only)', NULL, 'RC', 5, false, true, false, false, false, true, 'synonym', false, 424, 0, NULL, 'question_taxonomy=Language Skills|Reading; iimking labels "RC" (44) and "Reading Comprehension" (39) — same thing, two spellings.'),
  ('V-RC-FUN-001', 'core_type', 'V-RC-FUN', 'Reading Comprehension', 'Passage Fundamentals', 'Main Idea', NULL, NULL, 7, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC1 Central Idea & Theme; Bible RC1. Overlaps TSPM "M" (Main idea) — Rav to decide whether this lives here or only in V-SM-TSP.'),
  ('V-RC-FUN-002', 'core_type', 'V-RC-FUN', 'Reading Comprehension', 'Passage Fundamentals', 'Best Title', NULL, NULL, 8, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC1 Title Selection'),
  ('V-RC-FUN-003', 'core_type', 'V-RC-FUN', 'Reading Comprehension', 'Passage Fundamentals', 'Passage Structure / Paragraph Function', NULL, NULL, 9, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC1 Passage Structure'),
  ('V-RC-DET-001', 'core_type', 'V-RC-DET', 'Reading Comprehension', 'Detail & Fact-Based', 'Direct Fact Lookup', NULL, NULL, 11, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC3 Explicit Detail; On the CAT side this is V-EV-TRF Truth Facts. Keep here only for CET/NMAT style papers.'),
  ('V-RC-DET-002', 'core_type', 'V-RC-DET', 'Reading Comprehension', 'Detail & Fact-Based', 'Chronology / Sequence', NULL, NULL, 12, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC3 Sequence of Events'),
  ('V-RC-DET-003', 'core_type', 'V-RC-DET', 'Reading Comprehension', 'Detail & Fact-Based', 'Data / Statistic Retrieval', NULL, NULL, 13, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC3 Numerical Detail'),
  ('V-RC-VIC-001', 'core_type', 'V-RC-VIC', 'Reading Comprehension', 'Vocabulary in Context', 'Contextual Word Meaning', NULL, NULL, 15, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC5 Word Meaning in Context'),
  ('V-RC-VIC-002', 'core_type', 'V-RC-VIC', 'Reading Comprehension', 'Vocabulary in Context', 'Idiomatic Phrase Meaning', NULL, NULL, 16, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=RC5 Phrase Interpretation'),
  ('V-RC-EXC-001', 'core_type', 'V-RC-EXC', 'Reading Comprehension', 'Except Based Questions', 'Except-based (form modifier)', NULL, 'RC', 18, false, false, false, false, true, false, 'exact', false, 0, 92, 'Verbal — White Book ch 7 (p50–57)', 'cat_verbal_pyq_questions.is_except = true on 92 of 506 rows, spread across Inference / Truth Facts / etc. Store as a FLAG on the question, not as its core type. Oktober Festival Day 9 = Except Based Questions.'),
  ('V-SM-SUM-001', 'core_type', 'V-SM-SUM', 'Summary', 'Non-RC Summary', 'Summary', 'Summary', 'Non RC', 21, true, false, true, true, true, true, 'exact', false, 56, 54, 'Verbal — White Book ch 8 (p58–66)', 'bible=PB7 Paragraph Summary; universe_nodes=TX_6230B3D1342E1D0461D4, TX_A139F618539BF19ECBA2; arena=Verbal|Paragraph-Based|Paragraph Summary; Arena mapping approval_status=pending with note "VA Summary maps to paragraph summary topic, RC TSPM is separate".'),
  ('V-SM-TSP-001', 'core_type', 'V-SM-TSP', 'Summary', 'TSPM based (Tone · Scope · Purpose · Main idea)', 'Tone of Passage', 'Summary', 'RC', 23, true, false, true, true, false, false, 'exact', false, 0, 0, 'Verbal — White Book ch 1 (p2–9)', 'bible=RC2 Tone; universe_nodes=TX_B5201D8A4964FD11391A; arena=Verbal|Reading Comprehension|TSPM; 17 live questions, 3 test rows.'),
  ('V-SM-TSP-002', 'core_type', 'V-SM-TSP', 'Summary', 'TSPM based (Tone · Scope · Purpose · Main idea)', 'Scope of Passage', 'Summary', 'RC', 24, true, false, true, true, false, false, 'exact', false, 0, 0, 'Verbal — White Book ch 1 (p2–9)', 'bible=RC2 Scope; universe_nodes=TX_6B9A4D8A235B86405C3C; arena=Verbal|Reading Comprehension|TSPM; 15 live questions, 3 test rows.'),
  ('V-SM-TSP-003', 'core_type', 'V-SM-TSP', 'Summary', 'TSPM based (Tone · Scope · Purpose · Main idea)', 'Purpose of Passage', 'Summary', 'RC', 25, true, false, true, true, false, false, 'exact', false, 0, 0, 'Verbal — White Book ch 1 (p2–9)', 'bible=RC2 Purpose; universe_nodes=TX_0AC2476046C891B8D941; arena=Verbal|Reading Comprehension|TSPM; 18 live questions, 3 test rows.'),
  ('V-SM-TSP-004', 'core_type', 'V-SM-TSP', 'Summary', 'TSPM based (Tone · Scope · Purpose · Main idea)', 'Main idea of Passage (TSPM, CAT label)', 'Summary', 'RC', 26, false, false, false, true, true, false, 'exact', false, 0, 44, 'Verbal — White Book ch 1 (p2–9)', 'arena=Verbal|Reading Comprehension|TSPM; The CAT PYQ label is the single word "TSPM" (44 rows) — it does not split into T/S/P/M. The three nodes above come from Cetking tests. DECISION NEEDED: keep 4 core types and tag each PYQ, or keep one core type "TSPM".'),
  ('V-SM-TSP-005', 'core_type', 'V-SM-TSP', 'Summary', 'TSPM based (Tone · Scope · Purpose · Main idea)', 'Attitude & Bias', 'Summary', 'RC', 27, true, false, false, false, false, false, 'bible_only', true, 0, 0, 'Verbal — White Book ch 1 (p2–9)', 'bible=RC2 Attitude & Bias'),
  ('V-PG-JUM-001', 'core_type', 'V-PG-JUM', 'Paragraph', 'Para Jumbles', 'Jumbled (TITA)', 'Paragraph', 'Non RC', 30, true, false, true, true, true, true, 'exact', false, 43, 47, 'Verbal — White Book ch 10 (p73–80)', 'bible=PB1 Para Jumbles without options; universe_nodes=TX_FB2DD9FF1758ECEB0923; arena=Verbal|Paragraph-Based; CAT asks this TITA. iimking spells it Para Jumble / Para Jumbles / Parajumbles / ParaJumbles — all one core type.'),
  ('V-PG-JUM-002', 'core_type', 'V-PG-JUM', 'Paragraph', 'Para Jumbles', 'Jumbled with options', 'Paragraph', 'Non RC', 31, true, true, false, false, false, false, 'synonym', true, 43, 0, 'Verbal — White Book ch 10 (p73–80)', 'bible=PB2 Para Jumbles with options; question_taxonomy=Language Skills|Reading|Para Jumbles; NMAT/CET form. Node TX_FB2DD9FF1758ECEB0923 ("Reading|Para Jumbles", NMAT Brown Book) may belong here rather than TITA — Rav to confirm.'),
  ('V-PG-JUM-003', 'core_type', 'V-PG-JUM', 'Paragraph', 'Para Jumbles', 'Mandatory Pair', 'Paragraph', 'Non RC', 32, true, false, false, false, false, false, 'bible_only', true, 43, 0, 'Verbal — White Book ch 10 (p73–80)', 'bible=PB1 Mandatory Pair'),
  ('V-PG-OMO-001', 'core_type', 'V-PG-OMO', 'Paragraph', 'Odd Man Out', 'Odd Man Out', 'Paragraph', 'Non RC', 34, true, false, true, true, true, true, 'exact', false, 59, 36, 'Verbal — White Book ch 9 (p67–72)', 'bible=PB4 Sentence Elimination; universe_nodes=TX_F8B97346857792CA857D; arena=Verbal|Paragraph-Based|Odd Man Out; Do NOT merge with V-VO-WRL "Odd One Out (words)" — that is a vocabulary question. iimking "Odd One Out" (3) is this one. 6 rows under topic Odd One Out carry no question_type.'),
  ('V-PG-COM-001', 'core_type', 'V-PG-COM', 'Paragraph', 'Para Completion & Sentence Insertion', 'Completion', 'Paragraph', 'Non RC', 36, true, false, false, false, true, true, 'exact', false, 34, 27, 'Verbal — White Book ch 11 (p81–86)', 'bible=PB3 Sentence Completion; iimking: "Paragraph Completion" (17) + "Para Completion" (9) = one core type.'),
  ('V-PG-COM-002', 'core_type', 'V-PG-COM', 'Paragraph', 'Para Completion & Sentence Insertion', 'Sentence Insertion / Missing Sentence', 'Paragraph', 'Non RC', 37, false, false, false, false, false, true, 'exact', false, 34, 0, 'Verbal — White Book ch 11 (p81–86)', 'iimking: Sentence Insertion 4 + Missing sentences 2 + Missing Sentence 2. No separate CAT PYQ label — Rav to say whether CAT counts this inside Completion.'),
  ('V-PG-JOI-001', 'core_type', 'V-PG-JOI', 'Paragraph', 'Sentence Joining & Matching (CET)', 'Sentence Joining', NULL, NULL, 39, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=PB5'),
  ('V-PG-JOI-002', 'core_type', 'V-PG-JOI', 'Paragraph', 'Sentence Joining & Matching (CET)', 'Match the Following (Paragraph)', NULL, NULL, 40, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=PB6'),
  ('V-EV-WMT-001', 'core_type', 'V-EV-WMT', 'Evidence', 'Why Mention This', 'Why Mention This', 'Evidence', 'RC', 43, false, false, true, true, true, true, 'exact', false, 0, 57, 'Verbal — White Book ch 3 (p21–30)', 'universe_nodes=(hierarchy RC|Why Mention This); arena=Verbal|Reading Comprehension; iimking label "Keywords" (3 rows) looks like this type — VERIFY before mapping.'),
  ('V-EV-TRF-001', 'core_type', 'V-EV-TRF', 'Evidence', 'Truth & Facts based', 'Truth Facts', 'Evidence', 'RC', 45, false, false, true, true, true, false, 'exact', false, 0, 53, 'Verbal — White Book ch 4 (p31–34)', 'universe_nodes=(hierarchy RC|Truth Facts); arena=Verbal|Reading Comprehension'),
  ('V-CR-INF-001', 'core_type', 'V-CR-INF', 'Critical Reasoning', 'Inference Based Questions', 'Inference', 'Critical Reasoning', 'RC', 48, true, false, true, true, true, true, 'exact', false, 15, 98, 'Verbal — White Book ch 2 (p10–20)', 'bible=RC4 / CR4; universe_nodes=(hierarchy RC|Inference); arena=Verbal|Critical Reasoning; Arena mapping approved (exact, "Same broad classification; verbal only").'),
  ('V-CR-INF-002', 'core_type', 'V-CR-INF', 'Critical Reasoning', 'Inference Based Questions', 'Must-Be-True', 'Critical Reasoning', 'RC', 49, true, false, false, false, false, false, 'bible_only', true, 15, 0, 'Verbal — White Book ch 2 (p10–20)', 'bible=CR4 Must-Be-True'),
  ('V-CR-WST-001', 'core_type', 'V-CR-WST', 'Critical Reasoning', 'Strength / Weaken Arguments', 'Weakening Strengthening', 'Critical Reasoning', 'RC', 51, true, false, true, true, true, true, 'exact', false, 5, 34, 'Verbal — White Book ch 6 (p41–49)', 'bible=CR2; universe_nodes=(hierarchy RC|Weaken Strengthening); arena=Verbal|Critical Reasoning; iimking "Argument" (5 rows) provisionally mapped here — VERIFY, could be V-CR-ARG.'),
  ('V-CR-CEF-001', 'core_type', 'V-CR-CEF', 'Critical Reasoning', 'Cause Effect Reasoning', 'Cause Effect Reasoning', 'Critical Reasoning', 'RC', 53, false, false, true, true, true, true, 'exact', false, 25, 44, 'Verbal — White Book ch 5 (p35–40)', 'universe_nodes=(hierarchy RC|Cause Effect Reasoning); test_taxonomy "Cause Effect"; arena=Verbal|Critical Reasoning; iimking label "Cause-Effect / Reasoning" (25).'),
  ('V-CR-SIM-001', 'core_type', 'V-CR-SIM', 'Critical Reasoning', 'Similarity', 'Similarity', 'Critical Reasoning', 'RC', 55, true, false, true, true, true, false, 'exact', false, 0, 12, NULL, 'bible=RC4 Apply-to-New-Situation; universe_nodes=(hierarchy RC|Similarity); arena=Verbal|Critical Reasoning; 12 PYQ rows and no book chapter — flag for content.'),
  ('V-CR-TRC-001', 'core_type', 'V-CR-TRC', 'Critical Reasoning', 'Truth Claim Conclusions', 'Truth Claim Conclusions', NULL, NULL, 57, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=CR4 Best-Supported Conclusion; universe_nodes=TX_E921A2E22250BC847947; 10 live questions, 4 test rows. Hierarchy "Critical Reasoning|Conclusions & Inference" (proposed) maps here.'),
  ('V-CR-ASM-001', 'core_type', 'V-CR-ASM', 'Critical Reasoning', 'Assumptions', 'Statement & Assumption', NULL, NULL, 59, true, false, true, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR1 / CR5; universe_nodes=(hierarchy Critical Reasoning|Assumptions, proposed)'),
  ('V-CR-ASM-002', 'core_type', 'V-CR-ASM', 'Critical Reasoning', 'Assumptions', 'Necessary Assumption', NULL, NULL, 60, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR1'),
  ('V-CR-COA-001', 'core_type', 'V-CR-COA', 'Critical Reasoning', 'Course of Action', 'Course of Action', NULL, NULL, 62, true, false, true, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR5; universe_nodes=(hierarchy Critical Reasoning|Course of Action, proposed)'),
  ('V-CR-ARG-001', 'core_type', 'V-CR-ARG', 'Critical Reasoning', 'Arguments (standalone)', 'Strong / Weak Argument (CET)', NULL, NULL, 64, true, false, true, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR5; universe_nodes=(hierarchy Critical Reasoning|Arguments, proposed)'),
  ('V-CR-ARG-002', 'core_type', 'V-CR-ARG', 'Critical Reasoning', 'Arguments (standalone)', 'Identify Conclusion / Premise', NULL, NULL, 65, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR1'),
  ('V-CR-FLW-001', 'core_type', 'V-CR-FLW', 'Critical Reasoning', 'Flaw & Paradox', 'Identify Flaw', NULL, NULL, 67, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR3'),
  ('V-CR-FLW-002', 'core_type', 'V-CR-FLW', 'Critical Reasoning', 'Flaw & Paradox', 'Resolve Paradox', NULL, NULL, 68, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=CR3'),
  ('V-VO-SYN-001', 'core_type', 'V-VO-SYN', 'Vocabulary', 'Synonyms & Antonyms', 'Direct Synonym', NULL, NULL, 71, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V2; question_taxonomy=Verbal|Vocabulary|Synonyms (One-Dimensional); universe_nodes=TX_950D9763AEC4CF6FA295'),
  ('V-VO-SYN-002', 'core_type', 'V-VO-SYN', 'Vocabulary', 'Synonyms & Antonyms', 'Direct Antonym', NULL, NULL, 72, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V2; question_taxonomy=Verbal|Vocabulary|Antonyms (One-Dimensional); universe_nodes=TX_79EDFC16AC9900C1601C'),
  ('V-VO-SYN-003', 'core_type', 'V-VO-SYN', 'Vocabulary', 'Synonyms & Antonyms', 'Correct Synonym-Antonym Pair', NULL, NULL, 73, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V2; question_taxonomy=Verbal|Vocabulary|Synonym-Antonym Integration (Two-Dimensional); universe_nodes=TX_70C6C798C1C239B8DF3A, TX_B05D6414FFECFC95564E; Test batch "Vocabulary Builder|Antonym & Synonym|Antonym Synonym" (4 test rows) sits here — mixed syn/ant test, could instead be split across Direct Synonym + Direct Antonym.'),
  ('V-VO-SYN-004', 'core_type', 'V-VO-SYN', 'Vocabulary', 'Synonyms & Antonyms', 'Synonym (NMAT)', NULL, NULL, 74, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Synonym (NMAT Brown Book 2026); universe_nodes=TX_5A40C8F93719AB890831; NMAT label for Direct Synonym — keep the source label, map to the same core type.'),
  ('V-VO-SYN-005', 'core_type', 'V-VO-SYN', 'Vocabulary', 'Synonyms & Antonyms', 'Antonym (NMAT)', NULL, NULL, 75, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Antonym (NMAT Brown Book 2026); universe_nodes=TX_750E8621AA829A758026'),
  ('V-VO-OWS-001', 'core_type', 'V-VO-OWS', 'Vocabulary', 'One-Word Substitution', 'Person-Type OWS', NULL, NULL, 77, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V1 1A; universe_nodes=TX_013FC9435DE36F128021, TX_BE0AB3B251899BABE5E0; 18 live questions. Node duplicated under sub-section "Vocabulary" and "Vocabulary Usage".'),
  ('V-VO-OWS-002', 'core_type', 'V-VO-OWS', 'Vocabulary', 'One-Word Substitution', 'Action/Process OWS', NULL, NULL, 78, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V1 1B; universe_nodes=TX_2C110D9B275E64C98836, TX_8623C329E2CFF73086DC; 18 live questions; duplicated node.'),
  ('V-VO-OWS-003', 'core_type', 'V-VO-OWS', 'Vocabulary', 'One-Word Substitution', 'Abstract-Concept OWS', NULL, NULL, 79, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V1 1C; universe_nodes=TX_89D644A9DB4D12E158C7, TX_AAA9F79BDAC1B682CD81; 18 live questions; duplicated node.'),
  ('V-VO-OWS-004', 'core_type', 'V-VO-OWS', 'Vocabulary', 'One-Word Substitution', 'Definition to Word', NULL, NULL, 80, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V1; question_taxonomy=Verbal|Vocabulary|One-Word Substitution (One-Dimensional); universe_nodes=TX_AA8FFB524B877506A3E8'),
  ('V-VO-IDM-001', 'core_type', 'V-VO-IDM', 'Vocabulary', 'Idioms & Phrases', 'Idiom Meaning (Usage)', NULL, NULL, 82, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V6 6A; universe_nodes=TX_F25C8DFC0A148EE7328E, TX_7E76EC7D491D23CF172E; 18 live questions; duplicated node.'),
  ('V-VO-IDM-002', 'core_type', 'V-VO-IDM', 'Vocabulary', 'Idioms & Phrases', 'Definition-to-Idiom Match', NULL, NULL, 83, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V6 6B; universe_nodes=TX_7E4CB6FE1EF81961382B, TX_93C34634B557249B3D26; 18 live questions; duplicated node.'),
  ('V-VO-IDM-003', 'core_type', 'V-VO-IDM', 'Vocabulary', 'Idioms & Phrases', 'Best-Fit Idiom in Context', NULL, NULL, 84, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V6 6C; universe_nodes=TX_03762175A6427618BD27, TX_7F8C88820DCCA661AB3A; 18 live questions; duplicated node.'),
  ('V-VO-IDM-004', 'core_type', 'V-VO-IDM', 'Vocabulary', 'Idioms & Phrases', 'Idiom Meaning Identification', NULL, NULL, 85, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V6; question_taxonomy=Verbal|Idioms|Idioms (One-Dimensional); universe_nodes=TX_6E527492C7BB3528095C'),
  ('V-VO-IDM-005', 'core_type', 'V-VO-IDM', 'Vocabulary', 'Idioms & Phrases', 'Idioms Phrases (NMAT)', NULL, NULL, 86, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Idioms Phrases (NMAT); universe_nodes=TX_D166688B95F65A65BD57'),
  ('V-VO-SPL-001', 'core_type', 'V-VO-SPL', 'Vocabulary', 'Spelling', 'Standard Spelling Correction', NULL, NULL, 88, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V5 5A; universe_nodes=TX_142F195A602E6B68A89C, TX_120652D25FFA2D4536E4; 18 live questions; duplicated node.'),
  ('V-VO-SPL-002', 'core_type', 'V-VO-SPL', 'Vocabulary', 'Spelling', 'Commonly Confused Spellings', NULL, NULL, 89, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V5 5B; universe_nodes=TX_2E148904C23EA9CCEADB, TX_03A411EBE0DF96A14A73; 18 live questions; duplicated node.'),
  ('V-VO-SPL-003', 'core_type', 'V-VO-SPL', 'Vocabulary', 'Spelling', 'Correct Spelling Recognition', NULL, NULL, 90, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V5; question_taxonomy=Verbal|Vocabulary|Spelling (One-Dimensional); universe_nodes=TX_08D3B55DC0CCA628A57A'),
  ('V-VO-SPL-004', 'core_type', 'V-VO-SPL', 'Vocabulary', 'Spelling', 'Spelling Test (NMAT)', NULL, NULL, 91, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Spelling Test (NMAT); universe_nodes=TX_D645AA472ABB2F8E21AB'),
  ('V-VO-ROT-001', 'core_type', 'V-VO-ROT', 'Vocabulary', 'Roots & Prefixes', 'Root Meaning Identification', NULL, NULL, 93, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Roots (One-Dimensional); universe_nodes=TX_3C3BD4B598096A5F2C77'),
  ('V-VO-ROT-002', 'core_type', 'V-VO-ROT', 'Vocabulary', 'Roots & Prefixes', 'Root-Word Multi-Match', NULL, NULL, 94, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Roots (Two-Dimensional); universe_nodes=TX_93AFFF61EBF96BB7F05F'),
  ('V-VO-ROT-003', 'core_type', 'V-VO-ROT', 'Vocabulary', 'Roots & Prefixes', 'Roots & Prefixes practice batch', NULL, NULL, 95, false, false, true, false, false, false, 'batch', false, 0, 0, NULL, 'universe_nodes=TX_028E81E2599FD8FB7E27, TX_52D31C01BD3CEBAB1B2F, TX_7A498A9E62688B83EBB5, TX_7A7A7D2F7914A526BC6E, TX_9D03A9449074EC8C7E33; 5 nodes are TEST BATCHES (Life & People, Roots D&E, F&G, H&I, Roots and Prefixes), not core types. Keep as batches or re-file under the two core types above — Rav to decide.'),
  ('V-VO-FIB-001', 'core_type', 'V-VO-FIB', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', 'Single Word Blank', NULL, NULL, 97, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V3 3A; universe_nodes=TX_FAE6E0C5DE267C124137, TX_82071801A275FF69DBD0; 18 live questions; "Vocabulary Builder|Fill Blanks" is the same thing.'),
  ('V-VO-FIB-002', 'core_type', 'V-VO-FIB', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', 'Collocation-Based Blank', NULL, NULL, 98, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V3 3B; universe_nodes=TX_6754781603168668C32A, TX_97333F8BE5E3C21271D4; 18 live questions; duplicated node.'),
  ('V-VO-FIB-003', 'core_type', 'V-VO-FIB', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', 'Register-Based Blank', NULL, NULL, 99, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V3 3C; universe_nodes=TX_362FC62717143950FF1B, TX_6F4E31F49F7CB4A1E9E6; 18 live questions; duplicated node.'),
  ('V-VO-FIB-004', 'core_type', 'V-VO-FIB', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', 'Single-Blank Contextual Vocabulary', NULL, NULL, 100, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Sentence Completion (One-Dimensional); universe_nodes=TX_E09D48931CE4231B275C'),
  ('V-VO-FIB-005', 'core_type', 'V-VO-FIB', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', 'Dual-Blank Semantic Logic', NULL, NULL, 101, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Sentence Completion (Two-Dimensional); universe_nodes=TX_D777BC8B02CDD2FA8A6B'),
  ('V-VO-FIB-006', 'core_type', 'V-VO-FIB', 'Vocabulary', 'Fill in the Blanks (Vocabulary)', 'Sentence Completion (NMAT)', NULL, NULL, 102, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Sentence Completion (NMAT); universe_nodes=TX_9FB3898F6D0928299FB5'),
  ('V-VO-CLZ-001', 'core_type', 'V-VO-CLZ', 'Vocabulary', 'Cloze', 'Single-Blank Cloze', NULL, NULL, 104, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=G10 10A; question_taxonomy=Verbal|Vocabulary|Cloze (One-Dimensional); universe_nodes=TX_818FEC7B04DD820944F6'),
  ('V-VO-CLZ-002', 'core_type', 'V-VO-CLZ', 'Vocabulary', 'Cloze', 'Cloze Tests (NMAT)', NULL, NULL, 105, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Cloze Tests (NMAT); universe_nodes=TX_EEF803EDAA9BA073102C'),
  ('V-VO-CTX-001', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Sentence-Based Contextual Meaning', NULL, NULL, 107, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V4 4B; question_taxonomy=Verbal|Vocabulary|Contextual Meaning (One-Dimensional); universe_nodes=TX_254C7F3505E216C5552C'),
  ('V-VO-CTX-002', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Meaning Across Contexts', NULL, NULL, 108, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Contextual Meaning (Two-Dimensional); universe_nodes=TX_41461B520AD21097DE93'),
  ('V-VO-CTX-003', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Multiple Usage Accuracy', NULL, NULL, 109, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V4 4A; question_taxonomy=Verbal|Vocabulary|Usage (Two-Dimensional); universe_nodes=TX_C96A0961189770CBC565'),
  ('V-VO-CTX-004', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Vocab Usage (NMAT)', NULL, NULL, 110, false, true, true, false, false, false, 'synonym', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|Vocab Usage (NMAT); universe_nodes=TX_F7417487E302EC14A6DF'),
  ('V-VO-CTX-005', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'One Word Fits Three Statements', NULL, NULL, 111, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Polysemy and Usage (Two-Dimensional); universe_nodes=TX_654FFCCA94AFA48C8E6F'),
  ('V-VO-CTX-006', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Count the Fitting Options', NULL, NULL, 112, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Sentence Compatibility (Two-Dimensional); universe_nodes=TX_EB5E039D3F36E61321E9'),
  ('V-VO-CTX-007', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Contextual Confusable Choice', NULL, NULL, 113, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=V4 4C; question_taxonomy=Verbal|Vocabulary|Confusables (One-Dimensional); universe_nodes=TX_BDBE709E8B0360E7C562'),
  ('V-VO-CTX-008', 'core_type', 'V-VO-CTX', 'Vocabulary', 'Contextual Meaning & Usage', 'Paragraph Inference plus Synonym', NULL, NULL, 114, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Reading Vocabulary (Two-Dimensional); universe_nodes=TX_6533326DF349B4A0305B; Crosses into RC — a vocabulary question on a paragraph.'),
  ('V-VO-WRL-001', 'core_type', 'V-VO-WRL', 'Vocabulary', 'Word Relationships', 'Odd One Out (words)', NULL, NULL, 116, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Semantic Classification (One-Dimensional); universe_nodes=TX_F2FA7CBE3B46DE79FB4E; NOT the paragraph Odd Man Out (V-PG-OMO). Same words, different question.'),
  ('V-VO-WRL-002', 'core_type', 'V-VO-WRL', 'Vocabulary', 'Word Relationships', 'Relationship Matrix / Odd Pair', NULL, NULL, 117, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Word Relationships (Two-Dimensional); universe_nodes=TX_D41ABD3502D22F791968'),
  ('V-VO-WRL-003', 'core_type', 'V-VO-WRL', 'Vocabulary', 'Word Relationships', 'Match the Following (Vocabulary)', NULL, NULL, 118, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Verbal|Vocabulary|Integrated Vocabulary (Two-Dimensional); universe_nodes=TX_3098B6B9FB48511E2172'),
  ('V-VO-HFW-001', 'core_type', 'V-VO-HFW', 'Vocabulary', 'High Frequency Words', 'High Frequency Words', NULL, NULL, 120, false, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'question_taxonomy=Language Skills|Vocabulary|High Frequency Words (NMAT); universe_nodes=TX_A79F3DD72CE0D2433950'),
  ('V-VO-UNT-001', 'core_type', 'V-VO-UNT', 'Vocabulary', 'Vocabulary (untyped)', 'Vocabulary (untyped)', NULL, NULL, 122, false, false, true, false, false, false, 'placeholder', false, 0, 0, NULL, 'universe_nodes=TX_525F163E2B8F7DA64ECA; lms_topics Vocabulary (MBA CET); 40 live questions carry topic=Vocabulary and no sub-type. Needs re-tagging, then this row retires.'),
  ('V-GR-SVA-001', 'core_type', 'V-GR-SVA', 'Grammar', 'Subject Verb Agreement', 'Subject Verb Agreement', NULL, NULL, 125, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=G3 3B; universe_nodes=TX_C93EABE27BB73C9DAF40, TX_171DF40A497AFFC03EF6; 25 live questions. Node TX_171DF40A497AFFC03EF6 has sub_section and topic SWAPPED ("Subject Verb Agreement|Grammar") — fix on migration.'),
  ('V-GR-SIP-001', 'core_type', 'V-GR-SIP', 'Grammar', 'Sentence Improvement', 'Sentence Improvement', NULL, NULL, 127, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=G1; question_taxonomy=Language Skills|Grammar|Sentence Improvement (NMAT); universe_nodes=TX_D6E1AF30B60E1E0C4B36'),
  ('V-GR-ERR-001', 'core_type', 'V-GR-ERR', 'Grammar', 'Spotting Error', 'Spotting Error', NULL, NULL, 129, true, true, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=G3; question_taxonomy=Language Skills|Grammar|Spotting Error (NMAT); universe_nodes=TX_0BA2D548031924FFF6ED; Hierarchy "Grammar & Usage|Sentence Correction & Errors" (proposed) maps here.'),
  ('V-GR-FOS-001', 'core_type', 'V-GR-FOS', 'Grammar', 'Figures of Speech', 'Figure of Speech', NULL, NULL, 131, true, false, true, false, false, false, 'exact', false, 0, 0, NULL, 'bible=G7; universe_nodes=TX_C0DE0A76188A1461DCB5; 1 test row.'),
  ('V-GR-VCE-001', 'core_type', 'V-GR-VCE', 'Grammar', 'Voice (Active–Passive)', 'Voice Conversion', NULL, NULL, 133, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=G4'),
  ('V-GR-SPH-001', 'core_type', 'V-GR-SPH', 'Grammar', 'Speech (Direct–Indirect)', 'Reported Speech', NULL, NULL, 135, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=G5'),
  ('V-GR-POS-001', 'core_type', 'V-GR-POS', 'Grammar', 'Parts of Speech & Modifiers', 'Parts of Speech Usage', NULL, NULL, 137, true, false, false, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=G6'),
  ('V-GR-GFB-001', 'core_type', 'V-GR-GFB', 'Grammar', 'Grammar Fill in the Blanks', 'Grammar-Function Fill (articles, modals, tags)', NULL, NULL, 139, true, false, true, false, false, false, 'bible_only', true, 0, 0, NULL, 'bible=G9; universe_nodes=(hierarchy Grammar & Usage|Fill in the Blanks & Cloze, proposed)'),
  ('V-GR-UNT-001', 'core_type', 'V-GR-UNT', 'Grammar', 'Grammar (untyped)', 'Grammar (untyped)', NULL, NULL, 141, false, false, true, false, false, false, 'placeholder', false, 0, 0, NULL, 'universe_nodes=TX_FA62EC71C6AF41C0EDEF; lms_topics Grammar (MBA CET); 12 live questions carry topic=Grammar and no sub-type. Hierarchy "Grammar & Usage|Grammar Rules" (proposed) sits here until re-tagged.'),
  ('V-GN-INT-001', 'core_type', 'V-GN-INT', 'Verbal General', 'Strategy & Intro', 'Verbal Strategy & Intro', NULL, NULL, 144, false, false, true, false, false, false, 'placeholder', false, 0, 0, NULL, 'universe_nodes=(hierarchy Verbal General|Strategy & Intro, proposed); Video/handout container, no questions.')
on conflict (core_id) do nothing;


-- ─── chapter roll-up view (mirrors quant_master_taxonomy_chapters) ──────────
create or replace view public.verbal_master_taxonomy_chapters as
select c.core_id                as chapter_id,
       c.subsection,
       c.chapter,
       c.mother_core_type,
       c.white_book_chapter,
       c.cat_questions_in_chapter,
       c.cat_pyq_in_core_type   as cat_pyq_in_chapter,
       count(t.core_id)                                             as core_types,
       count(t.core_id) filter (where t.match_status = 'exact')      as core_types_live,
       count(t.core_id) filter (where t.proposed_addition)           as core_types_proposed,
       c.status,
       c.sort_order
from public.verbal_master_taxonomy c
left join public.verbal_master_taxonomy t on t.parent_id = c.core_id and t.level = 'core_type'
where c.level = 'chapter'
group by c.core_id, c.subsection, c.chapter, c.mother_core_type, c.white_book_chapter,
         c.cat_questions_in_chapter, c.cat_pyq_in_core_type, c.status, c.sort_order
order by c.sort_order;

-- ─── STEP 4 · verify, then Control Room handover ────────────────────────────
-- Expected: 1 section · 8 subsections · 43 chapters · 92 core types = 144 rows.
do $$
declare n integer; c integer;
begin
  select count(*) into n from public.verbal_master_taxonomy;
  select count(*) into c from public.verbal_master_taxonomy where level='core_type';
  if n <> 144 or c <> 92 then
    raise exception 'Verbal master taxonomy load wrong: % rows (expected 144), % core types (expected 92)', n, c;
  end if;
  -- every non-root row must have a parent that exists
  select count(*) into n from public.verbal_master_taxonomy x
    where x.parent_id is not null
      and not exists (select 1 from public.verbal_master_taxonomy p where p.core_id = x.parent_id);
  if n > 0 then raise exception 'Verbal master taxonomy: % orphan rows', n; end if;
end $$;

insert into control_room.change_events (request_id, session_id, actor, event_kind, object_schema, object_name, operation, details)
select cr.id, cr.session_id, 'claude', 'schema_and_data', 'public', 'verbal_master_taxonomy', 'CREATE+INSERT',
  'Created table + view verbal_master_taxonomy_chapters. Loaded 144 rows (1 section, 8 subsections, 43 chapters, 92 core types). Verified counts and parent integrity in-transaction. All rows status=from_bible_unfrozen; 25 core types flagged proposed_addition for Rav. No existing object or row changed. Outstanding: (1) 424 actual-CAT RC rows in cat_import_questions still have no question_type, (2) 0 of 747 Verbal answers source-verified, (3) Verbal cat_question_id not assigned, (4) 4 Arena mappings still pending approval, (5) 10 open decisions listed in reference-bank/verbal/summary.md. Next: Rav freezes chapters, then backfill cat_import_questions.ck_subsection/ck_chapter from this table.'
from control_room.change_requests cr
where cr.title = 'Verbal master taxonomy: new table public.verbal_master_taxonomy + 144 rows'
order by cr.created_at desc limit 1;

update control_room.change_requests
   set status='completed', completed_at=now(),
       verification_notes='144 rows, 92 core types, no orphans — asserted inside the transaction.'
 where title = 'Verbal master taxonomy: new table public.verbal_master_taxonomy + 144 rows';

update control_room.sessions
   set status='finished', finished_at=now(), last_seen_at=now(),
       notes = coalesce(notes,'') || ' | Done: verbal_master_taxonomy created and loaded.'
 where actor='claude' and status='active';

commit;

-- ─── rollback, if ever needed ────────────────────────────────────────────────
-- drop view if exists public.verbal_master_taxonomy_chapters;
-- drop table if exists public.verbal_master_taxonomy;
