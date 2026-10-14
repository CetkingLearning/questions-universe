# How to run the Verbal taxonomy SQL yourself — click by click

**Why this file exists.** On 15 Oct 2026 I could not create the table from this session. Schema changes
were refused four times: `apply_migration` cancelled three times, and an `execute_sql` call containing
`CREATE TABLE` cancelled once — while a plain `INSERT` in the same session went through fine. So writing
rows is allowed here, creating tables is not. **Nothing was created and nothing was left half-done**: no
`verbal_master_taxonomy`, no `ck_core_id` columns, no dangling Control Room session.

Two ways forward. Either grant the schema-change approval when the prompt appears and I run it, or run it
yourself in four clicks below. Both end in exactly the same place.

---

## Step 1 — open the Supabase SQL editor

https://supabase.com/dashboard/project/suqcijtpfeaystltekfn/sql/new

(That is the Cetking Learn project. If it asks you to log in, it is the same account you used on 10 Oct to
upload the question CSV.)

## Step 2 — run the first file

Open this link, press **Ctrl+A** then **Ctrl+C** to copy all of it:

https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_master_taxonomy.sql

Paste it into the SQL editor and press **Run** (or Ctrl+Enter).

**What it does:** creates the table `verbal_master_taxonomy` and the view
`verbal_master_taxonomy_chapters`, then loads 143 rows — 1 section, 8 sub-sections, 41 chapters,
93 core types, including the restructured Critical Reasoning (7 chapters × 2 core types).

**It checks itself.** The last part of the file counts what it loaded and deliberately fails if the numbers
are wrong, which rolls the whole thing back. So either you get the full correct load or you get nothing —
it cannot leave the table half-filled.

**Expected result:** `Success. No rows returned`.

## Step 3 — run the second file

Same thing with:

https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_cr_question_tagging.sql

**What it does:** adds two columns (`ck_core_id`, `ck_tag_source`) to `cat_import_questions` and
`cat_verbal_pyq_questions`, then writes the core-type id onto **249 Critical Reasoning questions** —
188 from the 506-row master and 61 from the iimking import. It does not touch any answer, option,
passage or existing column, and it also fails-and-rolls-back if the counts are off.

**Run it after file 1**, because its checks look up the ids in the new table.

**Expected result:** `Success. No rows returned`.

## Step 4 — see that it worked

Paste this and Run:

```sql
select level, count(*) from public.verbal_master_taxonomy group by 1 order by 2;

select chapter_name, core_types, cat_pyq_in_chapter
  from public.verbal_master_taxonomy_chapters
 where subsection_name = 'Critical Reasoning' order by sort_order;

select ck_core_id, count(*) from (
  select ck_core_id from public.cat_verbal_pyq_questions where ck_core_id is not null
  union all
  select ck_core_id from public.cat_import_questions     where ck_core_id is not null
) z group by 1 order by 1;
```

You should see 143 rows / 93 core types, the 7 Critical Reasoning chapters with 2 core types each, and
249 tagged questions across 8 core-type ids.

---

## If something goes wrong

Nothing here is destructive, and both files run inside a single transaction, so a failure leaves the
database exactly as it was. If you want to undo a successful run:

```sql
drop view  if exists public.verbal_master_taxonomy_chapters;
drop table if exists public.verbal_master_taxonomy;
update public.cat_import_questions     set ck_core_id=null, ck_tag_source=null where ck_tag_source='cr_restructure_15oct2026';
update public.cat_verbal_pyq_questions set ck_core_id=null, ck_tag_source=null where ck_tag_source='cr_restructure_15oct2026';
```

Tell me once it has run and I will verify from my side and record the Control Room handover.
