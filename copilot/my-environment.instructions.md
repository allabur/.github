---
description: "Environment and package management guidelines for Python projects"
applyTo: "**/*.{py,toml,lock}"
---

# Environment & Package Management Guidelines

## Overview

**uv** is a fast, reliable Python package and environment manager written in Rust. It replaces pip, pip-tools, virtualenv, and conda/mamba with a single tool that is 10-100x faster.

## Core Principles

- **Single tool**: Use `uv` for all package and environment management
- **pyproject.toml first**: Single source of truth for project metadata and dependencies
- **Lockfile discipline**: Commit `uv.lock` for reproducible environments
- **Virtual environments**: Always use project-specific `.venv/` (auto-created by uv)
- **Modern standards**: Follow PEP 621, PEP 631, PEP 660

## Installation

### macOS/Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Windows

```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Verify Installation

```bash
uv --version
```

## Project Setup

```bash
# Create new project with standard structure
uv init myproject
cd myproject

# Initialize git
git init

# Add dependencies
uv add pandas numpy scikit-learn

# Add development dependencies
uv add --dev pytest ruff mypy pytest-cov

# Sync environment (creates .venv/ and installs everything)
uv sync
```

## Essential Commands

### Environment Management

```bash
# Create/update virtual environment and install all dependencies
uv sync

# Sync only production dependencies (exclude dev)
uv sync --no-dev

# Update all dependencies to latest compatible versions
uv lock --upgrade

# Update specific package
uv lock --upgrade-package pandas

# Remove virtual environment
rm -rf .venv/
```

### Package Management

```bash
# Add production dependency
uv add package-name

# Add with version constraint
uv add "pandas>=2.0.0,<3.0.0"

# Add development dependency
uv add --dev pytest

# Add optional dependency group
uv add --optional docs sphinx

# Remove package
uv remove package-name

# List installed packages
uv pip list
```

### Running Commands

```bash
# Run Python script in project environment
uv run python script.py

# Run installed command-line tool
uv run pytest
uv run ruff check .
uv run mypy .

# Run arbitrary command
uv run jupyter notebook

# Activate environment manually (optional, uv run is preferred)
source .venv/bin/activate  # Unix/macOS
.venv\Scripts\activate     # Windows

```

## Python Version Management {#python-version}

```bash
# Install specific Python version
uv python install 3.12

# Use specific Python version for project
uv python pin 3.12

# List available Python versions
uv python list

# List installed Python versions
uv python list --only-installed
```

### Python Version Requirements

When specifying `requires-python` in `pyproject.toml`, follow these guidelines:

```toml
# Option 1: Flexible (recommended for most projects)
requires-python = ">=3.12"
# ✅ Works with 3.12, 3.13, 3.14, and future versions
# ✅ Broad ecosystem compatibility
# ✅ CI/CD friendly

# Option 2: Conservative (good for production)
requires-python = ">=3.12,<3.14"
# ✅ Only 3.12 and 3.13
# ✅ Avoid surprises from very new versions
# ✅ Predictable behavior

# Option 3: Modern (new/experimental projects)
requires-python = ">=3.13"
# ✅ Latest features
# ⚠️ Some packages may not have wheels yet
# ⚠️ Less tested in production

# Option 4: Legacy compatibility
requires-python = ">=3.10"
# ✅ Maximum compatibility
# ⚠️ Missing newer Python features
```

### ❌ What NOT to Use

```toml
# Don't use "latest" - not a valid PEP 440 specifier
requires-python = "latest"  # ❌ Invalid

# Avoid exact versions for libraries (too restrictive)
requires-python = "==3.12"  # ⚠️ Only for specific use cases
```

### Version Timeline (as of October 2025)

- **Python 3.10**: Released Oct 2021, supported until Oct 2026
- **Python 3.11**: Released Oct 2022, supported until Oct 2027
- **Python 3.12**: Released Oct 2023, supported until Oct 2028 ⭐ **Recommended**
- **Python 3.13**: Released Oct 2024, supported until Oct 2029
- **Python 3.14**: Released Oct 2025, supported until Oct 2030 (very new!)

### Decision Guide

**Use `>=3.12` if:**

- Building a library or package
- Want maximum compatibility
- Need stable ecosystem support

**Use `>=3.12,<3.14` if:**

- Enterprise/production application
- Want to avoid untested versions
- Need predictable CI/CD

**Use `>=3.13` if:**

- Personal/experimental project
- Want latest Python features
- Can handle occasional compatibility issues

## [pyproject.toml](templates/pyproject.toml) {#pyproject-toml}

## Lockfile Management {#lockfile-management}

### Understanding uv.lock

- **Auto-generated**: Created/updated automatically by `uv add`, `uv sync`, `uv lock`
- **Reproducible**: Pins exact versions of all dependencies and sub-dependencies
- **Cross-platform**: Works on different OS and architectures
- **Commit it**: Always commit `uv.lock` to version control

### Lockfile Operations

```bash
# Update lockfile without syncing environment
uv lock

# Update lockfile and environment
uv sync

# Update specific package in lockfile
uv lock --upgrade-package requests

# Regenerate lockfile from scratch
rm uv.lock && uv lock
```

## Workflow Patterns

### Daily Development

```bash
# Morning: Sync environment with latest lockfile
uv sync

# Add new dependency as needed
uv add requests

# Run tests
uv run pytest

# Run linting
uv run ruff check .

# Run type checking
uv run mypy .

# Evening: Commit changes including uv.lock
git add pyproject.toml uv.lock
git commit -m "feat: add requests for API integration"
```

### Dependency Updates

```bash
# Weekly: Update all dependencies
uv lock --upgrade

# Test that everything still works
uv run pytest

# If tests pass, commit
git add uv.lock
git commit -m "chore: update dependencies"
```

### [CI/CD Integration](templates/ci.yml)

## [Migration from Other Tools](../scripts/migrate-to-uv.sh)

### Comparison with Other Tools

| Feature         | uv                 | pip          | conda       | Poetry      |
| --------------- | ------------------ | ------------ | ----------- | ----------- |
| Speed           | ⚡️ 10-100x faster | 1x           | ~3x         | ~2x         |
| Lockfile        | ✅ Built-in        | ⚠️ pip-tools | ✅ Built-in | ✅ Built-in |
| Virtual envs    | ✅ Auto-created    | ❌ Manual    | ✅ Built-in | ✅ Built-in |
| Python install  | ✅ Yes             | ❌ No        | ✅ Yes      | ❌ No       |
| PEP 621         | ✅ Native          | ⚠️ Limited   | ❌ No       | ⚠️ Custom   |
| Cross-platform  | ✅ Yes             | ✅ Yes       | ✅ Yes      | ✅ Yes      |
| Non-Python deps | ❌ No              | ❌ No        | ✅ Yes      | ❌ No       |

### From conda/mamba

**Before (environment.yml):**

```yaml
name: myproject
channels:
  - conda-forge
dependencies:
  - python=3.12
  - pandas
  - numpy
  - pip:
      - pytest
```

**After (pyproject.toml):**

```toml
[project]
name = "myproject"
requires-python = ">=3.12"
dependencies = ["pandas", "numpy"]

[project.optional-dependencies]
dev = ["pytest"]
```

**Migration steps:**

1. `uv init` (if starting fresh) or create `pyproject.toml`
2. `uv add pandas numpy` (production dependencies)
3. `uv add --dev pytest` (development dependencies)
4. `uv sync`
5. Delete `environment.yml`
6. Update `.gitignore` to include `.venv/` and exclude `uv.lock` is committed

### From pip + requirements.txt

**Before:**

```txt
# requirements.txt
pandas>=2.0.0
numpy>=1.24.0
scikit-learn>=1.3.0

# requirements-dev.txt
pytest>=7.0.0
ruff>=0.1.0
```

**After:**

```bash
# Convert requirements.txt
uv add $(cat requirements.txt)

# Convert requirements-dev.txt
uv add --dev $(cat requirements-dev.txt)

# Or manually:
uv add pandas numpy scikit-learn
uv add --dev pytest ruff

# Sync environment
uv sync
```

### From Poetry

**Before (pyproject.toml with Poetry):**

```toml
[tool.poetry]
name = "myproject"
version = "0.1.0"

[tool.poetry.dependencies]
python = "^3.12"
pandas = "^2.0.0"

[tool.poetry.dev-dependencies]
pytest = "^7.0.0"
```

**After (pyproject.toml with uv):**

```toml
[project]
name = "myproject"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = ["pandas>=2.0.0"]

[project.optional-dependencies]
dev = ["pytest>=7.0.0"]
```

**Migration steps:**

1. Update `[tool.poetry]` section to `[project]` (PEP 621 format)
2. Convert `[tool.poetry.dependencies]` to `dependencies = []`
3. Convert `[tool.poetry.dev-dependencies]` to `[project.optional-dependencies] dev = []`
4. Remove `poetry.lock` and `.venv/`
5. `uv sync`
6. Delete `poetry.lock`

## Best Practices

### Project Structure

```
myproject/
├── .venv/              # Virtual environment (auto-created, not committed)
├── src/
│   └── myproject/      # Source code
├── tests/              # Test suite
├── docs/               # Documentation
├── pyproject.toml      # Project metadata and dependencies
├── uv.lock             # Lockfile (commit this!)
├── README.md
├── .gitignore
└── .python-version     # Optional: pin Python version
```

### [.gitignore](templates/.gitignore)

### Security

- **Never commit `.venv/`**: Contains local installation paths
- **Always commit `uv.lock`**: Ensures reproducible environments
- **Use environment variables**: For secrets and API keys
- **Pin Python version**: Use `requires-python` in `pyproject.toml`
- **Review lockfile changes**: When updating dependencies

### Performance

- **Cache uv in CI**: Use `actions/cache` for faster builds
- **Use `uv sync --no-dev`**: In production deployments
- **Parallel installations**: uv automatically parallelizes
- **Local cache**: uv caches downloads in `~/.cache/uv/`

## Troubleshooting

### Common Issues

**Issue: `uv sync` fails with dependency conflict**

```bash
# Solution 1: Update lockfile
uv lock --upgrade

# Solution 2: Check for incompatible constraints
uv pip tree

# Solution 3: Relax version constraints in pyproject.toml
# Change "package==1.0.0" to "package>=1.0.0"
```

**Issue: Package not found**

```bash
# Check available versions
uv pip index versions package-name

# Try with different index
uv add package-name --index-url https://pypi.org/simple
```

**Issue: Python version mismatch**

```bash
# Check required version
cat pyproject.toml | grep requires-python

# Install correct version
uv python install 3.12

# Pin version for project
uv python pin 3.12
```

**Issue: Slow first sync**

```bash
# This is normal - uv is downloading and caching packages
# Subsequent syncs will be much faster

# Check cache location
ls ~/.cache/uv/
```

### Getting Help

```bash
# General help
uv --help

# Command-specific help
uv add --help
uv sync --help

# Check installed version
uv --version

# Official documentation
# https://docs.astral.sh/uv/
```

### When NOT to Use uv

- **System-level packages**: Use OS package manager (apt, brew, etc.)
- **Non-Python dependencies**: Use conda/mamba for binary dependencies (CUDA, etc.)
- **Legacy Python (<3.8)**: uv requires Python 3.8+
- **Existing Poetry projects**: Migration requires effort, may not be worth it mid-project

## Additional Resources

- **Official docs**: https://docs.astral.sh/uv/
- **GitHub**: https://github.com/astral-sh/uv
- **PEP 621**: https://peps.python.org/pep-0621/
- **Packaging guide**: https://packaging.python.org/

## Guiding Principles for AI Assistance

When working with uv projects:

1. **Always use `uv run`** for executing commands in project context
2. **Never suggest pip directly** - use `uv add` instead
3. **Ensure pyproject.toml exists** before adding dependencies
4. **Remind to commit uv.lock** after dependency changes
5. **Suggest `uv sync` after cloning** a repository
6. **Use modern dependency syntax** (e.g., `package>=1.0.0`)
7. **Prefer `uv` over manual venv activation** for simplicity
8. **Check Python version** requirements before suggesting packages
9. **Recommend lockfile updates** when dependencies seem outdated
10. **Explain PEP 621 format** when creating pyproject.toml

## Quick Reference

```bash
# Setup
curl -LsSf https://astral.sh/uv/install.sh | sh
uv init myproject && cd myproject

# Dependencies
uv add package-name              # Add production dependency
uv add --dev package-name        # Add dev dependency
uv remove package-name           # Remove dependency
uv sync                          # Install all dependencies

# Environment
uv run python script.py          # Run script in env
uv run pytest                    # Run tests
uv python install 3.12           # Install Python version
uv python pin 3.12               # Pin Python version

# Updates
uv lock --upgrade                # Update all dependencies
uv lock --upgrade-package pandas # Update specific package

# CI/CD
uv sync --no-dev                 # Production install
```
