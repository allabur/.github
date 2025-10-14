---
description: "General coding best practices and guidelines"
applyTo: "**/*"
---

# Coding Guidelines

## Core Principles

- **Test-Driven Development (TDD)**: Write tests FIRST, then implement code. Red → Green → Refactor cycle is mandatory
- **Readability first**: Clear, expressive logic over clever tricks
- **Explicit over implicit**: Make intentions obvious
- **Single Responsibility**: Each function/class does one thing well
- **DRY**: Don't Repeat Yourself - avoid code duplication
- **PEP 8 & SOLID**: Follow [PEP 8](https://peps.python.org/pep-0008/) and SOLID design principles
- **Type hints everywhere**: All functions must have complete type annotations (Python 3.10+)
- **No dead code**: Remove unused code (use version control to retrieve if needed)

## Naming Conventions (PEP 8)

| Element         | Convention           | Example                                  |
| --------------- | -------------------- | ---------------------------------------- |
| Package/Module  | lowercase            | `analysis.py`, `mypackage/`              |
| Class           | PascalCase           | `DataProcessor`, `UserAccount`           |
| Function/Method | snake_case           | `process_data()`, `calculate_total()`    |
| Variable        | snake_case           | `file_path`, `max_iter`, `user_count`    |
| Constant        | UPPER_SNAKE_CASE     | `MAX_ROWS = 5000`, `API_URL`             |
| Private         | \_leading_underscore | `_helper_function()`, `_internal_cache`  |
| Boolean         | is*/has*/can\_       | `is_valid`, `has_permission`, `can_edit` |

**Guidelines**: Use descriptive names (verbs for functions, nouns for classes/variables). Avoid abbreviations except well-known ones (`df`, `url`, `api`). Use English consistently

## Code Style & Formatting

- **Indentation**: 4 spaces (no tabs)
- **Line length**: Max 88 characters (Black standard)
- **Blank lines**: 2 between top-level definitions, 1 between methods
- **Trailing commas**: Use in multiline structures
- **String quotes**: Be consistent (prefer double quotes or use Black)
- **Functions**: < 50 lines, single purpose, separate logical blocks with blank lines

## Type Hints (Python 3.10+)

**Required for ALL function signatures** using modern syntax:

```python
# Built-in types (no imports)
def process_data(
    items: list[dict[str, int | str]],
    threshold: float | None = None
) -> tuple[list[str], dict[str, float]]:
    pass

# Special types only
from typing import Callable, Literal, TypeVar

def transform(
    data: list[T],
    func: Callable[[T], str],
    mode: Literal["fast", "slow"] = "fast"
) -> list[str]:
    pass
```

**Rules**: Use `X | Y` (not `Union`), `X | None` (not `Optional`), built-in types (`list` not `List`), match pandas/numpy types (`pd.DataFrame`, `np.ndarray`)

## Import Organization

```python
# 1. Standard library
import os
from pathlib import Path

# 2. Third-party
import pandas as pd
import numpy as np

# 3. Local
from mypackage.utils import helper
```

**Rules**: Sort alphabetically within groups, use absolute imports, avoid `from module import *`, one import per line

## Error Handling

**Principles**: Use specific exceptions, provide context, never fail silently, use custom exceptions when appropriate

**DO**:

```python
try:
    data = load_file(filepath)
except FileNotFoundError:
    logger.error(f"File not found: {filepath}")
    raise
except json.JSONDecodeError as e:
    raise ValueError(f"Cannot parse {filepath}") from e

# Custom exceptions
class DataValidationError(ValueError):
    """Raised when data validation fails."""

# Resource management
with open('file.txt') as f:
    data = f.read()
```

**DON'T**: Use bare `except:`, catch too broadly (`except Exception:`), fail silently (`except: pass`)

## Documentation

### Docstring Standards (NumPy-style)

ALL public functions/classes MUST have docstrings:

```python
def calculate_statistics(
    data: list[float],
    include_median: bool = True
) -> dict[str, float]:
    """Calculate statistical measures for a dataset.

    Parameters
    ----------
    data : list[float]
        Numerical values to analyze.
    include_median : bool, optional
        Whether to include median calculation, by default True.

    Returns
    -------
    dict[str, float]
        Dictionary with keys 'mean', 'std', and optionally 'median'.

    Raises
    ------
    ValueError
        If data is empty or contains non-numeric values.

    Examples
    --------
    >>> calculate_statistics([1, 2, 3, 4, 5])
    {'mean': 3.0, 'std': 1.414, 'median': 3.0}
    """
```

**Required**: Summary, Parameters, Returns. **Recommended**: Raises, Examples, Notes

### Inline Comments

**Use sparingly**: Explain "why" not "what". Keep updated. Use `TODO:`/`FIXME:` tags. Avoid stating the obvious

## Logging & Warnings

Use `logging` module for all application logging:

```python
import logging
logger = logging.getLogger(__name__)

logger.debug("Detailed trace information")
logger.info("User logged in successfully")
logger.warning("API rate limit approaching")
logger.error("Failed to save data to database")
logger.critical("Database connection lost")
```

Use `warnings` for deprecations:

```python
import warnings
warnings.warn("old_function is deprecated", DeprecationWarning, stacklevel=2)
```

In tests: `pytest -W error` or `warnings.filterwarnings("error")`

## Security

### Credentials Management

**NEVER hardcode secrets** - use environment variables or secure vaults:

```python
import os
from dotenv import load_dotenv

load_dotenv()
api_key = os.getenv("API_KEY")
if not api_key:
    raise ValueError("API_KEY environment variable not set")
```

### Input Validation

Always validate and sanitize external input:

```python
def process_user_input(user_data: dict[str, str]) -> dict[str, str]:
    """Process user input with validation."""
    required = ["name", "email"]
    missing = [field for field in required if field not in user_data]
    if missing:
        raise ValueError(f"Missing required fields: {missing}")

    sanitized = {
        "name": user_data["name"].strip()[:100],
        "email": user_data["email"].strip().lower()
    }

    if not validate_email(sanitized["email"]):
        raise ValueError(f"Invalid email: {sanitized['email']}")

    return sanitized
```

**Best practices**: Validate all input, use parameterized queries, avoid `eval()`/`exec()`, keep dependencies updated

## Performance & Optimization

**Don't optimize prematurely** - profile first:

```python
import time
start = time.perf_counter()
result = expensive_operation()
print(f"Took {time.perf_counter() - start:.4f}s")
```

**Key techniques**:

- Algorithmic efficiency: Use O(n) vs O(n²) when possible
- Vectorization: NumPy/pandas operations over loops
- Cache lookups: Avoid repeated dictionary/attribute access
- Use generators for large sequences
- Consider `functools.lru_cache` for expensive functions

```python
# BAD: O(n²)
result = [x for x in list1 for y in list2 if x == y]

# GOOD: O(n)
result = list(set(list1) & set(list2))

# Vectorization
data = np.array(data)
result = data ** 2 + 2 * data + 1  # Better than loop
```

## Testing

Design code to be testable - separate concerns, use dependency injection:

```python
# GOOD: Easy to test
def complex_calculation(data: list[float]) -> float:
    """Pure function - easy to test."""
    return sum(data) / len(data)

def process_and_save(filename: str) -> None:
    """Orchestration - test with mocks."""
    data = load_from_database()
    result = complex_calculation(data)  # Already tested
    save_to_file(filename, result)
```

**Requirements**: Write unit tests for all public functions, test positive and negative cases, use descriptive names, follow AAA pattern (Arrange-Act-Assert), mock external dependencies

**Mocking example**:

```python
from unittest.mock import Mock, patch

def test_api_call_success():
    mock_response = Mock()
    mock_response.json.return_value = {"status": "success"}

    with patch('requests.get', return_value=mock_response):
        result = fetch_data("https://api.example.com")

    assert result["status"] == "success"
```

## Modern Python Idioms

**List comprehensions**:

```python
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]
```

**f-strings**:

```python
message = f"Hello, {name}! You are {age} years old."
```

**Context managers**:

```python
with open('file.txt') as f:
    data = f.read()
```

**pathlib over os.path**:

```python
from pathlib import Path
config_path = Path.home() / ".config" / "app" / "settings.json"
if config_path.exists():
    data = config_path.read_text()
```

**enumerate and zip**:

```python
for i, item in enumerate(items, start=1):
    print(f"{i}. {item}")

for name, score in zip(names, scores):
    print(f"{name}: {score}")
```

**Modern data structures**:

```python
# dataclasses
from dataclasses import dataclass

@dataclass
class User:
    name: str
    email: str
    age: int
    is_active: bool = True

# sets for membership
valid_codes = {"USD", "EUR", "GBP", "JPY"}
if code in valid_codes:  # O(1) lookup
    process(code)

# collections
from collections import defaultdict, Counter
counts = defaultdict(int)
word_counts = Counter(words)
```

## Test-Driven Development (TDD) Workflow

### The Red-Green-Refactor Cycle

When implementing any new feature or fixing any bug, ALWAYS follow this cycle:

#### 1. 🔴 **RED** - Write a Failing Test

```python
# tests/test_calculator.py
def test_add_two_positive_numbers():
    """Test addition of two positive numbers"""
    # Arrange
    calc = Calculator()
    
    # Act
    result = calc.add(2, 3)
    
    # Assert
    assert result == 5
```

Run the test - it MUST fail because the code doesn't exist yet:
```bash
pytest tests/test_calculator.py::test_add_two_positive_numbers  # Should FAIL
```

#### 2. 🟢 **GREEN** - Write Minimal Code to Pass

```python
# src/mypackage/calculator.py
class Calculator:
    def add(self, a: int, b: int) -> int:
        """Add two numbers."""
        return a + b  # Simplest implementation
```

Run the test - it MUST pass:
```bash
pytest tests/test_calculator.py::test_add_two_positive_numbers  # Should PASS
```

#### 3. 🔵 **REFACTOR** - Improve Code Quality

Now that tests pass, refactor for better design:

```python
# src/mypackage/calculator.py
class Calculator:
    """Performs basic arithmetic operations."""
    
    def add(self, a: int | float, b: int | float) -> int | float:
        """Add two numbers.
        
        Parameters
        ----------
        a : int | float
            First number to add.
        b : int | float
            Second number to add.
        
        Returns
        -------
        int | float
            Sum of the two numbers.
        
        Examples
        --------
        >>> calc = Calculator()
        >>> calc.add(2, 3)
        5
        """
        return a + b
```

Run tests again to ensure refactoring didn't break anything:
```bash
pytest tests/test_calculator.py  # Should still PASS
```

#### 4. ♻️ **REPEAT** - Continue the Cycle

Add more test cases and repeat:
```python
def test_add_negative_numbers():
    calc = Calculator()
    assert calc.add(-5, -3) == -8

def test_add_floats():
    calc = Calculator()
    assert calc.add(2.5, 3.7) == 6.2
```

### TDD Best Practices

- **Never write production code without a failing test first**
- **Write the simplest test that could possibly fail**
- **Take small steps** - one test at a time
- **Run tests frequently** - after every change
- **Keep the feedback loop tight** - tests should run in seconds
- **Use descriptive test names** that document behavior
- **Refactor only when tests are green**

### TDD for Bug Fixes

When fixing a bug:

1. **Write a test that reproduces the bug** (it will fail)
2. **Fix the bug** (test should pass)
3. **Refactor** if needed (test should still pass)

```python
def test_divide_by_zero_raises_error():
    """Regression test for issue #42: division by zero crashes"""
    calc = Calculator()
    with pytest.raises(ZeroDivisionError):
        calc.divide(10, 0)
```

## Code Quality Checklist

### Before Writing Production Code

- [ ] Have you written a failing test first? (RED)
- [ ] Does the test clearly specify the expected behavior?
- [ ] Is the test using the AAA pattern (Arrange-Act-Assert)?

### Before Committing

- [ ] All tests pass: `pytest` (GREEN)
- [ ] Code is refactored for clarity and maintainability (REFACTOR)
- [ ] Passes `ruff format .` and `ruff check .` (no errors)
- [ ] Passes `mypy .` in strict mode (no type errors)
- [ ] Test coverage ≥ 70% (target: 90%): `pytest --cov=mypackage`
- [ ] All public functions have NumPy-style docstrings
- [ ] All functions have complete type hints (parameters and return values)
- [ ] No hardcoded secrets or credentials
- [ ] Exceptions handled appropriately
- [ ] Important operations logged
- [ ] No dead code or commented-out code

### DO

- **Follow TDD**: Write tests FIRST, then implement code (Red → Green → Refactor)
- Write clear, self-documenting code with descriptive names
- Keep functions small (< 50 lines) with single responsibility
- Use modern Python features (f-strings, pathlib, dataclasses, pattern matching)
- Handle errors explicitly with specific exceptions
- Profile before optimizing
- Validate external input
- Use environment variables for secrets
- Add type hints to ALL functions (parameters and return values)
- Run `pytest` after every code change to ensure tests still pass

### DON'T

- **Skip TDD**: Never write production code without a failing test first
- Use bare `except:` or ignore warnings
- Hardcode secrets or credentials
- Premature optimization or overly complex one-liners
- Copy-paste code instead of refactoring
- Leave commented-out code or dead code
- Use `from module import *`
- Mix tabs and spaces
- Write code without type hints
- Commit code with failing tests

## AI Assistant Guidelines

1. **ALWAYS follow TDD**: When asked to implement a feature, generate the test FIRST, then the implementation
2. Follow these standards strictly
3. Use modern Python 3.10+ syntax (use `|` for unions, built-in types like `list`, `dict`)
4. Prioritize readability over cleverness
5. Always include complete type hints (parameters and return values) using modern syntax
6. Handle errors with specific exceptions
7. Write testable code with separated concerns
8. Never hardcode secrets
9. Profile before optimizing
10. Keep it simple and clear
11. Generate NumPy-style docstrings for all public functions
12. Run tests after code generation to verify functionality
