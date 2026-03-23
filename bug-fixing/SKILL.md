---
name: bug-fixing
description: Investigate, document, and repair bugs in existing code with a repeatable workflow that creates a bug workspace, records findings, tracks numbered fix attempts, and waits for explicit user confirmation before marking the bug fixed. Use when the user asks to debug, investigate, or fix a bug, defect, regression, failing existing behavior, or a previously documented unresolved bug.
---

# Bug Fixing

## Overview

Use this skill to turn a bug report into a documented repair loop. Keep all bug context under `docs/bugs/NNN-short-name/` so investigation notes, attempt history, and final status stay traceable across retries.

Treat the bug workspace as an append-only record:

- Never delete bug documents or bugfix attempt files that were created for the bug unless the user explicitly asks for that cleanup.
- Never remove mentions of prior attempts from `status.md`, `description.md`, or later attempt files just because a newer attempt exists.
- Never reuse or rename an existing `fix-attempt-XXX.md` file for a different attempt.
- Correct inaccurate notes by appending a clarification or a newer status entry, not by erasing the historical record.
- Treat post-attempt user feedback that says the bug is still broken, lists newly noticed symptoms, or reports regressions in the same screen or flow as continuation of the same bug unless the user clearly describes an unrelated issue.

## Workflow

1. Clarify the bug if the report is incomplete.
2. Create or locate the bug workspace.
3. Create or update the running status file.
4. Record the normalized bug description.
5. Investigate before editing.
6. Create the next fix-attempt file and document the plan.
7. Implement and verify the change.
8. Ask the user to confirm the bug is fixed.
9. Mark the bug fixed or open the next attempt.

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

Additional preservation rules:

- Consider everything under the bug workspace part of the audit trail for that bug.
- Do not delete `description.md`, `initial-findings.md`, `status.md`, or any `fix-attempt-*.md` file during normal iteration.
- If temporary debugging artifacts are worth keeping, store them under the bug workspace and mention them in the current attempt file instead of silently removing them.
- If a follow-up arrives after a fix attempt and it describes additional symptoms, missing UI, layout regressions, or other still-broken behavior in the same feature area, keep using the existing bug workspace instead of opening a new bug by default.

## 3. Create Or Update `status.md`

Create `status.md` as soon as the bug workspace exists, then keep updating the same file throughout the bug lifecycle.

Use it as the durable summary for:

- Current state
- Active attempt
- Most recent update
- Resolution summary
- Attempt history
- State change log

`status.md` must be append-only in spirit:

- Update the current-state fields as the bug progresses.
- Append new attempt-history and state-change entries instead of replacing older ones.
- Preserve references to every prior `fix-attempt-XXX.md`, including failed or superseded attempts.

## 4. Record `description.md`

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

Update it when the bug definition becomes clearer, but do not use it to erase attempt history or final outcomes that belong in `status.md` and the attempt files.

## 5. Investigate Before Fixing

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

If later attempts uncover materially different evidence, add dated updates or note the handoff in the new attempt file instead of rewriting history as if the earlier findings never existed.

## 6. Create The Next `fix-attempt-XXX.md`

Create `fix-attempt-001.md` for the first implementation pass. Increment the suffix for each additional attempt on the same bug.

Each attempt file must contain both the plan and the outcome:

- Attempt status
- Goal of the attempt
- Relation to previous attempts
- Proposed change
- Risks
- Expected verification
- Files or components involved
- Actual implementation summary
- Test and verification results
- Outcome and remaining gaps

Update the same attempt file as the work progresses. Do not split planning and results into separate files.

When a later attempt supersedes an earlier one, leave the earlier file in place and record why it was insufficient.

## 7. Implement And Verify

Fix the bug after the investigation and attempt plan are documented. Verify with the strongest checks available in the current environment.

Prefer:

- Reproduction-based verification
- Automated tests
- Focused regression checks
- Manual validation when automation is not available

Record the results in the current attempt file.

Also update `status.md` after each material milestone such as:

- investigation completed
- attempt started
- verification finished
- awaiting user confirmation
- user confirmed fixed
- user reported still broken

Never delete or collapse earlier status/history entries while doing these updates.

## 8. Ask The User To Confirm

After local verification, ask the user to confirm whether the bug is fixed in their environment or use case.

Do not mark the bug as fixed based only on local confidence.

## 9. Close Or Continue

If the user confirms the repair:

- Create or update `status.md`
- Mark the state as `fixed`
- Record the confirmation date
- Summarize the final resolution
- Preserve the full attempt history and state-change log
- Update `description.md` status only if helpful, without removing historical detail from other files

If the user reports the bug is still present:

- Leave the bug open
- Treat follow-up reports from retesting as the same bug by default when they describe the same feature area, the same user flow, or regressions introduced by the attempted fix
- Create the next numbered `fix-attempt-XXX.md`
- Use the new attempt file even if the user reports symptoms that were not written down before, as long as they are part of the same unresolved bug thread
- Update `status.md` with the failed attempt outcome and the new active attempt
- Only start a new bug workspace when the user clearly reports a separate unrelated issue
- Repeat from investigation, using the previous attempt history to refine the next approach

## Templates

Use these files as starting points when creating bug documents:

- `templates/description.md`
- `templates/initial-findings.md`
- `templates/fix-attempt-template.md`
- `templates/status.md`
