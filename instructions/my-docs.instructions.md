---
description: "Documentation guidelines and best practices for Python projects"
applyTo: "**/*"
---

# Documentation Guidelines

## Core Principles

When creating or updating documentation:

- **Document what, how, and why**: Cover functionality, usage, and design decisions
- **Keep docs in sync with code**: Update documentation whenever code changes
- **Write for your audience**: Users need usage guides, developers need API references
- **Automate where possible**: Generate API docs from docstrings, use CI to validate builds

## Docstring Standards

### NumPy-Style Format

ALL public functions, classes, and methods MUST include NumPy-style docstrings with these sections:

- **Summary**: One-line description (required)
- **Parameters**: Document each parameter with type and description (required if function has parameters)
- **Returns**: Document return value with type and description (required if function returns)
- **Raises**: Document exceptions that may be raised (optional but recommended)
- **Examples**: Provide usage examples (highly recommended)
- **Notes**: Additional context or caveats (optional)

### Example Template

```python
def function_name(param1: type1, param2: type2) -> return_type:
"""Brief one-line summary.

    Optional extended description providing more context about what
    the function does and why it exists.

    Parameters
    ----------
    param1 : type1
        Description of first parameter.
    param2 : type2
        Description of second parameter.

    Returns
    -------
    return_type
        Description of return value.

    Raises
    ------
    ValueError
        When parameter validation fails.
    TypeError
        When parameter has wrong type.

    Examples
    --------
    >>> function_name(value1, value2)
    expected_output

    Notes
    -----
    Additional information about implementation details or usage.
    """
    pass

```

## Documentation Tooling

### For Simple to Medium Projects

Use **MkDocs** with **mkdocstrings** plugin:

```bash

# Install

pip install mkdocs mkdocs-material mkdocstrings[python]

# Create basic config (mkdocs.yml)

# Build docs

mkdocs build --strict

# Serve locally

mkdocs serve
```

**Benefits**: Simple setup, Markdown-native, excellent Material theme, automatic API doc generation.

### For Complex Projects

Use **Sphinx** with Napoleon extension:

```bash
# Install

pip install sphinx sphinx-rtd-theme sphinx-autodoc-typehints

# Initialize

sphinx-quickstart docs

# Build with warnings as errors

sphinx-build -W docs docs/\_build
```

**Benefits**: Advanced features, multiple output formats, extensive customization.

## Required Documentation Files

### README.md (Root)

MUST include:

- Project title and description
- Key features (bullet points)
- Installation instructions
- Quickstart/usage example
- Link to full documentation
- License information
- Contribution guidelines link

### CHANGELOG.md (Root)

MUST follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added

- New features

### Changed

- Changes in existing functionality

### Deprecated

- Soon-to-be removed features

### Removed

- Removed features

### Fixed

- Bug fixes

### Security

- Security updates

## [1.0.0] - 2025-01-15

### Added

- Initial release
```

Use **Conventional Commits** to automate changelog generation with **Semantic Release**.

### CONTRIBUTING.md (Root, if open source)

MUST include:

- How to set up development environment
- Coding standards and style guide
- How to run tests
- Pull request process
- Issue reporting guidelines

### LICENSE (Root)

Choose appropriate license:

- **MIT**: Permissive, allows commercial use
- **Apache 2.0**: Permissive with patent grant
- **GPL-3**: Copyleft, requires sharing modifications
- **GNU AGPL-3**: Strong copyleft, requires sharing modifications even for network use

## Type Hints

ALL function signatures MUST include type hints using modern Python 3.9+ syntax:

```python
def process_data(
    data: list[dict[str, int | str]],
    threshold: float | None = None
) -> dict[str, int]:
    """Process data with optional threshold."""
    pass
```

**Modern syntax guidelines (Python 3.9+)**:

- Use built-in types: `list`, `dict`, `set`, `tuple` instead of `List`, `Dict`, `Set`, `Tuple`
- Use `X | Y` instead of `Union[X, Y]` (Python 3.10+)
- Use `X | None` instead of `Optional[X]` (Python 3.10+)
- Import from `typing` only for special types: `TypeVar`, `Protocol`, `Literal`, etc.

**Example with advanced types**:

```python
from collections.abc import Callable, Iterable, Sequence
from typing import TypeVar, Protocol

T = TypeVar('T')

def transform(
    items: Sequence[T],
    func: Callable[[T], str]
) -> list[str]:
    """Transform items using provided function."""
    return [func(item) for item in items]
```

Benefits:

- Cleaner, more readable syntax
- Native Python support (no imports for basic types)
- Enables static type checking with mypy
- Enhances IDE autocomplete
- Reduces runtime errors

## Inline Comments

### Guidelines

**DO**:

- Comment non-obvious logic or algorithms
- Explain "why" not "what"
- Use TODO/FIXME tags consistently: `# TODO: description`
- Keep comments up-to-date with code

**DON'T**:

- State the obvious: `i = 0 # set i to zero`
- Leave outdated comments
- Over-comment self-explanatory code
- Use comments as a substitute for clear code

### Section Tags

For large modules, use section headers:

```python

# --- Data Loading ---

# --- Data Processing ---

# --- Validation ---

# --- Output Generation ---

```

## Documentation in CI/CD

### Required CI Steps

Add to `.github/workflows/ci.yml`:

```yaml

- name: Build documentation
  run: |
  mkdocs build --strict # For MkDocs

  # OR

  sphinx-build -W docs docs/\_build # For Sphinx

- name: Check docstring coverage
  run: |
  interrogate -v --fail-under=80 src/
```

### Auto-Deploy Documentation

Deploy to GitHub Pages on release:

```yaml
- name: Deploy docs
  if: github.event_name == 'release'
  run: |
  mkdocs gh-deploy --force
```

## Best Practices for AI Assistance

When generating or updating documentation:

1. **Always include docstrings** for new functions/classes
2. **Update docstrings** when modifying function signatures
3. **Provide examples** in docstrings to show usage
4. **Keep README in sync** with major changes
5. **Update CHANGELOG** using Conventional Commits
6. **Validate docs build** before committing
7. **Check for broken links** in documentation
8. **Ensure type hints** are present and accurate

## Documentation Checklist

Before committing code with new/modified functionality:

- [ ] All public functions have NumPy-style docstrings
- [ ] Type hints added to function signatures
- [ ] Usage examples included in docstrings
- [ ] README updated if API changed
- [ ] CHANGELOG updated with changes
- [ ] Documentation builds without warnings
- [ ] Links in docs are valid
- [ ] Code comments explain non-obvious logic
- [ ] TODO tags tracked or addressed
