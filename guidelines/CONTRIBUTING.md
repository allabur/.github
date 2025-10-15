# Contributing to Python Projects

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to Python projects.

## Code of Conduct

By participating in this project, you agree to:
- Be respectful and inclusive of differing viewpoints and experiences
- Use welcoming and inclusive language
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## How to Contribute

### Reporting Bugs

1. **Check Existing Issues** - Search the issue tracker to avoid duplicates
2. **Create a Clear Report** including:
   - A clear, descriptive title
   - Detailed steps to reproduce the bug
   - Expected behavior
   - Actual behavior
   - Your environment (OS, Python version, dependencies)
   - Any relevant logs, error messages, or stack traces
   - Minimal code example that reproduces the issue

**Bug Report Template:**
```markdown
## Bug Description
[Clear description of the bug]

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [e.g., Ubuntu 22.04, macOS 14.0, Windows 11]
- Python Version: [e.g., 3.11.5]
- Package Version: [e.g., 1.2.3]
- Relevant Dependencies: [list key dependencies and versions]

## Additional Context
[Stack traces, logs, screenshots]
```

### Suggesting Enhancements

1. **Check Existing Suggestions** - Search issues and discussions
2. **Provide Context** - Explain why this enhancement would be useful
3. **Consider Scope** - Is it generally useful or specific to your use case?
4. **Describe Implementation** - If possible, outline how it might be implemented
5. **Show Examples** - Provide code examples of how it would be used

**Enhancement Request Template:**
```markdown
## Feature Description
[Clear description of the proposed feature]

## Motivation
[Why is this feature needed? What problem does it solve?]

## Proposed Solution
[How should this feature work?]

## Example Usage
```python
# Example code showing how the feature would be used
```

## Alternatives Considered
[What other approaches were considered?]
```

### Pull Requests

1. **Fork the Repository**
   - Click "Fork" on GitHub
   - Clone your fork locally

2. **Create a Feature Branch**
   ```bash
   # Using git-flow style
   git checkout -b feature/your-feature-name
   # or
   git checkout -b fix/your-bug-fix
   # or
   git checkout -b docs/improve-documentation
   ```

3. **Commit Guidelines**
   - Follow [Conventional Commits](https://www.conventionalcommits.org/)
   - Write clear, descriptive commit messages
   - Use the imperative mood ("Add feature" not "Added feature")
   - Reference issues in commit messages
   - Format:
     ```
     <type>(<scope>): <subject>

     <body>

     Fixes #123
     ```

   **Commit Types:**
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation changes
   - `test`: Adding or updating tests
   - `refactor`: Code refactoring
   - `perf`: Performance improvements
   - `chore`: Maintenance tasks
   - `ci`: CI/CD changes

4. **Code Quality Requirements**
   - Follow [PEP 8](https://peps.python.org/pep-0008/) style guide
   - Add type hints to all function signatures
   - Write NumPy-style docstrings for public functions
   - Include tests for new functionality
   - Ensure all tests pass
   - Maintain or improve code coverage
   - Update documentation

5. **Before Submitting Pull Request**
   ```bash
   # Format code
   ruff format .

   # Lint code
   ruff check .

   # Type check
   mypy --strict src/

   # Run tests with coverage
   pytest --cov=mypackage --cov-report=term

   # Build documentation
   mkdocs build --strict  # or: sphinx-build -W docs docs/_build
   ```

6. **Submit Pull Request**
   - Provide a clear title and description
   - Link related issues (Fixes #123, Closes #456)
   - Include any necessary documentation updates
   - Add notes about testing performed
   - Explain any breaking changes

### Development Setup

#### Prerequisites

- **Python**: 3.10 or later
- **Git**: 2.25 or later
- **pip** or **conda**: For package management
- **make** (optional): For build automation

#### Local Development Setup

```bash
# 1. Clone your fork
git clone https://github.com/YOUR_USERNAME/project-name.git
cd project-name

# 2. Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/project-name.git

# 3. Create virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate

# or with conda
conda env create -f environment.yml
conda activate project-name

# 4. Install development dependencies
pip install -e ".[dev]"
# or
pip install -r requirements-dev.txt

# 5. Install pre-commit hooks (if available)
pre-commit install

# 6. Verify setup
pytest
ruff check .
mypy src/
```

#### Development Workflow

```bash
# 1. Sync with upstream
git checkout main
git pull upstream main

# 2. Create feature branch
git checkout -b feature/my-new-feature

# 3. Make changes and test iteratively
# Edit code...
pytest tests/test_mymodule.py
ruff check .
mypy src/mypackage/mymodule.py

# 4. Commit changes
git add .
git commit -m "feat: add new feature"

# 5. Keep branch updated
git fetch upstream
git rebase upstream/main

# 6. Push to your fork
git push origin feature/my-new-feature

# 7. Create pull request on GitHub
```

### Testing

#### Test Requirements

1. **Unit Tests**
   - Add tests for all new functionality
   - Update tests when modifying existing code
   - Use pytest fixtures for reusable components
   - Follow AAA pattern (Arrange-Act-Assert)
   - Use descriptive test names

2. **Integration Tests**
   - Test interactions between components
   - Use temporary databases or mock external services
   - Clean up resources after tests

3. **Test Coverage**
   - Maintain or improve coverage
   - Aim for ≥70% coverage (target: 90%)
   - Focus on critical business logic
   - Don't worry about 100% coverage

#### Writing Tests

```python
import pytest
from mypackage import MyClass

def test_my_function_with_valid_input():
    """Test my_function with valid input."""
    # Arrange
    input_data = {"key": "value"}
    
    # Act
    result = my_function(input_data)
    
    # Assert
    assert result["status"] == "success"
    assert "data" in result

def test_my_function_with_invalid_input_raises_error():
    """Test my_function raises ValueError for invalid input."""
    # Arrange
    invalid_data = {}
    
    # Act & Assert
    with pytest.raises(ValueError) as exc_info:
        my_function(invalid_data)
    assert "key is required" in str(exc_info.value)

@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {
        "items": [1, 2, 3],
        "metadata": {"version": "1.0"}
    }

def test_process_data(sample_data):
    """Test data processing with fixture."""
    result = process_data(sample_data)
    assert len(result) == 3
```

### Documentation

#### Documentation Requirements

1. **Code Documentation**
   - Add NumPy-style docstrings to all public functions and classes
   - Include type hints on all function signatures
   - Provide usage examples in docstrings
   - Document exceptions that may be raised

2. **Project Documentation**
   - Update README.md for user-facing changes
   - Add or update guides for new features
   - Keep CHANGELOG.md up to date
   - Update API documentation

3. **Documentation Style**
   ```python
   def calculate_total(
       items: list[dict[str, float]],
       tax_rate: float = 0.0,
   ) -> float:
       """Calculate total price including tax.
       
       Parameters
       ----------
       items : list[dict[str, float]]
           List of items with 'price' key.
       tax_rate : float, optional
           Tax rate as decimal (e.g., 0.08 for 8%), by default 0.0.
       
       Returns
       -------
       float
           Total price including tax.
       
       Raises
       ------
       ValueError
           If items is empty or contains invalid prices.
       
       Examples
       --------
       >>> items = [{"price": 10.0}, {"price": 20.0}]
       >>> calculate_total(items, tax_rate=0.08)
       32.4
       """
       pass
   ```

## Code Review Process

### For Contributors

1. **Be Patient** - Reviews take time
2. **Be Responsive** - Address feedback promptly
3. **Be Open** - Consider suggestions even if you disagree initially
4. **Be Professional** - Keep discussions focused on the code

### For Reviewers

1. **Be Constructive** - Provide specific, actionable feedback
2. **Be Thorough** - Check code, tests, and documentation
3. **Be Timely** - Respond to PRs within a reasonable timeframe
4. **Be Respectful** - Focus on code quality, not personal preferences

### Review Checklist

- [ ] Code follows style guidelines (PEP 8, type hints, docstrings)
- [ ] Tests are included and pass
- [ ] Test coverage is maintained or improved
- [ ] Documentation is updated
- [ ] Commit messages follow conventions
- [ ] No secrets or credentials in code
- [ ] Breaking changes are documented
- [ ] CI checks pass

## License and Copyright

- All contributions must be licensed under the project's license (typically MIT or Apache 2.0)
- You retain copyright on your contributions
- By submitting a pull request, you agree to license your contributions under the same license

## Getting Help

- **Documentation**: Check project documentation first
- **Issues**: Search existing issues for similar problems
- **Discussions**: Ask questions in GitHub Discussions
- **Chat**: Join project chat/Slack if available
- **Email**: Contact maintainers for sensitive issues

## Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md (if exists)
- Mentioned in release notes for significant contributions
- Recognized in project documentation where appropriate

## Additional Resources

- [PEP 8 - Style Guide for Python Code](https://peps.python.org/pep-0008/)
- [PEP 257 - Docstring Conventions](https://peps.python.org/pep-0257/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [NumPy Docstring Guide](https://numpydoc.readthedocs.io/en/latest/format.html)
- [pytest Documentation](https://docs.pytest.org/)
- [Git Best Practices](https://git-scm.com/book/en/v2)

Thank you for contributing! Every contribution, whether it's code, documentation, bug reports, or suggestions, helps make the project better.
