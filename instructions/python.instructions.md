# Python Project Instructions

## Overview

These instructions provide general guidance for Python projects (Python 3.10+) following modern best practices.

## Python Version

- **Minimum**: Python 3.10
- **Recommended**: Python 3.11 or 3.12
- Use modern syntax features:
  - Type hints with `|` for unions (not `typing.Union`)
  - `match`/`case` statements where appropriate
  - Structural pattern matching
  - Parameter specification variables

## Project Structure

```
project-root/
├── src/
│   └── package_name/
│       ├── __init__.py
│       ├── module.py
│       └── subpackage/
│           └── __init__.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py
│   └── test_module.py
├── docs/
│   ├── conf.py
│   └── index.md
├── pyproject.toml
├── README.md
├── .gitignore
└── environment.yml (optional, for conda)
```

## Dependencies Management

### Using pyproject.toml (Recommended)

```toml
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "package-name"
version = "0.1.0"
description = "A Python package"
requires-python = ">=3.10"
dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]
docs = [
    "mkdocs>=1.5.0",
    "mkdocs-material>=9.0.0",
]

[tool.ruff]
line-length = 88
target-version = "py310"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP", "B", "A", "C4", "DTZ", "T10", "EM", "ISC", "ICN", "PIE", "PT", "Q", "RSE", "RET", "SIM", "TID", "ARG", "ERA", "PD", "PGH", "PL", "TRY", "NPY", "RUF"]

[tool.mypy]
python_version = "3.10"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
```

## Code Style

- Follow PEP 8 conventions
- Use Ruff for linting and formatting (replaces Black, isort, flake8, etc.)
- Line length: 88 characters (Black default)
- Use type hints for all public APIs
- Use docstrings (Google or NumPy style)

## Type Hints

```python
# Modern Python 3.10+ syntax
from collections.abc import Sequence

def process_items(items: list[str] | None = None) -> dict[str, int]:
    """Process items and return count mapping.
    
    Args:
        items: List of items to process, or None for empty list.
        
    Returns:
        Dictionary mapping item names to counts.
    """
    if items is None:
        items = []
    return {item: len(item) for item in items}

# Generic types
from typing import TypeVar, Generic

T = TypeVar("T")

class Container(Generic[T]):
    def __init__(self, value: T) -> None:
        self.value = value
    
    def get(self) -> T:
        return self.value
```

## Testing

- Use pytest for testing
- Aim for >80% code coverage
- Place tests in `tests/` directory mirroring src structure
- Use `conftest.py` for shared fixtures

## Documentation

- Use docstrings for all public modules, classes, functions
- Generate docs with MkDocs or Sphinx
- Keep README.md up to date with installation and usage

## CI/CD

- Run tests on multiple Python versions (3.10, 3.11, 3.12)
- Check code with Ruff and mypy
- Measure coverage with pytest-cov
- Use GitHub Actions for automation

## Virtual Environments

```bash
# Using venv (built-in)
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
.venv\Scripts\activate     # Windows

# Using conda
conda env create -f environment.yml
conda activate myenv
```

## Common Commands

```bash
# Install package in development mode
pip install -e ".[dev]"

# Run tests
pytest

# Run tests with coverage
pytest --cov=src --cov-report=html

# Lint and format
ruff check .
ruff format .

# Type check
mypy src/

# Build documentation
mkdocs serve
```

## Best Practices

1. **Use absolute imports** in production code
2. **Avoid mutable default arguments**
3. **Use context managers** for resource management
4. **Prefer composition over inheritance**
5. **Keep functions small and focused**
6. **Write self-documenting code** with clear names
7. **Use pathlib** for file system operations
8. **Handle exceptions appropriately** (don't use bare except)
9. **Use logging** instead of print statements
10. **Keep dependencies up to date** and minimal

## Security

- Never commit secrets or credentials
- Use environment variables for sensitive data
- Keep dependencies updated for security patches
- Use tools like `pip-audit` or `safety` to check for vulnerabilities
