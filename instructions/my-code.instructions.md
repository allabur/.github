# My Python Coding Instructions

## Code Style and Formatting

### Ruff Configuration

Use Ruff as the primary linter and formatter:

```bash
# Format code
ruff format .

# Check for issues
ruff check .

# Fix auto-fixable issues
ruff check --fix .
```

### Type Checking with mypy

All code must pass mypy strict mode:

```bash
mypy src/
```

Configuration in `pyproject.toml`:

```toml
[tool.mypy]
python_version = "3.10"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_generics = true
disallow_subclassing_any = true
disallow_untyped_calls = true
disallow_untyped_decorators = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
```

## Modern Python Syntax (3.10+)

### Type Hints

**DO:**
```python
from collections.abc import Callable, Sequence, Mapping

def process(
    data: dict[str, int],
    callback: Callable[[int], str] | None = None,
) -> list[str]:
    """Process data with optional callback."""
    ...
```

**DON'T:**
```python
from typing import Dict, List, Optional, Union, Callable

def process(
    data: Dict[str, int],
    callback: Optional[Union[Callable[[int], str], None]] = None,
) -> List[str]:
    """Process data with optional callback."""
    ...
```

### Error Handling

**DO:**
```python
def read_config(path: str) -> dict[str, str]:
    """Read configuration from file."""
    try:
        with open(path) as f:
            return json.load(f)
    except FileNotFoundError:
        logger.warning("Config file not found: %s", path)
        return {}
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON in config: {e}") from e
```

**DON'T:**
```python
def read_config(path: str) -> dict[str, str]:
    try:
        with open(path) as f:
            return json.load(f)
    except:  # Too broad
        return {}
```

### Pattern Matching

Use `match`/`case` for complex conditionals:

```python
def handle_response(response: dict[str, Any]) -> str:
    """Handle API response."""
    match response:
        case {"status": "success", "data": data}:
            return f"Success: {data}"
        case {"status": "error", "message": msg}:
            raise APIError(msg)
        case _:
            raise ValueError("Unknown response format")
```

## Code Organization

### Module Structure

```python
"""Module docstring explaining purpose.

Longer description if needed, including usage examples.
"""

from __future__ import annotations  # If needed for forward references

# Standard library imports
import logging
import sys
from pathlib import Path

# Third-party imports
import requests
from pydantic import BaseModel

# Local imports
from .utils import helper_function

# Module constants
LOGGER = logging.getLogger(__name__)
DEFAULT_TIMEOUT = 30

# Type aliases
JsonDict = dict[str, Any]

# Classes and functions
...
```

### Function Guidelines

- Keep functions small (< 50 lines)
- One clear purpose per function
- Type hints for all parameters and return values
- Docstrings for all public functions

```python
def calculate_metrics(
    data: Sequence[float],
    *,
    precision: int = 2,
    include_median: bool = True,
) -> dict[str, float]:
    """Calculate statistical metrics for data.
    
    Args:
        data: Sequence of numeric values.
        precision: Decimal places for rounding (default: 2).
        include_median: Whether to include median in results (default: True).
        
    Returns:
        Dictionary with calculated metrics (mean, std, optionally median).
        
    Raises:
        ValueError: If data is empty.
    """
    if not data:
        raise ValueError("Cannot calculate metrics for empty data")
    
    result = {
        "mean": round(statistics.mean(data), precision),
        "std": round(statistics.stdev(data), precision),
    }
    
    if include_median:
        result["median"] = round(statistics.median(data), precision)
    
    return result
```

### Class Guidelines

- Use dataclasses or Pydantic models for data structures
- Implement `__repr__` for debugging
- Use properties for computed values
- Keep inheritance shallow

```python
from dataclasses import dataclass, field

@dataclass
class Config:
    """Application configuration."""
    
    name: str
    version: str
    debug: bool = False
    features: list[str] = field(default_factory=list)
    
    def __post_init__(self) -> None:
        """Validate configuration after initialization."""
        if not self.name:
            raise ValueError("Name cannot be empty")
```

## Documentation

### Docstring Style

Use Google style docstrings:

```python
def fetch_data(
    url: str,
    timeout: int = 30,
    headers: dict[str, str] | None = None,
) -> dict[str, Any]:
    """Fetch JSON data from URL.
    
    Makes an HTTP GET request and returns parsed JSON response.
    
    Args:
        url: The URL to fetch data from.
        timeout: Request timeout in seconds (default: 30).
        headers: Optional HTTP headers to include.
        
    Returns:
        Parsed JSON response as dictionary.
        
    Raises:
        requests.RequestException: If request fails.
        ValueError: If response is not valid JSON.
        
    Example:
        >>> data = fetch_data("https://api.example.com/data")
        >>> print(data["status"])
        ok
    """
    ...
```

## Logging

Use the logging module, not print:

```python
import logging

logger = logging.getLogger(__name__)

def process_file(path: Path) -> None:
    """Process a file."""
    logger.info("Processing file: %s", path)
    
    try:
        # Process
        logger.debug("File size: %d bytes", path.stat().st_size)
    except Exception as e:
        logger.error("Failed to process %s: %s", path, e, exc_info=True)
        raise
    else:
        logger.info("Successfully processed: %s", path)
```

## Common Patterns

### Context Managers

```python
from contextlib import contextmanager
from typing import Generator

@contextmanager
def temporary_setting(name: str, value: Any) -> Generator[None, None, None]:
    """Temporarily set a configuration value."""
    old_value = config.get(name)
    config.set(name, value)
    try:
        yield
    finally:
        config.set(name, old_value)
```

### Resource Management

```python
from pathlib import Path

def read_data(path: Path) -> str:
    """Read data from file."""
    # Prefer pathlib
    return path.read_text(encoding="utf-8")

def write_data(path: Path, content: str) -> None:
    """Write data to file."""
    path.write_text(content, encoding="utf-8")
```

## Performance Considerations

- Use generators for large sequences
- Prefer list comprehensions over map/filter
- Use `__slots__` for memory-critical classes
- Profile before optimizing

## Code Review Checklist

See `my-review.instructions.md` for detailed code review guidelines.

## References

- PEP 8: Style Guide for Python Code
- PEP 257: Docstring Conventions
- PEP 484: Type Hints
- PEP 585: Type Hinting Generics In Standard Collections (Python 3.9+)
- PEP 604: Allow writing union types as X | Y (Python 3.10+)
