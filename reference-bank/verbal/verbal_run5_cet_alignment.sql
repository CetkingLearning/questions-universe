-- ===========================================================================
--  Cetking Verbal - RUN 5 : align the MBA CET Verbal questions to the taxonomy
--
--  Scope: all 998 MBA CET Verbal Ability questions
--    CET 2025 official  298
--    CET 2026 official  350
--    CET 2026 twins     350   (inherit their official's tags via source_question_id)
--
--  Two axes per question, exactly as agreed:
--    ck_core_id       concept  (verbal_master_taxonomy)
--    ck_question_type format   (verbal_question_type_registry)
--
--  Runs AFTER verbal_run4_grammar.sql - it needs the V-GR-* subchapters
--  and the QT registry. One transaction, all-or-nothing, self-asserting.
-- ===========================================================================

begin;

-- ---------------------------------------------------------------- preflight
do $$
declare n int;
begin
  if not exists (select 1 from information_schema.tables
                  where table_schema='public' and table_name='verbal_question_type_registry') then
    raise exception 'ABORT: run verbal_run4_grammar.sql first - the Question Type Registry does not exist.';
  end if;
  select count(*) into n from public.verbal_master_taxonomy where level='subtopic' and master_id like 'V-GR-%';
  if n <> 19 then raise exception 'ABORT: expected 19 Grammar subchapters, found %. Run run 4 first.', n; end if;
end $$;

-- -------------------------------------------- the new RC type Rav approved
insert into public.verbal_master_taxonomy
  (master_id, parent_id, level, name, section_id, subsection_id, subsection_name,
   chapter_id, chapter_name, core_type_id, core_type_no, core_type_name,
   sort_order, in_bible, match_status, status, source, rc_non, notes)
select 'V-RC-EVD-004','V-RC-EVD','core_type','Inference based','V','V-RC','Reading Comprehension',
       'V-RC-EVD','Evidence based','V-RC-EVD-004',4,'Inference based',
       coalesce((select max(sort_order) from public.verbal_master_taxonomy where chapter_id='V-RC-EVD'),0)+1,
       true,'rav_approved','rav_approved_15oct2026','cet_alignment_15oct2026','RC',
       'Added 15 Oct 2026 on Rav''s approval. 69 MBA CET inference questions had no home: Evidence based covered Truth&Facts / Why Mention This / Vocab, TSPM covered tone-scope-purpose-main-idea. CAT inference questions land here too.'
 where not exists (select 1 from public.verbal_master_taxonomy where master_id='V-RC-EVD-004');

-- ------------------------------------------------------------- link columns
alter table public.pyq_question_bank add column if not exists ck_core_id      text;
alter table public.pyq_question_bank add column if not exists ck_tag_level    text;
alter table public.pyq_question_bank add column if not exists ck_question_type text
  references public.verbal_question_type_registry(question_type_id);
alter table public.pyq_question_bank add column if not exists ck_tag_source   text;
create index if not exists pyq_question_bank_ck_core_id_idx on public.pyq_question_bank (ck_core_id);

-- =========================================================================
--  the mapping, kept as a table so you can read it, audit it and change it
--  '*' in arena_sub_topic means the whole arena_topic maps this way
-- =========================================================================
drop table if exists public.cet_verbal_tag_map;
create table public.cet_verbal_tag_map (
  arena_topic      text not null,
  arena_sub_topic  text not null,
  ck_core_id       text not null references public.verbal_master_taxonomy(master_id),
  ck_tag_level     text not null check (ck_tag_level in ('core_type','subtopic')),
  ck_question_type text references public.verbal_question_type_registry(question_type_id),
  needs_review     boolean not null default false,
  reason           text,
  primary key (arena_topic, arena_sub_topic)
);
comment on table public.cet_verbal_tag_map is
  'How each MBA CET Verbal (arena_topic, arena_sub_topic) maps onto the Cetking Verbal taxonomy. Edit a row and re-run the UPDATE below to re-tag. needs_review=true marks a judgement call Rav should check.';

insert into public.cet_verbal_tag_map
  (arena_topic, arena_sub_topic, ck_core_id, ck_tag_level, ck_question_type, needs_review, reason)
values
  ('Specific Detail', '*', 'V-RC-EVD-001', 'core_type', null, false, 'detail retrieval is evidence from the passage'),
  ('Inference', '*', 'V-RC-EVD-004', 'core_type', null, false, 'NEW type, approved by Rav 15 Oct: inference had no home'),
  ('Vocabulary in Context', '*', 'V-RC-EVD-003', 'core_type', null, false, 'exactly what Vocab Based Questions is for'),
  ('Main Idea', '*', 'V-RC-TSP-001', 'core_type', null, false, 'main idea'),
  ('Tone', '*', 'V-RC-TSP-004', 'core_type', null, false, 'tone'),
  ('TSPM', 'RC Title', 'V-RC-TSP-002', 'core_type', null, false, 'title'),
  ('TSPM', 'RC Primary Purpose', 'V-RC-TSP-006', 'core_type', null, false, 'purpose'),
  ('TSPM', 'RC Purpose of Analogy', 'V-RC-TSP-006', 'core_type', null, false, 'purpose'),
  ('TSPM', 'RC Purpose of Definition', 'V-RC-TSP-006', 'core_type', null, false, 'purpose'),
  ('TSPM', 'RC Purpose of Quote Marks', 'V-RC-EVD-002', 'core_type', null, false, 'this is precisely Why Mention This'),
  ('Para Jumbles', '5-Sentence Jumble', 'V-PG-JUM-002', 'core_type', null, false, '5 statements with options'),
  ('Para Jumbles', '5-Sentence Jumble Chronology', 'V-PG-JUM-002', 'core_type', null, false, '5 statements with options'),
  ('Para Jumbles', '5-Sentence Jumble Fixed Opener', 'V-PG-JUM-002', 'core_type', null, false, '5 statements with options'),
  ('Para Jumbles', '5-Sentence Story Jumble', 'V-PG-JUM-002', 'core_type', null, false, '5 statements with options'),
  ('Para Jumbles', '6-Sentence Jumble', 'V-PG-JUM-003', 'core_type', null, false, '6-7 statements'),
  ('Para Jumbles', '6-Sentence Jumble Fixed Opener', 'V-PG-JUM-003', 'core_type', null, false, '6-7 statements'),
  ('Para Jumbles', '7-Part Jumble Position', 'V-PG-JUM-003', 'core_type', null, false, '6-7 statements'),
  ('Para Jumbles', '4-Sentence Jumble', 'V-PG-JUM-002', 'core_type', null, true, 'FINDING: 4-statement jumble has NO type. Parked on 5-statement. Needs V-PG-JUM-004 or a rename.'),
  ('Para Jumbles', '4-Sentence Jumble (fixed ends)', 'V-PG-JUM-002', 'core_type', null, true, 'FINDING: 4-statement jumble has NO type. Parked on 5-statement. Needs V-PG-JUM-004 or a rename.'),
  ('Odd Man Out', 'Contradicting Sentence', 'V-PG-OMO-001', 'core_type', null, false, 'sentence odd-one-out'),
  ('Odd Man Out', 'Focus Shift Sentence', 'V-PG-OMO-001', 'core_type', null, false, 'sentence odd-one-out'),
  ('Odd Man Out', 'Odd Sentence Out', 'V-PG-OMO-001', 'core_type', null, false, 'sentence odd-one-out'),
  ('Odd Man Out', 'Tone Reversal Sentence', 'V-PG-OMO-001', 'core_type', null, false, 'sentence odd-one-out'),
  ('Odd Man Out', 'Letter Group Odd One', 'V-VO-MNR-SEM-001', 'core_type', null, true, 'FINDING: Slot 1 Q151 - a LETTER-GROUP odd-one-out, not a sentence one, and Arena files it under "Traditional Logic" inside Verbal Ability. master-taxonomy.csv warns word and sentence odd-one-out must never merge. Parked on the vocabulary Odd One Out; it may belong in the Logic universe instead.'),
  ('Sentence Rearrangement', 'Sentence Combination', 'V-PG-JOI-001', 'core_type', null, false, 'joining two sentences'),
  ('Sentence Rearrangement', '6-Sentence Position Question', 'V-PG-JUM-003', 'core_type', null, false, '6 statements'),
  ('Sentence Rearrangement', '4-Fragment Sentence Order', 'V-PG-JUM-002', 'core_type', null, true, 'same 4-statement gap as above'),
  ('Sentence Rearrangement', '4-Part Sentence Jumble', 'V-PG-JUM-002', 'core_type', null, true, 'same 4-statement gap as above'),
  ('Idioms & Phrases', 'Idiom Meaning', 'V-VO-IDM-USE-001', 'core_type', null, false, 'meaning / usage of a given idiom'),
  ('Idioms & Phrases', 'Common Idiom', 'V-VO-IDM-USE-001', 'core_type', null, false, 'meaning / usage of a given idiom'),
  ('Idioms & Phrases', 'Idiom Usage in Sentence', 'V-VO-IDM-USE-001', 'core_type', null, false, 'meaning / usage of a given idiom'),
  ('Idioms & Phrases', 'Business/Negotiation Idiom', 'V-VO-IDM-USE-001', 'core_type', null, false, 'meaning / usage of a given idiom'),
  ('Idioms & Phrases', 'Idiom Fit with Context', 'V-VO-IDM-COR-001', 'core_type', null, false, 'pick the idiom that fits'),
  ('Phrasal Verbs', '*', 'V-VO-IDM-USE-001', 'core_type', null, true, 'phrasal verbs filed as idiom usage - confirm you want them there and not a type of their own'),
  ('Antonym & Synonym', 'Synonym of Adjective', 'V-VO-MNR-SYN-001', 'core_type', null, false, 'direct synonym'),
  ('Antonym & Synonym', 'Synonym of Verb', 'V-VO-MNR-SYN-001', 'core_type', null, false, 'direct synonym'),
  ('Antonym & Synonym', 'Synonym of Noun', 'V-VO-MNR-SYN-001', 'core_type', null, false, 'direct synonym'),
  ('Antonym & Synonym', 'Synonym', 'V-VO-MNR-SYN-001', 'core_type', null, false, 'direct synonym'),
  ('Antonym & Synonym', 'Antonym of Adjective', 'V-VO-MNR-ANT-001', 'core_type', null, false, 'direct antonym'),
  ('Antonym & Synonym', 'Antonym of Noun', 'V-VO-MNR-ANT-001', 'core_type', null, false, 'direct antonym'),
  ('Antonym & Synonym', 'Antonym of Verb', 'V-VO-MNR-ANT-001', 'core_type', null, false, 'direct antonym'),
  ('Antonym & Synonym', 'Antonym', 'V-VO-MNR-ANT-001', 'core_type', null, false, 'direct antonym'),
  ('Antonym & Synonym', 'Synonym-Antonym Pair', 'V-VO-MNR-SYN-002', 'core_type', null, false, 'your 2D type gets its first real question'),
  ('Fill Blanks', '*', 'V-VO-CTX-SCO-001', 'core_type', 'QT06', false, 'vocabulary blank + the shared Fill in the Blanks format id'),
  ('Word Meaning', 'Nonsense Word in Context', 'V-VO-CTX-CTM-001', 'core_type', null, false, 'contextual meaning'),
  ('Word Meaning', 'Meaning in Context', 'V-VO-CTX-CTM-001', 'core_type', null, false, 'contextual meaning'),
  ('Word Meaning', 'Verb Meaning in Context', 'V-VO-CTX-CTM-001', 'core_type', null, false, 'contextual meaning'),
  ('Word Meaning', 'Phobia Names', 'V-VO-MNR-DEF-001', 'core_type', null, false, 'phobia/mania one-word substitution'),
  ('Roots & Prefixes', '*', 'V-VO-WSA-ROT-001', 'core_type', null, false, 'root meaning'),
  ('Cloze Test', '*', 'V-VO-CTX-CLZ-001', 'core_type', null, true, 'cloze is a FORMAT too - open question whether you want QT07 Cloze in the registry'),
  ('One-Word Substitution', '*', 'V-VO-MNR-DEF-001', 'core_type', null, false, 'definition to word'),
  ('Sentence Completion', '*', 'V-VO-CTX-SCO-001', 'core_type', null, false, 'Arena files it under Vocabulary Usage, so the vocabulary kind, not V-PG-COM'),
  ('Spelling', '*', 'V-VO-WSA-SPL-001', 'core_type', null, false, 'spelling recognition'),
  ('Usage', '*', 'V-VO-CTX-USG-001', 'core_type', null, false, 'confusable / correct usage'),
  ('Analogy (Word)', 'Antonym Pair Analogy', 'V-VO-MNR-SEM-002', 'core_type', null, false, 'word relationship'),
  ('Analogy (Word)', 'Inferior Work : Creator', 'V-VO-MNR-SEM-002', 'core_type', null, false, 'word relationship'),
  ('Analogy (Word)', 'Type : Category', 'V-VO-MNR-SEM-002', 'core_type', null, false, 'word relationship'),
  ('Analogy (Word)', 'Homophone Pair', 'V-VO-CTX-USG-001', 'core_type', null, false, 'homophones are confusables'),
  ('Direct Indirect', '*', 'V-GR-SPT-DIS', 'subtopic', null, false, 'direct-indirect speech'),
  ('Tenses', '*', 'V-GR-VRB-TNS', 'subtopic', null, false, 'tenses'),
  ('Subject Verb Agreement', '*', 'V-GR-VRB-SVA', 'subtopic', null, false, 'SVA'),
  ('Prepositions', '*', 'V-GR-USG-PRP', 'subtopic', null, false, 'prepositions'),
  ('Active Passive', '*', 'V-GR-SPT-VCE', 'subtopic', null, false, 'active-passive voice'),
  ('Articles', '*', 'V-GR-USG-ART', 'subtopic', null, false, 'articles and determiners'),
  ('Figures of Speech', '*', 'V-GR-SPT-FOS', 'subtopic', null, false, 'the only Bible-less subchapter that CET actually tests'),
  ('Spotting Error', 'Adjective vs Adverb', 'V-GR-DSC-ADV', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Article Error', 'V-GR-USG-ART', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Article Error in Idiom', 'V-GR-USG-ART', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Conditional Tense Error', 'V-GR-VRB-CND', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Correct Sentence Conjunction', 'V-GR-USG-CNJ', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Correlative Conjunctions', 'V-GR-USG-CNJ', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Fixed Conjunction Error', 'V-GR-USG-CNJ', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Double Comparative', 'V-GR-DSC-CMP', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Missing Preposition', 'V-GR-USG-PRP', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Preposition Error', 'V-GR-USG-PRP', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Phrasal Verb Preposition', 'V-GR-USG-PRP', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Superfluous Preposition', 'V-GR-USG-PRP', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'One of + Plural Noun', 'V-GR-VRB-SVA', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'One of the + Plural', 'V-GR-VRB-SVA', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Subject Verb Agreement', 'V-GR-VRB-SVA', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Subject-Verb Agreement', 'V-GR-VRB-SVA', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Participle Phrase No Error', 'V-GR-VRB-INF', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Pronoun Ambiguity', 'V-GR-STR-PRN', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Relative Pronoun Error', 'V-GR-STR-PRN', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'That vs What', 'V-GR-STR-PRN', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Phrase Misuse', 'V-GR-USG-CCW', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Wrong Word Form', 'V-GR-USG-CCW', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Wrong Word Usage', 'V-GR-USG-CCW', 'subtopic', 'QT04', false, 'error spotting format, concept from the subtopic'),
  ('Spotting Error', 'Idiom and Tense Error', 'V-GR-VRB-TNS', 'subtopic', 'QT04', true, 'mixed idiom+tense error, filed on tense'),
  ('Spotting Error', 'Redundancy Error', 'V-GR-STR-NEG', 'subtopic', 'QT04', true, 'FINDING: no Redundancy subchapter in your 19; filed under Construction Rules'),
  ('Spotting Error', 'Spelling Error', 'V-VO-WSA-SPL-001', 'core_type', 'QT04', true, 'FINDING: spelling is not one of your 19 grammar subchapters, so this maps into VOCABULARY'),
  ('Spotting Error', 'Spelling Context Error', 'V-VO-WSA-SPL-001', 'core_type', 'QT04', true, 'FINDING: same - grammar format, vocabulary concept'),
  ('Spotting Error', 'Correct Sentence Selection', 'V-GR-UNT-001', 'core_type', 'QT04', true, 'generic "pick the correct sentence" - no single concept'),
  ('Spotting Error', 'No Error Sentence', 'V-GR-UNT-001', 'core_type', 'QT04', true, 'generic - no single concept'),
  ('Spotting Error', 'Multi-Sentence Correctness', 'V-GR-UNT-001', 'core_type', 'QT02', true, 'generic, and the FORMAT is QT02 not QT04'),
  ('Spotting Error', 'Pick Correct Sentences', 'V-GR-UNT-001', 'core_type', 'QT02', true, 'generic, and the FORMAT is QT02 not QT04'),
  ('Sentence Improvement', 'Ambiguous Comparison', 'V-GR-DSC-CMP', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Faulty Comparison', 'V-GR-DSC-CMP', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Collocation', 'V-GR-USG-CCW', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Conditional Inversion', 'V-GR-VRB-CND', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Dangling Modifier', 'V-GR-STR-MOD', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Dangling Participle', 'V-GR-STR-MOD', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Gerund after Preposition', 'V-GR-VRB-INF', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Infinitive after Force', 'V-GR-VRB-INF', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Infinitive vs Gerund', 'V-GR-VRB-INF', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Participle Usage', 'V-GR-VRB-INF', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Hardly When Inversion', 'V-GR-STR-NEG', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Hardly… When', 'V-GR-STR-NEG', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'No Sooner Than Inversion', 'V-GR-STR-NEG', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Order of Adjectives', 'V-GR-DSC-ADJ', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Parallelism', 'V-GR-STR-PAR', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Preposition Usage', 'V-GR-USG-PRP', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Preposition with Adjective', 'V-GR-USG-PRP', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Pronoun Consistency', 'V-GR-STR-PRN', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Who vs Whom', 'V-GR-STR-PRN', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Reporting Verb Usage', 'V-GR-SPT-DIS', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Sequence of Tenses', 'V-GR-VRB-TNS', 'subtopic', 'QT01', false, 'sentence improvement format, concept from the subtopic'),
  ('Sentence Improvement', 'Idiom Correction', 'V-VO-IDM-COR-001', 'core_type', 'QT01', true, 'FINDING: grammar format, IDIOM concept - the two axes earning their keep'),
  ('Sentence Improvement', 'Idiomatic Phrase', 'V-VO-IDM-USE-001', 'core_type', 'QT01', true, 'FINDING: grammar format, idiom concept'),
  ('Sentence Improvement', 'Choose Correct Sentence', 'V-GR-UNT-001', 'core_type', 'QT01', true, 'generic - no single concept'),
  ('Sentence Improvement', 'Correct Word Retained', 'V-GR-UNT-001', 'core_type', 'QT01', true, 'generic - no single concept'),
  ('Sentence Improvement', 'No Correction Needed', 'V-GR-UNT-001', 'core_type', 'QT01', true, 'generic - no single concept');

-- =========================================================================
--  PART A - tag the 648 officials from the map
-- =========================================================================
update public.pyq_question_bank p
   set ck_core_id = mp.ck_core_id,
       ck_tag_level = mp.ck_tag_level,
       ck_question_type = coalesce(mp.ck_question_type, p.ck_question_type),
       ck_tag_source = 'cet_verbal_align_15oct2026'
  from public.cet_verbal_tag_map mp
 where p.exam='MBA CET' and p.section='Verbal Ability'
   and (p.tags is null or p.tags not ilike '%twin%')
   and p.arena_topic = mp.arena_topic
   and (mp.arena_sub_topic = '*' or mp.arena_sub_topic = p.arena_sub_topic)
   and not (mp.arena_sub_topic = '*' and exists (
         select 1 from public.cet_verbal_tag_map x
          where x.arena_topic = p.arena_topic and x.arena_sub_topic = p.arena_sub_topic));

-- =========================================================================
--  PART B - propagate to the 350 twins from their official
--  A twin is the same question type and difficulty with values changed, so
--  it must carry the same tags. Joined on source_question_id = 'T'||official.
-- =========================================================================
update public.pyq_question_bank t
   set ck_core_id = o.ck_core_id,
       ck_tag_level = o.ck_tag_level,
       ck_question_type = o.ck_question_type,
       ck_tag_source = 'cet_verbal_align_15oct2026_twin'
  from public.pyq_question_bank o
 where t.exam='MBA CET' and t.section='Verbal Ability' and t.tags ilike '%twin%'
   and o.exam='MBA CET' and o.section='Verbal Ability'
   and (o.tags is null or o.tags not ilike '%twin%')
   and o.source_question_id = substring(t.source_question_id from 2)
   and o.ck_core_id is not null;

-- ------------------------------------------------------------- assertions
do $$
declare n int; bad text;
begin
  select count(*) into n from public.pyq_question_bank
   where exam='MBA CET' and section='Verbal Ability' and ck_core_id is null;
  if n > 0 then raise exception 'ABORT: % CET Verbal questions left untagged.', n; end if;

  select count(*) into n from public.pyq_question_bank
   where exam='MBA CET' and section='Verbal Ability' and ck_tag_source like 'cet_verbal_align_15oct2026%';
  if n <> 998 then raise exception 'ABORT: tagged %, expected 998.', n; end if;

  select count(*) into n from public.pyq_question_bank
   where exam='MBA CET' and section='Verbal Ability' and tags ilike '%twin%' and ck_core_id is not null;
  if n <> 350 then raise exception 'ABORT: % twins tagged, expected 350.', n; end if;

  -- every tag resolves at the level it claims
  select string_agg(distinct ck_core_id||'/'||ck_tag_level, ', ') into bad
    from public.pyq_question_bank p
   where p.exam='MBA CET' and p.section='Verbal Ability' and p.ck_core_id is not null
     and not exists (select 1 from public.verbal_master_taxonomy t
                      where t.master_id=p.ck_core_id and t.level=p.ck_tag_level);
  if bad is not null then raise exception 'ABORT: tags not resolving at their level: %', bad; end if;

  -- a twin must always agree with its official
  select count(*) into n from public.pyq_question_bank t
    join public.pyq_question_bank o
      on o.source_question_id = substring(t.source_question_id from 2)
     and o.exam='MBA CET' and o.section='Verbal Ability'
     and (o.tags is null or o.tags not ilike '%twin%')
   where t.exam='MBA CET' and t.section='Verbal Ability' and t.tags ilike '%twin%'
     and (t.ck_core_id is distinct from o.ck_core_id
       or t.ck_question_type is distinct from o.ck_question_type);
  if n > 0 then raise exception 'ABORT: % twins disagree with their official.', n; end if;
end $$;

-- ---------------------------------------------------------- what you will see
select coalesce(s.name,'(?)') as subsection, p.ck_core_id,
       coalesce(t.name,'(?)') as type_name,
       count(*) as questions,
       count(*) filter (where p.year=2025) as cet25,
       count(*) filter (where p.year=2026 and p.tags not ilike '%twin%') as cet26,
       count(*) filter (where p.tags ilike '%twin%') as twins
  from public.pyq_question_bank p
  left join public.verbal_master_taxonomy t on t.master_id = p.ck_core_id
  left join public.verbal_master_taxonomy s on s.master_id = t.subsection_id and s.level='subsection'
 where p.exam='MBA CET' and p.section='Verbal Ability'
 group by 1,2,3 order by 1, questions desc;

commit;

-- ---------------------------------------------------------------------- undo
-- update public.pyq_question_bank set ck_core_id=null, ck_tag_level=null,
--        ck_question_type=null, ck_tag_source=null where ck_tag_source like 'cet_verbal_align_15oct2026%';
-- drop table if exists public.cet_verbal_tag_map;
-- delete from public.verbal_master_taxonomy where master_id='V-RC-EVD-004';
