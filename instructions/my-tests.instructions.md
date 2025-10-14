# My Python Testing Instructions

## Testing Philosophy

- **Write tests first**: Test-driven development (TDD) when possible
- **Test behavior, not implementation**: Focus on what, not how
- **Keep tests simple**: Tests should be easier to understand than the code
- **Fast tests**: Unit tests should run in milliseconds
- **Reliable tests**: No flaky tests; they should be deterministic

## Test Framework: pytest

Use pytest for all testing needs.

```bash
# Install pytest and plugins
pip install pytest pytest-cov pytest-mock pytest-asyncio pytest-xdist

# Run tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html --cov-report=term

# Run in parallel
pytest -n auto

# Run specific test
pytest tests/test_module.py::test_function
```

## Test Structure

```
tests/
├── __init__.py
├── conftest.py              # Shared fixtures and configuration
├── unit/                    # Unit tests (fast, isolated)
│   ├── __init__.py
│   ├── test_models.py
│   └── test_utils.py
├── integration/             # Integration tests (slower)
│   ├── __init__.py
│   └── test_api.py
└── fixtures/                # Test data files
    ├── sample_data.json
    └── test_config.yml
```

## Writing Tests

### Basic Test Structure

```python
"""Tests for user authentication module."""

import pytest
from myapp.auth import authenticate_user, hash_password, User

class TestAuthentication:
    """Test suite for authentication functions."""
    
    def test_authenticate_valid_user(self) -> None:
        """Test authentication with valid credentials."""
        # Arrange
        username = "testuser"
        password = "secure_password"
        
        # Act
        user = authenticate_user(username, password)
        
        # Assert
        assert user is not None
        assert user.username == username
        assert user.is_authenticated
    
    def test_authenticate_invalid_password(self) -> None:
        """Test authentication fails with invalid password."""
        username = "testuser"
        wrong_password = "wrong"
        
        with pytest.raises(AuthenticationError):
            authenticate_user(username, wrong_password)
    
    @pytest.mark.parametrize(
        ("username", "password", "expected"),
        [
            ("user1", "pass1", True),
            ("user2", "pass2", True),
            ("", "pass", False),
            ("user", "", False),
        ],
    )
    def test_authenticate_parametrized(
        self,
        username: str,
        password: str,
        expected: bool,
    ) -> None:
        """Test authentication with various inputs."""
        result = authenticate_user(username, password)
        assert result.is_authenticated == expected
```

### Fixtures

Use fixtures for test setup and shared resources:

```python
# conftest.py
import pytest
from myapp.database import Database
from myapp.models import User

@pytest.fixture
def db() -> Database:
    """Create a test database."""
    database = Database(":memory:")  # In-memory SQLite
    database.create_tables()
    yield database
    database.close()

@pytest.fixture
def sample_user() -> User:
    """Create a sample user for testing."""
    return User(
        id=1,
        username="testuser",
        email="test@example.com",
    )

@pytest.fixture
def authenticated_client(client, sample_user):
    """Create an authenticated test client."""
    client.login(sample_user)
    return client
```

### Parametrized Tests

Use parametrization for testing multiple scenarios:

```python
@pytest.mark.parametrize(
    ("input_value", "expected_output"),
    [
        (0, "zero"),
        (1, "one"),
        (2, "two"),
        (-1, "negative"),
    ],
    ids=["zero", "one", "two", "negative"],
)
def test_number_to_word(input_value: int, expected_output: str) -> None:
    """Test number to word conversion."""
    assert number_to_word(input_value) == expected_output
```

## Testing Patterns

### Testing Exceptions

```python
def test_division_by_zero() -> None:
    """Test that division by zero raises ValueError."""
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(10, 0)
```

### Testing Async Code

```python
import pytest

@pytest.mark.asyncio
async def test_async_function() -> None:
    """Test asynchronous function."""
    result = await fetch_data_async("https://api.example.com")
    assert result["status"] == "ok"
```

### Mocking

Use pytest-mock for mocking:

```python
def test_api_call_with_mock(mocker) -> None:
    """Test API call with mocked response."""
    # Mock the external API call
    mock_response = {"data": "test"}
    mocker.patch("myapp.api.requests.get", return_value=mock_response)
    
    result = fetch_data("https://api.example.com")
    assert result == mock_response
```

### Testing with Temporary Files

```python
import tempfile
from pathlib import Path

def test_file_processing(tmp_path: Path) -> None:
    """Test file processing with temporary directory."""
    # tmp_path is provided by pytest
    test_file = tmp_path / "test.txt"
    test_file.write_text("test content")
    
    result = process_file(test_file)
    assert result == "processed: test content"
```

## Test Coverage

### Coverage Configuration

```toml
# pyproject.toml
[tool.coverage.run]
source = ["src"]
omit = [
    "*/tests/*",
    "*/test_*.py",
    "*/__init__.py",
]

[tool.coverage.report]
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
    "@abstractmethod",
]
```

### Coverage Goals

- **Minimum**: 80% line coverage
- **Target**: 90%+ line coverage
- **Critical paths**: 100% coverage for security and data integrity code

### Running Coverage

```bash
# Generate coverage report
pytest --cov=src --cov-report=html --cov-report=term-missing

# View HTML report
open htmlcov/index.html  # macOS
xdg-open htmlcov/index.html  # Linux
```

## Test Categories and Markers

```python
# conftest.py
import pytest

def pytest_configure(config):
    """Register custom markers."""
    config.addinivalue_line("markers", "unit: Unit tests (fast, isolated)")
    config.addinivalue_line("markers", "integration: Integration tests (slower)")
    config.addinivalue_line("markers", "slow: Slow tests")
    config.addinivalue_line("markers", "requires_db: Tests requiring database")

# Usage in tests
@pytest.mark.unit
def test_fast_unit() -> None:
    """Fast unit test."""
    pass

@pytest.mark.integration
@pytest.mark.slow
def test_integration() -> None:
    """Slow integration test."""
    pass
```

```bash
# Run only unit tests
pytest -m unit

# Run all except slow tests
pytest -m "not slow"

# Run integration tests
pytest -m integration
```

## pytest Configuration

```toml
# pyproject.toml
[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=src",
    "--cov-report=term-missing:skip-covered",
    "--cov-report=html",
    "--cov-report=xml",
]
markers = [
    "unit: Unit tests",
    "integration: Integration tests",
    "slow: Slow tests",
    "requires_db: Tests requiring database",
]
```

## Best Practices

### 1. Naming Conventions

- Test files: `test_*.py` or `*_test.py`
- Test functions: `test_*`
- Test classes: `Test*`
- Be descriptive: `test_user_login_with_invalid_password`

### 2. Test Independence

```python
# BAD: Tests depend on each other
def test_create_user() -> None:
    user = create_user("test")
    assert user.id == 1

def test_get_user() -> None:
    user = get_user(1)  # Depends on previous test
    assert user.name == "test"

# GOOD: Each test is independent
def test_create_user(db) -> None:
    user = create_user("test", db)
    assert user.id is not None

def test_get_user(db, sample_user) -> None:
    db.add(sample_user)
    user = get_user(sample_user.id, db)
    assert user.name == sample_user.name
```

### 3. Arrange-Act-Assert Pattern

```python
def test_calculate_total() -> None:
    """Test total calculation."""
    # Arrange
    items = [
        {"price": 10.0, "quantity": 2},
        {"price": 5.0, "quantity": 3},
    ]
    
    # Act
    total = calculate_total(items)
    
    # Assert
    assert total == 35.0
```

### 4. Test Data Management

```python
# tests/fixtures/sample_data.py
SAMPLE_USERS = [
    {"username": "user1", "email": "user1@example.com"},
    {"username": "user2", "email": "user2@example.com"},
]

# tests/test_users.py
from tests.fixtures.sample_data import SAMPLE_USERS

def test_user_creation() -> None:
    """Test user creation with sample data."""
    for user_data in SAMPLE_USERS:
        user = User(**user_data)
        assert user.username == user_data["username"]
```

### 5. Testing Edge Cases

Always test:
- Empty inputs
- None values
- Boundary conditions
- Invalid inputs
- Error conditions

```python
@pytest.mark.parametrize(
    ("input_list", "expected"),
    [
        ([], 0),  # Empty list
        ([1], 1),  # Single item
        ([1, 2, 3], 6),  # Normal case
        ([-1, -2], -3),  # Negative numbers
    ],
)
def test_sum_list(input_list: list[int], expected: int) -> None:
    """Test list sum with various edge cases."""
    assert sum_list(input_list) == expected
```

## Integration Testing

```python
import pytest
from httpx import AsyncClient
from myapp.main import app

@pytest.mark.asyncio
async def test_api_endpoint() -> None:
    """Test API endpoint integration."""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/api/users")
        assert response.status_code == 200
        assert len(response.json()) > 0
```

## Performance Testing

```python
import time

def test_performance_requirement() -> None:
    """Test that operation completes within time limit."""
    start = time.time()
    
    result = expensive_operation()
    
    duration = time.time() - start
    assert duration < 1.0, f"Operation took {duration:.2f}s, expected < 1.0s"
    assert result is not None
```

## Testing Checklist

Before merging code:

- [ ] All tests pass locally
- [ ] New code has tests (aim for 80%+ coverage)
- [ ] Edge cases are tested
- [ ] Error conditions are tested
- [ ] Tests are independent and don't rely on execution order
- [ ] No flaky tests (run multiple times to verify)
- [ ] Fast tests (unit tests < 100ms each)
- [ ] Tests have clear, descriptive names
- [ ] Fixtures are used for shared setup
- [ ] Mocks are used appropriately (not over-mocked)

## CI Integration

Tests should run automatically in CI:

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12"]
    
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
      - run: pip install -e ".[dev]"
      - run: pytest --cov --cov-report=xml
      - uses: codecov/codecov-action@v3
```

## Resources

- [pytest Documentation](https://docs.pytest.org/)
- [pytest-cov](https://pytest-cov.readthedocs.io/)
- [pytest-mock](https://pytest-mock.readthedocs.io/)
- [Testing Best Practices](https://docs.python-guide.org/writing/tests/)
