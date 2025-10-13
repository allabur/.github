---
description: "CI/CD guidelines and best practices for automated workflows"
applyTo: "**/*"
---

# CI/CD Guidelines

## Core Principles

When creating or modifying CI/CD pipelines:

- **Automate quality checks** to catch issues early (linting, testing, coverage)
- **Fail fast** on errors, warnings, or coverage drops
- **Use semantic versioning** with conventional commits for releases
- **Never hardcode secrets** - use CI environment variables and secret storage

## Continuous Integration (CI)

### Required CI Steps

Every CI workflow must include:

1. **Environment Setup**

   - Use clean base image (Ubuntu latest)
   - Install Python 3.12+ or project-specified version
   - Cache dependencies for faster builds
   - Install dev dependencies: `mamba env create -f environment.yml` or `pip install -r requirements-dev.txt`

2. **Code Quality Checks**

   - **Ruff**: Primary linter and formatter (replaces flake8, black, isort)
   - **mypy**: Type checking in strict mode
   - Treat all warnings as errors (`-W error`)

3. **Testing**

   - Run full test suite: `pytest --cov=<package>`
   - Minimum coverage: 70% (target: 90%)
   - Fail build if coverage drops below threshold
   - Use pytest with strict settings

4. **Documentation Build**
   - Build docs with warnings as errors
   - Verify no broken references or syntax issues

### CI Configuration

- **Location**: `.github/workflows/ci.yml`
- **Triggers**: Pull requests and pushes to main/develop branches
- **Coverage Integration**: Upload to Codecov or Coveralls for tracking

## Continuous Deployment (CD)

### Branching Strategy

- **Git Flow**: Use develop → main branching model
- Releases only from `main` branch
- Feature branches merge to `develop` via pull requests

### Conventional Commits

**MANDATORY** commit message format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types** (affect versioning):

- `feat:` - New feature (minor bump)
- `fix:` - Bug fix (patch bump)
- `perf:` - Performance improvement (patch bump)
- `docs:` - Documentation only (no version bump)
- `test:` - Adding/updating tests (no version bump)
- `build:` - Build system changes (no version bump)
- `ci:` - CI configuration changes (no version bump)
- `refactor:` - Code refactoring (no version bump)
- `style:` - Formatting changes (no version bump)
- `chore:` - Maintenance tasks (no version bump)

**Breaking Changes**:

- Add `!` after type: `feat!:` or `fix!:`
- Include `BREAKING CHANGE:` in footer (triggers major bump)

**Examples**:

```
feat(api): add user authentication endpoint
fix(parser): handle null values in JSON response
docs: update installation instructions
feat!: remove deprecated API v1 endpoints
```

### Release Automation

- **Tool**: Python Semantic Release (PSR)
- **Trigger**: Merge to `main` branch
- **Process**:
  1. Analyze commits since last release
  2. Determine version bump (major/minor/patch)
  3. Update version in `pyproject.toml`
  4. Generate/update `CHANGELOG.md`
  5. Create Git tag
  6. Build distributions (sdist + wheel)
  7. Publish to PyPI

### Security

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

```yaml
name: CI
on: [push, pull_request]
jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: "pip"
      - name: Install dependencies
        run: pip install -e ".[dev]"
      - name: Lint with Ruff
        run: ruff check .
      - name: Type check with mypy
        run: mypy .
      - name: Test with pytest
        run: pytest --cov --cov-report=xml
      - name: Upload coverage
        uses: codecov/codecov-action@v4
```

## Guiding Principles for AI Assistance

When asked to create or modify CI/CD:

1. **Ask about project context**: Python version, testing framework, deployment target
2. **Follow the structure above**: Environment → Quality → Tests → Deploy
3. **Enforce conventional commits**: Suggest commit message format if missing
4. **Prioritize security**: Remind about secrets management
5. **Keep it simple**: Only add complexity when necessary
6. **Make it maintainable**: Use clear names, comments for non-obvious steps
