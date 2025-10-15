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
- **[instructions/](instructions/)**: Modular coding guidelines
  - Coding standards (PEP 8, type hints, error handling)
  - Testing guidelines (pytest, AAA pattern, coverage)
  - Documentation standards (NumPy-style docstrings)
  - CI/CD workflows (conventional commits, semantic release)
  - Code review guidelines
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

- **ci.yml**: Continuous integration (ruff, mypy, pytest)
- **release.yml**: Semantic versioning releases from main
- **pre-release.yml**: RC releases from develop
- **dependabot.yml**: Automated dependency updates

### 📖 Documentation

- **[guidelines/](guidelines/)**: Comprehensive guidelines for Python projects
  - Architecture patterns and project structure
  - Coding standards and best practices
  - Testing methodology with pytest
  - Configuration management
  - Contribution and commit guidelines
- **[docs/prompts-quick-reference.md](docs/prompts-quick-reference.md)**: Prompt commands cheat sheet
- **[docs/prompt-recommendations-config.md](docs/prompt-recommendations-config.md)**: Auto-suggestion configuration

## Quick Start

### For Python Projects

```bash
# Environment setup
mamba env create -f environment.yml
mamba activate project-name
pip install -e ".[dev]"

# Verify setup
pytest -q && ruff check . && mypy .
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
3. **AI Agent Guidelines**: Centralized instructions, prompts, and modes for consistent AI assistance

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

## Reference Projects

This repository serves as a reference for other projects:

- **Default Community Health Files**: Automatically applied to all repositories under `allabur` account
- **Reusable Workflows**: CI/CD workflows that can be referenced from other repositories
- **AI Agent Standards**: Standardized instructions for GitHub Copilot and other AI assistants
- **Python Best Practices**: Comprehensive guidelines for Python project development

Projects using these standards benefit from:
- Consistent code quality and testing practices
- Automated versioning and release management
- Standardized PR and issue workflows
- AI-assisted development with context-aware suggestions
