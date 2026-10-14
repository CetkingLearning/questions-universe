# Prompt — build the Verbal / Logic master taxonomy the same way as Quant (15 Oct 2026)

Paste into a fresh Claude chat. Pick the section in the first line.

```
You are building the Cetking Master Taxonomy for the section: [VERBAL | LOGIC/DILR]  ← pick one.
This mirrors what was done for Quant on 15 Oct 2026. Read first: memory files cetking-content-universes,
cetking-supabase-universes, verbal-bible + varc-world (for Verbal) or dilr-world (for Logic), and
cetking-one/docs/STATUS.md in GitHub CetkingLearning/cetking-platform (branch cetking-one-nextjs) —
section "QUANT MASTER TAXONOMY" is the model. Don't ask me what was decided; it's all there.

RULE (Ravneet, 15 Oct 2026): everything in Cetking Universe — questions, tests, mocks, Arena, handouts,
PPTs, books, Pulse, Rav Singh AI — revolves around ONE master taxonomy per section, with an ID at every
level. Difficulty names everywhere: Level 0 · Easy · Medium · Hard · CAT level.

ID SCHEME (same shape as Quant's Q-AR-PER-001):
  Section: V (Verbal) / L (Logic-DILR)
  Sub-section: section + 2-letter code (Verbal: RC Reading Comprehension, SM Summary, PG Paragraph,
    EV Evidence, CR Critical Reasoning, VO Vocabulary/Grammar if needed; Logic: AR Arrangement,
    CS Caselet, GR Graphs (incl. Venn), SR Schedule & Routing, LR other CET-style LR if needed)
  Chapter: sub-section + 3-letter code, e.g. V-PG-JUM (Para Jumbles), L-AR-WDW (Wide Wordy)
  Core type: chapter + 3 digits, e.g. V-PG-JUM-001
  Future question IDs hang off it: V-PG-JUM-001-E-0001 (level L0/E/M/H/C). Document, don't generate.

SOURCES TO MERGE (read-only SELECTs in Supabase suqcijtpfeaystltekfn — "Cetking Learn"):
  1. The section's Bible / master structure: Verbal = the locked Verbal Bible structure in memory
     (verbal-bible) + the four promoted sections; Logic = DILR types in dilr-world + cetking-content-universes.
     If Ravneet pastes a Bible taxonomy file in this chat, that file is the base (authority), like Quant's.
  2. public.question_taxonomy rows for this section (incl. NMAT Brown Book / CET Pattern rows — keep, tag source).
  3. public.taxonomy_universe_nodes rows for this section.
  4. Arena / War Room topic structure (cetking_cat_arena_taxonomy_map + arena* tables) for this section.
  5. Real CAT questions: public.cat_import_questions where section = 'Verbal' (859) or 'DILR' (866):
     use column `topic` for chapter counts; for Verbal also cat_verbal_pyq_questions (506) and its
     cat_verbal_* summary tables; for DILR the cat_dilr_* tables. Keep raw labels (TSPM, Why Mention This…).
Merge rule: Bible/master is the base; map every other source's item to a chapter + core type by name or clear
synonym (match_status exact/synonym/new); items found only in sources 2–4 become proposed_addition rows for
Ravneet to accept/reject. Never invent chapters to make it tidy; never silently drop a source item.

OUTPUT
  A. CSVs in a working folder: master.csv (one row per level: section, sub-section, chapter, core type —
     with master_id, names, in_bible/in_question_taxonomy/in_universe_nodes/in_arena flags, match_status,
     proposed_addition, cat_questions_in_chapter, rav_decision (blank), rav_notes (blank)),
     sources-unmatched.csv, id-scheme.md, summary.md.
  B. Google Sheet: ask me for a blank sheet link (https://sheets.new) if none is given, then fill tabs
     Master · Chapters · Unmatched-Proposed · ID scheme. Freeze the header row.
  C. GitHub: push the same CSVs to CetkingLearning/questions-universe under
     reference-bank/<verbal|logic>/ (master-taxonomy.csv etc.), commit to main, and add a line to
     reference-bank/README.md. Also export the section's CAT questions from cat_import_questions into
     cat-universe/<verbal|dilr>/ organised by master chapter (one CSV per chapter, columns like
     cat-universe/quant/*.csv — copy its header; for DILR keep set_title + context_text so a set stays together).
  D. Supabase: DO NOT create tables while I'm not there to click Allow. Prepare the SQL for
     <section>_master_taxonomy (same columns as the planned quant_master_taxonomy: core_id, section,
     subsection, chapter, core_type, sort_order, status 'from_bible_unfrozen', frozen_at/by, source) and
     tell me to say "create the taxonomy table" when I'm back. Follow the Control Room procedure (schema
     control_room: read instructions, register session + change, handover) whenever you do write.
  E. Docs: add a "<SECTION> MASTER TAXONOMY" block to cetking-one/docs/STATUS.md and a §4B/§4C in
     docs/CONTENT-UNIVERSES.md in cetking-platform (docs-only → straight to cetking-one-nextjs), same wording
     style as the Quant block.
  F. Finish with the colour-box summary (🟢 DONE · 🟡 YOUR ACTION · 🔴 PROBLEM · 🔵 FYI) and the Sheet link.

Rajat's workflow (LADDER.md, WORKFLOW.md, CHATGPT-BRIEF.md, CHATGPT-START.md in questions-universe) stays
the same; only the chapter folders and source files change. Don't give Rajat Supabase access. Model: Opus
for the merge decisions, Sonnet for the exports and Sheet filling.
```
