---
description: "Python-specific coding guidelines and best practices"
applyTo: "**/*.py"
---

# Python Coding Instructions

## Style and Formatting

- Follow PEP 8 style guidelines
- Use 4 spaces for indentation (no tabs)
- Line length should not exceed 88 characters (Black formatter standard)
- Use trailing commas in multiline structures

## Naming Conventions

- Use snake_case for files, modules, variables, and functions
- Use PascalCase for class names
- Use UPPER_SNAKE_CASE for constants
- Use leading underscore for private attributes
- Use verbs for functions, nouns for classes and variables
- Use boolean prefixes (is*, has*, can\_) for boolean variables

## Import Organization

- Use absolute imports within the main package for clarity
- Use relative imports only within submodules or sibling files
- Avoid wildcard imports (from module import \*)
- Order imports: standard library → third-party → local application
- Sort imports alphabetically within each group
- Use specific imports rather than importing entire modules

## Type Hints - Modern Syntax (Python 3.9+)

- **ALWAYS use modern type hint syntax** for Python 3.9+:

  - Use `list[str]` instead of `List[str]`
  - Use `dict[str, int]` instead of `Dict[str, int]`
  - Use `tuple[str, ...]` instead of `Tuple[str, ...]`
  - Use `set[str]` instead of `Set[str]`
  - Use `str | int | None` instead of `Union[str, int, None]`
  - Use `str | None` instead of `Optional[str]`

- **Import from typing only when necessary**:

  - Import `Literal`, `Callable`, `TypeVar`, `Protocol` when needed
  - Avoid importing `List`, `Dict`, `Tuple`, `Set`, `Union`, `Optional`

- **Complete type annotations required**:
  - ALL function parameters must have type annotations
  - ALL functions must have return type annotations
  - Format: `parameter: TypeAnnotation = default_value`
  - Match pandas/numpy types: `pd.DataFrame`, `pd.Series`, `np.ndarray`
  - Ensure type consistency between annotations, docstrings, and implementation

## Type Annotation Examples (Modern Syntax)

```python
# Basic types with modern syntax
def process_data(
    name: str = "default",
    count: int = 0,
    items: list[str] | None = None,
    mapping: dict[str, int | float] | None = None,
    active: bool = True
) -> dict[str, any]:
    pass
```

```python
# Complex types requiring minimal typing imports
from typing import Callable, Literal

def analyze_data(
    data: list[str] | dict[str, any] | None = None,
    callback: Callable[[str], int] | None = None,
    mode: Literal["fast", "slow"] = "fast",
    df: pd.DataFrame | None = None
) -> tuple[pd.DataFrame, dict[str, float]]:
    pass
```

```python
# Modern pandas/numpy integration
def process_dataframe(
    df: pd.DataFrame,
    columns: list[str] | None = None,
    series: pd.Series | None = None,
    array: np.ndarray | None = None
) -> pd.DataFrame | None:
    pass
```

## Documentation

- Use triple quotes for docstrings
- Follow NumPy docstring format exclusively
- Include parameter types and descriptions
- Document return values and exceptions

## Python Best Practices

- Use list comprehensions when they improve readability
- Prefer f-strings for string formatting
- Use context managers (with statements) for resource handling
- Use enumerate() instead of range(len()) for loops with indices
- Use pathlib.Path for file system operations
- Prefer is/is not for None comparisons

## Error Handling

- Use specific exception types instead of bare except
- Create custom exception classes when appropriate
- Use logging module instead of print statements
- Handle exceptions at the appropriate level

## Data Structures

- Use dataclasses or Pydantic models for structured data
- Use sets for membership testing and removing duplicates
- Use collections.defaultdict and collections.Counter when appropriate
- Consider using NamedTuple for simple data containers

## Python Code Structure

- Use step-wise comments for major function blocks (# Step 1: Filter by admission date)
- Do not number comments for default kwargs extraction
- Use blank lines to separate logical sections
- Keep inline comments minimal and purposeful
- Structure complex functions with clear section breaks
- Use descriptive block comments for algorithm steps
