# .github

Default community health files, AI agent guidelines, and reusable GitHub Actions workflows for all repositories under the allabur account.

## Contents

### 📋 Community Health Files

- **CODEOWNERS**: Default code ownership
- **PULL_REQUEST_TEMPLATE.md**: Standardized PR format
- **ISSUE_TEMPLATE/**: Bug reports, feature requests, refactoring
- **labels.yml**: Consistent label definitions

### 🤖 AI Agent Configuration

- **[copilot-instructions.md](copilot-instructions.md)**: Main instructions for GitHub Copilot
- **[instructions/](instructions/)**: Modular coding guidelines with TDD focus
  - **Test-Driven Development** (Red-Green-Refactor cycle)
  - Coding standards (PEP 8, type hints Python 3.10+, error handling)
  - Testing guidelines (pytest with plugins, AAA pattern, TDD workflow, coverage)
  - Documentation standards (NumPy-style docstrings, MkDocs, modern type hints)
  - CI/CD workflows (ruff, mypy, pytest, matrix testing, semantic release)
  - Code review guidelines (TDD compliance, type checking verification)
  - Taming Copilot meta-instructions
- **[prompts/](prompts/)**: Task-specific reusable prompts
  - `/analyze-dataframe` - Data quality assessment
  - `/document-function` - Generate NumPy docstrings
  - `/generate-pytest` - Create comprehensive tests
  - `/create-latex-table` - Format tables for papers
  - `/optimize-code` - Performance optimization
  - `/review-commit` - Conventional commit messages
  - See [prompts/README.md](prompts/README.md) for full list
- **[chatmodes/](chatmodes/)**: AI personas for specialized contexts
  - 4.1-Beast mode for autonomous agent behavior

### ⚙️ Workflows

- **ci.yml**: Continuous integration with TDD validation
  - Code formatting: `ruff format --check`
  - Linting: `ruff check` (replaces flake8, black, isort)
  - Type checking: `mypy` in strict mode
  - Testing: `pytest` with coverage (≥ 70%)
  - Matrix testing: Python 3.10, 3.11, 3.12, 3.13
- **release.yml**: Semantic versioning releases from main
- **pre-release.yml**: RC releases from develop
- **dependabot.yml**: Automated dependency updates

### 📚 Reference Projects

- **[refs/awesome-copilot/](refs/awesome-copilot/)**: GitHub Copilot customizations collection
- **[refs/feedbackflow/](refs/feedbackflow/)**: C#/.NET reference patterns

### 📖 Documentation

- **[docs/prompts-quick-reference.md](docs/prompts-quick-reference.md)**: Prompt commands cheat sheet
- **[docs/prompt-recommendations-config.md](docs/prompt-recommendations-config.md)**: Auto-suggestion configuration

## Quick Start

### For Python Projects

```bash
# Environment setup (mamba or pip)
mamba env create -f environment.yml
mamba activate project-name
pip install -e ".[dev]"

# Verify setup - TDD workflow ready
ruff format --check . && ruff check . && mypy . && pytest -q
```

### TDD Workflow

All development follows the Red-Green-Refactor cycle:

```bash
# 1. RED: Write failing test
pytest tests/test_feature.py::test_new_behavior  # Should FAIL

# 2. GREEN: Implement minimal code
pytest tests/test_feature.py::test_new_behavior  # Should PASS

# 3. REFACTOR: Improve code quality
pytest  # All tests should still pass
```

### Using Copilot Prompts

```
1. Open file in VS Code
2. Press Cmd+I (Ctrl+I on Windows)
3. Type / to see available prompts
4. Select prompt or type command (e.g., /analyze-dataframe)
```

### Conventional Commits

```bash
feat(scope): add new feature
fix(scope): resolve bug
docs: update documentation
test: add missing tests
```

## Integration

These defaults apply automatically to all repositories under `allabur` account that don't have their own versions.

### Override in Specific Repos

Create `.github/copilot-instructions.md` in your repo to:

- Override completely, OR
- Extend: Reference these defaults and add project-specific instructions

### Configure Prompt Auto-Suggestions

Add to your VS Code `settings.json`:

```jsonc
"chat.promptFilesRecommendations": {
  "**/*.py": ["prompts/document-function.prompt.md"],
  "**/*.ipynb": ["prompts/analyze-dataframe.prompt.md"]
}
```

See [docs/prompt-recommendations-config.md](docs/prompt-recommendations-config.md) for full configuration.

## Architecture

This repository serves three purposes:

1. **Default Health Files**: GitHub automatically uses these for any repo without its own versions
2. **Reusable Workflows**: Shared CI/CD that can be referenced from other repos
3. **AI Agent Guidelines**: Centralized TDD-focused instructions, prompts, and modes for consistent Python development with pytest, ruff, and mypy

## Contributing

See individual READMEs:

- [prompts/README.md](prompts/README.md) - Create new prompts
- [instructions/](instructions/) - Add new instruction files
- [copilot-instructions.md](copilot-instructions.md) - Overview document

## Resources

- [GitHub default community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [VS Code Copilot Instructions](https://aka.ms/vscode-instructions-docs)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Python Semantic Release](https://python-semantic-release.readthedocs.io/)
