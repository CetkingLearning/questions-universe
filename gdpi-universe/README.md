# GDPI Universe (Purva — Admissions)

interviewking.in content brought into Cetking Universe (Ravneet, 15 Oct 2026).
Four universes under PURVA_ADMISSIONS_UNIVERSE: GDPI_SYLLABUS · GDPI_SKILL_BUILDERS · GDPI_EXPERIENCES · GDPI_PI_QUESTIONS.

- `import/pages.json` — all 90 published posts/pages from the WordPress export (body HTML + text), loaded into `gdpi.pages`.
- `import/questions.json` — every interview/GD/WAT question, with the author's answer exactly as written where one exists; loaded into `gdpi.questions`.
- `import/experiences.json` — GDPI experience posts and the colleges they belong to (`gdpi.experiences`, `gdpi.experience_colleges` → `admissions_colleges.id`).

Supabase loads these files straight from this branch (raw GitHub URL via pg_net).
