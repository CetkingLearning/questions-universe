# Aligning the MBA CET Verbal questions to the taxonomy — 15 Oct 2026

Rav: *"all CET 2025, CET 2026 questions, all the twin questions we made, everything should be
following this taxonomy, so that tomorrow we can put up the questions based on it."*

## Scope — 998 questions, all of them

| | n |
|---|---:|
| MBA CET 2025 official (6 slots) | 298 |
| MBA CET 2026 official (7 slots) | 350 |
| MBA CET 2026 twins (7 slots) | 350 |
| **Total** | **998** |

SNAP 2024 Verbal (15) and the CAT VARC rows in this table are **out of scope** for this run — say
the word and they follow the same path.

## How it works

Two things made this tractable rather than a 998-row hand job.

**1. Arena classification already exists on all 648 officials.** Every one has
`arena_topic` + `arena_sub_topic` filled by the earlier editorial pass. That collapses to a
**122-row mapping** covering every live combination. Verified against the live table: **zero
uncovered pairs**.

**2. Twins inherit from their official.** All 350 twins carry
`source_question_id = 'T' || <official's id>`, and all 350 resolve 1:1. A twin is the same question
type at the same difficulty with values changed, so it must carry the same tags — the file
propagates them by that join and then *asserts* no twin disagrees with its official. Re-running
also repairs a twin that has drifted.

## The mapping lives in the database

`public.cet_verbal_tag_map` — 122 rows, each with a `reason` and a `needs_review` flag. Change a
row, re-run the UPDATE, re-tag. It is meant to be read and argued with, not buried in a script.
Same content as `cet-verbal-tag-map.csv` here.

**20 of the 122 rows are flagged `needs_review`.** Those are judgement calls, not guesses I am
hiding.

## What the alignment found

1. **RC "Inference" had no home — 69 questions.** Evidence based covered Truth & Facts / Why
   Mention This / Vocab Based; TSPM covered tone-scope-purpose-main-idea. Inference is neither.
   Rav approved a new `V-RC-EVD-004 Inference based`, which this file creates. CAT inference
   questions land there too.
2. **The two-axis model earns its keep immediately.** Four questions are filed by CET under a
   *grammar* format but their concept is *vocabulary* — `Spelling Error` and `Spelling Context
   Error` (→ `V-VO-WSA-SPL-001`), `Idiom Correction` (→ `V-VO-IDM-COR-001`) and `Idiomatic Phrase`
   (→ `V-VO-IDM-USE-001`). A single-axis taxonomy would have had to lie about one or the other.
3. **Two questions are really QT02, not QT04.** `Multi-Sentence Correctness` and `Pick Correct
   Sentences` are multiple-sentence-improvement format even though Arena files them under Spotting
   Error. The registry caught that.
4. **4-statement para jumbles have no type — 9 questions.** `V-PG-JUM` offers TITA, 5-statement and
   6-7-statement. CET asks 4-statement jumbles (7 under Para Jumbles, 2 under Sentence
   Rearrangement). Parked on the 5-statement type and flagged. Needs a `V-PG-JUM-004` or a rename.
5. **One question is not Verbal at all.** Slot 1 Q151, `Letter Group Odd One`, is a letter-group
   puzzle that Arena itself files under `Traditional Logic` inside Verbal Ability. Parked on the
   vocabulary Odd One Out and flagged — it probably belongs in the Logic universe.
   `master-taxonomy.csv` already warned that word and sentence odd-one-out must never merge; this is
   that warning coming true.
6. **`Redundancy Error` has nowhere clean to sit.** Your 19 subchapters have no Redundancy
   subchapter, though the Bible lists redundancy under both Error Spotting and Sentence Improvement.
   Filed under Construction Rules and flagged.
7. **CET tests Figures of Speech (2 questions)** — one of the two subchapters with *no* Grammar
   Bible content. Worth knowing before you write that chapter.
8. **CET has zero Idiom Identification questions.** All 43 idiom questions are Usage (40) or Correct
   Idiom (3). Your `V-VO-IDM-IDN` subtype is real but untested by CET.
9. **18 of your 19 Grammar subchapters are exercised by CET.** The one CET never touches is
   `Speech Identification` — the other Bible-less subchapter.
10. **A data-hygiene nit:** `Subject Verb Agreement` and `Subject-Verb Agreement` both exist as
    Arena subtopics. Both map to the same place, so nothing breaks, but one spelling should win.

## Why it is safe

One transaction. It refuses to start without run 4. It asserts: all 998 tagged and **none left
untagged**, exactly 998 carrying this run's tag source, all 350 twins tagged, every tag resolving in
`verbal_master_taxonomy` *at the level it claims*, and no twin disagreeing with its official.

The untagged assertion is the important one. When a new CET paper arrives with a subtopic the map
has never seen, this file **aborts** rather than quietly leaving those questions untagged. Proven in
test: one unmapped question → `ABORT: 1 CET Verbal questions left untagged.`

Validated on a throwaway Postgres 16 seeded from the live schema and the live per-subtopic counts:
happy path, re-run idempotency, missing-run-4 abort, unmapped-question abort, twin-drift repair, and
the question-type foreign key.
