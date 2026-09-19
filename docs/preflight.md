# Preflight Checklist

Run this before starting or delegating work.

## 1. Objective check
- The task is stated in one sentence.
- The expected outcome is clear.
- The acceptance criteria are explicit enough to validate.

## 2. Scope check
- The work is bounded to the relevant files or subsystem.
- The task is not broadening into unrelated cleanup.
- The patch will not touch unrelated user work.

## 3. Evidence check
- Relevant repo evidence was inspected.
- Root cause or requirement was identified before patching.
- Unknowns were stated instead of assumed.

## 4. Safety check
- Existing user changes are protected.
- No destructive or forceful commands are needed.
- Dependencies and side effects are understood.

## 5. Agent routing check
- The primary role matches the job: planner, researcher, fixer, validator, reviewer, or orchestrator.
- The work is not over-distributed across too many agents.
- Parallel work is safe and independent.

## 6. Validation check
- The smallest relevant proof is identified.
- The proof is scoped to the changed behavior.
- The expected result is observable and measurable.

## 7. Stop condition check
- The task has a defined end state.
- A completion decision can be made from evidence.
- The work can stop once validation confirms the outcome.

If any item is missing, pause and resolve it before continuing.
