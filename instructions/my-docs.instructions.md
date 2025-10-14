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

### Recommended: MkDocs with Material Theme

Use **MkDocs** with **mkdocstrings[python]** plugin for automatic API documentation from docstrings:

```bash
# Install
pip install mkdocs mkdocs-material mkdocstrings[python]

# Create basic mkdocs.yml configuration
site_name: My Project
theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - toc.integrate
    - search.suggest

plugins:
  - search
  - mkdocstrings:
      handlers:
        python:
          paths: [src]
          options:
            docstring_style: numpy
            show_source: true
            show_root_heading: true
            show_signature_annotations: true
            separate_signature: true

markdown_extensions:
  - pymdownx.highlight
  - pymdownx.superfences
  - pymdownx.tabbed
  - admonition
  - codehilite

# Build docs (fail on warnings)
mkdocs build --strict

# Serve locally for preview
mkdocs serve
```

**Benefits**: 
- Simple Markdown-based documentation
- Automatic API docs from NumPy-style docstrings
- Beautiful Material theme
- Fast builds and live reloading
- Easy GitHub Pages deployment

### Alternative: Sphinx for Large Projects

Use **Sphinx** with Napoleon extension for complex documentation needs:

```bash
# Install
pip install sphinx sphinx-rtd-theme sphinx-autodoc-typehints

# Initialize in docs/ directory
sphinx-quickstart docs

# Configure docs/conf.py
extensions = [
    'sphinx.ext.autodoc',
    'sphinx.ext.napoleon',  # NumPy-style docstrings
    'sphinx.ext.viewcode',
    'sphinx_autodoc_typehints',
]
napoleon_numpy_docstring = True

# Build with warnings as errors
sphinx-build -W docs docs/_build
```

**Benefits**: 
- Advanced features (cross-references, multiple output formats)
- Extensive customization
- Industry standard for large projects

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

ALL function signatures MUST include type hints using modern Python 3.10+ syntax:

```python
def process_data(
    data: list[dict[str, int | str]],
    threshold: float | None = None,
) -> dict[str, int]:
    """Process data with optional threshold."""
    pass
```

**Modern syntax guidelines (Python 3.10+)**:

- Use built-in types: `list`, `dict`, `set`, `tuple` instead of importing from `typing`
- Use `X | Y` instead of `Union[X, Y]`
- Use `X | None` instead of `Optional[X]`
- Import from `typing` only for special types: `TypeVar`, `Protocol`, `Literal`, `Callable`, etc.
- Import from `collections.abc` for abstract types: `Sequence`, `Mapping`, `Iterable`, etc.

**Example with advanced types**:

```python
from collections.abc import Callable, Sequence
from typing import TypeVar, Literal

T = TypeVar('T')

def transform(
    items: Sequence[T],
    func: Callable[[T], str],
    mode: Literal["fast", "slow"] = "fast",
) -> list[str]:
    """Transform items using provided function.
    
    Parameters
    ----------
    items : Sequence[T]
        Input items to transform.
    func : Callable[[T], str]
        Transformation function.
    mode : Literal["fast", "slow"], optional
        Processing mode, by default "fast".
    
    Returns
    -------
    list[str]
        Transformed items.
    """
    return [func(item) for item in items]
```

**Benefits**:

- Cleaner, more readable syntax
- Native Python support (no imports for basic types)
- Enables static type checking with mypy
- Enhances IDE autocomplete and refactoring
- Catches type-related errors before runtime
- Self-documenting code

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
- name: Check docstring coverage
  run: |
    pip install interrogate
    interrogate -v --fail-under=80 src/

- name: Build documentation
  run: |
    pip install mkdocs mkdocs-material mkdocstrings[python]
    mkdocs build --strict
  # OR for Sphinx:
  # pip install sphinx sphinx-rtd-theme sphinx-autodoc-typehints
  # sphinx-build -W docs docs/_build
```

### Auto-Deploy Documentation to GitHub Pages

Deploy to GitHub Pages on pushes to main:

```yaml
name: Deploy Docs

on:
  push:
    branches: [main]

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: "pip"
      
      - name: Install dependencies
        run: |
          pip install mkdocs mkdocs-material mkdocstrings[python]
      
      - name: Deploy docs
        run: mkdocs gh-deploy --force
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
