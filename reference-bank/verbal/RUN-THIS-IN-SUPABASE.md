# How to run the Verbal taxonomy SQL yourself — click by click

## Where things stand (15 Oct 2026)

**Run 1 is DONE.** You ran `verbal_master_taxonomy.sql` and `verbal_cr_question_tagging.sql` and both
succeeded. Verified from my side: 143 taxonomy rows, 93 core types, no orphans, and 249 Critical Reasoning
questions tagged. Critical Reasoning is live as 7 chapters × 2 core types.

**Run 2 is waiting for you.** You then confirmed "yes chapters in RC", so Reading Comprehension needs
reshaping: Evidence and Summary/TSPM stop being sub-sections and become chapters inside RC.

---

## Run 2 — reshape Reading Comprehension

**Step 1.** Open the SQL editor: https://supabase.com/dashboard/project/suqcijtpfeaystltekfn/sql/new

**Step 2.** Open this link, **Ctrl+A** then **Ctrl+C**:

https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_master_taxonomy_RESHAPE_rc.sql

**Step 3.** Paste into the editor and press **Run**. Expect `Success. No rows returned`.

### What it does

Deletes all 143 taxonomy rows and reloads **131** — one transaction, so it is all-or-nothing. Verbal goes
from 8 sub-sections to 6:

| Sub-section | Chapters | Core types |
|---|---:|---:|
| Reading Comprehension | 3 | 13 |
| Paragraph | 5 | 9 |
| Critical Reasoning | 7 | 14 |
| Vocabulary | 11 | 42 |
| Grammar | 9 | 9 |
| Verbal General | 1 | 1 |

RC's three chapters are **Evidence based**, **TSPM based**, and **CAT level RC**.

### Why it is safe for the work already done

The 14 Critical Reasoning core-type ids reload **unchanged**, so the 249 questions you already tagged keep
pointing at the right core types. The file asserts exactly that before committing — if even one tagged
question would be orphaned, it raises `RESHAPE ABORTED` and rolls the whole thing back. I tested this against
a copy of your current live state (143 rows + 249 tagged questions) and all 249 still resolved afterwards.

**Step 4.** Check it, or just tell me and I'll verify:

```sql
select subsection_name,
       count(*) filter (where level='chapter')   as chapters,
       count(*) filter (where level='core_type') as core_types
  from public.verbal_master_taxonomy
 where level in ('chapter','core_type')
 group by 1 order by 1;

select count(*) as tagged_still_resolving
  from (select ck_core_id from public.cat_import_questions     where ck_core_id is not null
        union all
        select ck_core_id from public.cat_verbal_pyq_questions where ck_core_id is not null) z
  join public.verbal_master_taxonomy t on t.master_id = z.ck_core_id;
```

Expect the six rows above, and **249**.

---

## Why you are running these by hand

My own tool calls could not make schema changes in this session: `apply_migration` was cancelled three
times and an `execute_sql` containing `CREATE TABLE` once, while a plain `INSERT` went through. Your runs
work fine, so this is the reliable route for schema changes.

Worth being clear about one thing: **the two SQL errors you hit were my bugs, not a Supabase lock.** I had
passed a plain string to `change_events.details` (it is `jsonb`) and set `sessions.status = 'finished'`
(only `active` / `completed` / `abandoned` are allowed). I had tested against a local stub whose column
types I invented instead of reading yours. The stub is now generated from your real schema.

## Undo, if ever needed

```sql
-- back to the 143-row shape: re-run the previous file
--   reference-bank/verbal/verbal_master_taxonomy.sql
-- remove the CR question tags:
update public.cat_import_questions     set ck_core_id=null, ck_tag_source=null where ck_tag_source='cr_restructure_15oct2026';
update public.cat_verbal_pyq_questions set ck_core_id=null, ck_tag_source=null where ck_tag_source='cr_restructure_15oct2026';
-- remove the taxonomy entirely:
drop view  if exists public.verbal_master_taxonomy_chapters;
drop table if exists public.verbal_master_taxonomy;
```
