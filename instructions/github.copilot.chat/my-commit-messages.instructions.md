---
description: "Commit message formatting and conventions"
---

# Commit Message Instructions

## Commit Message Format

Follow the Conventional Commits specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

- **feat**: A new feature for the user
- **fix**: A bug fix for the user
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (formatting, etc.)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

## Guidelines

- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Don't capitalize the first letter of the description
- Don't end the description with a period
- Limit the description to 50 characters
- Limit the body to 72 characters per line
- Include motivation for the change and contrast with previous behavior

## Examples

```
feat(auth): add OAuth2 login integration

fix: resolve memory leak in data processing

docs: update API documentation for v2.0

refactor(database): optimize query performance

test: add unit tests for user validation

style: fix indentation in components

perf: improve loading time for large datasets

ci: add automated testing workflow

chore: update dependencies to latest versions

revert: revert "feat: add experimental feature"
```

## Breaking Changes

For breaking changes, add "BREAKING CHANGE:" in the footer or use "!" after the type:

```
feat!: remove deprecated API endpoints

BREAKING CHANGE: The old authentication endpoints have been removed.
Use the new OAuth2 endpoints instead.
```

## Issue References

Reference issues in the footer:

```
fix: correct navigation bug

Closes #123
Fixes #456
```

## Notebook-specific Convention

MANDATORY When committing changes to Jupyter Notebooks (`.ipynb`), use the following format:

```
notebook({fileBasenameNoExtension}): WIP updates {YYYY-MM-DD}
```

- `{fileBasenameNoExtension}` is the name of the notebook without the `.ipynb` extension.
- `{YYYY-MM-DD}` is the date of the commit.
- Ignore outputs, execution counts, and metadata.
- Focus only on logical changes in code or markdown cells.
