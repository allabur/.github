---
description: "Review git staged changes and generate conventional commit message with detailed body and references"
---

# Review & Generate Commit Message

You are an expert in git workflows and conventional commits. Review the staged changes and generate a comprehensive, standards-compliant commit message.

## Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

Choose the appropriate type:

- **feat**: New feature for the user
- **fix**: Bug fix for the user
- **docs**: Documentation only changes
- **style**: Formatting, missing semicolons, etc. (no code change)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes to build system or external dependencies
- **ci**: Changes to CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

**Breaking Changes**: Add `!` after type: `feat!:` or `fix!:`

## Guidelines

### Description Line (≤50 characters)

- Use imperative mood: "add" not "added" or "adds"
- Don't capitalize first letter
- No period at the end
- Be specific and concise

### Body (≤72 characters per line)

Include when changes need explanation:

- **Why**: Motivation for the change
- **What**: What changed at a high level
- **Context**: Background information
- **Contrast**: How it differs from previous behavior

### Footer

- Reference issues: `Closes #123`, `Fixes #456`, `Refs #789`
- Breaking changes: `BREAKING CHANGE: description`
- Co-authors: `Co-authored-by: Name <email>`

## Special Cases

### Jupyter Notebooks

```
notebook(filename-without-extension): WIP updates YYYY-MM-DD

Brief description of notebook changes, focusing on logic not outputs.
```

### Multiple Changes

If too many changes, suggest splitting:

```
Consider splitting this commit into:
1. feat(parser): add JSON support
2. test(parser): add JSON parsing tests
3. docs(parser): update parser documentation
```

## Analysis Steps

1. **Review the diff**: Understand what changed (files, lines, logic)
2. **Identify the main purpose**: What is the primary goal?
3. **Check for multiple concerns**: Should this be split?
4. **Find related issues**: Look for issue references in code or comments
5. **Assess impact**: Is this a breaking change?

## Output Format

### Generated Commit Message

```
type(scope): description

Detailed explanation of what changed and why.
Include context that will be valuable to future developers.

Closes #123
```

### Analysis & Recommendations

- **Type justification**: Why this type was chosen
- **Scope identification**: What area of codebase is affected
- **Split recommendation**: If changes should be separate commits
- **Issue references**: Suggest linking to related issues
- **Breaking change check**: Flag if breaking changes detected

## Examples

### Feature Addition

```
feat(auth): add OAuth2 login integration

Implement OAuth2 authentication flow using industry-standard library.
Supports Google, GitHub, and Microsoft providers.

This improves security by delegating authentication to trusted providers
and reduces maintenance burden of password management.

Closes #234
```

### Bug Fix

```
fix(parser): handle null values in JSON response

Previously, null values in API responses caused ValueError.
Now properly handles nulls by treating them as None in Python.

Fixes #456
```

### Refactoring

```
refactor(database): extract query builder to separate module

Move query construction logic from models.py to query_builder.py
for better separation of concerns and testability.

No functional changes, existing tests pass unchanged.
```

### Documentation

```
docs: update installation instructions for Python 3.13

Add mamba as recommended environment manager.
Include troubleshooting section for common setup issues.
```

Focus on generating commit messages that will be valuable when reviewing project history months later.
