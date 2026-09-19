# Debugging Protocol

Reference guide for the OHTF hypothesis-driven debugging cycle defined in AGENTS.md §4.

## The OHTF Cycle

### 1. OBSERVE

Before forming any hypothesis:
- Reproduce the failure or confirm the error.
- Read the actual error message carefully. Copy it exactly.
- Identify the failing component, file, and line if available.
- Check recent changes (git log, git diff) that might be related.

Do not skip observation. Most debugging failures start with an assumed rather than observed error.

### 2. HYPOTHESIZE

Form a falsifiable hypothesis:

> "Component X fails because Y. I will verify this by checking Z."

Rules:
- One hypothesis at a time.
- The hypothesis must be testable with a concrete action.
- State what evidence would disprove it.
- Prefer the simplest explanation first.

### 3. TEST

Run the minimal probe:
- Add a log, inspect a value, run a targeted test, or check a specific condition.
- The test must produce evidence that confirms OR denies the hypothesis.
- Record the actual result.

IF confirmed → proceed to FIX.
IF denied → return to HYPOTHESIZE with the new evidence.

### 4. FIX

Apply the smallest change that resolves the proven root cause:
- Fix the root cause, not the symptom.
- Do not add defensive code around an undiagnosed problem.
- Do not suppress errors to make tests pass.
- Run verification to confirm the fix.

## Failure Budget

| Attempt | Action |
|---|---|
| 1 | Targeted fix based on current evidence |
| 2 | Broaden investigation, new hypothesis |
| 3 | Fundamentally different approach |
| After 3 | STOP. Report evidence. Ask for help. |

## Evidence Collection

For each debugging step, record:
- What was checked
- What was found
- What was concluded
- What remains unknown

## Common Anti-Patterns

| Anti-Pattern | Why It Fails | Correct Approach |
|---|---|---|
| Shotgun patching | Obscures root cause | One hypothesis, one test |
| Error suppression | Hides the bug | Fix the cause, not the symptom |
| Blind retry | No new information | Analyze failure before retrying |
| Scope expansion | Loses focus | Stay on the observed failure |
| Assumed cause | Confirmation bias | Test the hypothesis explicitly |

## Escalation

WHEN the failure budget is exhausted:
1. Document what was tried and what evidence was gathered.
2. State the remaining hypotheses and what would test them.
3. Identify what information or access is missing.
4. Hand off or ask for help with structured context.
