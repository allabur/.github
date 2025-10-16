# Testing Guidelines

This document outlines testing conventions and patterns for Python projects using pytest.

## Core Principles

When writing tests:

- **Start simple**: Write basic tests first, increase complexity gradually
- **Test what matters**: Focus on critical functionality and edge cases
- **Keep tests readable**: Tests should be easy to understand and maintain
- **Run tests often**: Catch issues early in development

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

Test multiple inputs efficiently:

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

# Run specific test file
pytest tests/test_calculator.py

# Run specific test function
pytest tests/test_calculator.py::test_add_two_numbers

# Stop on first failure (useful for debugging)
pytest -x

# Run only failed tests from last run
pytest --lf

# Show print statements (useful for debugging)
pytest -s
```

### Warnings Configuration

**For beginners** (less strict, focus on learning):

```bash
# Show warnings but don't fail
pytest

# Show summary of warnings at the end
pytest -rw
```

**As you progress** (more strict):

```bash
# Show detailed warnings
pytest -W default

# Eventually: treat specific warnings as errors
pytest -W error::DeprecationWarning
```

**Note**: Don't use `-W error` globally while learning - it's too strict and can be discouraging.

## CI/CD Integration

### Basic Test Command

In CI, run tests with coverage:

```bash
pytest --cov=mypackage --cov-report=xml --cov-report=term
```

### Coverage Thresholds

Start with relaxed thresholds and tighten over time:

```ini
# pytest.ini or pyproject.toml
[tool:pytest]
addopts = --cov=mypackage --cov-fail-under=60
```

## Best Practices

### DO

- Write tests for new features before marking them complete - TDD paradigms
- Test edge cases (empty lists, None values, negative numbers)
- Use descriptive test names that explain what's being tested
- Keep tests simple and focused on one behavior
- Use fixtures to avoid code duplication
- Run tests before committing code

### DON'T

- Skip writing tests because you're "just learning"
- Test implementation details (test behavior, not internals)
- Write overly complex tests that are hard to understand
- Ignore failing tests or mark them as "skip" without a plan to fix
- Copy-paste test code without understanding it
- Let warnings pile up (address them gradually)

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

1. **Match skill level**: Generate simple, clear tests for beginners
2. **Provide context**: Explain what the test does and why
3. **Use fixtures appropriately**: Show how to avoid duplication
4. **Include assertions**: Every test needs at least one `assert`
5. **Test edge cases**: But don't overwhelm with too many at once
6. **Keep warnings visible**: Show warnings but don't fail on them initially
7. **Encourage gradual improvement**: Start with basic coverage, improve over time
