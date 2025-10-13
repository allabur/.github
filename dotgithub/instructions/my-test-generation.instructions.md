---
description: "Test generation guidelines and best practices"
applyTo: "**/*.{test,spec}.{js,ts,py}"
---

# Test Generation Instructions

## Test Organization
- Mirror source code structure in test directories
- Use consistent naming: test_filename.py or filename.test.js
- Place tests in dedicated test directories (tests/, __tests__, test/)
- Group related test files in subdirectories matching source structure
- Use clear hierarchy that matches project organization

## Test Structure Example
```
/src/
  └── utils/
        └── parser.py

/tests/
  └── utils/
        └── test_parser.py
```

## Test Structure
- Use the AAA pattern: Arrange, Act, Assert
- Write descriptive test names that explain what is being tested
- Group related tests using describe/context blocks
- Keep tests independent and isolated

## Test Coverage
- Test happy path scenarios first
- Include edge cases and error conditions
- Test boundary values (empty arrays, null values, etc.)
- Test async operations with proper await/promise handling
- Test error scenarios and exception handling

## Test Data
- Use factory functions or builders for test data creation
- Create realistic but simple test data
- Use constants for commonly used test values
- Mock external dependencies and API calls

## Assertions
- Use specific assertions that clearly indicate what failed
- Prefer multiple specific assertions over one complex assertion
- Use custom matchers when available for better error messages
- Test both positive and negative cases

## Python Testing (pytest)
- Use pytest fixtures for setup and teardown
- Use parametrize decorator for testing multiple scenarios
- Use mock.patch for mocking dependencies
- Follow naming convention: test_function_name_condition_expected_result

## JavaScript Testing (Jest/Vitest)
- Use beforeEach/afterEach for setup and cleanup
- Use jest.mock() or vi.mock() for mocking modules
- Use toMatchSnapshot() for UI component testing
- Use act() wrapper for React component testing

## Integration Tests
- Test complete workflows and user scenarios
- Use real database connections when testing data layer
- Test API endpoints with actual HTTP requests
- Verify side effects and state changes

## Performance Tests
- Include performance benchmarks for critical paths
- Test with realistic data volumes
- Monitor memory usage and execution time
- Set reasonable performance thresholds
