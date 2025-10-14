---
description: "Testing guidelines and best practices for Python projects"
applyTo: "**/*.{py,test.py,spec.py}"
---

# Testing Guidelines

## Core Principles

When writing tests:

- **TDD is mandatory**: Write tests BEFORE production code (Red → Green → Refactor)
- **Test behavior, not implementation**: Focus on what the code does, not how it does it
- **One assertion per concept**: Each test should verify one specific behavior
- **Tests as documentation**: Test names and structure should explain what the code does
- **Fast feedback**: Tests should run quickly (milliseconds for unit tests)
- **Isolated and independent**: Tests should not depend on each other or on external state

## Test Framework

### Pytest Basics

- **Framework**: Use **pytest** as the testing framework
- **File naming**: Name test files `test_*.py` or `*_test.py`
- **Location**: Place tests in a `tests/` directory at project root
- **Function naming**: Use descriptive names following the pattern:
  - `test_function_name_condition_expected_result()`
  - Examples: `test_calculate_total_with_discount_returns_reduced_price()`
  - Or simpler: `test_user_can_login()`, `test_divide_by_zero_raises_error()`
- **Avoid generic names**: Don't use `test_function()` or `test_1()`

### Test Structure

Organize tests to mirror your source code structure in flat organization:

```
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── calculator.py
│       └── utils.py
└── tests/
    ├── __init__.py
    ├── test_calculator.py
    └── test_utils.py
```

When to use alternatives:

- Mirrored (subdirectories): Only when src/ has multiple levels of subdirectories
- By type (unit/integration): Only for large projects with many types of tests

### AAA Pattern

Use the **AAA pattern** for clear, readable tests:

- **Arrange**: Set up test data and preconditions
- **Act**: Execute the code being tested
- **Assert**: Verify the results

```python
def test_calculate_discount():
    # Arrange
    original_price = 100
    discount_percent = 20

    # Act
    final_price = calculate_discount(original_price, discount_percent)

    # Assert
    assert final_price == 80
```

## Coverage Goals

### Progressive Targets

Start with achievable goals and improve over time:

- **Beginner**: Aim for **≥ 60% coverage** initially
- **Intermediate**: Work toward **≥ 75% coverage** as you gain confidence
- **Advanced**: Target **≥ 90% coverage** for production code

### Measuring Coverage

Use `pytest-cov` to track coverage:

```bash
# Run tests with coverage report
pytest --cov=mypackage

# Generate HTML report for detailed view
pytest --cov=mypackage --cov-report=html
```

**Focus on**:

- Critical business logic
- Edge cases and error conditions
- Public APIs and interfaces

**Don't worry about**:

- 100% coverage (diminishing returns)
- Trivial getters/setters
- Third-party library code

## Test Types

### Unit Tests

Test individual functions or methods in isolation:

```python
def test_add_two_numbers():
    result = calculator.add(2, 3)
    assert result == 5

def test_divide_by_zero_raises_error():
    with pytest.raises(ZeroDivisionError):
        calculator.divide(10, 0)
```

**Characteristics**:

- Fast execution (milliseconds)
- No external dependencies
- Test one thing at a time

### Integration Tests

Test how components work together:

```python
def test_user_registration_workflow():
    user = create_user("test@example.com", "password123")
    assert user.is_active
    assert user.email == "test@example.com"
```

**Characteristics**:

- May involve multiple modules
- Can use database or file system
- Slower than unit tests

### Regression Tests

When fixing a bug, add a test to prevent it from returning:

```python
def test_issue_123_negative_price_handling():
    """Regression test for bug #123: negative prices caused crash"""
    result = calculate_total(items=[{"price": -10}])
    assert result == 0  # Should handle gracefully
```

## Fixtures and Test Data

Use **fixtures** to set up common test resources:

```python
import pytest

@pytest.fixture
def sample_user():
    """Provide a test user for multiple tests"""
    return User(name="Test User", email="test@example.com")

def test_user_name(sample_user):
    assert sample_user.name == "Test User"

def test_user_email(sample_user):
    assert sample_user.email == "test@example.com"
```

### Test Data Best Practices

**Factory Functions**: Create reusable test data generators:

```python
def create_test_user(name="Test User", email="test@example.com", active=True):
    """Factory function for creating test users"""
    return User(name=name, email=email, is_active=active)

def test_user_creation():
    user = create_test_user(name="Alice")
    assert user.name == "Alice"
```

**Constants**: Define commonly used test values:

```python
# test_constants.py
VALID_EMAIL = "test@example.com"
INVALID_EMAIL = "not-an-email"
TEST_PASSWORD = "SecurePass123!"
EMPTY_STRING = ""
MAX_USERNAME_LENGTH = 50

def test_email_validation():
    assert validate_email(VALID_EMAIL) is True
    assert validate_email(INVALID_EMAIL) is False
```

**Realistic Data**: Keep test data simple but realistic:

```python
def test_order_calculation():
    # Simple but realistic order data
    order = {
        "items": [
            {"name": "Widget", "price": 10.00, "quantity": 2},
            {"name": "Gadget", "price": 15.50, "quantity": 1}
        ],
        "tax_rate": 0.08
    }
    total = calculate_order_total(order)
    assert total == 38.34  # (20 + 15.50) * 1.08
```

### Parametrized Tests

Test multiple inputs efficiently with `@pytest.mark.parametrize`:

```python
@pytest.mark.parametrize("input,expected", [
    (2, 4),
    (3, 9),
    (5, 25),
    (-2, 4),
])
def test_square_numbers(input, expected):
    assert square(input) == expected
```

**Advanced parametrization** with test IDs for better output:

```python
@pytest.mark.parametrize(
    "email,is_valid",
    [
        ("user@example.com", True),
        ("user.name+tag@example.co.uk", True),
        ("invalid-email", False),
        ("@example.com", False),
        ("user@", False),
    ],
    ids=["standard", "complex", "no-at", "no-user", "no-domain"]
)
def test_email_validation(email, is_valid):
    assert validate_email(email) == is_valid
```

### Mocking with pytest-mock

Use `pytest-mock` for cleaner mocking syntax:

```bash
pip install pytest-mock
```

```python
def test_api_call_with_mock(mocker):
    """Test API call using pytest-mock"""
    # Mock the requests.get call
    mock_get = mocker.patch('requests.get')
    mock_get.return_value.json.return_value = {"status": "success"}
    mock_get.return_value.status_code = 200
    
    # Call the function
    result = fetch_data("https://api.example.com")
    
    # Verify the result
    assert result["status"] == "success"
    # Verify the mock was called correctly
    mock_get.assert_called_once_with("https://api.example.com")
```

### Pytest Plugins

Essential pytest plugins for Python projects:

```bash
pip install pytest pytest-cov pytest-mock pytest-xdist pytest-timeout
```

- **pytest-cov**: Coverage reporting
- **pytest-mock**: Simplified mocking with `mocker` fixture
- **pytest-xdist**: Run tests in parallel (`pytest -n auto`)
- **pytest-timeout**: Prevent hanging tests (`@pytest.mark.timeout(5)`)

### Using pytest.ini or pyproject.toml

Configure pytest behavior in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=mypackage",
    "--cov-report=term-missing",
    "--cov-report=html",
    "--cov-fail-under=70",
]
markers = [
    "slow: marks tests as slow (deselect with '-m \"not slow\"')",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests",
]
```

## Assertions Best Practices

### Use Specific Assertions

**DO**: Use multiple specific assertions that clearly indicate what failed:

```python
def test_user_registration():
    user = register_user("alice@example.com", "password123")

    # Multiple specific assertions
    assert user is not None
    assert user.email == "alice@example.com"
    assert user.is_active is True
    assert user.created_at is not None
```

**DON'T**: Use one complex assertion:

```python
def test_user_registration():
    user = register_user("alice@example.com", "password123")

    # Avoid: Hard to debug when it fails
    assert user and user.email == "alice@example.com" and user.is_active
```

### Test Both Positive and Negative Cases

```python
def test_email_validation_positive():
    """Test valid email addresses"""
    assert validate_email("user@example.com") is True
    assert validate_email("name+tag@domain.co.uk") is True

def test_email_validation_negative():
    """Test invalid email addresses"""
    assert validate_email("not-an-email") is False
    assert validate_email("@example.com") is False
    assert validate_email("user@") is False
```

### Use Custom Error Messages

```python
def test_price_calculation():
    result = calculate_price(quantity=5, unit_price=10.0)
    assert result == 50.0, f"Expected 50.0 but got {result}"
```

## Test Reliability

### Deterministic Tests

- **Set random seeds** if using randomness: `random.seed(42)`
- **Avoid time dependencies**: Use fixed dates or mock `datetime.now()`
- **Don't depend on external services**: Mock HTTP calls, databases, etc.
- **Clean up after tests**: Remove temp files, reset state

### Handling Flaky Tests

If a test fails occasionally:

1. **Investigate immediately** - don't ignore it
2. **Check for race conditions** or timing issues
3. **Add proper waits** or synchronization
4. **Consider using mocks** for external dependencies

## Performance Tests

When testing performance-critical code:

### Include Performance Benchmarks

```python
import time

def test_data_processing_performance():
    """Test that data processing completes within reasonable time"""
    large_dataset = generate_test_data(size=10000)

    start_time = time.time()
    result = process_data(large_dataset)
    elapsed_time = time.time() - start_time

    assert elapsed_time < 1.0, f"Processing took {elapsed_time:.2f}s, expected < 1.0s"
    assert len(result) == 10000
```

### Test with Realistic Data Volumes

```python
def test_bulk_import_performance():
    """Test bulk import with realistic data volume"""
    # Test with production-like data size
    records = [create_test_record(i) for i in range(1000)]

    start = time.perf_counter()
    imported_count = bulk_import(records)
    duration = time.perf_counter() - start

    assert imported_count == 1000
    assert duration < 5.0, f"Bulk import took {duration:.2f}s"
```

### Monitor Memory Usage

```python
import tracemalloc

def test_memory_efficient_processing():
    """Ensure processing doesn't exceed memory limits"""
    tracemalloc.start()

    # Process large dataset
    result = process_large_file("test_data.csv")

    current, peak = tracemalloc.get_traced_memory()
    tracemalloc.stop()

    # Peak memory should be under 100MB
    assert peak < 100 * 1024 * 1024, f"Peak memory usage: {peak / 1024 / 1024:.2f}MB"
```

### Set Reasonable Performance Thresholds

```python
@pytest.mark.benchmark
def test_search_performance():
    """Search should complete in under 100ms for 1000 items"""
    items = [f"item_{i}" for i in range(1000)]

    start = time.perf_counter()
    result = search_items(items, "item_500")
    elapsed = (time.perf_counter() - start) * 1000  # Convert to ms

    assert result == "item_500"
    assert elapsed < 100, f"Search took {elapsed:.2f}ms"
```

## Running Tests

### Development Workflow

```bash
# Run all tests
pytest

# Run with verbose output
pytest -v

# Run specific test file
pytest tests/test_calculator.py

# Run specific test function
pytest tests/test_calculator.py::test_add_two_numbers

# Run tests matching a pattern
pytest -k "test_add"

# Stop on first failure (useful for debugging)
pytest -x

# Run only failed tests from last run
pytest --lf

# Run tests in parallel (requires pytest-xdist)
pytest -n auto

# Show print statements (useful for debugging)
pytest -s

# Run with coverage
pytest --cov=mypackage --cov-report=term-missing

# Generate HTML coverage report
pytest --cov=mypackage --cov-report=html
# Then open htmlcov/index.html in browser
```

### TDD Workflow Integration

During TDD cycle, use these commands:

```bash
# 1. RED: Run new failing test
pytest tests/test_new_feature.py::test_specific_case -v

# 2. GREEN: Run same test after implementation
pytest tests/test_new_feature.py::test_specific_case -v

# 3. REFACTOR: Run all tests to ensure nothing broke
pytest

# Quick feedback loop: Run tests on file save
pytest-watch  # or use `ptw` (install with: pip install pytest-watch)
```

### Warnings Configuration

**Recommended approach** (progressive strictness):

```bash
# Default: Show warnings
pytest

# Show detailed warning information
pytest -v -rA

# Treat specific warnings as errors (good for CI)
pytest -W error::DeprecationWarning -W error::UserWarning

# Eventually: Treat all warnings as errors (strict mode for mature projects)
pytest -W error
```

**Configure in pyproject.toml**:

```toml
[tool.pytest.ini_options]
filterwarnings = [
    "error",  # Treat all warnings as errors
    "ignore::DeprecationWarning:some_module",  # Ignore specific warnings if needed
]
```

## CI/CD Integration

### Basic Test Command

In CI, run tests with coverage and strict settings:

```bash
pytest --cov=mypackage --cov-report=xml --cov-report=term-missing --strict-markers -W error
```

### Coverage Thresholds

Set appropriate thresholds based on project maturity:

```toml
# pyproject.toml
[tool.pytest.ini_options]
addopts = [
    "--cov=mypackage",
    "--cov-fail-under=70",  # Start with 70%, work toward 90%
    "--cov-report=term-missing",
    "--cov-report=html",
]
```

### GitHub Actions Example

```yaml
name: Tests
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.10", "3.11", "3.12", "3.13"]
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -e ".[dev]"
      
      - name: Run tests with coverage
        run: |
          pytest --cov=mypackage --cov-report=xml --cov-report=term-missing -W error
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml
          fail_ci_if_error: true
```

## Best Practices

### DO

- **Write tests FIRST** before production code (TDD Red-Green-Refactor cycle)
- Test behavior and public interfaces, not implementation details
- Test edge cases (empty lists, None values, negative numbers, boundary conditions)
- Use descriptive test names that explain behavior (not just "test_function_1")
- Keep tests simple and focused on one behavior per test
- Use fixtures to avoid code duplication and setup/teardown
- Use parametrize for testing multiple similar cases
- Run tests frequently during development (after every small change)
- Run full test suite before committing code
- Use mocks/patches for external dependencies (APIs, databases, file system)
- Add regression tests for every bug fix
- Keep test execution fast (< 1 second for unit tests)

### DON'T

- Write production code without a failing test first (breaks TDD)
- Test implementation details that may change during refactoring
- Write overly complex tests that are hard to understand
- Ignore failing tests or mark them as "skip" without a plan to fix
- Copy-paste test code without understanding it
- Let warnings pile up (address them immediately with `-W error`)
- Create test interdependencies (tests should be isolated)
- Use sleep() to fix timing issues (use proper mocks/synchronization)
- Test private methods directly (test through public interface)
- Write tests that depend on external services without mocking

## Getting Started

### Minimal Test Example

```python
# tests/test_example.py
def test_basic_addition():
    """A simple test to get started"""
    result = 1 + 1
    assert result == 2
```

### Run Your First Test

```bash
# Install pytest
pip install pytest pytest-cov

# Run the test
pytest tests/test_example.py

# You should see: 1 passed
```

## Guiding Principles for AI Assistance

When generating or modifying tests:

1. **ALWAYS generate tests FIRST** before implementation code (TDD approach)
2. **Follow the AAA pattern** strictly: Arrange-Act-Assert with blank lines between sections
3. **Use descriptive names**: Test names should describe behavior being tested
4. **Generate parametrized tests** when testing multiple similar cases
5. **Include edge cases**: Test empty inputs, None, negative numbers, boundaries
6. **Use fixtures** for common setup to avoid duplication
7. **Mock external dependencies**: Use `pytest-mock` for APIs, databases, file I/O
8. **Configure pytest properly**: Show how to add markers, coverage settings in `pyproject.toml`
9. **Keep tests isolated**: Each test should be independent and not rely on others
10. **Make tests fast**: Unit tests should run in milliseconds, use mocks for slow operations
11. **Provide running instructions**: Show exact pytest commands to run the tests
12. **Treat warnings as errors**: Configure `-W error` in CI to catch all warnings
