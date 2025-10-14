# My Python Code Review Instructions

## Code Review Philosophy

- **Be kind and constructive**: Focus on the code, not the person
- **Be thorough**: Take time to understand the changes
- **Be specific**: Point to exact lines and provide examples
- **Be educational**: Explain why something should change
- **Be open**: Be willing to discuss and learn

## Review Checklist

### General

- [ ] PR has a clear title and description
- [ ] Changes are focused and address a single concern
- [ ] No unnecessary changes (formatting, refactoring unrelated code)
- [ ] No commented-out code
- [ ] No debug print statements
- [ ] No merge conflicts

### Code Quality

- [ ] Code follows PEP 8 and project style guidelines
- [ ] Code is readable and self-documenting
- [ ] Variable and function names are clear and descriptive
- [ ] Functions are small and focused (< 50 lines)
- [ ] No code duplication (DRY principle)
- [ ] Appropriate use of abstractions
- [ ] No magic numbers or strings (use constants)

### Type Hints

- [ ] All public functions have type hints
- [ ] Type hints use modern Python 3.10+ syntax (`|` for unions)
- [ ] No use of `typing.Union`, `typing.Optional`, `typing.List`, etc.
- [ ] Return types are specified
- [ ] Generic types are properly used
- [ ] Type hints are accurate

**Good:**
```python
def process(data: dict[str, int] | None = None) -> list[str]:
    ...
```

**Bad:**
```python
from typing import Dict, List, Optional

def process(data: Optional[Dict[str, int]] = None) -> List[str]:
    ...
```

### Error Handling

- [ ] Appropriate exceptions are raised with clear messages
- [ ] Exception handling is specific (no bare `except:`)
- [ ] Resources are properly cleaned up (use context managers)
- [ ] Error messages are informative
- [ ] Exceptions are chained with `from` when re-raising

**Good:**
```python
try:
    data = json.loads(content)
except json.JSONDecodeError as e:
    raise ValueError(f"Invalid JSON in config: {e}") from e
```

**Bad:**
```python
try:
    data = json.loads(content)
except:
    return None
```

### Documentation

- [ ] All public modules have docstrings
- [ ] All public classes have docstrings
- [ ] All public functions have docstrings
- [ ] Docstrings follow Google style
- [ ] Complex logic has explanatory comments
- [ ] README updated if needed
- [ ] CHANGELOG updated for user-facing changes

**Good:**
```python
def calculate_score(
    items: list[dict[str, Any]],
    *,
    weight: float = 1.0,
) -> float:
    """Calculate weighted score for items.
    
    Args:
        items: List of item dictionaries with 'value' key.
        weight: Multiplication factor for scores (default: 1.0).
        
    Returns:
        Calculated weighted score.
        
    Raises:
        ValueError: If items list is empty or items lack 'value' key.
    """
```

### Testing

- [ ] New code has tests
- [ ] Tests are clear and focused
- [ ] Tests follow AAA pattern (Arrange, Act, Assert)
- [ ] Edge cases are tested
- [ ] Error conditions are tested
- [ ] Tests have descriptive names
- [ ] No flaky tests
- [ ] Test coverage is maintained or improved
- [ ] Tests pass locally and in CI

**Test naming:**
```python
# Good
def test_user_login_with_valid_credentials() -> None:
    ...

def test_user_login_fails_with_invalid_password() -> None:
    ...

# Bad
def test_login() -> None:
    ...
```

### Performance

- [ ] No obvious performance issues
- [ ] Appropriate data structures used
- [ ] No unnecessary loops or computations
- [ ] Database queries are efficient (if applicable)
- [ ] Large data processed in chunks/streams when needed
- [ ] No premature optimization

### Security

- [ ] No hardcoded credentials or secrets
- [ ] User input is validated and sanitized
- [ ] SQL injection prevention (use parameterized queries)
- [ ] XSS prevention (if web application)
- [ ] CSRF protection (if web application)
- [ ] Dependencies are up to date
- [ ] No use of unsafe functions (`eval`, `exec`, `pickle` without validation)

### Dependencies

- [ ] New dependencies are necessary and justified
- [ ] Dependencies are pinned to specific versions
- [ ] Dependencies are compatible with Python 3.10+
- [ ] No deprecated dependencies
- [ ] License compatibility checked

### Python Best Practices

- [ ] Use context managers for resource management
- [ ] Use pathlib for file operations
- [ ] Use f-strings for string formatting
- [ ] Use comprehensions appropriately (not too complex)
- [ ] Use generators for large sequences
- [ ] Proper use of `@property`, `@staticmethod`, `@classmethod`
- [ ] No mutable default arguments

**Good:**
```python
from pathlib import Path

def read_config(path: Path) -> dict[str, Any]:
    """Read configuration from file."""
    with path.open() as f:
        return json.load(f)
```

**Bad:**
```python
def read_config(path: str) -> dict[str, Any]:
    """Read configuration from file."""
    f = open(path)
    data = json.load(f)
    f.close()
    return data
```

### Logging

- [ ] Use logging module, not print statements
- [ ] Appropriate log levels used
- [ ] Sensitive data not logged
- [ ] Log messages are clear and actionable

**Good:**
```python
import logging

logger = logging.getLogger(__name__)

def process_file(path: Path) -> None:
    """Process file."""
    logger.info("Processing file: %s", path)
    try:
        # Process
        logger.debug("File size: %d bytes", path.stat().st_size)
    except Exception as e:
        logger.error("Failed to process %s: %s", path, e, exc_info=True)
        raise
```

## Review Process

### 1. Understand the Context

- Read the issue or ticket
- Understand the goal of the PR
- Check related PRs or discussions

### 2. Review the Code

- Start with the tests to understand expected behavior
- Review main changes
- Check for side effects
- Verify error handling

### 3. Check CI/CD

- Ensure all checks pass
- Review test coverage report
- Check for security alerts
- Verify build artifacts

### 4. Provide Feedback

Use these labels for comments:

- **[BLOCKING]**: Must be fixed before merge
- **[SUGGESTION]**: Nice to have, but not required
- **[QUESTION]**: Clarification needed
- **[NITPICK]**: Minor style/preference issue
- **[PRAISE]**: Good implementation, worth highlighting

**Example comments:**

```markdown
**[BLOCKING]** Type hint is incorrect here:
```python
# Current
def get_user(id: int) -> User:
    ...

# Should be (might return None)
def get_user(id: int) -> User | None:
    ...
```

**[SUGGESTION]** Consider using a generator here for better memory efficiency with large datasets:
```python
def process_items(items: list[Item]) -> Generator[Result, None, None]:
    for item in items:
        yield process_item(item)
```

**[QUESTION]** Why do we need to fetch all users upfront? Could we use pagination?

**[NITPICK]** Prefer f-string over format():
```python
# Current
message = "User {} logged in".format(username)

# Prefer
message = f"User {username} logged in"
```

**[PRAISE]** Excellent use of pattern matching here! Very readable.
```

### 5. Approve or Request Changes

- **Approve**: If code is good or only has minor nitpicks
- **Request Changes**: If there are blocking issues
- **Comment**: For questions or non-blocking feedback

## Common Issues to Watch For

### 1. Missing Type Hints

```python
# Bad
def calculate(x, y):
    return x + y

# Good
def calculate(x: float, y: float) -> float:
    return x + y
```

### 2. Mutable Default Arguments

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

### 3. Bare Except Clauses

```python
# Bad
try:
    risky_operation()
except:
    pass

# Good
try:
    risky_operation()
except (ValueError, TypeError) as e:
    logger.warning("Operation failed: %s", e)
```

### 4. Missing Docstrings

```python
# Bad
def complex_calculation(a, b, c):
    return (a * b) / (c + 1)

# Good
def complex_calculation(a: float, b: float, c: float) -> float:
    """Calculate weighted ratio.
    
    Args:
        a: First multiplier.
        b: Second multiplier.
        c: Denominator offset.
        
    Returns:
        Calculated ratio.
    """
    return (a * b) / (c + 1)
```

### 5. Poor Error Messages

```python
# Bad
if not data:
    raise ValueError("Invalid")

# Good
if not data:
    raise ValueError("Data cannot be empty. Expected list of dictionaries.")
```

## Automated Review Tools

These tools should run in CI:

- **Ruff**: Linting and formatting
- **mypy**: Type checking
- **pytest**: Testing
- **coverage**: Code coverage
- **bandit**: Security issues
- **safety**: Dependency vulnerabilities

## Best Practices for PR Authors

To make reviews easier:

1. **Keep PRs small**: < 400 lines when possible
2. **Write clear PR description**: Explain what and why
3. **Add screenshots**: For UI changes
4. **Update tests**: Ensure tests pass
5. **Self-review first**: Review your own code before requesting review
6. **Address CI failures**: Fix issues before requesting review
7. **Respond to feedback**: Address comments promptly
8. **Ask questions**: If feedback is unclear, ask for clarification

## Review Examples

### Example 1: Type Hint Issue

```python
# Reviewer comment:
# [BLOCKING] The return type should be `User | None` since get_by_id can return None

# Original
def get_user(user_id: int) -> User:
    return db.query(User).filter_by(id=user_id).first()

# Fixed
def get_user(user_id: int) -> User | None:
    return db.query(User).filter_by(id=user_id).first()
```

### Example 2: Error Handling

```python
# Reviewer comment:
# [BLOCKING] Need to handle specific exceptions and provide better error message

# Original
def load_config(path: str) -> dict:
    return json.loads(open(path).read())

# Fixed
def load_config(path: Path) -> dict[str, Any]:
    """Load configuration from JSON file.
    
    Args:
        path: Path to config file.
        
    Returns:
        Parsed configuration dictionary.
        
    Raises:
        FileNotFoundError: If config file doesn't exist.
        ValueError: If config file contains invalid JSON.
    """
    try:
        return json.loads(path.read_text())
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON in {path}: {e}") from e
```

### Example 3: Testing

```python
# Reviewer comment:
# [SUGGESTION] Add test for edge case when list is empty

# Added test
def test_calculate_mean_empty_list() -> None:
    """Test that calculate_mean raises ValueError for empty list."""
    with pytest.raises(ValueError, match="Cannot calculate mean"):
        calculate_mean([])
```

## Resources

- [PEP 8 - Style Guide for Python Code](https://peps.python.org/pep-0008/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Best Practices for Code Review](https://google.github.io/eng-practices/review/)
- [The Art of Code Review](https://www.alexandra-hill.com/2018/06/25/the-art-of-giving-and-receiving-code-reviews/)
