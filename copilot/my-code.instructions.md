---
description: "General coding best practices and guidelines"
---

# Coding Guidelines

## Core Principles

- **Readability first**: Clear, expressive logic over clever tricks
- **Explicit over implicit**: Make intentions obvious
- **Single Responsibility**: Each function/class does one thing well
- **DRY**: Don't Repeat Yourself - avoid code duplication
- **PEP 8 & SOLID**: Follow [PEP 8](https://peps.python.org/pep-0008/) and SOLID design principles
- **TDD**: Write tests for new features and bug fixes
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

## Modern Python Idioms

### List comprehensions

```python
squares = [x**2 for x in range(10)]
evens = [x for x in range(10) if x % 2 == 0]
```

### f-strings

```python
message = f"Hello, {name}! You are {age} years old."
```

### Context managers

```python
with open('file.txt') as f:
    data = f.read()
```

### pathlib over os.path

```python
from pathlib import Path
config_path = Path.home() / ".config" / "app" / "settings.json"
if config_path.exists():
    data = config_path.read_text()
```

### enumerate and zip

```python
for i, item in enumerate(items, start=1):
    print(f"{i}. {item}")

for name, score in zip(names, scores):
    print(f"{name}: {score}")
```

### Modern data structures

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

## Testing

See [Testing Guidelines](./my-tests.instructions.md)

## Documentation

Document code following [Documentation Guidelines](./my-docs.instructions.md).

## Code Quality Checklist

### Before Committing

- [ ] Passes `ruff format` and `ruff check .`
- [ ] Passes `mypy` for type checking
- [ ] Tests pass, coverage ≥ 70% (target: 90%)
- [ ] All public functions have NumPy-style docstrings
- [ ] All functions have type hints
- [ ] No hardcoded secrets
- [ ] Exceptions handled appropriately
- [ ] Important operations logged

### DO

- Write clear, self-documenting code with descriptive names
- Keep functions small (< 50 lines) with single responsibility
- Use modern Python features (f-strings, pathlib, dataclasses)
- Handle errors explicitly with specific exceptions
- Profile before optimizing
- Validate external input
- Use environment variables for secrets

### DON'T

- Use bare `except:` or ignore warnings
- Hardcode secrets or credentials
- Premature optimization or overly complex one-liners
- Copy-paste code instead of refactoring
- Leave commented-out code
- Use `from module import *`
- Mix tabs and spaces

## AI Assistant Guidelines

1. Follow these standards strictly
2. Use modern Python 3.10+ syntax
3. Prioritize readability over cleverness
4. Always include type hints and docstrings
5. Handle errors with specific exceptions
6. Write testable code with separated concerns
7. Never hardcode secrets
8. Profile before optimizing
9. Keep it simple and clear
