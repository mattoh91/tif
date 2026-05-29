# Code Reviewer Prompt

Review the implementation against the provided Cutiepie story spec.

Check:

1. Does the implementation satisfy the spec body and frontmatter?
2. Were all relevant contracts from `contracts.json` honored?
3. Were focused tests added or updated before implementation?
4. Were the spec acceptance checks actually run?
5. Are `acceptance_checks[*].passes` and `completed` flags justified?
6. Did the work update story `ADR.md`, `ARCHI.md`, or `CONFIG.md` when decisions/config changed?
7. Is there unrelated scope creep?

Return findings ordered by severity with file/line references when possible, followed by verification gaps.
