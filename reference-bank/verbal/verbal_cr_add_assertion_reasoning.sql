-- Applied 15 Oct 2026 (Control Room change request 0c52c68d-722c-49df-b7e2-e316b2bf33d6). Rollback:
--   delete from public.verbal_master_taxonomy where master_id in ('V-CR-ASR-001','V-CR-ASR-002','V-CR-ASR');
insert into public.verbal_master_taxonomy
 (master_id, level, parent_id, name, section_id, subsection_id, subsection_name, chapter_id, chapter_name, chapter_code, core_type_id, core_type_no, core_type_name,
  sort_order, in_bible, in_question_taxonomy, in_universe_nodes, in_arena, cat_questions_in_chapter, match_status, proposed_addition, source_detail,
  status, source, mother_core_type, rc_non, cat_pyq_in_core_type, exams, exams_basis, rav_decision, rav_notes)
values
 ('V-CR-ASR','chapter','V-CR','Assertion Reasoning','V','V-CR','Critical Reasoning','V-CR-ASR','Assertion Reasoning','ASR',null,null,null,
  131,false,true,true,false,0,'new',false,'Added by Rav 15 Oct 2026 (8th CR chapter). Sources: question_taxonomy CET Pattern 38a1920e "Assertion Reasoning"; cet_question_topics CET_LR_CR_ASSERTION; universe node TX_4614FBE7930F687A8CB8; 10 CET/NMAT PYQs in pyq_question_bank (Logic L-CR-ASR shares this chapter).',
  'from_bible_unfrozen','logic_merge_15oct2026','Critical Reasoning',null,0,'MBA CET · NMAT · other non-CAT exams (not CAT)','Rav 15 Oct 2026: especially important for CET and other exams, not for CAT','accepted','8th Verbal CR chapter — CET / other exams, not CAT'),
 ('V-CR-ASR-001','core_type','V-CR-ASR','Single Statements','V','V-CR','Critical Reasoning','V-CR-ASR','Assertion Reasoning','ASR','V-CR-ASR-001',1,'Single Statements',
  132,false,true,true,false,0,'new',false,'Assertion–Reason pairs (A / R statements). The 10 CET/NMAT PYQs (Science A-R, Factual A-R, Science Assertion Reason) are this form.',
  'from_bible_unfrozen','logic_merge_15oct2026',null,'Non RC',0,'MBA CET · NMAT · other non-CAT exams (not CAT)','Rav 15 Oct 2026: CET / other exams, not CAT','accepted',null),
 ('V-CR-ASR-002','core_type','V-CR-ASR','Passage based','V','V-CR','Critical Reasoning','V-CR-ASR','Assertion Reasoning','ASR','V-CR-ASR-002',2,'Passage based',
  133,false,false,false,false,0,'new',true,'No rows yet — the passage-based half of Assertion Reasoning (keeps the 7x2 -> 8x2 CR grid).',
  'from_bible_unfrozen','logic_merge_15oct2026','Critical Reasoning','RC',0,'MBA CET · NMAT · other non-CAT exams (not CAT)','Rav 15 Oct 2026: CET / other exams, not CAT',null,null);
