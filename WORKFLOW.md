# How Rajat works on the Questions Universe (via GitHub)

Rajat works **only in GitHub** with ChatGPT. He never touches Supabase.
Claude moves files from GitHub into a Supabase **staging** area. Ravneet approves. Only then does anything enter the live system.

```
Rajat + ChatGPT  →  GitHub branch  →  Pull Request  →  Ravneet reviews  →  Claude loads to Supabase STAGING
                                                                        →  Ravneet approves in Supabase  →  LIVE
```

## One-time setup (Ravneet)
1. Add Rajat as a collaborator: https://github.com/CetkingLearning/questions-universe/settings/access → **Add people** → Rajat's GitHub username → role **Write**.
2. Protect `main`: https://github.com/CetkingLearning/questions-universe/settings/branches → **Add rule** → branch `main` → tick **Require a pull request before merging** and **Require approvals (1)**. Rajat can then only change `main` through a PR that you approve.

## Rajat's loop for every batch (e.g. "Surds & Indices — Hard cells")

**Step 1 — Start a branch**
- Open https://github.com/CetkingLearning/questions-universe
- Click the branch dropdown (says `main`) → type a name like `surds-hard-batch-1` → **Create branch**.

**Step 2 — Give ChatGPT the context**
- Paste into ChatGPT: the `README.md` (the guide), the chapter's `taxonomy.csv`, `blueprint.md` and `playbook.md`, and the rows of `questions.csv` for the Core Type being worked on.
- Use the **Generation** or **Audit** prompt from the bottom of `README.md`.
- Tell ChatGPT: "Output as CSV rows with exactly these columns: <paste header line of questions.csv>".

**Step 3 — Put the result in GitHub**
- Make sure the branch dropdown shows your branch (not `main`).
- Open the file (e.g. `chapters/surds-indices/questions.csv`) → pencil icon **Edit** → paste the new rows at the end → **Commit changes** → confirm it commits to your branch.
- New chapter? Copy `chapters/_template/` files into `chapters/<chapter-name>/`.
- Review notes go in the chapter's `reviews.csv` (one row per question checked — see `review-template.csv`).

**Step 4 — Open a Pull Request**
- GitHub shows a yellow bar **Compare & pull request** → click it.
- Title: `<Chapter> — <what this batch adds>` (e.g. `Surds & Indices — 60 Hard cells, draft v1`).
- Description: planned / drafted / reviewed counts, which Core Types, what ChatGPT model, anything unresolved.
- **Create pull request**. Do not merge.

**Step 5 — Ravneet reviews**
- Ravneet opens the PR, reads the diff (GitHub shows CSV changes line by line), comments or approves.
- If changes are needed, Rajat edits the same branch — the PR updates automatically.

**Step 6 — Claude loads to Supabase staging**
- Ravneet tells Claude: "load PR #<n> to staging". Claude copies the exact PR version into the Supabase staging area with the PR number as batch ID.
- Ravneet looks at it once in Supabase. On "approve" Claude moves the batch into the live Questions Universe; the PR gets merged to `main` so GitHub and Supabase match.

## Rules Rajat must follow
- One chapter, one batch, one branch, one PR.
- Never edit `main` directly. Never delete rows — mark `status = rejected` instead.
- Keep the column order exactly as in the CSV header. `id` is blank for new questions (Supabase assigns it); never change an existing `id`.
- `status` for anything new is always `draft`.
- `difficulty_dna` must be one of L0, E1–E4, M1–M5, H1–H5 and must match `difficulty_level` (zero / easy / medium / hard).
- Maths in LaTeX (`$\sqrt{45}$`, `$2^{19}$`), never plain `2^19` or `sqrt(45)`.
- Original AI questions are `source_type = original`; never label one as a CAT PYQ.
- Every review row records who/what reviewed (Rajat, Gemini, ChatGPT model name) — a self-check by the generating model is not an audit.

## Files in this repo
| Path | What it is |
|---|---|
| `README.md` | The handholding guide and master memory — read first, every time |
| `WORKFLOW.md` | This file |
| `review-template.csv` | Header row for review/audit records |
| `chapters/<chapter>/taxonomy.csv` | Frozen Core Types (do not edit without Ravneet) |
| `chapters/<chapter>/blueprint.md` | 15-cell coverage table — what exists, what is missing |
| `chapters/<chapter>/questions.csv` | All candidate questions for the chapter |
| `chapters/<chapter>/reviews.csv` | Review and audit records |
| `chapters/<chapter>/playbook.md` | Chapter playbook / teaching methods |
| `chapters/_template/` | Empty files to copy for a new chapter |
| `chapters/_export-log.md` | When each file was last exported from Supabase |
