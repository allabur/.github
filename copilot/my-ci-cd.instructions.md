---
description: "CI/CD guidelines and best practices for automated workflows"
---

# CI/CD Guidelines

## Core Principles

When creating or modifying CI/CD pipelines:

- **Automate quality checks** to catch issues early (linting, testing, coverage)
- **Fail fast** on errors, warnings, or coverage drops
- **Use semantic versioning** with conventional commits for releases
- **Never hardcode secrets** - use CI environment variables and secret storage

## Continuous Integration (CI)

Every CI workflow must include:

1. [**Environment Setup**](my-environment.instructions.md)
2. [**Code Quality Checks**](my-code.instructions.md)
3. [**Testing**](my-tests.instructions.md)
4. [**Documentation Build**](my-docs.instructions.md)

Check the following workflow template for reference: `templates/ci.yml`

## Continuous Deployment (CD)

### Branching Strategy: Trunk-Based Development

- Use a single `main` branch for production-ready code
- Developers create short-lived feature branches
- Feature branches are merged back into `main` frequently (at least daily)

### Commits Guidelines: [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification)

- Use instructions from `my-commit-messages.instructions.md` for guidance.

### Release Automation: Semantic Versioning with Python Semantic Release

- **Tool**: [Python Semantic Release](https://python-semantic-release.readthedocs.io/en/latest/index.html) (PSR)
- **Trigger**: Merge to `main` branch
- **Process**:
  1. Analyze commits since last release
  2. Determine version bump (major/minor/patch)
  3. Update version in `pyproject.toml`
  4. Generate/update `CHANGELOG.md`
  5. Create Git tag
  6. Build distributions (sdist + wheel)
  7. Publish to PyPI

### Security:

- **Secrets Management**: Store tokens in CI secrets (e.g., `PYPI_TOKEN`)
- **Never commit**: API keys, passwords, tokens, or credentials
- **Test PyPI First**: Upload to test.pypi.org before production PyPI

## When Generating CI/CD Workflows

**DO**:

- Use official actions from trusted sources
- Pin action versions for reproducibility
- Cache dependencies to speed up builds
- Run linters before tests (fail fast)
- Generate coverage reports
- Use matrix strategy only when testing multiple versions
- Add status badges to README

**DON'T**:

- Skip linting or testing steps
- Ignore coverage thresholds
- Allow warnings to pass silently
- Hardcode secrets or tokens
- Use deprecated actions
- Run unnecessary steps on every trigger

## Workflow Template Structure

- CI: Lint → Test → Coverage → Docs. `templates/ci.yml`
- CD: On `main` merge → Release → Publish. `templates/cd.yml`

## Guiding Principles for AI Assistance

When asked to create or modify CI/CD:

1. **Ask about project context**: Python version, testing framework, deployment target
2. **Follow the structure above**: Environment → Quality → Tests → Deploy
3. **Enforce conventional commits**: Suggest commit message format if missing
4. **Prioritize security**: Remind about secrets management
5. **Keep it simple**: Only add complexity when necessary
6. **Make it maintainable**: Use clear names, comments for non-obvious steps
