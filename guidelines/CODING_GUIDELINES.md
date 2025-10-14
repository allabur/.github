# Python Coding Guidelines

## Code Style

Follow PEP 8 and use Ruff for linting and formatting.

### Ruff Configuration

```toml
# pyproject.toml
[tool.ruff]
line-length = 88
target-version = "py310"
src = ["src"]

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "A",   # flake8-builtins
    "C4",  # flake8-comprehensions
    "DTZ", # flake8-datetimez
    "T10", # flake8-debugger
    "EM",  # flake8-errmsg
    "ISC", # flake8-implicit-str-concat
    "ICN", # flake8-import-conventions
    "PIE", # flake8-pie
    "PT",  # flake8-pytest-style
    "Q",   # flake8-quotes
    "RSE", # flake8-raise
    "RET", # flake8-return
    "SIM", # flake8-simplify
    "TID", # flake8-tidy-imports
    "ARG", # flake8-unused-arguments
    "ERA", # eradicate
    "PD",  # pandas-vet
    "PGH", # pygrep-hooks
    "PL",  # pylint
    "TRY", # tryceratops
    "NPY", # numpy
    "RUF", # ruff-specific
]

ignore = [
    "E501",   # line too long (handled by formatter)
    "PLR0913", # too many arguments
    "PLR2004", # magic value used in comparison
]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = [
    "S101",   # assert used
    "PLR2004", # magic values in tests are fine
]

[tool.ruff.lint.isort]
known-first-party = ["myapp"]

[tool.ruff.lint.pydocstyle]
convention = "google"
```

## Type Hints

Use modern Python 3.10+ type hint syntax.

### Basic Types

```python
# Modern Python 3.10+
def process(
    name: str,
    age: int,
    score: float,
    is_active: bool,
) -> None:
    """Process user data."""
    ...

# Collections
def analyze(
    items: list[str],
    mapping: dict[str, int],
    unique: set[int],
    coordinates: tuple[float, float],
) -> list[dict[str, Any]]:
    """Analyze data."""
    ...
```

### Union Types

```python
# DO: Use | for unions (Python 3.10+)
def get_user(user_id: int) -> User | None:
    """Get user by ID."""
    ...

def parse_value(value: str | int | float) -> float:
    """Parse numeric value."""
    return float(value)

# DON'T: Use typing.Union or typing.Optional
from typing import Union, Optional

def get_user(user_id: int) -> Optional[User]:  # Wrong
    ...

def parse_value(value: Union[str, int, float]) -> float:  # Wrong
    ...
```

### Generics

```python
from typing import TypeVar, Generic
from collections.abc import Callable, Sequence, Mapping

T = TypeVar("T")
K = TypeVar("K")
V = TypeVar("V")

# Generic class
class Cache(Generic[K, V]):
    """Generic cache implementation."""
    
    def __init__(self) -> None:
        self._data: dict[K, V] = {}
    
    def get(self, key: K) -> V | None:
        """Get value by key."""
        return self._data.get(key)
    
    def set(self, key: K, value: V) -> None:
        """Set value for key."""
        self._data[key] = value

# Generic function
def first(items: Sequence[T]) -> T | None:
    """Get first item from sequence."""
    return items[0] if items else None

# Callable types
def apply(func: Callable[[int], str], value: int) -> str:
    """Apply function to value."""
    return func(value)
```

### Type Aliases

```python
# Simple aliases
UserId = int
EmailAddress = str
JsonDict = dict[str, Any]

# Complex aliases
from collections.abc import Callable

ProcessorFunc = Callable[[str], int]
ResultMapping = dict[str, list[tuple[int, float]]]

# Usage
def get_user_id(email: EmailAddress) -> UserId:
    """Get user ID from email."""
    ...

def process_data(data: JsonDict) -> ResultMapping:
    """Process JSON data."""
    ...
```

### Protocol Classes

```python
from typing import Protocol

class Drawable(Protocol):
    """Protocol for drawable objects."""
    
    def draw(self) -> None:
        """Draw the object."""
        ...
    
    def get_bounds(self) -> tuple[int, int, int, int]:
        """Get bounding box."""
        ...

# Any class implementing these methods satisfies the protocol
class Circle:
    """Circle that can be drawn."""
    
    def draw(self) -> None:
        print("Drawing circle")
    
    def get_bounds(self) -> tuple[int, int, int, int]:
        return (0, 0, 100, 100)

def render(obj: Drawable) -> None:
    """Render any drawable object."""
    obj.draw()
```

## Naming Conventions

```python
# Modules and packages: lowercase with underscores
# my_module.py
# my_package/

# Classes: PascalCase
class UserAccount:
    pass

# Functions and methods: snake_case
def calculate_total(items: list[Item]) -> float:
    pass

# Variables: snake_case
user_count = 10
total_amount = 150.50

# Constants: UPPER_SNAKE_CASE
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30
API_BASE_URL = "https://api.example.com"

# Private attributes: leading underscore
class MyClass:
    def __init__(self) -> None:
        self._private_attr = "value"
    
    def _private_method(self) -> None:
        pass

# Type variables: PascalCase
T = TypeVar("T")
KeyType = TypeVar("KeyType")
```

## Code Organization

### Imports

```python
"""Module docstring."""

from __future__ import annotations  # If needed for forward references

# Standard library imports
import json
import logging
import sys
from pathlib import Path
from typing import Any

# Third-party imports
import numpy as np
import pandas as pd
import requests
from pydantic import BaseModel

# Local imports
from .models import User
from .utils import helper_function

# Type checking imports (not used at runtime)
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from .other_module import OtherClass
```

### Module Structure

```python
"""Module docstring explaining purpose."""

# Imports
...

# Module-level constants
LOGGER = logging.getLogger(__name__)
DEFAULT_CONFIG = {"timeout": 30}

# Type aliases
JsonDict = dict[str, Any]

# Exception classes
class ModuleError(Exception):
    """Module-specific error."""
    pass

# Public classes
class MainClass:
    """Main class."""
    pass

# Public functions
def public_function() -> None:
    """Public function."""
    pass

# Private functions
def _private_helper() -> None:
    """Private helper function."""
    pass
```

## Functions

### Function Guidelines

```python
def calculate_statistics(
    data: Sequence[float],
    *,
    precision: int = 2,
    include_median: bool = True,
) -> dict[str, float]:
    """Calculate statistical metrics for numeric data.
    
    Computes mean, standard deviation, and optionally median
    for the provided data sequence.
    
    Args:
        data: Sequence of numeric values to analyze.
        precision: Number of decimal places for rounding (default: 2).
        include_median: Whether to include median in results (default: True).
        
    Returns:
        Dictionary containing calculated metrics:
        - mean: Average value
        - std: Standard deviation
        - median: Median value (if include_median is True)
        
    Raises:
        ValueError: If data sequence is empty.
        
    Example:
        >>> stats = calculate_statistics([1.0, 2.0, 3.0, 4.0, 5.0])
        >>> stats["mean"]
        3.0
    """
    if not data:
        raise ValueError("Cannot calculate statistics for empty data")
    
    import statistics
    
    result = {
        "mean": round(statistics.mean(data), precision),
        "std": round(statistics.stdev(data), precision),
    }
    
    if include_median:
        result["median"] = round(statistics.median(data), precision)
    
    return result
```

### Keyword-Only Arguments

Use `*` to enforce keyword-only arguments for clarity:

```python
# Good: Forces caller to use keywords
def create_user(
    username: str,
    *,
    email: str,
    age: int | None = None,
    is_active: bool = True,
) -> User:
    """Create user with required keywords."""
    ...

# Usage
user = create_user("john", email="john@example.com", age=30)

# Bad: All positional can be confusing
def create_user(username: str, email: str, age: int | None = None, is_active: bool = True) -> User:
    ...

# Confusing usage
user = create_user("john", "john@example.com", None, False)
```

## Classes

### Dataclasses

Use dataclasses for data structures:

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    """User data class."""
    
    id: int
    username: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)
    tags: list[str] = field(default_factory=list)
    
    def __post_init__(self) -> None:
        """Validate after initialization."""
        if not self.username:
            raise ValueError("Username cannot be empty")
        if "@" not in self.email:
            raise ValueError("Invalid email format")
```

### Properties

```python
class Temperature:
    """Temperature with Celsius and Fahrenheit conversion."""
    
    def __init__(self, celsius: float) -> None:
        self._celsius = celsius
    
    @property
    def celsius(self) -> float:
        """Get temperature in Celsius."""
        return self._celsius
    
    @celsius.setter
    def celsius(self, value: float) -> None:
        """Set temperature in Celsius."""
        if value < -273.15:
            raise ValueError("Temperature below absolute zero")
        self._celsius = value
    
    @property
    def fahrenheit(self) -> float:
        """Get temperature in Fahrenheit."""
        return self._celsius * 9/5 + 32
    
    @fahrenheit.setter
    def fahrenheit(self, value: float) -> None:
        """Set temperature in Fahrenheit."""
        self.celsius = (value - 32) * 5/9
```

### Class Methods and Static Methods

```python
from datetime import datetime

class User:
    """User class with factory methods."""
    
    def __init__(self, id: int, username: str, email: str) -> None:
        self.id = id
        self.username = username
        self.email = email
    
    @classmethod
    def from_dict(cls, data: dict[str, Any]) -> User:
        """Create user from dictionary."""
        return cls(
            id=data["id"],
            username=data["username"],
            email=data["email"],
        )
    
    @staticmethod
    def is_valid_email(email: str) -> bool:
        """Check if email is valid."""
        return "@" in email and "." in email
```

## Error Handling

```python
# Specific exceptions
def divide(a: float, b: float) -> float:
    """Divide two numbers."""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b

# Exception chaining
def load_config(path: Path) -> dict[str, Any]:
    """Load configuration from file."""
    try:
        content = path.read_text()
        return json.loads(content)
    except FileNotFoundError:
        raise ConfigError(f"Config file not found: {path}") from None
    except json.JSONDecodeError as e:
        raise ConfigError(f"Invalid JSON in config: {e}") from e

# Context managers for cleanup
from contextlib import contextmanager

@contextmanager
def database_connection(url: str):
    """Context manager for database connection."""
    conn = connect(url)
    try:
        yield conn
    finally:
        conn.close()

# Usage
with database_connection("postgresql://...") as conn:
    conn.execute("SELECT * FROM users")
```

## Pattern Matching

Use pattern matching for complex conditionals (Python 3.10+):

```python
def handle_command(command: dict[str, Any]) -> str:
    """Handle command based on type."""
    match command:
        case {"action": "create", "resource": resource, "data": data}:
            return create_resource(resource, data)
        case {"action": "update", "id": id, "data": data}:
            return update_resource(id, data)
        case {"action": "delete", "id": id}:
            return delete_resource(id)
        case {"action": "list", "resource": resource}:
            return list_resources(resource)
        case _:
            raise ValueError(f"Unknown command: {command}")

def process_response(status: int, body: str) -> str:
    """Process HTTP response."""
    match status:
        case 200:
            return f"Success: {body}"
        case 400 | 422:
            return f"Client error: {body}"
        case 401 | 403:
            return "Authentication/Authorization error"
        case 404:
            return "Not found"
        case 500:
            return "Server error"
        case _:
            return f"Unknown status {status}"
```

## Best Practices

### Use pathlib

```python
from pathlib import Path

# Good
def read_file(path: Path) -> str:
    """Read file content."""
    return path.read_text(encoding="utf-8")

def ensure_directory(path: Path) -> None:
    """Ensure directory exists."""
    path.mkdir(parents=True, exist_ok=True)

# Bad
import os

def read_file(path: str) -> str:
    with open(path) as f:
        return f.read()
```

### Use f-strings

```python
# Good
name = "Alice"
age = 30
message = f"Hello, {name}! You are {age} years old."

# Bad
message = "Hello, {}! You are {} years old.".format(name, age)
message = "Hello, %s! You are %d years old." % (name, age)
```

### Use comprehensions appropriately

```python
# Good: Simple and readable
squares = [x**2 for x in range(10)]
evens = [x for x in numbers if x % 2 == 0]

# Good: Dictionary comprehension
word_lengths = {word: len(word) for word in words}

# Bad: Too complex
result = [
    process(item)
    for sublist in data
    for item in sublist
    if item.is_valid() and item.score > threshold
]

# Better: Break it down
valid_items = (
    item
    for sublist in data
    for item in sublist
    if item.is_valid() and item.score > threshold
)
result = [process(item) for item in valid_items]
```

### Avoid mutable default arguments

```python
# Bad
def add_item(item: str, items: list[str] = []) -> list[str]:
    items.append(item)
    return items

# Good
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items
```

## Documentation

See `/instructions/my-docs.instructions.md` for detailed documentation guidelines.

Quick reference:

```python
def function_name(
    param1: type1,
    param2: type2,
) -> return_type:
    """Short one-line summary.
    
    Longer description if needed, explaining the purpose
    and behavior in detail.
    
    Args:
        param1: Description of param1.
        param2: Description of param2.
        
    Returns:
        Description of return value.
        
    Raises:
        ValueError: When something goes wrong.
        
    Example:
        >>> result = function_name(value1, value2)
        >>> print(result)
        expected output
    """
```

## References

- [PEP 8](https://peps.python.org/pep-0008/) - Style Guide for Python Code
- [PEP 257](https://peps.python.org/pep-0257/) - Docstring Conventions
- [PEP 484](https://peps.python.org/pep-0484/) - Type Hints
- [PEP 604](https://peps.python.org/pep-0604/) - Union Types with |
- See `/instructions/my-code.instructions.md` for detailed coding standards
- See `/instructions/python.instructions.md` for Python best practices
