# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with Python projects following the standards defined in this repository.

## Repository Overview

This is a **default `.github` repository** for the `allabur` GitHub account. It contains community health files, AI agent instructions, and reusable workflows that automatically apply to all repositories under this account.

**Key Components:**
- Health Files: CODEOWNERS, PR templates, issue templates
- Reusable Workflows: Shared CI/CD workflows for Python projects
- AI Agent Instructions: Modular guidelines in `/instructions/` for coding, testing, commits, CI/CD, reviews, and docs
- Guidelines: Comprehensive documentation in `/guidelines/` folder
- Chat Modes & Prompts: AI agent personas and reusable prompts

## Development Commands

### Python Projects

Most repositories using these guidelines will be Python projects. Here are common commands:

### Linting and Type Checking
```bash
# Run linter (ruff)
ruff check .
ruff check --fix .                        # Auto-fix issues

# Run type checker (mypy)
mypy --strict src/
```

### Testing
```bash
# Run all tests with pytest
pytest

# Run with coverage report
pytest --cov=mypackage --cov-report=html

# Run specific test file
pytest tests/test_module.py

# Run specific test function
pytest tests/test_module.py::test_function_name
```

### Documentation
```bash
# Build documentation (MkDocs)
mkdocs build --strict

# Serve docs locally
mkdocs serve

# Check docstring coverage
interrogate -v --fail-under=80 src/
```

## Additional Documentation

For comprehensive development information, see:
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Python project architecture patterns and structure
- **[CODING_GUIDELINES.md](CODING_GUIDELINES.md)** - Python coding standards and conventions
- **[CONFIGURATION.md](CONFIGURATION.md)** - Configuration management for Python projects
- **[TESTING_GUIDELINES.md](TESTING_GUIDELINES.md)** - Pytest testing methodology and practices
- **[COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md)** - Commit message standards and best practices
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines for Python projects
- **[copilot-instructions.md](copilot-instructions.md)** - GitHub Copilot context for this repository

## Python Project Architecture

### Project Structure

Python projects following these guidelines typically use this structure:

```
project/
├── src/
│   └── mypackage/           # Source code package
│       ├── __init__.py
│       ├── models/          # Data models
│       ├── services/        # Business logic
│       ├── api/             # API endpoints (if applicable)
│       ├── utils/           # Utility functions
│       └── cli.py           # CLI entry point (if applicable)
├── tests/                   # Test suite (mirrors src structure)
│   ├── __init__.py
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   └── conftest.py         # Pytest fixtures
├── docs/                   # Documentation
│   ├── index.md
│   └── mkdocs.yml
├── scripts/                # Utility scripts
├── .github/                # GitHub configuration
│   └── workflows/          # CI/CD workflows
├── pyproject.toml          # Project metadata and dependencies
├── README.md               # Project overview
└── LICENSE                 # License information
```

### Key Organizational Principles

1. **Package Organization**: Use `src/` layout to avoid import conflicts
2. **Test Organization**: Mirror source structure in `tests/` directory
3. **Configuration**: Use `pyproject.toml` as primary configuration file
4. **Documentation**: Use MkDocs or Sphinx for project documentation

See **[ARCHITECTURE.md](ARCHITECTURE.md)** for detailed architecture patterns.

## Testing Architecture

### Test Structure

Python projects use pytest as the testing framework:

- **Unit Tests**: Test individual functions/methods in isolation
- **Integration Tests**: Test how components work together
- **Fixtures**: Reusable test data and setup via `conftest.py`
- **Parametrized Tests**: Test multiple inputs efficiently with `@pytest.mark.parametrize`

### Test Organization

```
tests/
├── __init__.py
├── unit/                    # Unit tests
│   ├── test_models.py
│   └── test_services.py
├── integration/             # Integration tests
│   └── test_api.py
├── conftest.py              # Pytest fixtures
└── fixtures/                # Test data
```

### Testing Best Practices

- **AAA Pattern**: Arrange, Act, Assert structure for clear tests
- **Descriptive Names**: Use names that explain what's being tested
- **Coverage Goals**: Start with 60%, work toward 75-90%
- **Run Tests Often**: Catch issues early in development

See **[TESTING_GUIDELINES.md](TESTING_GUIDELINES.md)** for detailed testing practices.

## Python Configuration Management

### pyproject.toml

Modern Python projects use `pyproject.toml` as the central configuration file (PEP 518, PEP 621):

```toml
[project]
name = "myproject"
version = "1.0.0"
description = "My Python project"
requires-python = ">=3.10"

dependencies = [
    "fastapi>=0.104.0",
    "pydantic>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]

[tool.ruff]
line-length = 88
target-version = "py310"

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
```

### Environment Variables

Use `.env` files for environment-specific configuration:

```bash
# .env.example
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
API_HOST=0.0.0.0
API_PORT=8000
SECRET_KEY=  # Generate with: openssl rand -hex 32
LOG_LEVEL=INFO
```

See **[CONFIGURATION.md](CONFIGURATION.md)** for complete configuration reference.

## Documentation Requirements

**⚠️ MANDATORY**: Always update documentation when making changes:

- **New features**: Update README.md and relevant guides
- **API changes**: Update docstrings with NumPy-style format
- **Configuration changes**: Update CONFIGURATION.md and examples
- **Breaking changes**: Update CHANGELOG.md and migration guides

### Documentation Standards

- **Docstrings**: Use NumPy-style docstring conventions
- **Type Hints**: Include on all function signatures (Python 3.10+)
- **Examples**: Provide practical examples in docstrings
- **API Docs**: Auto-generate with MkDocs or Sphinx

### Before Committing

Always verify documentation is current:

```bash
# Check docstring coverage
interrogate -v --fail-under=80 src/

# Verify docs build without errors
mkdocs build --strict

# Run linters and type checker
ruff check .
mypy --strict src/
```

## Development Philosophy

Follow these principles when working on Python projects:

- **Readability first**: Clear, expressive code over clever tricks
- **Explicit over implicit**: Make intentions obvious
- **Single Responsibility**: Each function/class does one thing well
- **DRY**: Don't Repeat Yourself - avoid code duplication
- **PEP 8 & SOLID**: Follow Python style guide and design principles
- **TDD**: Write tests for new features and bug fixes

## Python Code Conventions

### Naming Conventions (PEP 8)

| Element         | Convention           | Example                                  |
| --------------- | -------------------- | ---------------------------------------- |
| Package/Module  | lowercase            | `analysis.py`, `mypackage/`              |
| Class           | PascalCase           | `DataProcessor`, `UserAccount`           |
| Function/Method | snake_case           | `process_data()`, `calculate_total()`    |
| Variable        | snake_case           | `file_path`, `max_iter`, `user_count`    |
| Constant        | UPPER_SNAKE_CASE     | `MAX_ROWS = 5000`, `API_URL`             |
| Private         | \_leading_underscore | `_helper_function()`, `_internal_cache`  |

### Error Handling

```python
# Use specific exceptions
def process_file(path: str) -> dict:
    if not os.path.exists(path):
        raise FileNotFoundError(f"File not found: {path}")
    
    try:
        with open(path) as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON in {path}: {e}") from e
```

### Type Hints (Python 3.10+)

```python
from typing import Optional

def calculate_total(
    items: list[dict[str, float]],
    tax_rate: float = 0.0,
) -> float:
    """Calculate total price including tax.
    
    Parameters
    ----------
    items : list[dict[str, float]]
        List of items with 'price' key.
    tax_rate : float, optional
        Tax rate as decimal (e.g., 0.08 for 8%), by default 0.0.
    
    Returns
    -------
    float
        Total price including tax.
    """
    subtotal = sum(item["price"] for item in items)
    return subtotal * (1 + tax_rate)
```

## Commit Guidelines

Follow the project's commit message standards as defined in **[COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md)**:

### Format
```
<type>: <subject>

<body>

<footer>
```

### Types
- **feat**: New feature or functionality
- **fix**: Bug fix or correction
- **refactor**: Code restructuring without changing functionality
- **test**: Adding or modifying tests
- **docs**: Documentation changes
- **style**: Code formatting changes
- **build**: Build system or dependency changes
- **ci**: Continuous integration configuration

### Best Practices
- Use imperative mood in subject (≤50 characters)
- Explain "what" and "why" in body (wrap at 72 characters)
- Reference issues: `Fixes #123`, `Closes #456`
- Keep each commit focused on a single concern

## CI/CD Integration

### GitHub Actions Workflows

Python projects typically use these CI/CD workflows:

```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.10'
      - run: pip install -e ".[dev]"
      - run: ruff check .
      - run: mypy --strict src/
      - run: pytest --cov=mypackage
```

### Semantic Versioning

Use **python-semantic-release** for automated versioning:

- Commit messages determine version bumps
- `feat:` → minor version bump
- `fix:` → patch version bump
- `BREAKING CHANGE:` → major version bump