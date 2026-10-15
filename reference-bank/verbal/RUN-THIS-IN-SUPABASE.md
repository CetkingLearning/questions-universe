# How to run the Verbal taxonomy SQL yourself — click by click

## Where things stand (15 Oct 2026)

**Run 1 is DONE.** You ran `verbal_master_taxonomy.sql` and `verbal_cr_question_tagging.sql` and both
succeeded. Verified from my side: 143 taxonomy rows, 93 core types, no orphans, and 249 Critical Reasoning
questions tagged. Critical Reasoning is live as 7 chapters × 2 core types.

**Run 2 is DONE** — the taxonomy is live at 115 rows with Reading Comprehension, Paragraph and
Vocabulary all reshaped.

**Run 3 is DONE** — 246 Vocabulary questions tagged, 23 Bible-only sample questions stored.

**Runs 4 and 5 are waiting for you** (below, in that order): Grammar as 5 chapters / 19 subchapters
plus the Question Type Registry, then the alignment of all 998 MBA CET Verbal questions.
Only **Verbal General** is still untouched.

---

## Run 4 + Run 5 — Grammar, then the CET alignment  ← **DO THESE, IN THIS ORDER**

Two pastes. Run 5 refuses to start until run 4 has landed, so order matters but you cannot get it wrong.

### Run 4 — Grammar: 5 chapters / 19 subchapters + Question Type Registry

**Step 1.** https://supabase.com/dashboard/project/suqcijtpfeaystltekfn/sql/new
**Step 2.** Open, **Ctrl+A → Ctrl+C**:
https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_run4_grammar.sql
**Step 3.** Paste, **Run**. Expect 5 chapters · 19 subchapters · 300 targets · 6 question types · 37 tagged.

### Run 5 — align all 998 MBA CET Verbal questions

**Step 4.** Same editor, open and **Ctrl+A → Ctrl+C**:
https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_run5_cet_alignment.sql
**Step 5.** Paste, **Run**. It prints a table of every question type with its CET 2025 / CET 2026 / twin counts.

This one tags **CET 2025 (298) + CET 2026 official (350) + CET 2026 twins (350)** on both axes,
creates `V-RC-EVD-004 Inference based` that you approved, and leaves the whole mapping readable in
`public.cet_verbal_tag_map` — 122 rows, each with a reason, 20 flagged for your review.

Background and the ten findings: [CET-ALIGNMENT.md](CET-ALIGNMENT.md)

**Step 6.** Check it, and see the review queue:

```sql
select count(*) as total, count(*) filter (where ck_core_id is null) as untagged
  from public.pyq_question_bank where exam='MBA CET' and section='Verbal Ability';

select arena_topic, arena_sub_topic, ck_core_id, reason
  from public.cet_verbal_tag_map where needs_review order by 1,2;
```

Expect **998 total, 0 untagged.**

---

<details>
<summary>Run 4 details</summary>

**Step 1.** Open the SQL editor: https://supabase.com/dashboard/project/suqcijtpfeaystltekfn/sql/new

**Step 2.** Open this link, **Ctrl+A** then **Ctrl+C**:

https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_run4_grammar.sql

**Step 3.** Paste and press **Run**. Expect this table:

| item | n |
|---|---:|
| Grammar chapters | 5 |
| Grammar subchapters | 19 |
| target questions | 300 |
| question types in registry | 6 |
| live Grammar questions tagged | 37 |

### What it does

Your call — *"these six are question formats, not grammar concepts"* — becomes **two
independent axes**, and every question carries one id from each.

| Concept axis | Format axis |
|---|---|
| `verbal_master_taxonomy` → `ck_core_id` | `verbal_question_type_registry` → `ck_question_type` |
| 5 chapters → 19 subchapters → *Core Rules pending* | QT01–QT06, shared across all of Verbal |

The three old Grammar chapters that were really formats — Sentence Improvement, Spotting Error,
Grammar Fill in the Blanks — **leave the concept tree** and become QT01, QT04, QT06.

The registry is section-wide, not Grammar-only, exactly as you asked, so CAT/CET/SNAP/NMAT/XAT/CMAT
share one set of format ids. QT06 Fill in the Blanks is already marked as spanning Grammar,
Vocabulary and RC.

Background, the old→new mapping, and the five open questions:
[GRAMMAR-RESTRUCTURE.md](GRAMMAR-RESTRUCTURE.md)

**Step 4.** Check it, and see your worked example actually work:

```sql
select chapter_code, chapter_name, count(*) filter (where level='subtopic') as subchapters
  from public.verbal_master_taxonomy
 where master_id like 'V-GR-%' and master_id not like 'V-GR-UNT%'
 group by 1,2 order by 1;

select * from public.verbal_question_type_registry order by sort_order;
```

</details>

---

## Run 3 — Vocabulary question tags + the Bible sample — **DONE**

You ran this: **246** questions tagged and **23** Bible-only rows stored.

<details>
<summary>Original run-3 instructions, kept for reference</summary>

**Step 1.** Open the SQL editor: https://supabase.com/dashboard/project/suqcijtpfeaystltekfn/sql/new

**Step 2.** Open this link, **Ctrl+A** then **Ctrl+C**:

https://raw.githubusercontent.com/CetkingLearning/questions-universe/main/reference-bank/verbal/verbal_run3_vocab_tagging_and_bible.sql

**Step 3.** Paste and press **Run**. It prints two numbers: **246** and **23**.

### What it does

**(a) Tags all 246 live Vocabulary questions** onto the new question types. Adds
`questions.ck_core_id` and `questions.ck_tag_source`.

| Live path | n | → question type |
|---|---:|---|
| Vocabulary · Fill in the Blanks (3 subtopics) | 54 | `V-VO-CTX-SCO-001` |
| Vocabulary · Idioms & Phrases · Idiom Meaning (Usage) | 18 | `V-VO-IDM-USE-001` |
| Vocabulary · Idioms & Phrases · Idiom Identification | 18 | `V-VO-IDM-IDN-001` |
| Vocabulary · Idioms & Phrases · Correct Idiom in Context | 18 | `V-VO-IDM-COR-001` |
| Vocabulary · One-Word Substitution (3 subtopics) | 54 | `V-VO-MNR-DEF-001` |
| Vocabulary · Spelling (2 subtopics) | 36 | `V-VO-WSA-SPL-001` |
| Vocabulary Builder · Roots & Prefixes (4 subtopics) | 48 | `V-VO-WSA-ROT-001` |

The Idioms 54 are a clean 1:1 onto your three subtypes. The rest collapse into their 1D
types — the 2D types are built and waiting, with no questions yet.

**(b) Stores your 23 Bible sample idiom questions** — Usage 7, Identification 12, Correct
Idiom 4 — in a **new table of their own**, `public.verbal_bible_questions`.

You said *"do not use this sample anywhere ... these questions are only used for the Bible."*
So rather than a flag on a shared table, they sit in their own table that no live query reads,
with two CHECK constraints (`bible_only is true`, `status = 'bible_only'`) that make the
restriction **structural** — a future query cannot flip them live by accident. I tested that:
both `update ... set bible_only=false` and `set status='live'` are rejected by the database.

They are not in `question_bank` for a second reason too: that table has `option_a..option_d`
only, and your samples have **five** options each.

### Why it is safe

One transaction. It refuses to start unless the 23 Vocabulary question types exist, asserts
every per-type count above, asserts no Vocabulary question is left untagged, and asserts every
Bible row has 5 options with an answer among them. Any failure rolls back everything,
including the new column and table. Safe to run twice.

**Step 4.** Check it:

```sql
select ck_core_id, count(*) from public.questions
 where ck_tag_source = 'vocab_tagging_15oct2026' group by 1 order by 1;

select subtopic_name, count(*) from public.verbal_bible_questions group by 1;
```

</details>

---

## Run 2 — reshape RC + Paragraph + Vocabulary — **DONE**

You ran this. Verified from my side: 115 rows live — 1 section, 6 subsections, 28 chapters,
13 subtopics, 67 question types, all 23 Vocabulary types present.

<details>
<summary>Original run-2 instructions, kept for reference</summary>

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

</details>

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
-- remove the CET alignment (run 5):
update public.pyq_question_bank set ck_core_id=null, ck_tag_level=null, ck_question_type=null, ck_tag_source=null where ck_tag_source like 'cet_verbal_align_15oct2026%';
drop table if exists public.cet_verbal_tag_map;
delete from public.verbal_master_taxonomy where master_id='V-RC-EVD-004';
-- remove the Grammar restructure (run 4):
update public.questions set ck_core_id=null, ck_tag_level=null, ck_tag_source=null where ck_tag_source='grammar_restructure_15oct2026';
drop table if exists public.verbal_question_type_registry cascade;
-- remove the Vocabulary question tags (run 3):
update public.questions set ck_core_id=null, ck_tag_source=null where ck_tag_source='vocab_tagging_15oct2026';
-- remove the Bible sample (run 3):
drop table if exists public.verbal_bible_questions;
-- remove the taxonomy entirely:
drop view  if exists public.verbal_master_taxonomy_chapters;
drop table if exists public.verbal_master_taxonomy;
```
