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

Every CI workflow must include (in order):

1. **Environment Setup**

   - Use clean base image (Ubuntu latest)
   - Install Python 3.10+ (prefer 3.12 or 3.13)
   - Cache dependencies for faster builds: `actions/setup-python@v5` with `cache: 'pip'`
   - Install dependencies: `pip install -e ".[dev]"` or use `mamba env create -f environment.yml`

2. **Code Quality Checks** (Fast feedback - fail early)

   - **Ruff format check**: `ruff format --check .` (verify formatting without changing files)
   - **Ruff lint**: `ruff check .` (comprehensive linting - replaces flake8, isort, pydocstyle)
   - **mypy**: `mypy .` (strict type checking with no warnings)
   - Treat all warnings as errors

3. **Testing** (Only if linting passes)

   - Run full test suite: `pytest --cov=<package> -W error`
   - Minimum coverage: 70% (target: 90%)
   - Fail build if coverage drops below threshold
   - Upload coverage to Codecov/Coveralls

4. **Documentation Build** (Optional but recommended)
   - Build docs with warnings as errors
   - Verify no broken references or syntax issues: `mkdocs build --strict` or `sphinx-build -W`

### CI Configuration

- **Location**: `.github/workflows/ci.yml`
- **Triggers**: Pull requests and pushes to main/develop branches
- **Python versions**: Test on multiple versions (3.10, 3.11, 3.12, 3.13) using matrix strategy
- **Coverage Integration**: Upload to Codecov with `codecov/codecov-action@v4`
- **Caching**: Use `actions/setup-python@v5` with `cache: 'pip'` for dependency caching

### Ruff Configuration

Configure ruff in `pyproject.toml` for consistent behavior:

```toml
[tool.ruff]
# Target Python 3.10+ for modern syntax
target-version = "py310"

# Line length (Black standard)
line-length = 88

# Enable specific rule sets
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "SIM", # flake8-simplify
]

# Ignore specific rules if needed
ignore = []

# Exclude patterns
exclude = [
    ".git",
    "__pycache__",
    ".venv",
    "venv",
    "build",
    "dist",
    "*.egg-info",
]

[tool.ruff.lint.isort]
known-first-party = ["mypackage"]
```

### Mypy Configuration

Configure mypy in `pyproject.toml` for strict type checking:

```toml
[tool.mypy]
python_version = "3.10"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
strict_equality = true
strict = true

# Per-module options (if needed for third-party libraries)
[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
```

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

- Use official actions from trusted sources (GitHub, actions organization)
- Pin action versions for reproducibility (e.g., `@v4`, `@v5`)
- Cache dependencies to speed up builds (`cache: 'pip'` in setup-python)
- Run linters before tests (fail fast on style issues)
- Generate coverage reports and upload to Codecov
- Use matrix strategy to test multiple Python versions
- Add status badges to README
- Configure ruff and mypy in `pyproject.toml` for consistency
- Run tests with warnings as errors (`-W error`)
- Set appropriate coverage thresholds (`--cov-fail-under=70`)
- Use `if: matrix.python-version == '3.12'` to upload coverage once (not for each version)

**DON'T**:

- Skip linting or testing steps
- Ignore coverage thresholds
- Allow warnings to pass silently
- Hardcode secrets or tokens (use `${{ secrets.SECRET_NAME }}`)
- Use deprecated actions
- Run unnecessary steps on every trigger
- Test on Python versions < 3.10 (focus on modern Python)
- Mix different formatting/linting tools (use ruff exclusively)
- Skip type checking (mypy is mandatory)

## Workflow Template Structure

```yaml
name: CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  quality:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12", "3.13"]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: "pip"
      
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -e ".[dev]"
      
      - name: Check formatting with Ruff
        run: ruff format --check .
      
      - name: Lint with Ruff
        run: ruff check .
      
      - name: Type check with mypy
        run: mypy .
      
      - name: Test with pytest
        run: |
          pytest --cov=mypackage --cov-report=xml --cov-report=term-missing -W error
      
      - name: Upload coverage to Codecov
        if: matrix.python-version == '3.12'
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml
          fail_ci_if_error: true
          token: ${{ secrets.CODECOV_TOKEN }}
```

## Guiding Principles for AI Assistance

When asked to create or modify CI/CD:

1. **Ask about project context**: Python version, testing framework, deployment target
2. **Follow the structure above**: Environment → Quality → Tests → Deploy
3. **Enforce conventional commits**: Suggest commit message format if missing
4. **Prioritize security**: Remind about secrets management
5. **Keep it simple**: Only add complexity when necessary
6. **Make it maintainable**: Use clear names, comments for non-obvious steps
