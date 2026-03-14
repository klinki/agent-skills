---
name: bug-fixing
description: Investigate, document, and repair bugs in existing code with a repeatable workflow that creates a bug workspace, records findings, tracks numbered fix attempts, and waits for explicit user confirmation before marking the bug fixed. Use when the user asks to debug, investigate, or fix a bug, defect, regression, failing existing behavior, or a previously documented unresolved bug.
---

# Bug Fixing

## Overview

Use this skill to turn a bug report into a documented repair loop. Keep all bug context under `docs/bugs/NNN-short-name/` so investigation notes, attempt history, and final status stay traceable across retries.

## Workflow

1. Clarify the bug if the report is incomplete.
2. Create or locate the bug workspace.
3. Record the normalized bug description.
4. Investigate before editing.
5. Create the next fix-attempt file and document the plan.
6. Implement and verify the change.
7. Ask the user to confirm the bug is fixed.
8. Mark the bug fixed or open the next attempt.

## 1. Clarify Before Investigating

If the bug report is vague, ask targeted follow-up questions before creating a fix attempt. Resolve missing facts such as:

- What is supposed to happen versus what actually happens.
- How to reproduce the issue.
- Where the issue appears.
- Whether the bug is new, intermittent, or already partially investigated.

Do not start a fix attempt until the bug is concrete enough to investigate.

## 2. Create Or Locate The Bug Workspace

Store every bug under:

`docs/bugs/NNN-short-name/`

Rules:

- Create `docs/bugs/` if it does not exist.
- Use a 3-digit sequential prefix starting at `001`.
- Find the next number by scanning existing `docs/bugs/` directories and incrementing the highest numeric prefix.
- Generate `short-name` from the bug summary using ASCII only, lowercase words, and hyphens.
- Reuse an existing workspace when the user is continuing work on the same bug.

When creating a new bug workspace, use the templates in `templates/`.

## 3. Record `description.md`

Create or update `description.md` first. Capture:

- Normalized title
- Current status
- Reported symptoms
- Expected behavior
- Actual behavior
- Reproduction details
- Affected area
- Constraints
- Open questions

Keep this file as the canonical intake summary for the bug.

## 4. Investigate Before Fixing

Start with code reading and local context gathering. Use diagnostics only when they materially reduce uncertainty, such as:

- Running focused tests
- Reproducing the issue locally
- Inspecting logs or traces
- Adding temporary debugging instrumentation
- Verifying assumptions with small experiments

Record the investigation in `initial-findings.md`. Document:

- Confirmed facts
- Likely cause
- Unknowns
- Reproduction status
- Evidence gathered

Investigate before proposing a fix. Do not jump straight to code edits.

## 5. Create The Next `fix-attempt-XXX.md`

Create `fix-attempt-001.md` for the first implementation pass. Increment the suffix for each additional attempt on the same bug.

Each attempt file must contain both the plan and the outcome:

- Goal of the attempt
- Proposed change
- Risks
- Expected verification
- Files or components involved
- Actual implementation summary
- Test and verification results
- Outcome and remaining gaps

Update the same attempt file as the work progresses. Do not split planning and results into separate files.

## 6. Implement And Verify

Fix the bug after the investigation and attempt plan are documented. Verify with the strongest checks available in the current environment.

Prefer:

- Reproduction-based verification
- Automated tests
- Focused regression checks
- Manual validation when automation is not available

Record the results in the current attempt file.

## 7. Ask The User To Confirm

After local verification, ask the user to confirm whether the bug is fixed in their environment or use case.

Do not mark the bug as fixed based only on local confidence.

## 8. Close Or Continue

If the user confirms the repair:

- Create or update `status.md`
- Mark the state as `fixed`
- Record the confirmation date
- Summarize the final resolution

If the user reports the bug is still present:

- Leave the bug open
- Create the next numbered `fix-attempt-XXX.md`
- Repeat from investigation, using the previous attempt history to refine the next approach

## Templates

Use these files as starting points when creating bug documents:

- `templates/description.md`
- `templates/initial-findings.md`
- `templates/fix-attempt-template.md`
- `templates/status.md`
