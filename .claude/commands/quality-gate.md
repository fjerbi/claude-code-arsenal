# Quality Gate

Goal: decide whether the task is ready to stop.

Required checks before completion:
- the user request was understood
- scope stayed bounded
- the patch matches the request
- validation was run and evidence recorded
- no remaining direct blocker is unresolved
- no unrelated user work was touched

Decision:
- pass only when the evidence supports completion
- fail when the result is uncertain or unverified
- return to the root-cause loop if validation fails

Guardrails:
- do not stop early because a patch looks plausible
- do not override evidence with optimism
- do not treat assumptions as proof
