---
description: "Code review guidelines and focus areas"
---

# Code Review Instructions

## Review Focus Areas

### Code Quality

- Check for code readability and maintainability
- Verify adherence to established coding standards
- Look for potential bugs and logic errors
- Assess code complexity and suggest simplifications
- Review error handling and edge case coverage
- Verify complete type annotations for all function parameters and return values
- Check that type hints follow modern Python standards (Union vs |, Optional vs Union[T, None])
- Ensure type annotations match actual implementation and usage

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

- Missing error handling
- Inconsistent naming conventions
- Lack of documentation or comments
- Hardcoded values that should be configurable
- Unused variables or imports
- Potential race conditions in concurrent code
- Missing or inadequate tests
- Security vulnerabilities
- Performance anti-patterns
- Violation of SOLID principles
- Missing type annotations on function parameters or return values
- Inconsistent or incorrect type hints
- Use of deprecated typing syntax (e.g., List instead of list in Python 3.9+)

## Review Approval Criteria

- All critical and major issues must be addressed
- Code follows team coding standards
- Adequate test coverage is provided
- Documentation is complete and accurate
- No security vulnerabilities are present
- Performance impact is acceptable
