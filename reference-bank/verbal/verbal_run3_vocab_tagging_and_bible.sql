-- ===========================================================================
--  Cetking Verbal — RUN 3
--  (a) tag the 246 live Vocabulary questions onto the new question types
--  (b) store Rav's Idioms Bible sample questions, flagged BIBLE-ONLY
--  Built 15 Oct 2026.  Runs AFTER verbal_master_taxonomy_RESHAPE_rc.sql.
--  One transaction, all-or-nothing, self-asserting.
-- ===========================================================================

begin;

-- ---------------------------------------------------------------- preflight
do $$
declare n int;
begin
  select count(*) into n from public.verbal_master_taxonomy
   where level = 'core_type' and master_id like 'V-VO-%';
  if n <> 23 then
    raise exception 'ABORT: expected 23 Vocabulary core types, found %. Run verbal_master_taxonomy_RESHAPE_rc.sql first.', n;
  end if;
end $$;

-- =========================================================================
--  PART A — tag the live Vocabulary questions
-- =========================================================================

alter table public.questions add column if not exists ck_core_id    text;
alter table public.questions add column if not exists ck_tag_source text;

comment on column public.questions.ck_core_id is
  'Cetking master taxonomy core-type id (verbal_master_taxonomy.master_id / quant_master_taxonomy.master_id).';
comment on column public.questions.ck_tag_source is
  'Which tagging run set ck_core_id, so a run can be undone on its own.';

create index if not exists questions_ck_core_id_idx on public.questions (ck_core_id);

-- V-VO-CTX-SCO-001  <-  Vocabulary | Fill in the Blanks  (54 questions)
update public.questions
   set ck_core_id = 'V-VO-CTX-SCO-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary'
   and topic_name       = 'Fill in the Blanks'
   and sub_topic_name in ('Single Word Blank', 'Collocation-Based Blank', 'Register-Based Blank');

-- V-VO-IDM-USE-001  <-  Vocabulary | Idioms & Phrases  (18 questions)
update public.questions
   set ck_core_id = 'V-VO-IDM-USE-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary'
   and topic_name       = 'Idioms & Phrases'
   and sub_topic_name in ('Idiom Meaning (Usage)');

-- V-VO-IDM-IDN-001  <-  Vocabulary | Idioms & Phrases  (18 questions)
update public.questions
   set ck_core_id = 'V-VO-IDM-IDN-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary'
   and topic_name       = 'Idioms & Phrases'
   and sub_topic_name in ('Idiom Identification (Definition to Idiom)');

-- V-VO-IDM-COR-001  <-  Vocabulary | Idioms & Phrases  (18 questions)
update public.questions
   set ck_core_id = 'V-VO-IDM-COR-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary'
   and topic_name       = 'Idioms & Phrases'
   and sub_topic_name in ('Correct Idiom in Context');

-- V-VO-MNR-DEF-001  <-  Vocabulary | One-Word Substitution  (54 questions)
update public.questions
   set ck_core_id = 'V-VO-MNR-DEF-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary'
   and topic_name       = 'One-Word Substitution'
   and sub_topic_name in ('Person-Descriptors', 'Action/Process Descriptors', 'Abstract Concept Descriptors');

-- V-VO-WSA-SPL-001  <-  Vocabulary | Spelling  (36 questions)
update public.questions
   set ck_core_id = 'V-VO-WSA-SPL-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary'
   and topic_name       = 'Spelling'
   and sub_topic_name in ('5A Standard Spelling Correction', '5B Commonly Confused Spellings');

-- V-VO-WSA-ROT-001  <-  Vocabulary Builder | Roots & Prefixes  (48 questions)
update public.questions
   set ck_core_id = 'V-VO-WSA-ROT-001', ck_tag_source = 'vocab_tagging_15oct2026'
 where sub_section_name = 'Vocabulary Builder'
   and topic_name       = 'Roots & Prefixes'
   and sub_topic_name in ('Life & People', 'Roots D & E', 'Roots F & G', 'Roots H & I');

-- ------------------------------------------------------------- assertions A
do $$
declare n int; bad text;
begin
  -- 1. exactly 246 tagged by this run
  select count(*) into n from public.questions where ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 246 then
    raise exception 'ABORT: tagged % questions, expected 246.', n;
  end if;

  -- 2. no Vocabulary question left untagged
  select count(*) into n from public.questions
   where sub_section_name in ('Vocabulary','Vocabulary Builder') and ck_core_id is null;
  if n > 0 then
    raise exception 'ABORT: % Vocabulary questions left untagged.', n;
  end if;

  -- 3. every id written points at a real core type
  select string_agg(distinct ck_core_id, ', ') into bad from public.questions q
   where q.ck_tag_source = 'vocab_tagging_15oct2026'
     and not exists (select 1 from public.verbal_master_taxonomy t
                      where t.master_id = q.ck_core_id and t.level = 'core_type');
  if bad is not null then
    raise exception 'ABORT: core ids not in the taxonomy: %', bad;
  end if;

  -- 4. per-core-type counts are exactly as planned
  select count(*) into n from public.questions where ck_core_id = 'V-VO-CTX-SCO-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 54 then raise exception 'ABORT: V-VO-CTX-SCO-001 got %, expected 54.', n; end if;
  select count(*) into n from public.questions where ck_core_id = 'V-VO-IDM-USE-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 18 then raise exception 'ABORT: V-VO-IDM-USE-001 got %, expected 18.', n; end if;
  select count(*) into n from public.questions where ck_core_id = 'V-VO-IDM-IDN-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 18 then raise exception 'ABORT: V-VO-IDM-IDN-001 got %, expected 18.', n; end if;
  select count(*) into n from public.questions where ck_core_id = 'V-VO-IDM-COR-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 18 then raise exception 'ABORT: V-VO-IDM-COR-001 got %, expected 18.', n; end if;
  select count(*) into n from public.questions where ck_core_id = 'V-VO-MNR-DEF-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 54 then raise exception 'ABORT: V-VO-MNR-DEF-001 got %, expected 54.', n; end if;
  select count(*) into n from public.questions where ck_core_id = 'V-VO-WSA-SPL-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 36 then raise exception 'ABORT: V-VO-WSA-SPL-001 got %, expected 36.', n; end if;
  select count(*) into n from public.questions where ck_core_id = 'V-VO-WSA-ROT-001'
     and ck_tag_source = 'vocab_tagging_15oct2026';
  if n <> 48 then raise exception 'ABORT: V-VO-WSA-ROT-001 got %, expected 48.', n; end if;
end $$;

-- =========================================================================
--  PART B — Rav's Idioms Bible sample, BIBLE-ONLY
--
--  His instruction, verbatim: "Do not use this sample anywhere ... mark them
--  they are only for the Bible. These questions are only used for the Bible.
--  Part of the cetking verbal Bible book."
--
--  Kept in its own table rather than question_bank/questions so it CANNOT be
--  picked up by any live query. question_bank is 4-option anyway; these are 5.
-- =========================================================================

create table if not exists public.verbal_bible_questions (
  id              uuid primary key default gen_random_uuid(),
  bible_code      text not null unique,
  ck_core_id      text not null references public.verbal_master_taxonomy(master_id),
  subsection_name text not null,
  chapter_name    text not null,
  subtopic_name   text not null,
  q_no            int  not null,
  question_text   text not null,
  options         jsonb not null,
  correct_option  text not null,
  explanation     text,
  difficulty      text,
  source_type     text not null default 'verbal_bible_sample',
  bible_only      boolean not null default true,
  status          text not null default 'bible_only',
  notes           text,
  created_at      timestamptz not null default now(),
  constraint verbal_bible_questions_bible_only_chk check (bible_only is true),
  constraint verbal_bible_questions_status_chk     check (status = 'bible_only')
);

comment on table public.verbal_bible_questions is
  'Cetking Verbal Bible book reference questions ONLY. Rav: "Do not use this sample anywhere." Never serve these as live CAT/practice content; they exist to seed similar questions later. The bible_only and status CHECKs make the restriction structural.';

create index if not exists verbal_bible_questions_core_idx
  on public.verbal_bible_questions (ck_core_id);

-- reload idempotently: this run owns every 'verbal_bible_sample' row
delete from public.verbal_bible_questions where source_type = 'verbal_bible_sample';

insert into public.verbal_bible_questions
  (bible_code, ck_core_id, subsection_name, chapter_name, subtopic_name,
   q_no, question_text, options, correct_option, explanation, notes)
values
  ('VBIB-IDM-USE-001', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 1, 'After weeks of negotiation, the lawyer decided to play hardball to get a better settlement.',
   '{"A": "The lawyer used aggressive tactics", "B": "The lawyer was being lenient", "C": "The lawyer avoided confrontation", "D": "The lawyer postponed the negotiation", "E": "The lawyer revealed all secrets"}'::jsonb, 'A', '“Play hardball” means to use aggressive, uncompromising, or forceful tactics to achieve a desired result.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-USE-002', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 2, 'He tried to beat around the bush instead of giving a straight answer to the manager’s question.',
   '{"A": "He avoided giving a direct answer", "B": "He gave a clear and direct answer", "C": "He played aggressively", "D": "He revealed a secret", "E": "He made a reckless decision"}'::jsonb, 'A', '“Beat around the bush” means to avoid giving a direct answer or to evade the main point of a discussion.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-USE-003', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 3, 'The manager asked the team to pull their socks up before the deadline.',
   '{"A": "work harder", "B": "relax", "C": "slow down", "D": "take a break", "E": "quit"}'::jsonb, 'A', '“Pull one''s socks up” means to make a greater effort, work harder, or improve one''s performance.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-USE-004', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 4, 'During the debate, he decided to take the bull by the horns and address the controversial issue directly.',
   '{"A": "avoid the issue", "B": "confront the issue boldly", "C": "complain about the issue", "D": "delay taking action", "E": "ignore the problem"}'::jsonb, 'B', '“Take the bull by the horns” means to confront a difficult or controversial situation boldly and directly.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-USE-005', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 5, 'The CEO warned the staff not to rest on their laurels after the successful project.',
   '{"A": "avoid becoming complacent", "B": "stop working immediately", "C": "criticize the team''s success", "D": "compete with others", "E": "boast about achievements"}'::jsonb, 'A', '“Rest on one''s laurels” means to become complacent because of past success instead of continuing to make an effort.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-USE-006', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 6, 'Online scams can appear harmless at first but may be wolves in sheep''s clothing, concealing malicious intentions.',
   '{"A": "funny", "B": "sensitive", "C": "strange", "D": "quarrelsome", "E": "imposter"}'::jsonb, 'E', '“Wolf in sheep''s clothing” describes a person who appears harmless or friendly but conceals malicious or harmful intentions. Among the given options, “imposter” is the closest match.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-USE-007', 'V-VO-IDM-USE-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Usage', 7, 'The CEO''s claim that the crisis would resolve itself was dismissed as whistling in the dark.',
   '{"A": "Making optimistic predictions based on data", "B": "Expressing confidence to motivate others", "C": "Pretending confidence to hide fear or uncertainty", "D": "Taking a bold stand despite opposition", "E": "Offering reassurance grounded in experience"}'::jsonb, 'C', '“Whistling in the dark” means pretending to be confident or optimistic in order to hide fear, anxiety, or uncertainty.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-001', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 1, 'To stave off starvation',
   '{"A": "To prevent or ward off starvation", "B": "To turn pale", "C": "To cry wolf", "D": "To give false alarm", "E": "Do nothing"}'::jsonb, 'A', '“Stave off” means to ward off, prevent, or keep something undesirable away. Therefore, “to stave off starvation” means to keep starvation away.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-002', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 2, 'To throw down the gauntlet',
   '{"A": "To issue a challenge", "B": "To raise objections", "C": "To be discussed", "D": "To put someone at ease", "E": "None of these"}'::jsonb, 'A', '“Throw down the gauntlet” means to issue a challenge, especially a direct or formal challenge.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-003', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 3, 'To smell a rat',
   '{"A": "To see signs of plague epidemic", "B": "To get bad smell of a dead rat", "C": "To suspect foul dealings", "D": "To be in a bad mood", "E": "To teach someone a lesson"}'::jsonb, 'C', '“Smell a rat” means to suspect that something dishonest, suspicious, or deceptive is taking place.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-004', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 4, 'To hit the nail right on the head',
   '{"A": "To identify or express something exactly", "B": "To destroy one''s reputation", "C": "To announce one''s fixed views", "D": "To look at one steadily", "E": "To judge by appearance"}'::jsonb, 'A', '“Hit the nail right on the head” means to identify or express something with complete accuracy or to do exactly the right thing.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-005', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 5, '“Play the devil’s advocate”',
   '{"A": "To argue that something bad is coming, even though it’s calm right now", "B": "To hear news of something that is a secret", "C": "To follow a trend, and do what everyone else is doing", "D": "To defend the guilty person by arguing on his behalf", "E": "To argue the opposite of what you believe, just for the sake of argument"}'::jsonb, 'E', '“Play the devil’s advocate” means to argue against an idea or take an opposing position, often simply to test the strength of an argument.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-006', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 6, '“Break the ice”',
   '{"A": "To start a fight", "B": "To solve a difficult problem", "C": "To clear misunderstanding", "D": "To clear the ice on the road", "E": "To overcome social awkwardness"}'::jsonb, 'E', '“Break the ice” means to overcome initial social awkwardness or tension and make people feel more comfortable.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-007', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 7, '“Throw in the towel”',
   '{"A": "To surrender to temptation", "B": "To accept defeat", "C": "To give up a job", "D": "To make a sacrifice", "E": "To throw the towel to someone"}'::jsonb, 'B', '“Throw in the towel” means to give up, surrender, or accept defeat.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-008', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 8, '''Above board'' is:',
   '{"A": "Secretive", "B": "Dishonest", "C": "Honest", "D": "Careless", "E": "Confusing"}'::jsonb, 'C', '“Above board” means completely honest, open, and transparent, with nothing hidden or deceptive.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-009', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 9, 'A hornet''s nest.',
   '{"A": "a comfortable position", "B": "an difficult situation", "C": "among roses", "D": "a dilemma", "E": "keeping the peace"}'::jsonb, 'B', '“A hornet''s nest” refers to a troublesome, controversial, or difficult situation that may create considerable difficulty.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-010', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 10, 'Will o'' the wisp',
   '{"A": "Something elusive or deceptive", "B": "To act in a childish way", "C": "To act in a foolish way", "D": "To have desires unbacked by efforts", "E": "Verity"}'::jsonb, 'A', '“Will o'' the wisp” refers to something that is elusive, deceptive, or difficult or impossible to attain.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-011', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 11, 'Adam''s ale',
   '{"A": "Grace", "B": "Pleasure", "C": "Water", "D": "Juice", "E": "Brew"}'::jsonb, 'C', '“Adam''s ale” is an old idiomatic expression referring to plain water.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-IDN-012', 'V-VO-IDM-IDN-001', 'Vocabulary', 'Idioms and Phrases',
   'Idiom Identification', 12, 'French leave',
   '{"A": "Long absence", "B": "Leave on the pretext of illness", "C": "Causal leave", "D": "Absence without permission", "E": "Holiday"}'::jsonb, 'D', '“French leave” means leaving a place without permission or without informing the appropriate authority.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-COR-001', 'V-VO-IDM-COR-001', 'Vocabulary', 'Idioms and Phrases',
   'Correct Idiom', 1, '',
   '{"A": "Despite criticism, he decided to cross the Rubicon and launch his startup", "B": "Despite criticism, he decided to kick the bucket and launch his startup", "C": "Despite criticism, he decided to spill the beans and launch his startup", "D": "Despite criticism, he decided to break the ice and launch his startup", "E": "Despite criticism, he decided to beat around the bush and launch his startup"}'::jsonb, 'A', '"Cross the Rubicon" means to take a decisive step beyond which there is no turning back, fitting the decision to launch a startup.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-COR-002', 'V-VO-IDM-COR-001', 'Vocabulary', 'Idioms and Phrases',
   'Correct Idiom', 2, '',
   '{"A": "The committee tried to sweep the issue under the carpet by appointing an independent inquiry", "B": "The committee tried to sweep the issue under the carpet by openly addressing it in public", "C": "The committee tried to sweep the issue under the carpet by refusing to address it", "D": "The committee tried to sweep the issue under the carpet by exposing the corruption", "E": "The committee tried to sweep the issue under the carpet by bringing media attention to it"}'::jsonb, 'C', '"Sweep under the carpet" means to conceal, ignore, or avoid dealing with a problem, ignoring the issue completely.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-COR-003', 'V-VO-IDM-COR-001', 'Vocabulary', 'Idioms and Phrases',
   'Correct Idiom', 3, '',
   '{"A": "She decided to bite the bullet and accept the challenging assignment", "B": "She decided to bite the dust and accept the challenging assignment", "C": "She decided to hit the nail and accept the challenging assignment", "D": "She decided to break the ice and accept the challenging assignment", "E": "She decided to let the cat out of the bag and accept the challenging assignment"}'::jsonb, 'A', '"Bite the bullet" means to endure a painful or difficult situation that is seen as unavoidable',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content'),
  ('VBIB-IDM-COR-004', 'V-VO-IDM-COR-001', 'Vocabulary', 'Idioms and Phrases',
   'Correct Idiom', 4, '',
   '{"A": "She decided to hit the sack and finish the project on time", "B": "She decided to burn the midnight oil and finish the project on time", "C": "She decided to spill the beans and finish the project on time", "D": "She decided to bark up the wrong tree and finish the project on time", "E": "She decided to blow off steam and finish the project on time"}'::jsonb, 'B', '"Burn the midnight oil" means to work or study late into the night, which logically fits working late to complete a project on time.',
   'Rav sample, 15 Oct 2026 — Bible book only, never live content');

-- ------------------------------------------------------------- assertions B
do $$
declare n int;
begin
  select count(*) into n from public.verbal_bible_questions
   where source_type = 'verbal_bible_sample';
  if n <> 23 then raise exception 'ABORT: inserted % Bible rows, expected 23.', n; end if;

  select count(*) into n from public.verbal_bible_questions where ck_core_id = 'V-VO-IDM-USE-001';
  if n <> 7 then raise exception 'ABORT: V-VO-IDM-USE-001 got % Bible rows, expected 7.', n; end if;
  select count(*) into n from public.verbal_bible_questions where ck_core_id = 'V-VO-IDM-IDN-001';
  if n <> 12 then raise exception 'ABORT: V-VO-IDM-IDN-001 got % Bible rows, expected 12.', n; end if;
  select count(*) into n from public.verbal_bible_questions where ck_core_id = 'V-VO-IDM-COR-001';
  if n <> 4 then raise exception 'ABORT: V-VO-IDM-COR-001 got % Bible rows, expected 4.', n; end if;

  -- every row has 5 options and an answer that is one of them
  select count(*) into n from public.verbal_bible_questions
   where jsonb_typeof(options) <> 'object' or (select count(*) from jsonb_object_keys(options)) <> 5
      or not (options ? correct_option);
  if n > 0 then raise exception 'ABORT: % Bible rows have bad options/answer.', n; end if;
end $$;

-- ---------------------------------------------------------- what you will see
select 'A. live Vocabulary questions tagged' as step,
       count(*)::text as result
  from public.questions where ck_tag_source = 'vocab_tagging_15oct2026'
union all
select 'B. Bible-only sample questions stored', count(*)::text
  from public.verbal_bible_questions where source_type = 'verbal_bible_sample';

commit;

-- ---------------------------------------------------------------------- undo
-- update public.questions set ck_core_id=null, ck_tag_source=null
--  where ck_tag_source = 'vocab_tagging_15oct2026';
-- drop table if exists public.verbal_bible_questions;
