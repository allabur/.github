# GitHub Copilot Instructions

This document provides GitHub Copilot with essential context for working with Python projects following the standards in this repository.

## Quick Reference

This `.github` repository defines standards for Python projects under the `allabur` account:

- **Unified Python architecture** - Standard project structure with src/ layout
- **Configuration-driven workflows** - Behavior defined via pyproject.toml
- **Modern Python practices** - Python 3.10+, type hints, PEP 8, pytest
- **Documentation-first philosophy** - NumPy-style docstrings, MkDocs/Sphinx

## Essential Patterns

### Development Commands

```bash
# Linting and formatting
ruff check .                                  # Check for issues
ruff check --fix .                           # Auto-fix issues

# Type checking
mypy --strict src/                           # Static type checking

# Testing
pytest                                       # Run all tests
pytest --cov=mypackage --cov-report=html    # With coverage

# Documentation
mkdocs build --strict                        # Build documentation
interrogate -v --fail-under=80 src/         # Check docstring coverage
```

### Python Code Structure

```python
# Type hints and docstrings pattern
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
    
    Examples
    --------
    >>> items = [{"price": 10.0}, {"price": 20.0}]
    >>> calculate_total(items, 0.08)
    32.4
    """
    subtotal = sum(item["price"] for item in items)
    return subtotal * (1 + tax_rate)

# Error handling pattern
def process_file(path: str) -> dict:
    """Process a JSON file and return its contents."""
    if not os.path.exists(path):
        raise FileNotFoundError(f"File not found: {path}")
    
    try:
        with open(path) as f:
            return json.load(f)
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON in {path}: {e}") from e
```

## Key Files and Locations

### Documentation (Complete Reference)

- **[CLAUDE.md](CLAUDE.md)** - Complete development guide for Python projects
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Python project architecture patterns
- **[CODING_GUIDELINES.md](CODING_GUIDELINES.md)** - Python coding standards (PEP 8, type hints)
- **[CONFIGURATION.md](CONFIGURATION.md)** - Configuration with pyproject.toml and .env files
- **[TESTING_GUIDELINES.md](TESTING_GUIDELINES.md)** - Pytest testing practices
- **[COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md)** - Conventional commits format
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution workflow

### Python Project Structure

```
project/
├── src/
│   └── mypackage/           # Source code package
│       ├── __init__.py
│       ├── models/          # Data models
│       ├── services/        # Business logic
│       ├── api/             # API endpoints
│       └── utils/           # Utilities
├── tests/                   # Test suite
│   ├── unit/               # Unit tests
│   ├── integration/        # Integration tests
│   └── conftest.py         # Pytest fixtures
├── docs/                   # Documentation
├── .github/
│   └── workflows/          # CI/CD workflows
├── pyproject.toml          # Configuration
└── README.md
```

## Mandatory Development Requirements

When making changes, you **MUST always**:

1. **Add type hints** to all function signatures (Python 3.10+)
2. **Write NumPy-style docstrings** for public functions and classes
3. **Create/update tests** using pytest (AAA pattern)
4. **Run quality checks**: `ruff check .` and `mypy --strict src/`
5. **Verify tests pass**: `pytest --cov=mypackage`
6. **Update documentation** for user-facing changes

## Python Configuration

### pyproject.toml Structure

```toml
[project]
name = "myproject"
version = "1.0.0"
description = "My Python project"
requires-python = ">=3.10"

dependencies = [
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
select = ["E", "F", "I", "N", "UP"]

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = ["--cov=mypackage", "-v"]
```

## Critical Implementation Notes

1. **Type hints everywhere**: Use Python 3.10+ syntax (`list[str]`, `dict[str, int]`, `X | None`)
2. **NumPy docstrings**: All public APIs must have complete docstrings
3. **AAA test pattern**: Arrange, Act, Assert structure for tests
4. **Specific exceptions**: Use appropriate exception types with clear messages
5. **PEP 8 compliance**: Follow naming conventions and style guide

## Testing with Pytest

### Test Structure

```python
# tests/test_calculator.py
import pytest
from mypackage.calculator import calculate_total

def test_calculate_total_with_tax():
    """Test total calculation with tax applied."""
    # Arrange
    items = [{"price": 10.0}, {"price": 20.0}]
    tax_rate = 0.08
    
    # Act
    result = calculate_total(items, tax_rate)
    
    # Assert
    assert result == 32.4

@pytest.mark.parametrize("items,tax_rate,expected", [
    ([{"price": 10.0}], 0.0, 10.0),
    ([{"price": 10.0}], 0.10, 11.0),
    ([{"price": 10.0}, {"price": 20.0}], 0.08, 32.4),
])
def test_calculate_total_parametrized(items, tax_rate, expected):
    """Test multiple scenarios with parametrization."""
    result = calculate_total(items, tax_rate)
    assert result == expected
```

### Fixtures

```python
# tests/conftest.py
import pytest

@pytest.fixture
def sample_items():
    """Provide sample items for testing."""
    return [
        {"name": "Widget", "price": 10.0},
        {"name": "Gadget", "price": 20.0},
    ]

def test_with_fixture(sample_items):
    """Test using fixture data."""
    result = calculate_total(sample_items)
    assert result == 30.0
```

## Integration Points

- **GitHub Actions**: CI/CD workflows in `.github/workflows/`
- **Python Semantic Release**: Automated versioning from commit messages
- **MkDocs/Sphinx**: Documentation generation from docstrings
- **pytest-cov**: Code coverage reporting

---

**For complete details, see [CLAUDE.md](CLAUDE.md)** which contains the full development guide.