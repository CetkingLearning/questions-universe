# Grammar restructure — Rav, 15 Oct 2026

> "These six are question formats, not grammar concepts. So we should add a separate layer
> called Question Type, rather than making them chapters or subchapters."

That one sentence is the whole change. Grammar now has **two independent axes**.

| Concept axis (`verbal_master_taxonomy`) | Format axis (`verbal_question_type_registry`) |
|---|---|
| Section → Subsection → Chapter → Subchapter → Core Rule | Question Type, shared across all of Verbal |
| 5 chapters → 19 subchapters → *(rules pending)* | QT01–QT06 |

A question carries one id from each: `ck_core_id` + `ck_question_type`.

## The Bible agrees with him

Worth recording, because it is independent confirmation rather than my opinion. The Verbal
Bible's 10 Grammar chapters split cleanly into **6 formats and 4 concepts**, and his six
Question Types are almost exactly the Bible's six format chapters:

| His Question Type | Bible chapter |
|---|---|
| QT01 Sentence Improvement | G1 Sentence Improvement |
| QT02 Multiple Sentence Improvement | G1 subchapter 1B "Multiple" |
| QT03 Phrase Replacement | G2 Phrase & Segment Replacement |
| QT04 Grammar Error Spotting | G3 Error Spotting |
| QT05 Fragment Continuation | G8 Fragment & Logical Continuation |
| QT06 Fill in the Blanks | G9 Fill in the Blanks (Grammar-Function) |

The Bible's four *concept* chapters — G4 Voice, G5 Speech, G6 Parts of Speech, G7 Figures of
Speech — are the ones that survive as concepts, and they land in his G05 (plus G02/G03/G04).

The live table said the same thing: of the 9 Grammar chapters that were in Supabase, **three
were formats** (Sentence Improvement, Spotting Error, Grammar Fill in the Blanks). Those three
now leave the concept tree and become QT01, QT04, QT06.

## Old → new

See `grammar-migration.csv`. Nothing was tagged to any `V-GR` id, so no question was orphaned.

## Open — needs Rav

1. **Core Rules are not built.** He wrote "Core Rule: Grammar Bible rules". The Bible lists core
   *types* grouped under the six **format** chapters, not *rules* under his 19 **concept**
   subchapters. Producing 300 rules from that would mean inventing them. The 19 subchapters are
   in place and ready to receive them.
2. **The reference codes 77 / 79 / 80 / 81 / 84 / 85 could not be verified.**
   `public.question_taxonomy` contains **zero** Grammar rows, and nothing in Supabase carries
   those numbers. They are stored verbatim with `reference_code_verified = false`. Where are
   they from — the Grammar Bible book's own numbering?
3. **Parts of Speech has no home.** Old `V-GR-POS` "Parts of Speech & Modifiers" splits across
   G02.01 Modifiers, G02.02 Pronouns, G03.02 Conjunctions and G04 Adjectives/Adverbs. No
   questions were on it, so nothing was lost — but POS *identification* has no subchapter.
   Related: his G05.01 is "Speech Identification", while the Bible puts "Speech Identification"
   under Parts of Speech (meaning identify the part of speech). Does G05.01 mean identifying
   parts of speech, or identifying direct vs indirect speech?
4. **Cloze is a seventh format.** Bible G10 Cloze Test is a question format and is not among his
   six. Cloze currently sits on the concept axis in Vocabulary (`V-VO-CTX-CLZ`). Should it
   become QT07?
5. **The 25 live SVA questions have their columns swapped** — `sub_section_name = 'Subject Verb
   Agreement'` and `topic_name = 'Grammar'`, the opposite of the Vocabulary convention. They are
   tagged correctly regardless, but the raw columns are misleading and worth a cleanup.

## Targets, not inventory

Every `target_questions` value is his standardized practice target (300 = 5 × 60), explicitly
**not** a verified existing count. He said so himself and the column comment records it. Actual
live Grammar inventory today is **37 questions**.
