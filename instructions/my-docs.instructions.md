# My Python Documentation Instructions

## Documentation Philosophy

Documentation should be:
- **Clear and concise**: Get to the point quickly
- **Example-driven**: Show, don't just tell
- **Up-to-date**: Update docs with code changes
- **Accessible**: Easy to find and navigate

## Documentation Types

### 1. Code Documentation (Docstrings)

Every public module, class, function, and method must have a docstring.

#### Module Docstrings

```python
"""User authentication and authorization module.

This module provides functions and classes for handling user authentication,
including password hashing, token generation, and session management.

Example:
    >>> from myapp.auth import authenticate_user
    >>> user = authenticate_user("username", "password")
    >>> print(user.is_authenticated)
    True
"""
```

#### Class Docstrings

```python
class UserRepository:
    """Repository for user data operations.
    
    Provides methods for CRUD operations on user entities with
    proper error handling and validation.
    
    Attributes:
        db: Database connection instance.
        cache: Optional cache for query results.
        
    Example:
        >>> repo = UserRepository(db_connection)
        >>> user = repo.get_by_id(123)
        >>> user.email
        'user@example.com'
    """
```

#### Function Docstrings

Use Google-style docstrings:

```python
def hash_password(
    password: str,
    *,
    salt: bytes | None = None,
    iterations: int = 100000,
) -> tuple[bytes, bytes]:
    """Hash a password using PBKDF2-HMAC-SHA256.
    
    Args:
        password: Plain text password to hash.
        salt: Optional salt bytes. Generated if not provided.
        iterations: Number of iterations for key derivation (default: 100000).
        
    Returns:
        Tuple of (hashed_password, salt) as bytes.
        
    Raises:
        ValueError: If password is empty or too short.
        
    Example:
        >>> hashed, salt = hash_password("my_secure_password")
        >>> len(hashed)
        32
    """
```

### 2. README Documentation

Every project must have a comprehensive README.md:

```markdown
# Project Name

Brief one-line description of what the project does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Installation

### Using pip

\`\`\`bash
pip install package-name
\`\`\`

### From source

\`\`\`bash
git clone https://github.com/user/repo.git
cd repo
pip install -e ".[dev]"
\`\`\`

## Quick Start

\`\`\`python
from package_name import main_function

result = main_function(arg1, arg2)
print(result)
\`\`\`

## Configuration

Configuration options can be set via environment variables or config file:

\`\`\`python
# config.yml
setting1: value1
setting2: value2
\`\`\`

## Usage

### Basic Usage

[Examples of common use cases]

### Advanced Usage

[Examples of advanced features]

## Development

### Running Tests

\`\`\`bash
pytest
\`\`\`

### Code Quality

\`\`\`bash
ruff check .
mypy src/
\`\`\`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

[License information]

## Credits

[Acknowledgments]
```

### 3. API Documentation

Use MkDocs with mkdocstrings for automatic API documentation:

```yaml
# mkdocs.yml
site_name: My Project
site_description: Project description
site_url: https://myproject.readthedocs.io

theme:
  name: material
  palette:
    primary: blue
    accent: light blue
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
          options:
            docstring_style: google
            show_source: true
            show_root_heading: true

nav:
  - Home: index.md
  - User Guide:
    - Installation: guide/installation.md
    - Quick Start: guide/quickstart.md
    - Configuration: guide/configuration.md
  - API Reference:
    - Module 1: api/module1.md
    - Module 2: api/module2.md
  - Contributing: contributing.md
  - Changelog: changelog.md
```

### 4. Tutorial Documentation

Provide step-by-step tutorials for common workflows:

```markdown
# Tutorial: Building Your First Pipeline

This tutorial walks you through creating a data processing pipeline.

## Prerequisites

- Python 3.10 or higher
- Basic understanding of pandas

## Step 1: Setup

Create a new project:

\`\`\`bash
mkdir my-pipeline
cd my-pipeline
python -m venv .venv
source .venv/bin/activate
pip install pandas
\`\`\`

## Step 2: Create the Pipeline

[Detailed steps with code examples]

## Step 3: Test the Pipeline

[Testing examples]

## Next Steps

- [Link to advanced topics]
- [Link to API reference]
```

## Documentation Tools

### MkDocs Setup

```bash
# Install MkDocs with Material theme
pip install mkdocs mkdocs-material mkdocstrings[python]

# Create new documentation
mkdocs new .

# Serve locally
mkdocs serve

# Build for deployment
mkdocs build
```

### Sphinx Setup (Alternative)

```bash
# Install Sphinx
pip install sphinx sphinx-rtd-theme

# Initialize
sphinx-quickstart docs

# Build HTML
cd docs
make html
```

## Documentation Guidelines

### Writing Style

1. **Be concise**: Avoid unnecessary words
2. **Use active voice**: "The function returns" not "The value is returned"
3. **Be specific**: Provide exact details, not vague descriptions
4. **Use examples**: Code examples are worth a thousand words
5. **Keep it current**: Update docs with code changes

### Code Examples

- Must be valid, runnable code
- Include necessary imports
- Show expected output
- Cover common use cases
- Include error handling examples

### Type Information

Always include type hints in signatures:

```python
def process(data: list[dict[str, Any]]) -> pd.DataFrame:
    """Convert list of dicts to DataFrame.
    
    Args:
        data: List of dictionaries with consistent keys.
        
    Returns:
        DataFrame with columns from dictionary keys.
    """
```

## Documentation Structure

```
docs/
├── index.md                 # Home page
├── installation.md          # Installation instructions
├── quickstart.md           # Quick start guide
├── user-guide/
│   ├── basics.md          # Basic concepts
│   ├── advanced.md        # Advanced features
│   └── configuration.md   # Configuration options
├── api/
│   ├── core.md           # Core module API
│   ├── utils.md          # Utilities API
│   └── exceptions.md     # Exception classes
├── tutorials/
│   ├── tutorial-1.md     # Tutorial 1
│   └── tutorial-2.md     # Tutorial 2
├── contributing.md         # Contribution guidelines
└── changelog.md           # Version history
```

## Changelog Management

Keep a CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/):

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New feature X

### Changed
- Modified behavior of Y

### Deprecated
- Feature Z will be removed in next major version

### Removed
- Removed deprecated feature A

### Fixed
- Bug fix for issue #123

### Security
- Security patch for vulnerability CVE-XXXX

## [1.0.0] - 2025-01-15

### Added
- Initial release
```

## Documentation Review Checklist

Before merging changes:

- [ ] All new public APIs have docstrings
- [ ] Docstrings follow Google style
- [ ] README updated with new features
- [ ] API docs regenerated and reviewed
- [ ] Examples are tested and work
- [ ] Links are valid (no 404s)
- [ ] Changelog updated
- [ ] Version numbers updated if needed
- [ ] Documentation builds without errors
- [ ] Screenshots updated if UI changed

## Automation

### Pre-commit Hook

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.8
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

### CI Documentation Build

Ensure docs build in CI pipeline:

```yaml
# .github/workflows/docs.yml
name: Documentation

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      - run: pip install -e ".[docs]"
      - run: mkdocs build --strict
```

## Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Google Style Docstrings](https://google.github.io/styleguide/pyguide.html#38-comments-and-docstrings)
- [Sphinx Documentation](https://www.sphinx-doc.org/)
