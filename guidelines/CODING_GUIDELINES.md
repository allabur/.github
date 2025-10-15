# Coding Guidelines

This document outlines the coding standards and conventions for Python projects, aligned with modern best practices, PEP 8, and Python 3.10+ features.

## Documentation Requirements

**⚠️ CRITICAL**: Documentation must be updated whenever making changes to code, APIs, or behavior.

### Documentation Update Rules

1. **New Functions/Classes**: Add NumPy-style docstrings immediately
2. **Modified Signatures**: Update docstrings to match current parameters and return types
3. **New Features**: Update relevant documentation files (README, guides)
4. **Changed Behavior**: Update examples and usage instructions
5. **Configuration Changes**: Update configuration documentation and examples

### Documentation Standards

- Follow NumPy-style docstring conventions
- Include type hints on all function signatures
- Provide practical examples in docstrings
- Update README.md for user-facing changes
- Test all examples for accuracy
- Keep CHANGELOG.md updated

### Before Committing

Always verify documentation is current:
```bash
# Check docstring coverage
interrogate -v --fail-under=80 src/

# Verify docs build without errors
mkdocs build --strict  # or: sphinx-build -W docs docs/_build

# Run linters and type checker
ruff check .
mypy --strict src/
```

## Development Philosophy

**CRITICAL**: We follow a **pragmatic, anti-over-engineering approach** to software development:

### Core Principles

1. **Readability First**
   - Clear, expressive code over clever tricks
   - Self-documenting code with meaningful names
   - Explicit is better than implicit (Zen of Python)

2. **PEP 8 and SOLID Principles**
   - Follow [PEP 8](https://peps.python.org/pep-0008/) style guide
   - Apply SOLID principles appropriately
   - Don't force patterns where they don't fit

3. **Meaningful Encapsulation**
   - Organize code around problem domains
   - Use classes and modules naturally
   - Avoid unnecessary abstractions

4. **Function Design**
   - Complex functions may have many parameters - this is acceptable
   - Use dataclasses or Pydantic models when grouping related parameters makes sense
   - Don't artificially reduce parameter counts

5. **Anti-Over-Engineering**
   - Solve real problems, not theoretical ones
   - Choose simplicity over cleverness
   - Avoid premature optimization
   - Refactor when it adds real value, not for patterns' sake

### What This Means in Practice

```python
# GOOD: Clear function with multiple parameters reflecting the problem
def create_user(
    email: str,
    password: str,
    name: str,
    is_active: bool = True,
    send_welcome_email: bool = True,
) -> User:
    """Create a new user with validation."""
    pass

# GOOD: Grouping related configuration into a model
from pydantic import BaseModel

class UserConfig(BaseModel):
    """User creation configuration."""
    send_welcome_email: bool = True
    require_email_verification: bool = True
    initial_role: str = "user"

def create_user(
    email: str,
    password: str,
    name: str,
    config: UserConfig = UserConfig(),
) -> User:
    """Create a new user with configuration."""
    pass

# BAD: Artificial abstraction that doesn't add value
class UserCreationContext:
    """Overly generic wrapper."""
    def __init__(self, **kwargs):
        self.__dict__.update(kwargs)

def create_user(context: UserCreationContext) -> User:
    """Unclear what parameters are needed."""
    pass
```

### Guidelines for Refactoring

- **Don't refactor for patterns' sake** - refactor to solve actual problems
- **Do refactor when it improves clarity** or solves maintenance issues
- **Prefer explicit over implicit** - make intentions clear
- **Prefer readable over clever** - optimize for future readers

## Python Code Style

### Package and Module Organization

**Package Naming:**
- Use lowercase single words: `mypackage`, `core`, `utils`
- Use underscores if needed for readability: `my_package`, `data_processor`
- Avoid hyphens in package names (use underscores instead)
- Keep names short and descriptive

**File Organization:**
- One module per major class or group of related functions
- Group related functionality within packages
- Use descriptive filenames: `user_service.py`, `database.py`, `config.py`
- Use `__init__.py` to control package exports

**Module Structure:**
```python
"""Module docstring describing purpose."""

# 1. Standard library imports
import os
from pathlib import Path

# 2. Third-party imports
import pandas as pd
from fastapi import FastAPI

# 3. Local imports
from mypackage.core import models
from mypackage.utils import helpers

# Module constants
MAX_RETRIES = 3
DEFAULT_TIMEOUT = 30

# Module-level functions and classes
def public_function():
    """Public function accessible via import."""
    pass

def _private_function():
    """Private function for internal module use."""
    pass
```

### Import Organization

Organize imports in three distinct groups with blank lines between:

```python
# 1. Standard library (alphabetical)
import json
import os
from datetime import datetime
from pathlib import Path

# 2. Third-party packages (alphabetical)
import numpy as np
import pandas as pd
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# 3. Local packages (alphabetical)
from mypackage.core.models import User
from mypackage.core.services import UserService
from mypackage.utils.config import load_config
```

**Import Rules:**
- Sort alphabetically within each group
- Use absolute imports for better clarity
- Avoid `from module import *` (wildcard imports)
- Use `from x import y` for frequently used items
- Import modules for less frequently used items: `import collections` then `collections.Counter()`

### Naming Conventions (PEP 8)

| Element | Convention | Example |
|---------|------------|---------|
| Package/Module | lowercase, underscores if needed | `mypackage`, `data_processor.py` |
| Class | PascalCase | `UserService`, `DataProcessor` |
| Function/Method | snake_case | `process_data()`, `calculate_total()` |
| Variable | snake_case | `file_path`, `user_count`, `max_iterations` |
| Constant | UPPER_SNAKE_CASE | `MAX_ROWS = 5000`, `API_URL` |
| Private | _leading_underscore | `_helper_function()`, `_internal_cache` |
| Boolean | is*/has*/can* prefix | `is_valid`, `has_permission`, `can_edit` |
| Type Variables | PascalCase, single letter or descriptive | `T`, `ModelType`, `DataType` |

**Naming Guidelines:**
- Use descriptive names (verbs for functions, nouns for classes/variables)
- Avoid abbreviations except well-known ones (`df` for DataFrame, `url`, `api`, `db`)
- Use consistent English spelling throughout
- Make boolean variable names read naturally: `if user.is_active:`
- Use plurals for collections: `users`, `items`, `records`

### Type Hints (Python 3.10+)

**Required for ALL function signatures** using modern syntax:

```python
# Built-in types (no imports needed)
def process_data(
    items: list[dict[str, int | str]],
    threshold: float | None = None,
    options: dict[str, any] | None = None,
) -> tuple[list[str], dict[str, float]]:
    """Process data with optional threshold."""
    pass

# Use | for Union types (Python 3.10+)
def get_user(id: int | str) -> User | None:
    """Get user by ID (int) or email (str)."""
    pass

# Special types (import only when needed)
from typing import Callable, Literal, TypeVar, Protocol
from collections.abc import Iterable, Sequence

T = TypeVar('T')

def transform(
    data: Sequence[T],
    func: Callable[[T], str],
    mode: Literal["fast", "slow"] = "fast",
) -> list[str]:
    """Transform sequence using provided function."""
    pass

# Protocol for structural typing
class Drawable(Protocol):
    """Protocol for drawable objects."""
    def draw(self) -> None: ...

def render(obj: Drawable) -> None:
    """Render any object that implements draw."""
    obj.draw()
```

**Type Hint Rules:**
- Use `X | Y` not `Union[X, Y]` (Python 3.10+)
- Use `X | None` not `Optional[X]` (Python 3.10+)
- Use built-in types: `list`, `dict`, `set`, `tuple` (not `List`, `Dict`, etc.)
- Use `any` for truly dynamic types (sparingly)
- Match library types: `pd.DataFrame`, `np.ndarray`, `Path`
- Use `typing.Protocol` for structural typing
- Use `TypeVar` for generic functions

### Code Formatting

**Indentation:**
- Use 4 spaces (never tabs)
- Configure editor to insert spaces for Tab key

**Line Length:**
- Maximum 88 characters (Black standard)
- Break long lines logically
- Use parentheses for implicit line continuation

**Blank Lines:**
- 2 blank lines between top-level functions and classes
- 1 blank line between methods in a class
- 1 blank line to separate logical sections within functions

**String Quotes:**
- Be consistent within a project
- Prefer double quotes `"text"` or use a formatter (Black)
- Use triple quotes for docstrings and multi-line strings

**Trailing Commas:**
- Use in multi-line structures (lists, dicts, function arguments)
- Helps with cleaner diffs in version control

```python
# Good
users = [
    "alice",
    "bob",
    "charlie",  # Trailing comma
]

config = {
    "host": "localhost",
    "port": 8000,
    "debug": True,  # Trailing comma
}
```

**Function Length:**
- Target < 50 lines per function
- Single, well-defined purpose
- Extract helper functions for complex logic
- Separate logical blocks with blank lines

### Class Definitions

Structure classes logically with clear documentation:

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    """User model with validation.
    
    Attributes
    ----------
    id : int
        Unique user identifier.
    email : str
        User email address.
    name : str
        User full name.
    is_active : bool
        Whether the user account is active.
    created_at : datetime
        Timestamp when user was created.
    """
    id: int
    email: str
    name: str
    is_active: bool = True
    created_at: datetime = field(default_factory=datetime.now)
    
    def activate(self) -> None:
        """Activate the user account."""
        self.is_active = True
    
    def deactivate(self) -> None:
        """Deactivate the user account."""
        self.is_active = False
    
    def __repr__(self) -> str:
        """Return string representation."""
        return f"User(id={self.id}, email={self.email})"
```

**Class Guidelines:**
- Group related fields together
- Use `@dataclass` for data containers
- Use `@property` for computed attributes
- Order: class docstring, fields, `__init__` (if custom), public methods, private methods
- Align field comments for readability

## Error Handling

### Custom Exception Types

Define structured exceptions for specific error conditions:

```python
class ApplicationError(Exception):
    """Base exception for application errors."""
    pass

class ValidationError(ApplicationError):
    """Raised when data validation fails."""
    
    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"Validation error for '{field}': {message}")

class NotFoundError(ApplicationError):
    """Raised when a requested resource is not found."""
    
    def __init__(self, resource: str, id: int | str):
        self.resource = resource
        self.id = id
        super().__init__(f"{resource} with id '{id}' not found")

class DatabaseError(ApplicationError):
    """Raised when database operations fail."""
    
    def __init__(self, operation: str, original_error: Exception):
        self.operation = operation
        self.original_error = original_error
        super().__init__(f"Database error during {operation}: {original_error}")
```

### Error Handling Patterns

Always handle errors explicitly with appropriate context:

```python
# GOOD: Specific exception handling with context
try:
    data = load_file(filepath)
except FileNotFoundError:
    logger.error(f"File not found: {filepath}")
    raise
except json.JSONDecodeError as e:
    raise ValueError(f"Cannot parse JSON in {filepath}") from e
except Exception as e:
    logger.exception(f"Unexpected error loading {filepath}")
    raise

# GOOD: Context manager for resource cleanup
from contextlib import contextmanager

@contextmanager
def database_session():
    """Provide a transactional database session."""
    session = SessionLocal()
    try:
        yield session
        session.commit()
    except Exception:
        session.rollback()
        raise
    finally:
        session.close()

# Usage
with database_session() as session:
    user = session.query(User).first()
```

**Error Handling Guidelines:**
- Never use bare `except:` - always specify exception types
- Don't catch too broadly (`except Exception:`) unless re-raising
- Use `except ... as e:` to access exception details
- Log errors before re-raising for debugging
- Use `raise ... from e` to preserve exception chain
- Clean up resources in `finally` or use context managers
- Don't fail silently - at minimum log the error

### Exception Hierarchies

Create meaningful exception hierarchies:

```python
# Base exception
class APIError(Exception):
    """Base exception for API errors."""
    status_code = 500

class BadRequestError(APIError):
    """Raised for invalid client requests."""
    status_code = 400

class NotFoundError(APIError):
    """Raised when resource is not found."""
    status_code = 404

class UnauthorizedError(APIError):
    """Raised for authentication failures."""
    status_code = 401

# Usage in API handler
try:
    user = get_user(user_id)
except NotFoundError:
    return {"error": "User not found"}, 404
except APIError as e:
    return {"error": str(e)}, e.status_code
```

## Application Structure Patterns

### Service Layer Pattern

Services encapsulate business logic and orchestrate operations:

```python
class UserService:
    """Service for user management operations."""
    
    def __init__(
        self,
        user_repository: UserRepository,
        email_service: EmailService,
        logger: logging.Logger,
    ):
        self.user_repository = user_repository
        self.email_service = email_service
        self.logger = logger
    
    def register_user(
        self,
        email: str,
        password: str,
        name: str,
    ) -> User:
        """Register a new user account.
        
        Parameters
        ----------
        email : str
            User email address.
        password : str
            User password (will be hashed).
        name : str
            User full name.
        
        Returns
        -------
        User
            The created user object.
        
        Raises
        ------
        ValidationError
            If email already exists or validation fails.
        """
        # Validate input
        if self.user_repository.get_by_email(email):
            raise ValidationError("email", "Email already registered")
        
        # Create user
        user = User(
            email=email,
            password_hash=hash_password(password),
            name=name,
            is_active=False,
        )
        
        # Save to database
        try:
            user = self.user_repository.save(user)
        except Exception as e:
            self.logger.error(f"Failed to save user: {e}")
            raise DatabaseError("user creation", e) from e
        
        # Send verification email (don't fail if this fails)
        try:
            self.email_service.send_verification(user)
        except Exception as e:
            self.logger.warning(f"Failed to send verification email: {e}")
        
        return user
```

### Repository Pattern

Repositories abstract data access:

```python
from abc import ABC, abstractmethod
from typing import Sequence

class UserRepository(ABC):
    """Abstract repository for user data access."""
    
    @abstractmethod
    def get_by_id(self, user_id: int) -> User | None:
        """Get user by ID."""
        pass
    
    @abstractmethod
    def get_by_email(self, email: str) -> User | None:
        """Get user by email."""
        pass
    
    @abstractmethod
    def get_all(self) -> Sequence[User]:
        """Get all users."""
        pass
    
    @abstractmethod
    def save(self, user: User) -> User:
        """Save user to storage."""
        pass
    
    @abstractmethod
    def delete(self, user_id: int) -> bool:
        """Delete user by ID."""
        pass

class SQLAlchemyUserRepository(UserRepository):
    """SQLAlchemy implementation of user repository."""
    
    def __init__(self, session: Session):
        self.session = session
    
    def get_by_id(self, user_id: int) -> User | None:
        return self.session.get(User, user_id)
    
    def get_by_email(self, email: str) -> User | None:
        return self.session.query(User).filter_by(email=email).first()
    
    def get_all(self) -> Sequence[User]:
        return self.session.query(User).all()
    
    def save(self, user: User) -> User:
        self.session.add(user)
        self.session.commit()
        self.session.refresh(user)
        return user
    
    def delete(self, user_id: int) -> bool:
        user = self.get_by_id(user_id)
        if user:
            self.session.delete(user)
            self.session.commit()
            return True
        return False
```

### Dependency Injection

Use dependency injection for testability:

```python
# FastAPI example with dependency injection
from fastapi import Depends, FastAPI
from sqlalchemy.orm import Session

app = FastAPI()

def get_db() -> Session:
    """Provide database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def get_user_repository(db: Session = Depends(get_db)) -> UserRepository:
    """Provide user repository."""
    return SQLAlchemyUserRepository(db)

def get_user_service(
    user_repo: UserRepository = Depends(get_user_repository),
) -> UserService:
    """Provide user service."""
    return UserService(
        user_repository=user_repo,
        email_service=EmailService(),
        logger=logging.getLogger(__name__),
    )

@app.post("/users")
def create_user(
    user_data: UserCreate,
    service: UserService = Depends(get_user_service),
) -> UserResponse:
    """Create a new user."""
    user = service.register_user(
        email=user_data.email,
        password=user_data.password,
        name=user_data.name,
    )
    return UserResponse.from_orm(user)
```

## Logging and Output

### Logging Configuration

Use the standard `logging` module for all application logging:

```python
import logging
from pathlib import Path

def setup_logging(
    level: str = "INFO",
    log_file: Path | None = None,
) -> None:
    """Configure application logging.
    
    Parameters
    ----------
    level : str
        Logging level (DEBUG, INFO, WARNING, ERROR, CRITICAL).
    log_file : Path | None
        Optional log file path. If None, logs to console only.
    """
    # Create formatter
    formatter = logging.Formatter(
        "%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )
    
    # Configure root logger
    root_logger = logging.getLogger()
    root_logger.setLevel(getattr(logging, level.upper()))
    
    # Console handler
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(formatter)
    root_logger.addHandler(console_handler)
    
    # File handler (optional)
    if log_file:
        file_handler = logging.FileHandler(log_file)
        file_handler.setFormatter(formatter)
        root_logger.addHandler(file_handler)

# Usage in modules
logger = logging.getLogger(__name__)

def process_data(data: list[dict]) -> list[dict]:
    """Process data with logging."""
    logger.debug(f"Processing {len(data)} records")
    
    try:
        result = expensive_operation(data)
        logger.info(f"Successfully processed {len(result)} records")
        return result
    except Exception as e:
        logger.error(f"Failed to process data: {e}", exc_info=True)
        raise
```

### Logging Best Practices

**Log Levels:**
- `DEBUG`: Detailed information for debugging
- `INFO`: General informational messages
- `WARNING`: Warning messages (something unexpected but not an error)
- `ERROR`: Error messages (operation failed but application continues)
- `CRITICAL`: Critical errors (application may need to stop)

**What to Log:**
```python
# DO: Log important events and errors
logger.info("User logged in: %s", user.email)
logger.warning("API rate limit approaching: %d/%d", current, limit)
logger.error("Failed to save user: %s", error, exc_info=True)

# DON'T: Log sensitive information
logger.info(f"User password: {password}")  # NEVER log passwords
logger.debug(f"API key: {api_key}")  # NEVER log secrets
```

### Output Patterns

**Console Output:**
```python
import sys

# Regular output
print(f"Processing {count} items...")

# Error output to stderr
print(f"Error: {error_message}", file=sys.stderr)

# Success messages
print(f"✓ Successfully completed {operation}")

# Progress indication
from tqdm import tqdm

for item in tqdm(items, desc="Processing"):
    process_item(item)
```

## Testing Principles

### Test Organization

- Tests mirror source structure in `tests/` directory
- Use descriptive test names: `test_user_registration_sends_email()`
- Group related tests in the same file
- Use fixtures for reusable test components

### Test Structure (AAA Pattern)

Follow the Arrange-Act-Assert pattern:

```python
def test_user_activation():
    # Arrange
    user = User(id=1, email="test@example.com", is_active=False)
    service = UserService(repository=MockRepository())
    
    # Act
    service.activate_user(user.id)
    
    # Assert
    assert user.is_active is True
```

### Test Examples

```python
import pytest
from unittest.mock import Mock, patch

def test_register_user_success():
    """Test successful user registration."""
    # Arrange
    mock_repo = Mock()
    mock_repo.get_by_email.return_value = None
    service = UserService(mock_repo, Mock(), Mock())
    
    # Act
    user = service.register_user(
        email="new@example.com",
        password="password123",
        name="New User",
    )
    
    # Assert
    assert user.email == "new@example.com"
    assert user.is_active is False
    mock_repo.save.assert_called_once()

def test_register_user_duplicate_email():
    """Test user registration with duplicate email."""
    # Arrange
    existing_user = User(id=1, email="existing@example.com")
    mock_repo = Mock()
    mock_repo.get_by_email.return_value = existing_user
    service = UserService(mock_repo, Mock(), Mock())
    
    # Act & Assert
    with pytest.raises(ValidationError) as exc_info:
        service.register_user(
            email="existing@example.com",
            password="password123",
            name="New User",
        )
    assert "already registered" in str(exc_info.value)

@pytest.fixture
def sample_users() -> list[User]:
    """Provide sample users for testing."""
    return [
        User(id=1, email="alice@example.com", name="Alice"),
        User(id=2, email="bob@example.com", name="Bob"),
    ]

def test_get_all_users(sample_users):
    """Test retrieving all users."""
    # Arrange
    mock_repo = Mock()
    mock_repo.get_all.return_value = sample_users
    service = UserService(mock_repo, Mock(), Mock())
    
    # Act
    users = service.get_all_users()
    
    # Assert
    assert len(users) == 2
    assert users[0].email == "alice@example.com"
```

## Documentation

### Function Documentation (NumPy-Style)

ALL public functions and classes MUST have docstrings:

```python
def calculate_statistics(
    data: list[float],
    include_median: bool = True,
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
    
    Notes
    -----
    Uses numpy for efficient calculations.
    """
    if not data:
        raise ValueError("Data cannot be empty")
    
    stats = {
        "mean": np.mean(data),
        "std": np.std(data),
    }
    
    if include_median:
        stats["median"] = np.median(data)
    
    return stats
```

### Module Documentation

Provide module-level documentation at the top of files:

```python
"""User service module.

This module provides business logic for user management operations
including registration, authentication, and profile management.

Example
-------
>>> from mypackage.services import UserService
>>> service = UserService(user_repo, email_service)
>>> user = service.register_user("user@example.com", "password", "User Name")
"""

import logging
# ... rest of module
```

### Complex Logic Documentation

Document complex algorithms and important decisions:

```python
def process_data(data: list[dict]) -> list[dict]:
    """Process data with complex transformation.
    
    The processing follows these steps:
    1. Validate all records for required fields
    2. Normalize data formats (dates, numbers, text)
    3. Apply business rules and calculations
    4. Filter out invalid records
    5. Sort by priority and timestamp
    
    Each step can be interrupted by validation errors, which are
    collected and raised together at the end.
    """
    errors = []
    
    # Step 1: Validate
    for i, record in enumerate(data):
        try:
            validate_record(record)
        except ValidationError as e:
            errors.append(f"Record {i}: {e}")
    
    if errors:
        raise ValidationError("\n".join(errors))
    
    # Steps 2-5: Transform, apply rules, filter, sort
    # ...
```

## Quality Standards

### Mandatory Change Requirements

**CRITICAL**: When changing code, you MUST complete all these steps:

1. **Add/Update Type Hints**
   - All function parameters must have type hints
   - Return types must be specified
   - Use modern Python 3.10+ syntax (`X | Y`, not `Union[X, Y]`)
   - Follow type hint conventions in this guide

2. **Create/Adjust Tests**
   - Add new tests for new functionality
   - Update existing tests when behavior changes
   - Follow pytest conventions and AAA pattern
   - Use descriptive test names: `test_function_name_condition_expected_result()`
   - Ensure tests cover both success and error cases
   - Use fixtures from `conftest.py` for reusable components

3. **Run Quality Checks**
   - Execute `ruff check .` - must pass with no errors
   - Execute `ruff format .` - format code consistently
   - Execute `mypy --strict src/` - type checking must pass
   - Execute `pytest --cov=mypackage --cov-report=term` - tests must pass
   - Ensure coverage ≥ 70% (target: 90%)

4. **Update Documentation**
   - Update NumPy-style docstrings for modified functions
   - Update relevant `.md` files for user-facing changes
   - Update README.md for significant features
   - Update CHANGELOG.md under "Unreleased" section
   - Ensure documentation builds without errors

**Tool Commands:**
```bash
# Format code
ruff format .

# Lint code
ruff check .

# Type check
mypy --strict src/

# Run tests with coverage
pytest --cov=mypackage --cov-report=html --cov-report=term

# Build documentation
mkdocs build --strict  # or: sphinx-build -W docs docs/_build

# Check docstring coverage
interrogate -v --fail-under=80 src/
```

### Code Quality Checklist

Before committing code:

- [ ] Passes `ruff format .` and `ruff check .` with no errors
- [ ] Passes `mypy --strict src/` with no type errors
- [ ] All tests pass: `pytest`
- [ ] Test coverage ≥ 70% (target: 90%)
- [ ] All public functions have NumPy-style docstrings
- [ ] All functions have type hints (parameters and return values)
- [ ] No hardcoded secrets or credentials
- [ ] Exceptions handled appropriately with specific types
- [ ] Important operations logged at appropriate levels
- [ ] Documentation builds without errors

### Code Reviews

All code changes must:
- Follow these coding guidelines
- Complete all mandatory requirements above
- Have clear commit messages following COMMIT_GUIDELINES.md
- Pass all CI checks (linting, type checking, tests)
- Include comprehensive test coverage
- Update relevant documentation

### Tools and Automation

The project uses:
- **Ruff**: Fast Python linter and formatter (replaces flake8, black, isort)
- **mypy**: Static type checking
- **pytest**: Testing framework with coverage reporting
- **interrogate**: Docstring coverage checking
- **MkDocs/Sphinx**: Documentation generation

### Performance Considerations

- Profile before optimizing - use `cProfile` or `line_profiler`
- Use appropriate data structures and algorithms (consider complexity)
- Leverage vectorization with NumPy/pandas for data processing
- Cache expensive computations with `functools.lru_cache`
- Avoid premature optimization - clear code first, then optimize if needed
- Consider memory usage for large datasets

### Best Practices Summary

**DO:**
- Write clear, self-documenting code with descriptive names
- Keep functions small (< 50 lines) with single responsibility
- Use modern Python features (f-strings, pathlib, dataclasses, type hints)
- Handle errors explicitly with specific exceptions
- Profile before optimizing
- Validate and sanitize external input
- Use environment variables for secrets and configuration
- Write tests for all new features and bug fixes
- Update documentation when changing code

**DON'T:**
- Use bare `except:` or ignore exceptions silently
- Hardcode secrets, credentials, or environment-specific values
- Optimize prematurely or use overly complex one-liners
- Copy-paste code instead of refactoring to shared functions
- Leave commented-out code in commits
- Use wildcard imports (`from module import *`)
- Mix tabs and spaces (always use 4 spaces)
- Skip type hints or docstrings on public functions
- Commit without running linters and tests

## AI Assistant Guidelines

When using AI coding assistants (like GitHub Copilot):

1. **Follow these standards strictly** - AI suggestions must conform to these guidelines
2. **Use modern Python 3.10+ syntax** - No legacy typing imports
3. **Prioritize readability over cleverness** - Clear code beats clever code
4. **Always include type hints and docstrings** - Even for AI-generated code
5. **Handle errors with specific exceptions** - No bare except blocks
6. **Write testable code** - Separate concerns, use dependency injection
7. **Never hardcode secrets** - Use environment variables or config files
8. **Profile before optimizing** - Don't prematurely optimize AI-generated code
9. **Keep it simple and clear** - The next developer (or you) will thank you

## References

For detailed information on specific topics, see:

- **Python language guide**: [PEP 8 Style Guide](https://peps.python.org/pep-0008/)
- **Type hints**: [PEP 484](https://peps.python.org/pep-0484/), [PEP 604](https://peps.python.org/pep-0604/)
- **Project instructions**: `/instructions/my-code.instructions.md`
- **Testing guidelines**: `/instructions/my-tests.instructions.md`
- **Documentation standards**: `/instructions/my-docs.instructions.md`
- **CI/CD practices**: `/instructions/my-ci-cd.instructions.md`

These guidelines help maintain code quality and ensure consistency across Python projects. When in doubt, prioritize clarity and maintainability over cleverness.