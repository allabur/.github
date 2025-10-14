---
description: "Code review guidelines and best practices for Python projects"
applyTo: "**/*"
---

# Code Review Guidelines

## Core Principles

When conducting code reviews:

- **Be constructive and collaborative**: Focus on improving code quality together
- **Provide specific feedback**: Explain what needs to change and why
- **Reference standards**: Link to documentation or best practices
- **Start with positives**: Acknowledge good practices when you see them
- **Categorize by severity**: Help prioritize what needs immediate attention

## Review Focus Areas

### Code Quality

- Check for code readability and maintainability
- Verify adherence to established coding standards (PEP 8 via ruff)
- Look for potential bugs and logic errors
- Assess code complexity and suggest simplifications
- Review error handling and edge case coverage
- **TDD Compliance**: Verify tests were written before implementation code
- **Type annotations**: Verify complete type annotations for all function parameters and return values
- Check that type hints follow modern Python 3.10+ standards (`|` not `Union`, built-in types not `typing` imports)
- Ensure type annotations match actual implementation and usage
- **Mypy compliance**: Verify code passes mypy strict mode

### Security Review

- Check for hardcoded secrets or sensitive information
- Verify input validation and sanitization
- Look for SQL injection or XSS vulnerabilities
- Review authentication and authorization logic
- Check for proper encryption of sensitive data

### Performance Considerations

- Identify potential performance bottlenecks
- Review database queries for efficiency
- Check for memory leaks or excessive resource usage
- Assess algorithmic complexity
- Look for unnecessary network calls or loops

### Architecture and Design

- Verify adherence to established patterns and principles
- Check for proper separation of concerns
- Review API design and interface contracts
- Assess scalability implications
- Look for code duplication and opportunities for refactoring

## Review Comments Structure

- Start with positive feedback when applicable
- Be specific about what needs to be changed and why
- Provide concrete suggestions for improvement
- Reference documentation or best practices when relevant
- Use a constructive and collaborative tone
- Categorize comments by severity: Critical, Major, Minor, Suggestion

## Common Issues to Flag

- **TDD violations**: Production code without corresponding tests written first
- Missing error handling
- Inconsistent naming conventions
- Lack of documentation or comments
- Hardcoded values that should be configurable
- Unused variables or imports
- Potential race conditions in concurrent code
- Missing or inadequate tests (especially regression tests for bug fixes)
- Security vulnerabilities
- Performance anti-patterns
- Violation of SOLID principles
- **Missing type annotations** on function parameters or return values
- **Incorrect type hints** that don't match implementation
- Use of deprecated typing syntax (e.g., `List` instead of `list`, `Union` instead of `|`)
- **Ruff violations**: Code that doesn't pass `ruff format --check` or `ruff check`
- **Mypy errors**: Code that doesn't pass `mypy .` in strict mode
- **Test warnings**: Tests that generate warnings (should use `-W error`)
- **Low coverage**: Code changes without adequate test coverage (< 70%)

## Review Approval Criteria

- All critical and major issues must be addressed
- Code follows team coding standards
- Adequate test coverage is provided
- Documentation is complete and accurate
- No security vulnerabilities are present
- Performance impact is acceptable

## Code Review Checklist

Before approving or merging code, verify the following:

### Style & Quality

- [ ] **Style & Lint**: Does the code pass automated style checks?

  - Run `ruff format --check .` - no formatting issues
  - Run `ruff check .` - no lint errors
  - No PEP 8 violations
  - Code is cleanly formatted

- [ ] **Naming**: Are all new variables, functions, classes named according to conventions?
  - Descriptive, correct case (snake_case for functions, PascalCase for classes)
  - Public API names make sense in context
  - Follow PEP 8 naming conventions
  - No typos or abbreviations (except common ones like `df`, `api`, `url`)

### Documentation

- [ ] **Docstrings**: Does every public function/class have up-to-date NumPy-style docstrings?

  - Explains purpose, parameters, and return values
  - Includes examples where helpful
  - Raises section for important exceptions

- [ ] **Documentation Files**: Are docs updated for any new features or changes?

  - README reflects current functionality
  - Usage examples still work
  - API documentation is accurate
  - CHANGELOG updated with changes

- [ ] **Type Annotations**: Are functions and methods properly type-hinted?
  - Modern Python 3.10+ syntax (`list`, `dict`, not `List`, `Dict`)
  - Use `X | Y` instead of `Union[X, Y]`
  - Use `X | None` instead of `Optional[X]`
  - Run `mypy .` in strict mode - no typing issues
  - Types are readable, accurate, and necessary
  - Return types specified for all functions
  - Parameter types specified for all function arguments

### Error Handling & Testing

- [ ] **TDD Compliance**: Were tests written BEFORE implementation code?

  - Check commit history or PR description for test-first approach
  - Tests should demonstrate behavior before implementation
  - Red-Green-Refactor cycle followed

- [ ] **Error Handling**: Are exceptions used appropriately?

  - No silent `pass` on error
  - Specific exceptions caught (not blanket `except:` or bare `except Exception:`)
  - New errors are handled or explicitly propagated
  - No bare `except` or overly broad catches
  - Custom exceptions defined when appropriate

- [ ] **Testing**: Is there adequate test coverage?

  - Tests cover new code or bug fix (especially for bug fixes - regression tests)
  - Tests cover normal cases and edge cases (empty inputs, None, negative numbers)
  - All tests pass (`pytest`)
  - Test coverage ≥ 70% (target: 90%): `pytest --cov=mypackage`
  - Tests use AAA pattern (Arrange-Act-Assert)
  - Tests are isolated and don't depend on each other
  - Parametrized tests used for multiple similar cases
  - Mocks used for external dependencies (APIs, databases, file I/O)

- [ ] **Warnings**: Does the code introduce any new warnings?
  - Run tests with `-W error` to check: `pytest -W error`
  - No new deprecation or resource warnings
  - All warnings addressed or explicitly filtered

### Performance & Security

- [ ] **Performance Impact**: Is performance acceptable?

  - Performance-sensitive areas profiled or measured
  - Avoids obvious slowdowns (unnecessary loops, etc.)
  - Optimizations are justified with evidence
  - No premature micro-optimizations

- [ ] **Security & Secrets**: Are credentials properly handled?
  - No hardcoded secrets or personal data
  - API keys loaded from environment variables
  - Config files with secrets not in VCS
  - No sensitive info in logs or error messages

### Code Quality & Architecture

- [ ] **Clarity & Maintainability**: Is the code easy to understand?

  - Non-obvious sections are commented
  - Follows single-responsibility principle
  - Not overly long or complex
  - Consider refactoring if needed

- [ ] **Dependencies**: Are new dependencies justified?

  - Necessary and popular enough
  - Not adding heavy dependencies for trivial gains
  - Pinned to acceptable version range
  - Added to `pyproject.toml` and `environment.yml`

- [ ] **Backward Compatibility**: Does it maintain compatibility?
  - API changes marked with deprecation warnings
  - Breaking changes properly communicated
  - Version bump appropriate (major if breaking)

### Process & Integration

- [ ] **Commits & Changelog**: Are commits well-formed?

  - Follow Conventional Commits format (`type(scope): description`)
  - CHANGELOG.md updated under "Unreleased" or version section
  - Commit messages allow automatic changelog generation
  - No merge commits in feature branches (use rebase)

- [ ] **Continuous Integration**: Does CI pass?

  - No lint errors: `ruff format --check .` and `ruff check .` pass
  - No type errors: `mypy .` passes
  - All tests pass: `pytest` succeeds
  - No doc build failures
  - Coverage meets threshold (≥ 70%)
  - Secure usage of secrets (no hardcoded credentials)
  - Efficient caching configured

- [ ] **Documentation Build**: Do docs build without errors?

  - Run `mkdocs build --strict` or `sphinx-build -W`
  - No warnings or errors in doc generation
  - New content included and well-formatted
  - API docs automatically generated from docstrings

- [ ] **Final Sanity Check**: Does everything work end-to-end?
  - Pull branch fresh, recreate environment
  - Run `ruff format --check .` and `ruff check .` (no errors)
  - Run `mypy .` (no type errors)
  - Run full test suite: `pytest --cov=mypackage -W error` (all pass)
  - Quick manual test of main functionality if applicable
  - Installation works from scratch: `pip install -e ".[dev]"`
  - No missing files or packaging issues
  - Environment setup documented and reproducible

## Review Comment Template

Use this structure for review comments:

```markdown
**[Severity: Critical/Major/Minor/Suggestion]**

**Issue**: [Brief description of the problem]

**Why**: [Explanation of why this is an issue]

**Suggestion**: [Concrete recommendation for improvement]

**Reference**: [Link to docs/standards if applicable]
```

**Example**:

```markdown
**[Severity: Major]**

**Issue**: Missing type hints on function parameters

**Why**: Type hints improve code documentation, enable static type checking with mypy,
and help catch type-related errors before runtime.

**Suggestion**: Add type hints to all parameters and return values:
\`\`\`python
def process_data(items: list[dict[str, str]], threshold: float | None = None) -> dict[str, int]:
...
\`\`\`

**Reference**: See [Type Hints Guidelines](../my-docs.instructions.md#type-hints)
```

## Best Practices for Reviewers

### DO

- **Start with positive feedback** when you see good practices
- **Be specific** about what needs to change and why
- **Provide code examples** showing the suggested improvement
- **Ask questions** if intent is unclear rather than assuming
- **Focus on important issues** - don't be overly pedantic about minor style preferences
- **Acknowledge trade-offs** - sometimes there's more than one valid approach
- **Review incrementally** if the PR is large - provide early feedback

### DON'T

- **Be vague** - "This needs work" isn't helpful
- **Make it personal** - focus on the code, not the person
- **Nitpick excessively** on style if auto-formatting handles it
- **Block on trivial issues** - distinguish between critical and nice-to-have
- **Ignore context** - consider project constraints and deadlines
- **Review in one massive batch** - provide feedback early and often
- **Approve without reading** - take time to understand the changes

## Common Anti-Patterns to Flag

### Critical Issues

- **Security vulnerabilities**: SQL injection, XSS, exposed secrets, hardcoded credentials
- **Data loss risks**: Missing transaction handling, no backup strategy
- **Breaking changes**: Without deprecation warnings or major version bump
- **Race conditions**: In concurrent code without proper synchronization
- **Memory leaks**: Unclosed resources, circular references
- **TDD violations**: Production code without tests written first

### Major Issues

- **Missing error handling**: Functions that can fail but don't handle errors
- **Inadequate testing**: New features without tests, low coverage (< 70%)
- **Missing type hints**: Functions without type annotations
- **Type checking failures**: Code that doesn't pass `mypy .` in strict mode
- **Poor performance**: O(n²) where O(n) is possible, unnecessary database queries
- **Tight coupling**: Hard dependencies that make testing/reuse difficult
- **Missing documentation**: Public APIs without NumPy-style docstrings

### Minor Issues

- **Inconsistent naming**: Mixing conventions within the same module
- **Magic numbers**: Hardcoded values that should be constants
- **Code duplication**: Copy-pasted logic that could be extracted
- **Overly complex logic**: Could be simplified for readability
- **Outdated type syntax**: Using `Union` instead of `|`, `Optional` instead of `X | None`
- **Import organization**: Not following standard library → third-party → local order

## Guiding Principles for AI-Assisted Reviews

When using AI to assist with code reviews:

1. **Verify TDD compliance**: Check if tests were written before implementation
2. **Verify AI suggestions**: Don't blindly accept AI feedback - validate it
3. **Check type hints**: Ensure all functions have complete type annotations using Python 3.10+ syntax
4. **Run quality tools**: Execute `ruff`, `mypy`, and `pytest` to verify claims
5. **Provide context**: AI needs context about project standards and constraints
6. **Focus on substance**: AI can catch syntax/style, focus your review on logic, design, and TDD compliance
7. **Explain reasoning**: When overriding AI suggestions, document why
8. **Iterate**: Use AI for initial pass, then do detailed human review
9. **Learn patterns**: Note recurring issues AI catches to improve your own reviews
10. **Verify coverage**: Check actual coverage numbers, not just presence of tests

## Summary

Only after this checklist is satisfied should code be approved and merged. By rigorously following these steps, you maintain a high-quality codebase and establish clear expectations for all contributors, including AI coding assistants.
