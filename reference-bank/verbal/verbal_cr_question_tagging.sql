-- ============================================================================
-- Cetking Universe — VERBAL CRITICAL REASONING: map every CR question to the
-- 7 chapters × 2 core types (Rav, 15 Oct 2026).
--
-- Rule, applied by the data and not by hand:
--   a CR question that sits on a passage  -> that chapter's "Passage based"  (-002)
--   a CR question with no passage         -> that chapter's "Single Statements" (-001)
--
-- Additive: adds ck_core_id + ck_tag_source to the two question tables and
-- fills them for CR rows only. No answer, type, passage or existing column is
-- touched. Run AFTER verbal_master_taxonomy.sql.
-- ============================================================================

begin;

-- ─── columns (additive, idempotent) ─────────────────────────────────────────
alter table public.cat_import_questions      add column if not exists ck_core_id     text;
alter table public.cat_import_questions      add column if not exists ck_tag_source  text;
alter table public.cat_verbal_pyq_questions  add column if not exists ck_core_id     text;
alter table public.cat_verbal_pyq_questions  add column if not exists ck_tag_source  text;

comment on column public.cat_import_questions.ck_core_id is
  'Core type in the section master taxonomy (e.g. V-CR-INF-002). Additive key; question_type / shortcut / g_strategy_official keep their raw source labels.';
comment on column public.cat_verbal_pyq_questions.ck_core_id is
  'Core type in verbal_master_taxonomy (e.g. V-CR-INF-002).';

-- ─── 1 · the 506-row Verbal master: CR section ──────────────────────────────
-- 188 rows: Inference 98, Cause Effect Reasoning 44, Weakening Strengthening 34, Similarity 12.
update public.cat_verbal_pyq_questions q
   set ck_core_id = 'V-CR-' || m.code || '-' ||
                    case when coalesce(q.passage,'') <> '' then '002' else '001' end,
       ck_tag_source = 'cr_restructure_15oct2026',
       updated_at = now()
  from (values ('Inference','INF'), ('Cause Effect Reasoning','CEF'),
               ('Weakening Strengthening','ARG'), ('Similarity','SIM')) as m(gsq, code)
 where q.cetking_g_strategy_section = 'Critical Reasoning'
   and q.g_strategy_question = m.gsq;

-- ─── 2 · the iimking import: topic = Critical Reasoning ─────────────────────
-- 61 rows: Cause-Effect / Reasoning 25, Inference 21, Argument 9, Truth Claims & Conclusions 6.
update public.cat_import_questions q
   set ck_core_id = 'V-CR-' || m.code || '-' ||
                    case when coalesce(q.context_text,'') <> '' then '002' else '001' end,
       ck_tag_source = 'cr_restructure_15oct2026'
  from (values ('Inference','INF'), ('Cause-Effect / Reasoning','CEF'),
               ('Argument','ARG'), ('Truth Claims & Conclusions','TRC')) as m(qt, code)
 where q.section = 'Verbal'
   and q.topic = 'Critical Reasoning'
   and q.question_type = m.qt;

-- ─── 3 · verify ─────────────────────────────────────────────────────────────
do $$
declare a integer; b integer; untagged integer; bad integer;
begin
  select count(*) into a from public.cat_verbal_pyq_questions
   where cetking_g_strategy_section='Critical Reasoning' and ck_core_id is not null;
  select count(*) into b from public.cat_import_questions
   where section='Verbal' and topic='Critical Reasoning' and ck_core_id is not null;
  if a <> 188 then raise exception 'PYQ CR tagged % rows, expected 188', a; end if;
  if b <> 61  then raise exception 'import CR tagged % rows, expected 61', b;  end if;

  -- every CR row in scope must now carry a core id
  select count(*) into untagged from public.cat_import_questions
   where section='Verbal' and topic='Critical Reasoning' and ck_core_id is null;
  if untagged > 0 then raise exception '% CR import rows left untagged', untagged; end if;
  select count(*) into untagged from public.cat_verbal_pyq_questions
   where cetking_g_strategy_section='Critical Reasoning' and ck_core_id is null;
  if untagged > 0 then raise exception '% CR PYQ rows left untagged', untagged; end if;

  -- every core id written must exist in the master taxonomy
  select count(*) into bad from (
    select ck_core_id from public.cat_import_questions where ck_core_id is not null
    union select ck_core_id from public.cat_verbal_pyq_questions where ck_core_id is not null
  ) z where not exists (
    select 1 from public.verbal_master_taxonomy t
     where t.master_id = z.ck_core_id and t.level = 'core_type');
  if bad > 0 then raise exception '% core ids are not in verbal_master_taxonomy', bad; end if;
end $$;

-- ─── 4 · Control Room handover ──────────────────────────────────────────────
insert into control_room.sessions (actor, agent_type, purpose, status, notes)
values ('claude', 'opus', 'Verbal CR restructure: map all CR questions to the 7x2 core types', 'active',
        'Rav, 15 Oct 2026: Critical Reasoning becomes 7 chapters with Single Statements / Passage based inside each. Questions assigned by whether they sit on a passage.');

insert into control_room.change_requests (session_id, title, rationale, affected_objects, proposed_action, status, risk_level, verification_notes, rollback_notes, completed_at)
select s.id,
  'Verbal CR: ck_core_id on cat_import_questions + cat_verbal_pyq_questions, 249 CR rows tagged',
  'Rav restructured Critical Reasoning into 7 chapters x 2 core types (Single Statements / Passage based) and asked for all CR questions to be merged into them.',
  array['public.cat_import_questions','public.cat_verbal_pyq_questions'],
  'ALTER TABLE ADD COLUMN IF NOT EXISTS ck_core_id, ck_tag_source (both tables); UPDATE 188 PYQ CR rows + 61 import CR rows. No answer, type or passage changed.',
  'completed', 'low',
  '188 + 61 rows tagged, none left untagged, every core id present in verbal_master_taxonomy — asserted in-transaction.',
  'update public.cat_import_questions set ck_core_id=null, ck_tag_source=null where ck_tag_source=''cr_restructure_15oct2026''; same for cat_verbal_pyq_questions; then drop the two columns if nothing else uses them.',
  now()
from control_room.sessions s
where s.actor='claude' and s.status='active' and s.purpose like 'Verbal CR restructure%'
order by s.started_at desc limit 1;

insert into control_room.change_events (request_id, session_id, actor, event_kind, object_schema, object_name, operation, details)
select cr.id, cr.session_id, 'claude', 'schema_and_data', 'public', 'cat_import_questions + cat_verbal_pyq_questions', 'ALTER+UPDATE',
  jsonb_build_object('summary',
  'Verbal CR restructured to 7 chapters x 2 core types. Tagged 188 rows in cat_verbal_pyq_questions (Inference 98 -> V-CR-INF-002, Cause Effect 44 -> V-CR-CEF-002, Weakening Strengthening 34 -> V-CR-ARG-002, Similarity 12 -> V-CR-SIM-002; all sit on a passage) and 61 rows in cat_import_questions (Cause-Effect 13 passage / 12 single, Inference 20 passage / 1 single, Argument 9 single, Truth Claims & Conclusions 6 single). Merged away: V-CR-WST and V-CR-FLW into Arguments | Passage based; Must-Be-True into Inference; Identify Conclusion/Premise into Arguments | Single Statements; Necessary Assumption into Assumptions | Single Statements. OUTSTANDING: about 136 more CR questions are still hiding in the 424 untyped RC rows (Inference 53, Weakening Strengthening 38, Cause Effect 32, Similarity 13 by text match against the 506-row master) and are NOT tagged here — they need Rav to approve the wider tagging first. Also: the cat_card_questions qkey bug must be fixed before any tagging reaches the cards (reference-bank/verbal/CARD-KEY-BUG.md).')
from control_room.change_requests cr
where cr.title = 'Verbal CR: ck_core_id on cat_import_questions + cat_verbal_pyq_questions, 249 CR rows tagged'
order by cr.created_at desc limit 1;

update control_room.sessions set status='completed', finished_at=now(), last_seen_at=now()
 where actor='claude' and status='active' and purpose like 'Verbal CR restructure%';

commit;
