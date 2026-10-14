Cetking Questions Universe Handholding Guide and Master Memory
Cetking Questions Universe is the shared question architecture for Ravneet, Rajat, faculty, interns and AI assistants. One canonical bank supplies teaching, practice, books and assessments. Questions move through collection, classification, creation, independent verification, staging, human approval and publishing.

Owner: Ravneet Singh. Working memory dated 7 October 2026. This guide records agreed rules, practical operating instructions and known chapter status. Database controls described here are implementation requirements, not a claim that they are already deployed.

Governing rule: verified does not mean approved or published. AI-generated or reworked questions must not enter the production bank before Ravneet approves the exact version.

How to resume Questions Universe
When Ravneet says “Cetking Questions Universe”, open this guide and the current chapter files before continuing. Identify the chapter, its frozen taxonomy, approved DNA definitions, inventory gaps and last completed workflow stage. Preserve existing question IDs and decisions.

Use this reusable prompt:

Open Cetking Questions Universe and load its latest handholding guide and chapter records. Continue for [chapter] from [stage, if known]. Use the frozen Core Types and L0 + E1–E4 + M1–M5 + H1–H5 framework. Show planned, drafted, verified, approved and published counts separately. Keep complete solutions, playbook methods, provenance and metadata. Use properly rendered mathematics. Never publish without Ravneet’s approval of the exact question versions. If a decision is missing, identify it instead of inventing earlier agreement.

This is a retrieval instruction for future work, not an automatic scheduled task. In a new conversation, reference this Page to make the full memory available.

The architecture
Layer

Meaning

Example

Section and chapter

Familiar syllabus identity

Quant → Averages

Main Type

Student-friendly grouping, usually 3–5 per chapter

Read Total

Core Type

A distinct recurring solution structure

Find Missing Value

Difficulty DNA

What makes a question easy, medium or hard

M4 Reverse or Hidden Unknown

Canonical question

A stable question identity with reviewed versions

One question occupying a blueprint cell

Delivery selection

A curated use of canonical questions

Class and Handout

Keep chapter names students recognise: Averages, Mixtures, Time and Work, Geometry and so on. Shortcut names such as Breakup or x ki maro belong inside the chapter as methods or strategy tags. Earlier shortcut-only organisation confused students.

Discover Core Types from actual questions first. Then identify common solution methods and group related types. Do not force every new chapter into one concept or shortcut. Averages has a useful TOTAL framework; another chapter may need several methods.

Grouping should simplify navigation while preserving useful distinctions. Merging a Main Type is different from deleting a Core Type. Freeze taxonomy versions and retain a mapping whenever names or membership change.

Difficulty DNA
Each frozen Core Type has one L0 Foundation question plus 14 exam-style cells.

Cell

Meaning

Creation requirement

L0

Foundation

Teach the prerequisite idea in its simplest form; avoid relying on a named formula

E1

Direct Formula

The solution engine is immediately visible

E2

Reverse Formula

Use the same relationship backwards

E3

One Missing or Changed Piece

One obvious missing, added or changed quantity

E4

Simple Context

Wrap the direct concept in ordinary context

M1

Calculation Heavy

More computation with the same recognisable engine

M2

Language Heavy

Extract the relationship from more demanding wording

M3

Format or Presentation Variation

Recognise the same engine in a different representation

M4

Reverse or Hidden Unknown

Identify an unknown that is less directly stated

M5

Extra Information or Selection

Select relevant information or reject a distraction

H1

Multi-stage Chain

Connect several necessary reasoning steps

H2

Concept Disguise

Recognise an engine concealed by the problem structure

H3

Multiple Concepts or Engine Combination

Combine permitted engines within the chapter scope

H4

Constraint or Equation Building

Build and solve a model from meaningful restrictions

H5

Insight or Non-obvious Pivot

Use a decisive observation that simplifies the problem

Large numbers, long wording and ugly arithmetic alone do not make a question Hard. Every record needs a short DNA justification explaining the actual cognitive demand.

A number change is a variant, not proof of a different DNA cell. If a narrow Core Type cannot support authentic H1–H5 questions, flag the blueprint for review instead of filling it with clones or unrelated concepts. For pure chapters, H3 must respect the agreed exclusions.

Inventory mathematics and Golden selection
For C frozen Core Types, the standard full inventory is:

Component

Count

Foundation L0

C

Easy

4 × C

Medium

5 × C

Hard

5 × C

Exam-style bank

14 × C

Full canonical bank including Foundation

15 × C

Golden teaching spine

4 × C

Golden means L0 plus the best Easy, best Medium and best Hard question for each Core Type. These are selected records within the master bank, not additional questions. Do not permanently force the best choices to be E1, M3 and H5 merely because a draft used those tags.

A chapter’s scope follows genuine Core Types and approved exceptions. Do not invent types to reach a round target such as 300 or 400. Any extra variants must be counted separately from the canonical cell inventory.

The complete factory workflow
Stage

Owner

Action and required output

1 Collect

Rajat or team

Gather genuine reference questions; retain original wording or image, exam, year, source and contributor

2 Discover Core Types

AI

Read the whole topic pool and compare with existing taxonomy; produce evidence-backed proposed types

3 Map the pool

AI

Map every input question; flag duplicates, unmatched items, hybrids and gaps

4 Freeze Core Types

Ravneet with AI

Finalise names, scope, boundaries and taxonomy version

5 Create Main Types

AI with review

Group into roughly 3–5 accessible buckets without erasing useful Core Types

6 Build the matrix

AI

List every required L0, Easy, Medium and Hard cell; calculate expected counts

7 Ground Hard questions

AI and source pool

Attach actual CAT or relevant high-level exam evidence to Hard patterns

8 Generate complete candidates

AI

Write stem, options where applicable, answer, full solution, shortcut, playbook mapping, metadata and provenance

9 Rajat check

Rajat

Check wording, taxonomy, duplicates, answer, options and practical solvability

10 Gemini audit

Gemini

Solve independently; primarily report failures and problem cases

11 Second AI audit

Qwen, DeepSeek or chosen model

Independently verify corrected candidates, especially all first-audit failures

12 Final accuracy pass

AI and human

Resolve disagreements and leave unresolved items blocked

13 Staging

System

Upload verified candidates and audit history to a separate review layer

14 Approval

Ravneet

Approve, reject or request edits for exact question versions

15 Final publishing QA

Rajat

Reconcile counts, missing cells, duplicates, metadata and rejected items

16 Publish

Authorised publisher

Publish only the approved versions that passed final QA

Use web/PYQ material for taxonomy and exam-pattern evidence. Record whether an item is a genuine PYQ, a licensed/reusable question, an adaptation or an original AI question. An original question inspired by a CAT pattern must never be labelled an actual CAT PYQ. A Google result alone does not establish its exam, year or reuse permission.

If an external audit model has not actually run, record that stage as pending. Never replace Gemini or the second auditor with an unlabelled self-review.

Handholding instructions for Rajat and interns
Start a batch for one chapter. Record the requested exams, chapter boundaries and source files.

Upload the raw questions with source details. Preserve an original copy before cleaning OCR or notation.

Review the AI’s question-to-Core-Type map. Resolve unmatched questions before freezing the taxonomy.

Check the blueprint totals. Ask for a coverage table showing each Core Type against all 15 cells.

Review candidates in manageable batches. Solve before looking at the AI key where practical.

Record specific issues: wrong answer, duplicate, unclear domain, missing option, wrong DNA, wrong taxonomy or broken rendering.

Send the corrected, versioned batch through both independent audits.

Reconcile every failure. Send only resolved candidates to the verified queue.

Present the approval packet to Ravneet.

After approval, reconcile the exact publish list and check the published result.

Interns should work through a collection/review interface. They should not need direct Supabase access or production credentials. Their role is to draft, classify, flag and submit. Review and approval should be visible in the interface, with a separate authorised publishing action.

State transitions and approval controls
The principal lifecycle is:

RAW → CLASSIFIED → GENERATED → HUMAN_CHECKED → AI_AUDIT_1 → AI_AUDIT_2 → VERIFIED → PENDING_APPROVAL → APPROVED → PUBLISHED

Classification includes a frozen taxonomy reference. Audit stages must store outcomes; merely reaching an audit stage does not mean passing it. A retained PYQ still requires a normalised candidate version and review.

Implementation must also support NEEDS_REVISION, REJECTED and RETIRED outcomes. Revisions return to the relevant review stages. Keep the history of earlier outcomes instead of overwriting it.

Rule

Required behaviour

Separate staging

Candidate records cannot become visible in production simply because an AI inserted them

Exact-version approval

Approval refers to the content version Ravneet reviewed

Edit after approval

A content change invalidates approval for the new version and triggers review again

Publish validation

Check approval, final QA and version match at the server

Repeated publish request

Reuse the same canonical identity; do not create duplicates

Production correction

Create a reviewed revision and preserve previous published content and usage references

Rejected candidate

Keep its history and exclude it from publish counts

Access

Collection, review, approval and publishing permissions remain distinct

These are required controls for the future implementation. Before a database change, inspect the actual schema and access rules; the field names in this guide are a logical specification.

Complete question record
Group

Required information

Identity

Stable question ID, version, batch ID, canonical or variant designation, parent reference if applicable

Taxonomy

Section, Sub Section where used, Topic/chapter, Main Type, Core Type ID, taxonomy version, secondary skill tags

Difficulty

L0/Easy/Medium/Hard, DNA code, explanation of DNA fit, intended exam relevance

Question

Stem, mathematical source format, domain/assumptions, question format, language, media references

Options and answer

Stable option IDs and text for MCQs, correct option ID, exact answer, units and numeric tolerance where needed

Explanation

Full derivation, validation, concise shortcut, concept and method tags, playbook rule link

Distractors

Why each wrong option is plausible and what misconception it diagnoses

Provenance

Original source, exam/year/slot/question number when verified, URL or source file, source classification, original text, adaptation details, reuse status

People and audits

Contributor, generator/model if used, Rajat review, Gemini result, second AI result, correction history and unresolved issues

Approval

Approver, timestamp, approved version, rejection or edit reason

Publishing

Publisher, publish time, published version, production reference and rollback/retirement history

Delivery

Golden selection, class/handout, PPT/video, book level, Arena, topic test and mock tags

Timing

Estimated solve time with units; separate any test-level duration setting

Preserve the earlier upload taxonomy fields Section | Sub Section | Topic | Sub topic | Difficulty through an explicit mapping to the richer hierarchy. Do not silently assume that Sub topic means both Main Type and Core Type.

Earlier SQL upload timing defaults were Easy 5 minutes, Medium 10 and Hard 15. Their question-versus-test scope must be confirmed in the target upload contract. Do not automatically treat them as per-question solve targets.

Mathematics and MCQ quality
Store mathematics as structured LaTeX/MathJax-compatible source and render it in every student-facing stem, option, solution and playbook. LaTeX can internally contain exponent syntax; students should see superscripts, proper roots and fractions rather than raw caret text.

For documents and exports, use native equations or rendered mathematics. A raw Markdown export is not proof that the final interface renders correctly. Inspect the target student screen and at least one export.

Check variable domains, nonzero denominators, signs, root conventions, units, rounding and approximation precision. Substituting answers into the original equation is essential after squaring.

For a single-answer MCQ, exactly one option must be correct. Equivalent forms such as √45 and 3√5 cannot compete as different answers in a “largest” question. Balance answer positions after the content is sound, and regenerate the answer key whenever options move.

OCR must be resolved before solving: a pasted “219” may mean 2¹⁹; “ab” may mean a × b or a raised to b. Preserve the original and flag uncertainty rather than silently inventing a stem.

Independent audit and resolution
Give each auditor the same versioned question package. Ask it to solve independently, compare the key and explanation, check domain restrictions and inspect all options.

The audit output should focus on failures while retaining a record of coverage:

Field

Purpose

Question ID and version

Identifies exactly what was checked

Auditor and date

Establishes who or what performed the audit

Outcome

Pass, fail, ambiguous or unable to verify

Issue and severity

Explains what prevents use

Independent reasoning

Supports the finding

Proposed correction

Gives a concrete repair

Resolution and recheck

Shows whether the repaired version passed

Two models agreeing is supporting evidence, not a guarantee of 100% correctness. No unresolved ambiguity should be hidden behind a verified label. If a repair changes wording, options or constraints, recheck the answer and DNA fit for that new version.

The approval packet should include the question list, exact versions, coverage totals, audit coverage, resolved failures, remaining exclusions and final rendered preview.

Playbooks and teaching methods
A playbook is derived from the canonical questions and their actual solutions. It should contain formulas, concepts, recognition cues, methods, shortcuts, conditions and common traps. Offer a concise chapter introduction, ideally a one-page teaching view where feasible, with fuller detail online.

Preserve these Core-Type fields: playbook_rule, playbook_spot_words, playbook_killer_move, playbook_formula_mathjax, playbook_decision_hint and playbook_example. Questions retain their own full solution, shortcut and concept fields.

For every class or handout question, ask: “Can the current playbook explain this solution completely?” If not, extend the playbook or revise the method mapping.

The consecutive-odd-number example illustrates why this matters: the average of 9 consecutive odd numbers is 47, so the largest is 47 + 4 × 2 = 55. The playbook must explicitly capture symmetry, the middle term and step size. Calling the chapter TOTAL does not remove the need to explain this method.

Retain alternate valid methods where useful. Do not force a slower unified method without recording a clearer shortcut.

One bank feeding every product
Product

Agreed direction

Master bank

Complete canonical coverage, kept backstage

Golden spine

L0 plus best Easy, Medium and Hard per Core Type

Class and Handout

One combined selection; Averages uses 1 Easy + 1 Medium per Core Type, giving 30

PPT and Video

One combined teaching sequence linked to selected canonical questions

Playbook and Cheatsheet

Concepts and methods extracted from the bank; online plus suitable chapter-intro pages

Medium Book

Curated Medium questions

Hard Book

Curated Hard questions

Foundation and Easy practice

Primarily digital/Arena; avoid overwhelming the printed books

Arena

5 Easy + 5 Medium + 5 Hard per subtopic, giving 15 per set

Topic tests and mocks

Approved questions selected by coverage, difficulty and exam relevance

Revision and strategy

Reuse question IDs, methods, traps and learner evidence

Do not independently reinvent the book, handout and Arena banks. Link delivery selections to canonical IDs and versions; record any modified variant separately.

Arena’s 15 questions are a delivery rule, not a replacement for the canonical 15-cell structure. L0 is an additional foundation experience rather than silently becoming part of the 5/5/5 count.

An earlier equal-grouping idea suggested five Core Types per subtopic. The later Averages grouping is 5/4/6. Before building an Arena set, define which Main Type or subtopic it covers and rotate coverage where a bucket contains more types than one set can accommodate. Do not force the taxonomy back into equal groups.

Do not print all Medium or Hard canonical questions automatically. Choose a manageable student-facing set; exact book and mock allocations require a chapter plan.

Exam relevance and allocation
Canonical coverage and student-facing emphasis are separate decisions. A chapter can retain a useful Core Type while allocating it fewer class questions, book pages or mock slots.

For allocation, tag verified exam questions by exam, year, slot and Core Type. Deduplicate repeated copies, distinguish standalone from secondary-skill appearances, and report frequencies with the actual denominator. Compare recurrence, recent relevance, transfer value and teaching prerequisites.

Do not give each Main Type one-third of the teaching time merely because there are three buckets. “Change and Correction in Average has low exam relevance” is a hypothesis to test against the source pool, not an established frequency statistic.

Keep any weighting formula or numerical allocation as a proposal until approved. This guide does not invent exam-frequency data.

Averages chapter memory
Frozen architecture: 15 Core Types, 225 total canonical questions, including Foundation. Averages uses TOTAL as a common organising idea: total = average × count.

Main Type

Frozen Core Types

Read Total — 5

Basic Average; Find Missing Value; Consecutive Numbers; Find Number of Observations; Required Average

Mix Totals — 4

Combined Average; Weighted Average; Overlapping Average; Pairwise A-B-C

Repair Total — 6

Addition of Member; Removal of Member; Replacement; Group Transfer; Uniform Average Change; Wrong Entry/Correction

Inventory

Count

L0

15

Easy

60

Medium

75

Hard

75

Exam-style total

210

Full bank

225

Golden selection within the bank

60

Class and Handout selection

30

Superseded arithmetic: “225 + 15 = 240” is wrong for this architecture. The 225 already includes Foundation.

Earlier draft-generation history included a 225-row scaffold and Golden tags using L0/E1/M3/H5. A subsequent review flagged numerical clones. Row count and tags alone therefore do not establish genuine DNA coverage or a production-ready bank. Revalidate diversity before using that scaffold.

Older Averages inventories must not overwrite the frozen 15-Type architecture. Live counts and publication status require a separate current database check.

Pure Surds and Indices chapter memory
The accepted scope excludes logarithms, AM-GM, functions and unrelated mixed chapters. The broad “Advanced Pattern / Constraint” Core Type was removed; meaningful constraints can remain as H4 within pure S&I. The separate hybrid category was also removed from the final list.

No

Frozen Core Type

1

Square Root Basics

2

Surd Simplification and Operations

3

Nested Surds / Square Form

4

Surd Approximation

5

Radical Equations

6

x + 1/x and x − 1/x Identities

7

Index Laws Basics

8

Same Base Conversion

9

Negative / Fractional Indices

10

Exponential Equations

11

Prime-Factor Exponent Balancing

12

Power Comparison / Ordering

Full target: 180 = 12 L0 + 48 Easy + 60 Medium + 60 Hard. Golden selection would contain 48 questions.

The current Pure Surds and Indices starter bank contains 120 stem-and-answer rows: L0 + E1–E4 + M1–M5. The 60 Hard cells are missing. Complete MCQ distractors, full solutions, full metadata and audits are still required for the production workflow. The file also retains plain-text mathematical syntax requiring conversion.

Three corrections are present in the current file:

Cell

Correct result

Core 11 M2

Nᴺ = 2¹⁶ has no integer solution; N = 4 gives 2⁸

Core 12 M2

Cube root of 3 is larger than √2

Core 12 M3

3 raised to one-third is the largest listed power

These repairs do not certify the other 117 rows. For example, square-root and power questions still need explicit domains where answers depend on positivity, and DNA labels need substantive review.

The supplied CET and CMAT/SNAP/NMAT material is reference evidence, not a clean publishable bank. Some earlier stems, answers and explanations were mismatched or OCR-corrupted. Recheck the original before excluding a question: a reciprocal expression containing variable powers may still belong to indices.

No upload or production publication is established by this guide. The requested MathJax conversion and metadata upload remain separate tasks until verified.

Other chapter memory and boundaries
Mixtures: derive the Core Types from the existing reference questions before proposing a unifying method. Earlier work used 30 Easy and 20 hard CAT-level questions as reference DNA. The final frozen Mixtures taxonomy and question inventory must be loaded from its chapter record before generation; they are not defined here.

Equations: simple equations, quadratic equations and other represented structures should be discovered from the collected pool. Do not treat illustrative quantities such as 220, 300 or 400 as frozen chapter targets.

Across chapters, retain familiar syllabus labels and classify by genuine solution structure underneath. Keep cross-chapter secondary skills separate from the primary Core Type, and respect explicit pure-topic exclusions.

Publishing checklist

Chapter scope and taxonomy version are frozen.


Every required DNA cell has a genuine representative, or an approved exception is recorded.


Expected, drafted, verified, pending, approved, rejected and published counts reconcile.


Canonical questions and variants are counted separately.


All stems, domains, options, keys and solutions agree.


Single-answer MCQs have exactly one correct option.


Duplicate and near-duplicate checks are resolved.


Provenance and genuine-PYQ claims are supported.


Playbook methods cover every selected teaching question.


Rajat review and both AI audits actually ran on the relevant versions.


All blocking failures are resolved.


Mathematics renders correctly in the target interfaces and exports.


Ravneet approved the exact versions being published.


Rajat completed final QA after approval.


The publisher is authorised and repeated requests cannot duplicate records.


Published IDs, versions and counts are checked after the action.

Completion requires evidence for each applicable gate. A saved document, an answer correction or an AI pass alone is not production completion.

Reusable working prompts
Discovery

For [chapter], read the complete source pool and existing taxonomy. Map every question to a solution Core Type. Flag duplicates, ambiguous OCR, hybrids and gaps. Propose 3–5 Main Types while preserving granular distinctions. Do not freeze or generate a full bank until the taxonomy is approved.

Generation

Use taxonomy version [version]. Fill [specified cells] with complete candidates. Each must contain stem, applicable options, correct answer, full solution, shortcut/playbook mapping, DNA justification, domain and provenance. Avoid numerical clones. Respect pure-topic exclusions. Mark all output as candidates.

Audit

Independently solve every question in batch [ID/version]. Check wording, domain, answer, all options, solution, taxonomy and DNA. Return a coverage summary and primarily failures, ambiguities and proposed corrections. Do not mark unresolved cases as passed.

Approval preparation

Reconcile the batch against its blueprint. Show the exact candidate versions, audit results, corrections, exclusions and rendered previews. Prepare Ravneet’s approval list. Do not publish.

Publishing after approval

Publish only the exact approved versions in [approved batch], after final QA and permission checks. Preserve IDs, audit history and version references. Reconcile successful, failed and skipped records and report the actual result.

Maintaining this memory
Update the same guide when Ravneet changes the architecture. Record the date, changed decision, affected chapters and what it supersedes. Preserve chapter-specific exceptions without silently making them universal.

For each chapter, keep a linked register of taxonomy versions, sources, blueprint, candidates, audit reports, approval records and published manifests. Record the last completed stage and the next concrete action.

Current next steps for Pure Surds & Indices are to audit the existing 120 rows, repair wording and DNA fit, add the 60 Hard cells, complete options/solutions/metadata, convert mathematical rendering, run the human and independent AI reviews, and then use staging and approval. No generation or upload is performed merely by creating this guide.

Decision basis: Ravneet’s Question Factory SOP in this conversation; the accepted Questions Universe and Averages architecture from 6 October 2026; the Surds & Indices conversation and current corrected starter file. Implementation status must always be checked against the actual system before claiming a task is live.

