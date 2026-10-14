# Latent bug in `cat_card_questions` — fix it with the tagging, not after

Found 15 Oct 2026 while checking the Verbal cards. **Not student-facing today. It becomes
student-facing the moment the tagging work lands**, so fix it in the same change.

## What it is

The view de-duplicates with `DISTINCT ON (world, qkey)`, where

```
qkey = exam_year || '-' || left(letters_only(context_text), 60)
                 || '-' || left(letters_only(question_text), 60)
```

Sixty characters of question text is not enough to tell Verbal questions apart, because
**every non-RC Verbal type shares a boilerplate stem**:

- *"Five jumbled sentences (labelled 1, 2, 3, 4, and 5) are given below…"*
- *"The four sentences (labelled 1, 2, 3, and 4) given below…"*
- *"The given sentence is missing in the paragraph below…"*
- *"The passage given below is followed by four summaries…"*

and for most of those rows `context_text` is empty, so the first two parts of the key are
identical too. Different questions from the same year therefore collapse into one row.
RC is hit as well: several questions on one passage share both the passage opening and a
stem such as *"All of the following statements from the passage…"*.

## How much it eats

Distinct Verbal questions (keyed on `question_text + context_text + options`) that the
view's `qkey` cannot tell apart, and which would therefore never appear on a card:

| Topic | qkey groups | Distinct questions in them | **Questions lost** | Worst single group |
|---|---|---|---|---|
| Reading Comprehension | 22 | 66 | **44** | 8 → 1 |
| Odd One Out | 6 | 33 | **27** | 12 → 1 |
| Para Jumbles | 6 | 20 | **14** | 4 → 1 |
| Para Completion & Sentence Insertion | 3 | 13 | **10** | 6 → 1 |
| Para Summary | 9 | 18 | **9** | 2 → 1 |
| **Total** | **46** | **150** | **104** | |

**Today the loss is 0**, because only 76 Verbal rows carry a G Strategy and pass the answer
filter, and none of those 76 collide. The 104 all sit in the untagged 538. So the moment
`TAGGING-PLAN.md` runs, the view starts silently dropping about a hundred questions.

Also worth knowing: on the view's `qkey`, **23 groups hold rows whose stored answers disagree**
(130 rows) and **15 groups mix `match` with a non-`match` verify status**. On the stricter
content key only 1 group disagrees — so most of that disagreement is the key merging questions
that were never the same question.

## The fix

Make `qkey` a content key, the same one used everywhere else in the Verbal work:

```sql
md5(coalesce(question_text,'') || '|' || coalesce(context_text,'') || '|' || coalesce(options::text,''))
```

That keeps the real duplicates collapsing (iimking published the same question on 2–4 pages, and
those copies are byte-identical in these three fields — 88 rows, 86 of them in CAT 2025) while
leaving genuinely different questions alone.

If a looser key is wanted for near-duplicates, raise the truncation to the full strings rather
than lengthening it a little: the 2025 near-duplicates differ late in the text, not early.

## Checked and NOT a problem

`correct_option` and `correct_answer` are internally consistent on **all 1,800** checkable MCQ rows
across Quant, Verbal and DILR — the option key always points at the option whose text is stored as
the answer. So the import did not scramble keys against texts. A wrong stored answer comes from the
source it was taken from, not from the loader.
