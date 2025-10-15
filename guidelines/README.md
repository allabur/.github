# .github Repository Guidelines

Comprehensive documentation for Python projects following the standards defined in this repository.

## About

This repository provides default community health files, AI agent instructions, and reusable workflows for all repositories under the `allabur` account. The guidelines in this folder establish standards for Python project development, testing, documentation, and collaboration.

## Documentation Files

### Core Guidelines

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Python project architecture patterns, structure conventions, and design patterns
- **[CODING_GUIDELINES.md](CODING_GUIDELINES.md)** - Python coding standards, PEP 8 compliance, type hints, and code quality
- **[TESTING_GUIDELINES.md](TESTING_GUIDELINES.md)** - Pytest testing methodology, coverage goals, and best practices
- **[CONFIGURATION.md](CONFIGURATION.md)** - Configuration management with pyproject.toml, environment variables, and tool configs
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Contribution guidelines, development setup, and pull request workflow
- **[COMMIT_GUIDELINES.md](COMMIT_GUIDELINES.md)** - Commit message standards using conventional commits

### AI Assistant Context

- **[CLAUDE.md](CLAUDE.md)** - Guidance for Claude Code when working with Python projects
- **[copilot-instructions.md](copilot-instructions.md)** - GitHub Copilot context specific to this repository

## Quick Reference

### Project Structure

Python projects following these guidelines use:

```
project/
├── src/
│   └── mypackage/           # Source code
├── tests/                   # Test suite
├── docs/                    # Documentation
├── .github/
│   └── workflows/           # CI/CD workflows
├── pyproject.toml           # Project configuration
└── README.md
```

### Development Workflow

1. **Fork and Clone**: Fork the repository, clone your fork
2. **Create Branch**: `git checkout -b feature/your-feature`
3. **Make Changes**: Write code following PEP 8 and type hints
4. **Write Tests**: Add tests with pytest (AAA pattern)
5. **Check Quality**: Run ruff, mypy, and pytest
6. **Commit**: Use conventional commits format
7. **Submit PR**: Create pull request with clear description

### Common Commands

```bash
# Linting and type checking
ruff check .
mypy --strict src/

# Testing with coverage
pytest --cov=mypackage --cov-report=html

# Documentation
mkdocs build --strict
interrogate -v --fail-under=80 src/
```

## Integration

These guidelines integrate with:

- **Instructions**: Modular AI agent instructions in `/instructions/`
- **Workflows**: Reusable CI/CD workflows in `/workflows/`
- **Templates**: Issue and PR templates in `/ISSUE_TEMPLATE/` and root
- **Health Files**: CODEOWNERS, labels, and contribution standards

## Python Best Practices

### Code Quality

- **PEP 8 Compliance**: Follow Python style guide strictly
- **Type Hints**: Use Python 3.10+ type hints on all functions
- **Docstrings**: NumPy-style docstrings for all public APIs
- **Error Handling**: Use specific exceptions with clear messages
- **Testing**: Minimum 60% coverage, targeting 75-90%

### Tools and Linters

- **ruff**: Fast Python linter and formatter
- **mypy**: Static type checker for Python
- **pytest**: Testing framework with fixtures and parametrization
- **interrogate**: Docstring coverage checker
- **MkDocs**: Documentation generator

## Resources

- [PEP 8 - Style Guide for Python Code](https://peps.python.org/pep-0008/)
- [PEP 257 - Docstring Conventions](https://peps.python.org/pep-0257/)
- [NumPy Docstring Guide](https://numpydoc.readthedocs.io/en/latest/format.html)
- [pytest Documentation](https://docs.pytest.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Python Semantic Release](https://python-semantic-release.readthedocs.io/)

## Related Repositories

This is a **default `.github` repository**. For project-specific documentation:

- Check individual repository's `.github/` folder for overrides
- Reference these guidelines as defaults when repo-specific docs don't exist
- Extend rather than replace these standards in project-specific docs
