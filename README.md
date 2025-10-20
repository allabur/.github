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
- **[copilot/](copilot/)**: Modular instruction files
  - `my-code.instructions.md` - Coding standards (PEP 8, type hints, error handling)
  - `my-tests.instructions.md` - Testing guidelines (pytest, AAA pattern, coverage)
  - `my-docs.instructions.md` - Documentation standards (NumPy-style docstrings)
  - `my-ci-cd.instructions.md` - CI/CD workflows (conventional commits, semantic release)
  - `my-uv-environment.instructions.md` - uv package management guidelines
  - `my-review.instructions.md` - Code review best practices
  - `my-commit-messages.instructions.md` - Commit message conventions
  - `my-pull-request.instructions.md` - PR templates and workflow
  - `taming-copilot.instructions.md` - Meta-instructions for AI control
- **[instructions/](instructions/)**: Legacy modular guidelines (being migrated to copilot/)
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

### 🛠️ Scripts & Templates

- **[scripts/](scripts/)**: Automation scripts
  - `vscode-setup.sh` - Sync Copilot instructions to VS Code
  - `migrate-to-uv.sh` - Migrate projects from conda/mamba/pip/Poetry to uv
  - See [scripts/README-vscode-setup.md](scripts/README-vscode-setup.md) for details
- **[templates/](templates/)**: Project templates
  - `pyproject.toml` - Python project configuration template following PEP 621

### ⚙️ Workflows

- **ci.yml**: Continuous integration (ruff, mypy, pytest)
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

### For Python Projects (New Project)

```bash
# 1. Install uv (once)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Create new project
uv init myproject && cd myproject

# 3. Copy pyproject.toml template (optional)
cp /path/to/dotfiles/.github/templates/pyproject.toml .

# 4. Add dependencies
uv add pandas numpy scikit-learn
uv add --dev pytest ruff mypy

# 5. Sync and verify
uv sync
uv run pytest -q && uv run ruff check . && uv run mypy .
```

### For Python Projects (Migrate Existing)

```bash
# Use the migration script
/path/to/dotfiles/.github/scripts/migrate-to-uv.sh --help

# Quick migration with backup
/path/to/dotfiles/.github/scripts/migrate-to-uv.sh --keep-old --python 3.13

# Verify after migration
uv run pytest && uv run ruff check .
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

## Usage Guide

### Setting Up VS Code

Sync Copilot instructions to VS Code:

```bash
cd /path/to/dotfiles/.github
./scripts/vscode-setup.sh --verbose
```

This creates symlinks from `.github/copilot/`, `.github/prompts/`, and `.github/chatmodes/` to your VS Code prompts directory.

### Using the pyproject.toml Template

```bash
# Copy template to new project
cp /path/to/dotfiles/.github/templates/pyproject.toml /path/to/myproject/

# Edit metadata
cd /path/to/myproject
# Update name, version, description, authors, etc.

# Initialize with uv
uv sync
```

### Migrating Projects to uv

The migration script supports:

- **conda/mamba** (environment.yml) → uv
- **pip** (requirements.txt) → uv
- **Poetry** (pyproject.toml) → uv (with manual adjustments)

See [scripts/README-vscode-setup.md](scripts/README-vscode-setup.md) for detailed usage.

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

- [copilot/](copilot/) - Modular instruction files for Copilot
- [prompts/README.md](prompts/README.md) - Create new prompts
- [scripts/README-vscode-setup.md](scripts/README-vscode-setup.md) - Scripts documentation
- [templates/](templates/) - Project templates (pyproject.toml, etc.)
- [copilot-instructions.md](copilot-instructions.md) - Main overview document

## Resources

- [GitHub default community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
- [VS Code Copilot Instructions](https://aka.ms/vscode-instructions-docs)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Python Semantic Release](https://python-semantic-release.readthedocs.io/)
- [uv Documentation](https://docs.astral.sh/uv/)
- [PEP 621 - Project Metadata](https://peps.python.org/pep-0621/)
