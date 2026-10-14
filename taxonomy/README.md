# Cetking Quant Universe — Master Taxonomy

This directory holds the proposed shared taxonomy for **all Cetking Quant Universe chapters**.

## Source of truth

- `quant-core-types.csv` is the supplied master list of Quant chapters and Core Types.
- Use its chapter and Core Type names consistently when classifying CAT reference questions and creating the Level 0 → Easy → Medium → Hard ladder.
- Keep actual CAT questions in `cat-universe/` as reference records. Do not copy or rewrite the CAT question into the production question bank. Newly created original questions belong in the Quant Universe master bank and should link back to the source CAT record when relevant.
- PDFs, practice sets, and mocks should ultimately draw from the approved Quant Universe master bank, not directly from the CAT or Bible reference banks.

## Ladder rule

For each real CAT reference question, identify the concepts/Core Types it combines, then work backwards:

1. **Level 0** — prerequisite bare idea.
2. **Easy** — one core concept / one main solution engine.
3. **Medium** — two concepts or reasoning steps meet.
4. **Hard** — three concepts or a more complex combination that prepares for the CAT pattern.
5. **CAT level** — the original CAT reference question, preserved untouched in `cat-universe/`.

A harder rung must be more demanding in reasoning, not merely use larger numbers or longer wording. Verify every answer, option set, and solution independently; unresolved questions stay flagged and in draft.

## Important status of this import

This CSV is imported from the taxonomy file supplied for this update. The source uses `UNSPECIFIED IN SOURCE` for every Permanent Core ID, Sub-section, Subchapter, and Mother Core Type. Those values are preserved rather than invented. Therefore, treat this as the shared **taxonomy baseline for review**, not as a claim that all permanent IDs and parent relationships have already been approved or frozen.

Before any taxonomy is frozen or used for a live database migration, Ravneet should review the names, parent relationships, duplicate boundaries, and permanent IDs. Existing chapter-level frozen taxonomies must not be silently overwritten; reconcile them through a reviewed mapping/version change.
