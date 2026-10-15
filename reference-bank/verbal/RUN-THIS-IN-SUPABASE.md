# How to run the Verbal taxonomy SQL yourself — click by click

## Where things stand (15 Oct 2026)

**Run 1 is DONE.** You ran `verbal_master_taxonomy.sql` and `verbal_cr_question_tagging.sql` and both
succeeded. Verified from my side: 143 taxonomy rows, 93 core types, no orphans, and 249 Critical Reasoning
questions tagged. Critical Reasoning is live as 7 chapters × 2 core types.

**Run 2 is waiting for you.** It now carries TWO restructures in one file — Reading Comprehension
("yes chapters in RC") and Paragraph (his third sheet). **If you already copied the run-2 file earlier,
copy it again** — it has changed. Vocabulary, Grammar and General are untouched, pending his later sheets.

---

## Run 2 — reshape RC + Paragraph + Vocabulary (one file)

**Step 1.** Open the SQL editor: https://supabase.com/dashboard/project/suqcijtpfeaystltekfn/sql/new

**Step 2.** Open this link, **Ctrl+A** then **Ctrl+C**:

https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_master_taxonomy_RESHAPE_rc.sql

**Step 3.** Paste into the editor and press **Run**. Expect `Success. No rows returned`.

### What it does

Deletes all 143 taxonomy rows and reloads **115** — one transaction, all-or-nothing.

| Sub-section | Topics/Chapters | Subtopics | Question types |
|---|---:|---:|---:|
| Reading Comprehension | 3 | — | 13 |
| Paragraph | 4 | — | 7 |
| Critical Reasoning | 7 | — | 14 |
| **Vocabulary** | **4** | **13** | **23** |
| Grammar | 9 | — | 9 |
| Verbal General | 1 | — | 1 |

It also makes two schema additions for your Vocabulary shape:

- a new level **`subtopic`**, so the tree can be Section → Subsection → Topic → Subtopic → Question Type
- a **`dimension`** column (`1D` / `2D`, with `3D` allowed for later) — a complexity **tag**, not a level, exactly as you said

**Column names vs your words.** The table mirrors `quant_master_taxonomy`, so:
your **Topic** is stored in `chapter_*`, your **Subtopic** in `topic_*`, your **Question Type** in `core_type_*`.
Worth knowing before you query it.

### Vocabulary as loaded

| Topic | Subtopics | 1D | 2D |
|---|---:|---:|---:|
| Meaning and Relationships | 4 | 4 | 4 |
| Context and Usage | 4 | 4 | 4 |
| Idioms and Phrases | 3 | 3 | 0 |
| Word Structure and Accuracy | 2 | 2 | 2 |

Idioms is its own Topic with your three subtypes — **Idiom Usage · Idiom Identification · Correct Idiom**.
High Frequency Words was dropped (zero questions, same rule as Passage Structure).

### Why it is safe for the work already done

The 14 Critical Reasoning core-type ids reload **unchanged**, so the 249 questions already tagged keep
pointing at the right types. The file asserts that before committing — if even one tagged question would be
orphaned it raises `RESHAPE ABORTED` and rolls everything back. Validated against a copy of your current
live state; all 249 still resolved.

**Step 4.** Check it, or tell me and I will verify:

```sql
select level, count(*) from public.verbal_master_taxonomy group by 1;

select chapter_name, subtopics, core_types, one_d, two_d
  from public.verbal_master_taxonomy_chapters
 where subsection_name = 'Vocabulary' order by sort_order;
```

Expect 1 section / 6 subsections / 28 chapters / 13 subtopics / 67 question types, and the Vocabulary table above.


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
