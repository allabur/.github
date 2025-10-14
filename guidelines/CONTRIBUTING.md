# Contributing Guidelines

## Welcome

Thank you for considering contributing to this Python project! This document provides guidelines for contributing to ensure a smooth collaboration process.

## Getting Started

### Prerequisites

- Python 3.10 or higher
- Git
- Basic knowledge of Python and testing

### Development Setup

1. **Fork and clone the repository**

```bash
git clone https://github.com/yourusername/project.git
cd project
```

2. **Create a virtual environment**

```bash
# Using venv
python -m venv .venv
source .venv/bin/activate  # Linux/Mac
.venv\Scripts\activate     # Windows

# Or using conda
conda create -n project python=3.11
conda activate project
```

3. **Install in development mode**

```bash
pip install -e ".[dev]"
```

4. **Install pre-commit hooks**

```bash
pre-commit install
```

5. **Verify setup**

```bash
# Run tests
pytest

# Check code quality
ruff check .
mypy src/
```

## Development Workflow

### 1. Create an Issue

Before starting work:

- Check if an issue already exists
- If not, create one describing the bug or feature
- Wait for feedback/approval for major changes

### 2. Create a Branch

```bash
# Create feature branch
git checkout -b feat/your-feature-name

# Or bug fix branch
git checkout -b fix/your-bug-fix
```

Branch naming:
- `feat/feature-name` for new features
- `fix/bug-name` for bug fixes
- `docs/description` for documentation
- `refactor/description` for refactoring
- `test/description` for test additions

### 3. Make Changes

Follow our coding guidelines:

- Write clean, readable Python code
- Use type hints for all functions
- Follow PEP 8 style guide
- Use modern Python 3.10+ syntax
- Write docstrings for all public APIs

See `/guidelines/CODING_GUIDELINES.md` for detailed standards.

### 4. Write Tests

All code changes must include tests:

```python
# tests/test_feature.py
def test_new_feature() -> None:
    """Test the new feature works correctly."""
    result = new_feature(input_data)
    assert result == expected_output
```

See `/guidelines/TESTING_GUIDELINES.md` for testing standards.

### 5. Run Quality Checks

Before committing:

```bash
# Format code
ruff format .

# Lint code
ruff check .

# Type check
mypy src/

# Run tests
pytest

# Check coverage
pytest --cov=src --cov-report=term
```

### 6. Commit Changes

Follow Conventional Commits format:

```bash
git add .
git commit -m "feat: add user authentication"
```

See `/guidelines/COMMIT_GUIDELINES.md` for commit standards.

### 7. Push and Create Pull Request

```bash
git push origin feat/your-feature-name
```

Then create a pull request on GitHub.

## Pull Request Guidelines

### PR Title

Use Conventional Commits format:

- `feat: add user authentication`
- `fix: resolve database timeout`
- `docs: update installation guide`

### PR Description

Include:

1. **Description**: What does this PR do?
2. **Motivation**: Why is this change needed?
3. **Changes**: What changed?
4. **Testing**: How was it tested?
5. **Screenshots**: If applicable (for UI changes)
6. **Checklist**: See template below

### PR Template

```markdown
## Description

Brief description of the changes.

## Motivation and Context

Why is this change required? What problem does it solve?
Fixes #(issue number)

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Changes Made

- Change 1
- Change 2
- Change 3

## Testing

Describe the tests you ran to verify your changes:

- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing performed

## Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published
- [ ] I have updated the CHANGELOG.md (if applicable)

## Screenshots (if applicable)

Add screenshots to help explain your changes.
```

## Code Review Process

### What to Expect

1. **Automated Checks**: CI will run tests, linting, and type checking
2. **Manual Review**: Maintainers will review your code
3. **Feedback**: You may receive comments and change requests
4. **Iteration**: Address feedback and push updates
5. **Approval**: Once approved, your PR will be merged

### Responding to Feedback

- Be respectful and open to suggestions
- Ask questions if feedback is unclear
- Make requested changes promptly
- Push updates to the same branch

See `/instructions/my-review.instructions.md` for review guidelines.

## Coding Standards

### Python Style

- Follow PEP 8
- Use Ruff for formatting (88 character line length)
- Use type hints with modern syntax (`|` instead of `Union`)
- Write Google-style docstrings

```python
def calculate_score(
    items: list[dict[str, Any]],
    *,
    weight: float = 1.0,
) -> float:
    """Calculate weighted score for items.
    
    Args:
        items: List of item dictionaries.
        weight: Score multiplier (default: 1.0).
        
    Returns:
        Calculated weighted score.
        
    Raises:
        ValueError: If items list is empty.
    """
    if not items:
        raise ValueError("Items list cannot be empty")
    # Implementation...
```

### Testing Standards

- Write tests for all new code
- Aim for >80% code coverage
- Use pytest for testing
- Follow AAA pattern (Arrange, Act, Assert)

```python
def test_calculate_score() -> None:
    """Test score calculation."""
    # Arrange
    items = [{"value": 10}, {"value": 20}]
    
    # Act
    result = calculate_score(items, weight=2.0)
    
    # Assert
    assert result == 60.0
```

### Documentation Standards

- Add docstrings to all public modules, classes, and functions
- Update README.md for user-facing changes
- Update CHANGELOG.md for notable changes
- Use clear, concise language

## Types of Contributions

### Bug Reports

Create an issue with:

- Clear title
- Steps to reproduce
- Expected behavior
- Actual behavior
- Python version
- Relevant logs/screenshots

### Feature Requests

Create an issue with:

- Clear description
- Use case/motivation
- Proposed solution
- Alternatives considered

### Code Contributions

- Bug fixes
- New features
- Performance improvements
- Test improvements
- Documentation improvements

### Documentation Contributions

- Fix typos or errors
- Improve clarity
- Add examples
- Translate documentation

## Development Tips

### Running Specific Tests

```bash
# Run specific test file
pytest tests/test_models.py

# Run specific test
pytest tests/test_models.py::test_user_creation

# Run tests matching pattern
pytest -k "test_user"

# Run with coverage
pytest --cov=src --cov-report=html
```

### Debugging

```python
# Use breakpoint() for debugging
def calculate(x: int) -> int:
    breakpoint()  # Debugger will stop here
    return x * 2
```

### Type Checking

```bash
# Check specific file
mypy src/models.py

# Check entire project
mypy src/

# Show error codes
mypy src/ --show-error-codes
```

### Code Formatting

```bash
# Format all files
ruff format .

# Check formatting without changing
ruff format --check .

# Format specific file
ruff format src/models.py
```

## Project Structure

Understanding the project layout:

```
project/
├── src/
│   └── package_name/      # Main package
│       ├── __init__.py
│       ├── core/          # Core logic
│       ├── api/           # API layer
│       └── utils/         # Utilities
├── tests/
│   ├── unit/              # Unit tests
│   └── integration/       # Integration tests
├── docs/                  # Documentation
├── pyproject.toml         # Project configuration
├── README.md
└── CHANGELOG.md
```

## Release Process

Maintainers handle releases:

1. Update version in `pyproject.toml`
2. Update `CHANGELOG.md`
3. Create git tag: `v1.0.0`
4. Push tag to trigger release workflow
5. GitHub Actions builds and publishes to PyPI

## Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on the code, not the person
- Help others learn and grow

### Communication

- Use GitHub issues for bug reports and feature requests
- Use GitHub discussions for questions and ideas
- Be patient and understanding
- Assume good intentions

### Attribution

Contributors are recognized in:
- Git commit history
- CHANGELOG.md
- GitHub contributors page
- Release notes

## Getting Help

- Read the documentation
- Search existing issues
- Ask in GitHub discussions
- Check `/guidelines` and `/instructions` folders

## Resources

### Project Guidelines

- `/guidelines/ARCHITECTURE.md` - Architecture patterns
- `/guidelines/CODING_GUIDELINES.md` - Code style
- `/guidelines/COMMIT_GUIDELINES.md` - Commit format
- `/guidelines/CONFIGURATION.md` - Configuration
- `/guidelines/TESTING_GUIDELINES.md` - Testing standards

### Python Instructions

- `/instructions/python.instructions.md` - Python best practices
- `/instructions/my-code.instructions.md` - Coding standards
- `/instructions/my-docs.instructions.md` - Documentation
- `/instructions/my-tests.instructions.md` - Testing
- `/instructions/my-ci-cd.instructions.md` - CI/CD
- `/instructions/my-review.instructions.md` - Code review

### External Resources

- [PEP 8 Style Guide](https://peps.python.org/pep-0008/)
- [Python Packaging Guide](https://packaging.python.org/)
- [pytest Documentation](https://docs.pytest.org/)
- [mypy Documentation](https://mypy.readthedocs.io/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)

## Thank You!

Your contributions make this project better. Thank you for taking the time to contribute!
