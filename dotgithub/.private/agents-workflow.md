# Issue → Agent → PR workflow (VS Code-first)

This repo is ready for both Agent mode (in-editor) and Coding agent (cloud) workflows.

## When to use which
- Agent mode (editor): interactive, smaller steps, iterate locally.
- Coding agent (cloud): well-defined tasks you want to end in an autonomous PR.

## Hand-off options
- From GitHub PRs & Issues view: right-click Issue → Assign to Copilot (coding agent creates a PR).
- From Chat: Delegate to coding agent (experimental) to run in background.

## Review and iterate
- Use the PR template checklist.
- Ask for changes by mentioning @copilot in PR comments; the agent updates the PR.

## CI gates
- CI runs lint/type/tests on PRs.
- CodeQL runs weekly and on PR.
- Protect main/dev to require green checks (set this in repo settings).

## Labels and queries
- Conventional labels (type:feature/bug/refactor/docs/test/chore), status:* and by:copilot.
- VS Code shows a “Copilot on my behalf” PR list via saved queries.

## Issue templates (DoD-ready)
- Feature: context, proposal, constraints, non-goals, acceptance criteria, test plan.
- Bug: repro, expected/actual, severity, environment, constraints.
- Refactor: scope, risks, acceptance, non-goals.

## Tips
- Keep Issues ≤ 1 day of agent work and avoid cross-repo tasks.
- Prefer clear acceptance criteria and a minimal test plan.
- Use Conventional Commits in PR titles.
