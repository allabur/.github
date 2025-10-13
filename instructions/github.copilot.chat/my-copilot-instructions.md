# my-copilot-instructions.md

## Operator Interaction

### Code Style
- Follow PEP 8 conventions strictly.
- Use single quotes for strings unless double quotes are required for escaping.
- Ensure imports are sorted alphabetically and grouped (standard library, third-party, local).
- Avoid unused imports and variables.

### Formatting
- Limit line length to 88 characters.
- Use type hints for all functions and methods.
- Prefer f-strings for string formatting.

### Error Prevention
- Avoid mutable default arguments in functions.
- Use `is` for None comparisons.
- Handle exceptions explicitly and avoid bare `except`.

### Python-Specific Rules
- Always use `pathlib` for file path operations.
- Avoid wildcard imports (`from module import *`).
- Use list comprehensions over map/filter for readability.

### Testing
- Maintain 100% code coverage for new functionality.
- Include unit tests for edge cases and integration tests for APIs.

### Change Logging
- Document all changes in `CHANGELOG.md` following semantic versioning.
- Include the date and description of changes.

### Environment Variables
- Use `.env` files for sensitive data and provide examples in `.env.example`.

## Python Code Standards (Ruff Integration)

When generating Python code, follow these Ruff-compliant standards:

### Import Organization
- Use absolute imports when possible
- Group imports: standard library, third-party, local
- Sort imports alphabetically within groups
- Avoid wildcard imports (`from module import *`)

### Code Style
- Use double quotes for strings consistently
- Maximum line length: 88 characters
- Use f-strings for string formatting
- Follow PEP 8 naming conventions

### Code Quality
- Avoid unused imports and variables
- Use type hints for function parameters and return values
- Prefer list comprehensions over map/filter when readable
- Use `pathlib` instead of `os.path` for path operations

### Error Prevention
- Always handle potential exceptions appropriately
- Use `is` and `is not` for None comparisons
- Avoid mutable default arguments
