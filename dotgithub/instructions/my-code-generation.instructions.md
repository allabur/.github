---
description: "General coding best practices and guidelines"
---

# General Coding Instructions

## Code Quality

- Write clean, readable, and maintainable code
- Use meaningful variable and function names that describe their purpose
- Add comprehensive comments for complex logic
- Follow the DRY (Don't Repeat Yourself) principle
- Keep functions small and focused on a single responsibility

## Naming Conventions

- Be descriptive and concise in all naming
- Avoid abbreviations unless well-known
- Use English for all names consistently
- Use verbs for functions, nouns for variables and classes
- Use boolean prefixes for boolean variables
- Keep names consistent across the project

## Documentation

- Always include docstrings/JSDoc for functions, classes, and modules
- Use NumPy style for Python docstrings
- Include complete type annotations for all function parameters and return values
- Add inline comments for complex algorithms or business logic
- Include examples in documentation when helpful
- Document any assumptions or limitations
- Ensure type annotations match documented types in docstrings

## Type Hints (Python 3.9+ Modern Syntax)

- **MANDATORY**: Use modern type hint syntax for all Python code
- Use `str | None` instead of `Optional[str]`
- Use `list[str]`, `dict[str, int]`, `tuple[str, ...]` instead of importing from typing
- Only import from typing for: `Literal`, `Callable`, `TypeVar`, `Protocol`
- Ensure type annotations match documented types in docstrings
- Include complete type annotations for all function parameters and return values

## Error Handling

- Implement proper error handling and logging
- Use try-catch blocks appropriately
- Provide meaningful error messages
- Handle edge cases and validate inputs

## Security

- Never hardcode sensitive information like passwords or API keys
- Use environment variables for configuration
- Validate and sanitize all user inputs
- Follow security best practices for the specific technology stack

## Performance

- Consider performance implications of code decisions
- Use appropriate data structures and algorithms
- Avoid premature optimization but be mindful of obvious inefficiencies
- Profile code when performance is critical

## Testing

- Write unit tests for critical functionality
- Include both positive and negative test cases
- Use descriptive test names that explain what is being tested
- Mock external dependencies in tests

## Project Structure

- Maintain clean, modular, and layered architecture
- Group related files and respect package boundaries
- Use clear directory structure with logical separation
- Follow established patterns in the codebase
- Prefer fewer dependencies and minimal side effects
- Optimize for readability, maintainability, then performance

## Design Principles

- Follow SOLID principles for modularity and scalability
- Each function should do one thing and do it well
- Keep functions short, readable, and testable
- Avoid side effects unless explicitly documented
- Prefer composition over inheritance
- Use dependency injection for better testability

## Code Structure and Comments

- Use step-wise comments for each major block in functions
- Keep inline comments minimal, only for complex logic clarification
- Separate logical sections with blank lines for readability
- Structure code in clear, logical blocks
- Use descriptive section headers in complex functions
- Avoid over-commenting obvious operations
