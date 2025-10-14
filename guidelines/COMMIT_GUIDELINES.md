# Commit Guidelines

## Commit Message Format

Follow [Conventional Commits](https://www.conventionalcommits.org/) specification.

### Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Type

Must be one of:

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code refactoring (neither fixes a bug nor adds a feature)
- **perf**: Performance improvements
- **test**: Adding or updating tests
- **build**: Changes to build system or dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files

### Scope

Optional scope indicating what is being changed:

- **api**: API changes
- **core**: Core functionality
- **cli**: Command-line interface
- **models**: Data models
- **utils**: Utility functions
- **config**: Configuration
- **deps**: Dependencies

### Description

- Use imperative, present tense: "add" not "added" or "adds"
- Don't capitalize first letter
- No period at the end
- Maximum 72 characters

### Examples

```bash
# Simple commits
feat: add user authentication
fix: resolve database connection timeout
docs: update installation instructions
test: add tests for user service

# With scope
feat(api): add endpoint for user registration
fix(core): handle empty input in validation
docs(readme): add usage examples
refactor(models): simplify user model structure

# With body
feat: add CSV export functionality

Users can now export their data to CSV format. The export includes
all user information and related records.

# With breaking change
feat!: change API authentication method

BREAKING CHANGE: API now uses OAuth2 instead of API keys. 
All clients must update their authentication mechanism.

# Multiple paragraphs
fix: resolve memory leak in data processing

The data processor was holding references to processed items,
causing memory usage to grow unbounded.

Changes:
- Clear item references after processing
- Add memory profiling tests
- Update documentation

Closes #123
```

## Python-Specific Examples

### Features

```bash
# New functionality
feat: add data validation using pydantic
feat(models): implement user authentication model
feat(cli): add command for database migrations
feat: support async database operations

# New API
feat(api): add REST endpoint for user management
feat: implement GraphQL schema for products
```

### Bug Fixes

```bash
# Bug fixes
fix: correct type hints in user repository
fix: handle None values in data processing
fix(api): return 404 for missing resources
fix: resolve race condition in cache update

# Security fixes
fix: sanitize user input to prevent SQL injection
fix(auth): validate JWT token expiration
```

### Documentation

```bash
# Documentation updates
docs: add API documentation with examples
docs: update README with installation steps
docs: add docstrings to public functions
docs(api): document authentication flow
```

### Testing

```bash
# Test additions
test: add unit tests for user service
test: add integration tests for API endpoints
test(models): add edge case tests for validation
test: increase coverage for core module

# Test fixes
fix(test): correct mock setup in user tests
test: fix flaky test in database module
```

### Refactoring

```bash
# Code refactoring
refactor: simplify error handling logic
refactor(models): extract validation to separate class
refactor: use dataclasses instead of regular classes
refactor(api): consolidate duplicate route handlers
```

### Dependencies

```bash
# Dependency changes
build(deps): upgrade pytest to 7.4.0
build(deps): add ruff for linting
build(deps): update pydantic to 2.0.0
chore(deps): remove unused dependency requests
```

### CI/CD

```bash
# CI changes
ci: add GitHub Actions workflow for tests
ci: enable codecov integration
ci: run tests on Python 3.10, 3.11, 3.12
ci: add security scanning with bandit
```

### Performance

```bash
# Performance improvements
perf: optimize database query with indexing
perf: use lazy loading for large datasets
perf(core): reduce memory usage in data processing
perf: implement caching for frequently accessed data
```

## Commit Best Practices

### 1. Make atomic commits

Each commit should represent a single logical change:

```bash
# Good: Separate commits for separate concerns
git commit -m "feat: add user model"
git commit -m "test: add tests for user model"
git commit -m "docs: document user model API"

# Bad: Everything in one commit
git commit -m "add user model, tests, and docs"
```

### 2. Write meaningful messages

```bash
# Good: Clear and specific
feat(api): add pagination support for user list endpoint

# Bad: Vague
fix: update code
chore: changes
```

### 3. Reference issues

Link commits to issues:

```bash
fix: resolve database timeout issue

Increases connection pool size and adds retry logic.

Fixes #42

# Or multiple issues
feat: add export functionality

Implements CSV and JSON export formats.

Closes #123
Closes #124
```

### 4. Explain why, not what

```bash
# Good: Explains reasoning
refactor: switch from JSON to YAML for config

YAML is more readable and supports comments, making it easier
for users to understand and modify configuration files.

# Bad: Just states what
refactor: change config format
```

### 5. Break up large changes

```bash
# Good: Multiple focused commits
refactor(models): extract validation logic
refactor(models): add type hints
refactor(models): improve error messages
test(models): add validation tests

# Bad: One large commit
refactor: improve models code
```

## Git Workflow

### Branch Naming

```bash
# Feature branches
feature/user-authentication
feature/csv-export
feat/add-caching

# Bug fix branches
fix/database-timeout
bugfix/validation-error
fix/memory-leak

# Other branches
docs/update-readme
refactor/simplify-api
chore/update-dependencies
```

### Working with Branches

```bash
# Create feature branch
git checkout -b feat/add-user-auth

# Make commits
git add src/auth.py
git commit -m "feat(auth): add password hashing"

git add tests/test_auth.py
git commit -m "test(auth): add authentication tests"

# Push branch
git push -u origin feat/add-user-auth

# Create pull request
# (Use GitHub UI or gh CLI)
```

### Before Committing

```bash
# Run tests
pytest

# Check code quality
ruff check .
ruff format .
mypy src/

# Review changes
git diff

# Stage changes
git add src/ tests/

# Commit
git commit -m "feat: add user authentication"
```

## Commit Message Template

Create `.gitmessage` template:

```
# <type>[optional scope]: <description>
# 
# [optional body]
# 
# [optional footer(s)]
#
# Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore
# Scope: api, core, cli, models, utils, config, deps
#
# Examples:
# feat(api): add user registration endpoint
# fix: resolve database connection timeout
# docs: update API documentation
#
# Breaking changes:
# feat!: change authentication method
# BREAKING CHANGE: API now uses OAuth2
```

Configure Git to use the template:

```bash
git config --global commit.template ~/.gitmessage
```

## Amending Commits

```bash
# Amend last commit message
git commit --amend -m "fix: correct type hints in user model"

# Amend last commit with new changes
git add src/models.py
git commit --amend --no-edit

# Interactive rebase to edit history (use carefully)
git rebase -i HEAD~3
```

## Pre-commit Hooks

Automate checks before committing:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict
  
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.8
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.7.1
    hooks:
      - id: mypy
        additional_dependencies: [types-requests]
  
  - repo: https://github.com/commitizen-tools/commitizen
    rev: v3.12.0
    hooks:
      - id: commitizen
```

Install hooks:

```bash
pip install pre-commit
pre-commit install
pre-commit install --hook-type commit-msg
```

## Commitizen Tool

Use commitizen for interactive commit creation:

```bash
# Install
pip install commitizen

# Interactive commit
cz commit

# Or use alias
cz c
```

Configuration in `pyproject.toml`:

```toml
[tool.commitizen]
name = "cz_conventional_commits"
version = "0.1.0"
tag_format = "v$version"
update_changelog_on_bump = true
```

## Changelog Generation

Generate changelog from commits:

```bash
# Using commitizen
cz changelog

# Or manually maintain CHANGELOG.md following Keep a Changelog format
```

CHANGELOG.md format:

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- User authentication system
- CSV export functionality

### Fixed
- Database timeout issue

## [1.0.0] - 2025-01-15

### Added
- Initial release
- User management API
- Data validation
```

## Bad Commit Examples to Avoid

```bash
# Too vague
git commit -m "update"
git commit -m "fix bug"
git commit -m "changes"

# Missing type
git commit -m "update README"
git commit -m "add tests"

# Wrong tense
git commit -m "feat: added user auth"
git commit -m "fix: fixing timeout"

# Too much in one commit
git commit -m "add user model, API endpoints, tests, docs, and refactor database"

# No context
git commit -m "fix: fix issue"
git commit -m "refactor: refactor code"
```

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [Commitizen](https://commitizen-tools.github.io/commitizen/)
- See `/instructions/my-ci-cd.instructions.md` for CI/CD guidelines
