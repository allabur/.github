# Python Testing Guidelines

## Testing Philosophy

- **Tests are documentation**: Tests show how code should be used
- **Tests give confidence**: Good tests allow refactoring with confidence
- **Tests find bugs early**: Bugs caught in tests are cheaper to fix
- **Tests drive design**: Writing testable code leads to better design

## Test Framework

Use **pytest** for all testing:

```bash
# Install
pip install pytest pytest-cov pytest-mock pytest-asyncio pytest-xdist

# Run tests
pytest

# Run with coverage
pytest --cov=src --cov-report=html --cov-report=term-missing

# Run in parallel
pytest -n auto

# Run specific test
pytest tests/test_module.py::test_function
```

## Project Structure

```
tests/
├── __init__.py
├── conftest.py              # Shared fixtures
├── unit/                    # Unit tests (fast, isolated)
│   ├── __init__.py
│   ├── test_models.py
│   ├── test_services.py
│   └── test_utils.py
├── integration/             # Integration tests (slower)
│   ├── __init__.py
│   ├── test_api.py
│   └── test_database.py
├── fixtures/                # Test data
│   ├── sample_data.json
│   └── test_config.toml
└── benchmarks/              # Performance tests
    └── test_performance.py
```

## Writing Tests

### Basic Test Structure

```python
"""Tests for user authentication module."""

import pytest
from myapp.auth import authenticate_user, User

class TestAuthentication:
    """Test suite for authentication."""
    
    def test_authenticate_valid_credentials(self) -> None:
        """Test authentication succeeds with valid credentials."""
        # Arrange
        username = "testuser"
        password = "secure_password123"
        
        # Act
        user = authenticate_user(username, password)
        
        # Assert
        assert user is not None
        assert user.username == username
        assert user.is_authenticated is True
    
    def test_authenticate_invalid_password(self) -> None:
        """Test authentication fails with invalid password."""
        # Arrange
        username = "testuser"
        wrong_password = "wrong_password"
        
        # Act & Assert
        with pytest.raises(AuthenticationError) as exc_info:
            authenticate_user(username, wrong_password)
        
        assert "Invalid password" in str(exc_info.value)
    
    def test_authenticate_nonexistent_user(self) -> None:
        """Test authentication fails for non-existent user."""
        with pytest.raises(AuthenticationError, match="User not found"):
            authenticate_user("nonexistent", "password")
```

### Parametrized Tests

Test multiple scenarios efficiently:

```python
import pytest

@pytest.mark.parametrize(
    ("input_value", "expected_output"),
    [
        (0, "zero"),
        (1, "one"),
        (2, "two"),
        (10, "ten"),
        (-1, "negative"),
    ],
    ids=["zero", "one", "two", "ten", "negative"],
)
def test_number_to_word(input_value: int, expected_output: str) -> None:
    """Test number to word conversion."""
    assert number_to_word(input_value) == expected_output

@pytest.mark.parametrize("value", [None, "", [], {}])
def test_validation_rejects_empty(value) -> None:
    """Test that validation rejects empty values."""
    with pytest.raises(ValueError):
        validate_input(value)
```

### Fixtures

Use fixtures for setup and shared resources:

```python
# conftest.py
import pytest
from pathlib import Path
from myapp.database import Database
from myapp.models import User

@pytest.fixture
def db() -> Database:
    """Create test database."""
    database = Database(":memory:")  # SQLite in-memory
    database.create_tables()
    yield database
    database.close()

@pytest.fixture
def sample_user() -> User:
    """Create sample user."""
    return User(
        id=1,
        username="testuser",
        email="test@example.com",
    )

@pytest.fixture
def temp_config_file(tmp_path: Path) -> Path:
    """Create temporary config file."""
    config_file = tmp_path / "config.toml"
    config_file.write_text("""
    [app]
    name = "TestApp"
    debug = true
    """)
    return config_file

@pytest.fixture
def authenticated_client(client, sample_user):
    """Create authenticated test client."""
    client.login(sample_user)
    return client
```

### Fixture Scopes

```python
@pytest.fixture(scope="session")
def database_engine():
    """Create database engine once per session."""
    engine = create_engine("postgresql://...")
    yield engine
    engine.dispose()

@pytest.fixture(scope="module")
def api_client():
    """Create API client once per module."""
    return APIClient(base_url="http://test")

@pytest.fixture(scope="function")  # Default scope
def temp_file(tmp_path):
    """Create temp file for each test."""
    return tmp_path / "test.txt"
```

## Testing Patterns

### Testing Exceptions

```python
def test_division_by_zero() -> None:
    """Test that division by zero raises ValueError."""
    with pytest.raises(ValueError, match="Cannot divide by zero"):
        divide(10, 0)

def test_invalid_input_type() -> None:
    """Test that invalid input type raises TypeError."""
    with pytest.raises(TypeError):
        calculate("not a number")
```

### Testing Async Code

```python
import pytest

@pytest.mark.asyncio
async def test_async_fetch() -> None:
    """Test asynchronous data fetching."""
    result = await fetch_data_async("https://api.example.com")
    assert result["status"] == "ok"
    assert "data" in result

@pytest.mark.asyncio
async def test_concurrent_operations() -> None:
    """Test concurrent operations work correctly."""
    results = await asyncio.gather(
        operation1(),
        operation2(),
        operation3(),
    )
    assert all(r is not None for r in results)
```

### Mocking and Patching

```python
from unittest.mock import Mock, MagicMock, patch

def test_api_call_with_mock(mocker) -> None:
    """Test API call with mocked response."""
    # Mock external API call
    mock_response = {"data": "test", "status": "ok"}
    mocker.patch("myapp.api.requests.get", return_value=mock_response)
    
    result = fetch_data("https://api.example.com")
    assert result == mock_response

def test_database_interaction(mocker) -> None:
    """Test database interaction with mock."""
    mock_db = mocker.Mock()
    mock_db.query.return_value = [{"id": 1, "name": "test"}]
    
    service = UserService(mock_db)
    users = service.get_all_users()
    
    assert len(users) == 1
    mock_db.query.assert_called_once()
```

### Testing with Temporary Files

```python
def test_file_processing(tmp_path: Path) -> None:
    """Test file processing with temporary file."""
    # tmp_path is provided by pytest
    test_file = tmp_path / "test.txt"
    test_file.write_text("test content")
    
    result = process_file(test_file)
    
    assert result.success is True
    assert result.lines_processed == 1

def test_directory_creation(tmp_path: Path) -> None:
    """Test directory creation."""
    new_dir = tmp_path / "subdir" / "nested"
    ensure_directory_exists(new_dir)
    
    assert new_dir.exists()
    assert new_dir.is_dir()
```

## Test Organization

### Test Markers

```python
# conftest.py
import pytest

def pytest_configure(config):
    """Register custom markers."""
    config.addinivalue_line("markers", "unit: Unit tests")
    config.addinivalue_line("markers", "integration: Integration tests")
    config.addinivalue_line("markers", "slow: Slow tests")
    config.addinivalue_line("markers", "requires_db: Tests requiring database")

# Usage
@pytest.mark.unit
def test_fast_unit() -> None:
    """Fast unit test."""
    pass

@pytest.mark.integration
@pytest.mark.slow
def test_integration() -> None:
    """Slow integration test."""
    pass

@pytest.mark.requires_db
def test_database_query(db) -> None:
    """Test requiring database."""
    pass
```

Run tests by marker:

```bash
# Run only unit tests
pytest -m unit

# Run all except slow tests
pytest -m "not slow"

# Run integration tests
pytest -m integration
```

### Skip and xfail

```python
@pytest.mark.skip(reason="Not implemented yet")
def test_future_feature() -> None:
    """Test for future feature."""
    pass

@pytest.mark.skipif(sys.version_info < (3, 11), reason="Requires Python 3.11+")
def test_python_311_feature() -> None:
    """Test using Python 3.11+ features."""
    pass

@pytest.mark.xfail(reason="Known bug, fix in progress")
def test_known_issue() -> None:
    """Test for known issue."""
    assert buggy_function() == expected_result
```

## Test Coverage

### Configuration

```toml
# pyproject.toml
[tool.coverage.run]
source = ["src"]
branch = true
omit = [
    "*/tests/*",
    "*/test_*.py",
    "*/__init__.py",
]

[tool.coverage.report]
precision = 2
show_missing = true
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

### Running Coverage

```bash
# Generate coverage report
pytest --cov=src --cov-report=html --cov-report=term-missing

# View HTML report
open htmlcov/index.html  # macOS
xdg-open htmlcov/index.html  # Linux

# Generate XML for CI
pytest --cov=src --cov-report=xml
```

### Coverage Goals

- **Minimum**: 80% line coverage
- **Target**: 90%+ line coverage
- **Critical code**: 100% coverage (security, data integrity)

## Best Practices

### 1. Test Naming

```python
# Good: Descriptive names
def test_user_login_succeeds_with_valid_credentials() -> None:
    pass

def test_user_login_fails_with_invalid_password() -> None:
    pass

def test_email_validation_rejects_invalid_format() -> None:
    pass

# Bad: Unclear names
def test_login() -> None:
    pass

def test_user() -> None:
    pass
```

### 2. Arrange-Act-Assert Pattern

```python
def test_calculate_total() -> None:
    """Test total calculation with discount."""
    # Arrange
    items = [
        {"price": 10.0, "quantity": 2},
        {"price": 5.0, "quantity": 3},
    ]
    discount = 0.1
    
    # Act
    total = calculate_total(items, discount=discount)
    
    # Assert
    assert total == 31.5  # (20 + 15) * 0.9
```

### 3. Test Independence

```python
# Good: Each test is independent
def test_create_user(db) -> None:
    """Test user creation."""
    user = create_user("test", db)
    assert user.username == "test"

def test_get_user(db, sample_user) -> None:
    """Test getting user."""
    db.add(sample_user)
    user = get_user(sample_user.id, db)
    assert user.username == sample_user.username

# Bad: Tests depend on order
def test_create() -> None:
    create_user("test")  # Creates in global state

def test_get() -> None:
    user = get_user(1)  # Depends on previous test
```

### 4. One Assertion per Test (when possible)

```python
# Good: Focused test
def test_user_has_correct_username() -> None:
    user = User(username="test")
    assert user.username == "test"

def test_user_has_correct_email() -> None:
    user = User(email="test@example.com")
    assert user.email == "test@example.com"

# Acceptable: Related assertions
def test_user_creation() -> None:
    user = User(username="test", email="test@example.com")
    assert user.username == "test"
    assert user.email == "test@example.com"
    assert user.is_active is True
```

### 5. Test Edge Cases

```python
@pytest.mark.parametrize(
    "input_value",
    [
        [],           # Empty
        [1],          # Single item
        [1, 2, 3],    # Normal case
        [-1, -2],     # Negative numbers
        [0],          # Zero
        [10**6],      # Large number
    ],
)
def test_sum_handles_edge_cases(input_value: list[int]) -> None:
    """Test sum handles various edge cases."""
    result = calculate_sum(input_value)
    assert result == sum(input_value)
```

## Integration Testing

```python
import pytest
from httpx import AsyncClient
from myapp.main import app

@pytest.mark.integration
@pytest.mark.asyncio
async def test_user_registration_flow() -> None:
    """Test complete user registration flow."""
    async with AsyncClient(app=app, base_url="http://test") as client:
        # Register user
        response = await client.post("/api/users", json={
            "username": "newuser",
            "email": "newuser@example.com",
            "password": "secure_password",
        })
        assert response.status_code == 201
        user_id = response.json()["id"]
        
        # Get user
        response = await client.get(f"/api/users/{user_id}")
        assert response.status_code == 200
        assert response.json()["username"] == "newuser"
```

## Performance Testing

```python
import time

def test_performance_requirement() -> None:
    """Test operation completes within time limit."""
    start = time.perf_counter()
    
    result = expensive_operation()
    
    duration = time.perf_counter() - start
    assert duration < 1.0, f"Operation took {duration:.2f}s (limit: 1.0s)"
    assert result is not None

# Using pytest-benchmark
def test_benchmark_calculation(benchmark) -> None:
    """Benchmark calculation performance."""
    result = benchmark(calculate_fibonacci, 20)
    assert result == 6765
```

## CI Integration

Tests run automatically in CI:

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

## Testing Checklist

Before committing:

- [ ] All tests pass locally
- [ ] New code has tests
- [ ] Tests are independent
- [ ] Edge cases are tested
- [ ] Error conditions are tested
- [ ] Coverage is maintained or improved
- [ ] No flaky tests
- [ ] Tests have clear names
- [ ] Tests follow AAA pattern

## Resources

- See `/instructions/my-tests.instructions.md` for detailed testing instructions
- [pytest Documentation](https://docs.pytest.org/)
- [pytest-cov](https://pytest-cov.readthedocs.io/)
- [pytest-mock](https://pytest-mock.readthedocs.io/)
- [Testing Best Practices](https://docs.python-guide.org/writing/tests/)
