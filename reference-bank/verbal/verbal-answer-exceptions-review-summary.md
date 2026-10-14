# Verbal answer exceptions: second-source review

Review of the 68 exception rows in `cat_import_questions` (Supabase project `suqcijtpfeaystltekfn`; Verbal, `is_actual_cat` true, stored `verify_status` of mismatch, missing_found, not_found or not_checked).
Review sheet: `/tmp/claude-0/-home-claude/f8418f1e-6f32-5297-830a-691d12d6c822/scratchpad/verbal/out/verbal-answer-exceptions-review.csv` (68 rows, UTF-8 with BOM so Excel shows curly quotes and Kekulé correctly).

**Nothing in Supabase was changed.** Only SELECT queries were run. No answer was edited. The `rav_decision` column is empty for you to fill in.

## Read this first: CAT 2025

Ravneet personally checked CAT 2025 against the original papers. So for the 16 rows below that are really CAT 2025 and where web sources disagree with Cetking, the most likely explanation is that **the web source is wrong, not Cetking**. Those rows are marked "differs" only to say "the web sources disagree with the stored answer". Please do not change any 2025 answer on the strength of this sheet; look at the original paper first. Every 2025 row carries that caveat in its notes.

For years other than 2025 nothing was checked against the original papers by anyone, so there the picture is different: two independent sources agree against Cetking in all 24 such rows, which points to a Cetking row error (see "How reliable is this").

## Verdict counts

| Verdict | Rows | Meaning here |
|---|---|---|
| differs | 40 (28 distinct questions) | Two sources agree with each other and not with the stored answer |
| match | 4 | Stored answer agrees with two sources |
| ours_blank | 23 | Nothing usable stored; two sources agree on an answer that could be adopted |
| not_found | 1 | No credible source for this exact text |
| option_order_differs | 0 | Not needed: where letters differ, the answer text differs too |

Confidence: 67 rows `two_sources_agree`, 1 row `none`. No row is `one_source` or `weak_match`: where I could only get one fetch to work I kept looking until I had a second, or I did not give a verdict.

### By stored status

| Stored status | Rows | Result of this review |
|---|---|---|
| mismatch | 33 | all 33 differs (two sources agree against Cetking) |
| missing_found | 21 | all 21 ours_blank (two sources agree; safe to adopt after a glance at the original) |
| not_found | 12 | 7 differs, 4 match, 1 not_found |
| not_checked | 2 | both ours_blank (answer 2 in both, two sources) |

### By year and slot (real exam, after correcting wrong labels, see below)

| Exam | Rows | differs | match | ours_blank | not_found |
|---|---|---|---|---|---|
| 2025 Slot 1 | 17 | 14 | 1 | 2 | 0 |
| 2025 Slot 2 | 6 | 0 | 0 | 6 | 0 |
| 2025 Slot 3 | 2 | 2 | 0 | 0 | 0 |
| 2025 (lookalike, no real slot) | 1 | 0 | 0 | 0 | 1 |
| 2024 Slot 1 | 5 | 5 | 0 | 0 | 0 |
| 2024 Slot 2 | 6 | 5 | 1 | 0 | 0 |
| 2024 Slot 3 | 6 | 5 | 1 | 0 | 0 |
| 2023 Slot 1 | 2 | 2 | 0 | 0 | 0 |
| 2023 Slot 2 | 2 | 2 | 0 | 0 | 0 |
| 2023 Slot 3 | 7 | 3 | 0 | 4 | 0 |
| 2022 Slot 1 / Slot 3 | 2 | 0 | 0 | 2 | 0 |
| 2021 Slot 3 | 1 | 0 | 0 | 1 | 0 |
| 2020 Slot 2 / Slot 3 | 3 | 0 | 0 | 3 | 0 |
| 2019 Slot 2 | 1 | 1 | 0 | 0 | 0 |
| 2018 Slot 1 | 3 | 0 | 0 | 3 | 0 |
| 2017 Slot 1 | 2 | 1 | 1 | 0 | 0 |
| 2017 Slot 2 | 2 | 0 | 0 | 2 | 0 |
| **Total** | **68** | **40** | **4** | **23** | **1** |

By the labels stored in the database the year counts are 2025: 29, 2024: 17, 2023: 8, 2022: 2, 2021: 1, 2020: 3, 2019: 1, 2018: 3, 2017: 2, no year: 2. The table above uses the real exam, which changes the year for 5 rows (listed below) and sets aside the lookalike row.

## Wrong labels found (worth fixing separately)

The `iimking.com/odd/` pages (and `odd-man-slot-3`) are labelled with the wrong exam for several rows:

- `8f364424` is stored as 2025 but is **CAT 2023 Slot 1** (English number names).
- `cfdbadad` and `ee2495bd` are stored as 2025 but are **CAT 2017 Slot 1** (exercise and the brain; Mars water).
- `1e642a45` and `21de44f5` have no year but are **CAT 2023 Slot 3** (soft skills; Boa Senior and the Bo language).
- `35b3e727` (phytoplankton, stored 2025) is a **rewritten lookalike** of the real CAT 2025 Slot 3 question, not the real thing. It is the only not_found result, because its sentences appear in no source. The real question is already held separately by Cetking and matches.
- `814736a0` and `e0ee3186` are stored as 2025 with no slot; the sources place them in Slot 1.

## The 40 "differs" rows (supabase_id, what Cetking has, what the two sources say)

Sorted newest exam first. "Ours" is the stored letter and answer. The first 16 rows are real CAT 2025: see the caveat at the top, the web source may be the wrong one.

| Exam | supabase_id | Ours | Sources say |
|---|---|---|---|
| 2025 S1 | `0a3ce9ff-900d-4498-899f-947f97a89a39` | C: Empathy and imagination. | The borders of criminal responsibility. |
| 2025 S1 | `afe2329c-de14-4bae-aab1-adebc69e7a90` | C: Empathy and imagination. | The borders of criminal responsibility. |
| 2025 S1 | `118597be-1b47-4580-abab-53400bd2e462` | 1 | 4 |
| 2025 S1 | `1f310ff9-8ae4-4733-a66c-74910b0c88df` | 1 | 4 |
| 2025 S1 | `306e57f4-e037-4940-829e-7f15f9db113b` | 1 | 4 |
| 2025 S1 | `6555de57-947e-43cb-8f94-ec818486586e` | 1 | 4 |
| 2025 S1 | `e0ee3186-8af1-4ddc-94bd-4e508b132b3e` | E: Sentence 5 | 4 (same question as the four rows above) |
| 2025 S1 | `163227c0-e9bb-489d-9a0a-b6492f1ef7d3` | C: Option 4 | Option 3 |
| 2025 S1 | `1b89b927-3bff-4392-aedd-d0fd98a8d8d7` | C: Option 4 | Option 3 |
| 2025 S1 | `875b4dba-b07a-489e-a254-b446640c9a56` | C: Option 4 | Option 3 |
| 2025 S1 | `643d6926-b3c1-43bf-acdd-93b5fd82b6fb` | B: The communication problem is what allows us to see electronic music as music... | A: Unfamiliar forms and terms might get in the way..., but this can be overcome. |
| 2025 S1 | `b7d5267f-989d-4f83-8403-5de6217515e5` | B: (same as above) | A: (same as above) |
| 2025 S1 | `6edf1fb3-2540-4f33-9fa4-749b342a1be5` | C: Generic | Particular |
| 2025 S1 | `f4e9ea02-2b5b-4c10-ae53-7719a1dbe483` | C: Generic | Particular |
| 2025 S3 | `70814ead-d28f-41f0-a836-e7bb523641d9` | C: Option 2 | Option 3 |
| 2025 S3 | `9b2b65ac-34c4-4fe4-a703-c726d38df1a5` | D: Option 1 | Option 4 |
| 2024 S1 | `cc674049-0dc1-474b-9201-a67fe612f4e0` | A: Option 1 | Option 4 |
| 2024 S1 | `db4675f8-57fd-49d3-8b70-8f057b6d68d2` | A: Not all codes are natural but certain codes are naturalized... | Language and visual signs are codes. However, some of the codes are so widespread... |
| 2024 S1 | `febac648-b7ab-4305-9f3a-7c47b28ed26a` | C: (same text as above) | (same as above) |
| 2024 S1 | `21dfa914-ff30-4b3b-b6d0-0665bd38fbf3` | A: Sentence 1 | Sentence 2 |
| 2024 S1 | `c4d5d416-efb1-4b8a-b337-150848ee4db8` | D: Sentence 4 | Sentence 1 |
| 2024 S2 | `11c0b2a4-6075-4fda-a0c8-e944b73b7106` | C: Sentence 5 | Sentence 4 |
| 2024 S2 | `a5887f92-ecfc-4a6d-ae98-1981c137a684` | 5 | 4 |
| 2024 S2 | `ad1eb8c3-888d-4a47-8dde-4aa9d0629d88` | B: Sentence 2 | Sentence 4 (same question as the two rows above) |
| 2024 S2 | `53c47ca0-e84e-40a3-8ab2-7e3dbc3a1350` | A: Following the DIME model... | C: As part of conducting information warfare as per the DIME model... |
| 2024 S2 | `600daa24-bd93-4ee4-97aa-d5643c41cb14` | C: Option 4 | Option 3 |
| 2024 S3 | `571d589d-07a7-43f8-bc75-05c25878a831` | B: Option 2 | Option 3 |
| 2024 S3 | `ab946dca-333a-4620-8e3b-175e1719865b` | A: Option 1 | Option 4 |
| 2024 S3 | `c9f8e4f4-a00c-4159-aee4-8033a7310772` | C: Option 1 | Option 3 |
| 2024 S3 | `70f15e94-3975-4418-8c50-bb24775fc513` | D: By promoting an idealized past... | A: The tradwife, with her vintage dress and traditional roles... |
| 2024 S3 | `8f697db0-acee-4a41-86ca-ccbbf375eec1` | C: Sentence 3 | Sentence 2 |
| 2023 S1 | `827b9636-f2b8-42f9-bdd5-03a6a1e94ec0` | 1423 | 4123 |
| 2023 S1 | `8f364424-11b8-46d6-838f-21f1bb3b9cb2` | E: Sentence 5 | Sentence 3 |
| 2023 S2 | `9fd1e18a-b37c-4bc7-bb8b-0a625ab9a97d` | D: history can be objective like the sciences... | A: history is like science: a selective system of cognitive orientations to reality. |
| 2023 S2 | `c75ca928-02b7-4c95-9b78-33afa5ae4599` | A: Option 1 | Option 2 |
| 2023 S3 | `29b8cbfe-839b-498f-8c3d-5e4adc8d6002` | B: They were intended to protect... | A: They were aimed at protecting cultural property, but instead reduced new archaeological discoveries. |
| 2023 S3 | `2e3264ec-c959-4b33-92c0-3989531a97dd` | A: are a symbol of Western imperialism. | B: give a boost to the tourism sector. |
| 2023 S3 | `7524a028-777b-423f-a6bb-115fcc615879` | C: unlike the sciences, human achievements... | B: great innovations across various fields can stem from flashes of intuition... |
| 2019 S2 | `8bd087c5-af54-4d78-95dd-0c1efdc8238a` | 2143 | 3421 |
| 2017 S1 | `ee2495bd-21af-4567-88c9-be5e3dee3c1c` | C: Sentence 3 | Sentence 1 |

For "Option N" rows (sentence-insertion questions) N is the blank position in the paragraph.

## Sources used and sources refused

Used (every verdict row has the exact page URL in `source_url` and `second_source_url`):

- **2IIM** (`online.2iim.com/CAT-question-paper/...`): list pages for CAT 2025 Slots 1-3, 2024 Slots 1-3, 2023 Slots 1-3, 2022 Slots 1 and 3, 2021 Slot 3, 2020 Slots 2-3, 2019 Slot 2, 2018 Slot 1, 2017 Slot 2, plus a handful of single-question pages. Used for almost every row.
- **Hitbullseye** CAT 2025 answer-key PDFs for Slots I, II and III (key plus a written explanation per question; the PDF shows no question text, so I matched questions by what the explanation describes, and said so in the notes where that applied).
- **Career Launcher** solution pages for CAT 2024 Slots 1-3 and 2023 Slots 2-3. The pages are long, so I read the last part with a second request to reach the final questions.
- **Cracku**: single-question pages and a few listing pages. Several listing pages show no answers at all.
- **Collegedunia** question pages (CAT 2017, 2019, 2020 and 2025).

Refused or blocked:

- **No page was refused for legal reasons**, and I did not use curl, caches or archives to get around any fetch failure.
- One Cracku page (the 2025 "sui generis" question) first came back as "permission request not answered, do not retry". I did not retry it then. A search later listed the same address and a normal fetch of it worked. I am flagging that in case you want that row's Cracku evidence treated with extra caution; it is a 2025 row and 2IIM and Hitbullseye agree independently anyway.
- About a dozen other Cracku and Collegedunia pages returned a transient fetch error (for example the Cracku pages for the 2025 Slot 1 freedom and artists questions, and several 2018 and 2020 pages). Where that happened I used another source and recorded which. Notes on each row say which second source actually produced the verdict.
- Some sites' listing pages (Cracku 2018, 2020, 2022 Slot 3, 2017 Slot 2, 2025 Slots 1 and 2) show no answer key. The fetch tool offered its own derived answers for those; **I discarded all of them** and did not count them as sources. The same applies to opinions the tool added about which answer "reads better" (it questioned the keys for the 2025 silver question, the 2022 Slot 1 sentence insertion, and the hate-speech odd one out). Those are not sources and are not used, except that I flagged the 2022 Slot 1 aside in that row's notes so you can check it.
- A Collegedunia article page for CAT 2018 Slot 1 showed sequences that disagreed with 2IIM and Cracku for two of three jumbles, and its mirror site showed no answers. I treated that fetch as unreliable and noted it on the two rows involved.

## How reliable is this (honest view)

- **Strengths.** Sentence numbering in the odd-one-out rows lined up with each source's key text in every case I checked. In most rows two different sites agree with each other. In many "differs" rows Cetking also contradicts itself: duplicate copies of the same question hold different answers (freedom-over-death odd one out, cultivated-meat odd one out, X-chromosome, inequality, and a history duplicate).
- **Weaknesses.** I never saw an original question paper or the official IIM key. Every answer here comes from commercial or community answer pages, which carry their own mistakes (by the fetch tool's reading, one 2IIM page contradicts its own explanation and so does one Hitbullseye Slot II entry; and for the 2020 Slot 3 jumble the sources disagree about the official key). Pages were also read through a summarising tool that paraphrases, caps quotes and sometimes adds opinion, so a small mistake in transcription cannot be ruled out. It is also not strictly true that "two sources" are independent: 2IIM, Cracku and Career Launcher may borrow from each other.
- **What this means in practice.**
  - For non-2025 "differs" rows, I think a Cetking error is likely (two sources agree and I found nothing pointing the other way), but please confirm against the paper before editing.
  - For 2025 "differs" rows, treat them as "someone should look at the original" and expect that Cetking, which Ravneet has already checked, is usually right.
  - The 21 "missing_found" rows and the 2 "not_checked" rows are the safest wins: there is no stored answer to contradict, and two sources agree on one.
  - The 4 "match" rows give modest comfort, not proof.

## Patterns worth knowing

- **Possible import bug on sentence-insertion ("Option N") questions.** In 5 of the 9 such questions where Cetking disagrees with the sources, the stored options are in a shuffled order, and the stored letter equals the letter the sources' answer would have in plain Option 1-4 order. That is what you would see if the letter was kept while the options were reshuffled during import. The 4 other cases do not fit that pattern, so it is a hypothesis for the 5, not a finding. Rows involved: silver (3 copies), X-chromosome, inequality, `600daa24`, `c9f8e4f4`. The notes on each row say which fit.
- **Duplicated questions.** The same question was imported from several iimking pages, sometimes with different stored answers. Fixing one row is not enough; all copies of a question should be corrected together.
- **A side observation, not an exception row.** For the 2025 Slot 1 "panoptic mechanism" jumble, Cetking stores 2143 (three copies, all marked match against 2IIM). Hitbullseye's Slot I key gives 3142 instead, and 2IIM's own explanation seems to reason towards a different order than its key. This is the one place where the two 2025 sources disagree with each other. Since Ravneet checked 2025 against the originals, Cetking's 2143 is probably fine.
- **Not an error, a known dispute.** CAT 2020 Slot 3 exaptation jumble: the official key is reported as BDCA; 2IIM argues it is wrong and prints BCDA. The sheet records BDCA as the official answer and notes the dispute.

## Method

Matched by the question's own text, not by question number (few rows have one). For each unique question I fetched the stored `verify_source` pages first, then found a second independent source. `source_answer` comes only from a real fetched page; my own solving is in the separate `claude_own_reasoning` column and is not counted as a source. A verdict of `not_found` was used where no credible second source existed. 51 distinct questions sit behind the 68 rows.
