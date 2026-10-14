# Reading Comprehension — metadata index (15 Oct 2026)

`_index.csv` lists the 510 actual-CAT Reading Comprehension questions from Supabase `public.cat_import_questions` (Verbal, topic `Reading Comprehension`, `is_actual_cat` = true). It has the same 36 columns as the other Verbal files, filled as `ck_subsection` = Reading Comprehension, `ck_chapter` = Passage Practice, `ck_chapter_source` = `verbal_master_15oct`.

**It is an index, not the question text.** `context_text`, `question_text`, `option_a`–`option_d`, `solution` and `why_others_wrong` are deliberately empty because the full passages are about 1.9 MB of text. `ai_answer_notes` says `see Supabase cat_import_questions.id`; use `supabase_id` to fetch the text. `context_hash` groups the questions that belong to one passage (58 rows have no hash yet).

- **Full passage export is a separate job**, pending Ravneet's go-ahead (1.9 MB, to be run from his laptop).
- **424 of these 510 rows have no `question_type` yet.** They must be tagged against `cat_verbal_pyq_questions` (506 rows) first. The other 86 rows carry a generic `question_type` (`RC`, `Reading Comprehension` or `Keywords`) copied as-is.
- The older flat file `cat-universe/verbal/reading-comprehension.csv` (full text, old column layout, includes the 46 practice rows) is still in the repo until Ravneet decides what to do with it.
