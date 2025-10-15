# Repository Instructions for GitHub Copilot

## About This Repository

This is a **default `.github` repository** for the `allabur` GitHub account. All health files, workflows, and AI agent instructions defined here automatically apply to any repository under this account that doesn't have its own versions.

**Key Components:**

- **Health Files**: CODEOWNERS, PR templates, issue templates that apply org-wide
- **Reusable Workflows**: Shared CI/CD workflows in `workflows/`
- **AI Agent Instructions**: Modular guidelines in `instructions/` for coding, testing, commits, CI/CD, reviews, and docs
- **Chat Modes & Prompts**: AI agent personas (`chatmodes/`) and reusable prompts (`prompts/`)
- **Guidelines**: Comprehensive documentation in `guidelines/` for Python project development

**How to Extend**: Create project-specific `.github/copilot-instructions.md` in individual repos to override or augment these defaults. Reference detailed guidelines via: `[Coding](instructions/my-code.instructions.md)`

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Development Workflow](#development-workflow)
- [Project Structure](#project-structure)
- [Dependencies & Environment](#dependencies--environment)
- [Detailed Guidelines](#detailed-guidelines)

---

## Tech Stack

**Default Stack (Python Projects):**

| Tool   | Purpose                | Version |
| ------ | ---------------------- | ------- |
| Python | Language               | 3.13+   |
| pytest | Testing                | Latest  |
| ruff   | Linting & Formatting   | Latest  |
| mypy   | Type Checking          | Latest  |
| mamba  | Environment Management | Latest  |

### CI/CD

Continuous integration is defined in `.github/workflows/ci.yml` and runs on every push and pull request.

---

## Development Workflow

### 🚀 Quick Start

Set up your development environment with `mamba` and verify your setup:

```bash
# Create and activate the mamba environment
mamba env create -f environment.yml
mamba activate <project-name>

# Install the package in editable mode with dev dependencies
pip install -e ".[dev]"

# Verify setup by running checks
pytest -q
ruff check .
mypy .
```

**Alternative for existing environments:**

```bash
# Activate existing environment
mamba activate <project-name>

# Update dependencies if needed
mamba env update -f environment.yml --prune

# Run verification
pytest -q && ruff check . && mypy .
```

### 📝 Commit Guidelines

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

- `feat:` - New feature (minor version bump)
- `fix:` - Bug fix (patch version bump)
- `refactor:` - Code refactoring (no version bump)
- `docs:` - Documentation changes (no version bump)
- `test:` - Test additions/changes (no version bump)
- `ci:` - CI/CD changes (no version bump)
- `chore:` - Maintenance tasks (no version bump)

Add `!` for breaking changes: `feat!:` or `fix!:` (major version bump)

**Special Case - Jupyter Notebooks**: Use `notebook({filename}): WIP updates {YYYY-MM-DD}` format, ignoring outputs/metadata.

**Examples:**

```
feat(api): add user authentication endpoint
fix(parser): handle null values in JSON response
docs: update installation instructions
notebook(analysis): WIP updates 2025-10-14
```

### 🐛 Issues

Generate issues using templates in `.github/ISSUE_TEMPLATE/`. Required sections:

1. **Context** - Background and problem description
2. **Proposed Solution** - Recommended approach
3. **Acceptance Criteria** - Definition of done
4. **Test Plan** - How to verify the fix

### 🔀 Pull Requests

**Requirements:**

- Keep PRs small (≤ 300 lines of diff)
- Include tests for new features and bug fixes
- Update documentation as needed
- Ensure all CI checks pass (green status)

### 🤖 Task Delegation

When assigned an issue:

1. Plan the work and break it into steps
2. Open a draft PR early
3. Run tests locally before pushing
4. Iterate on reviewer feedback
5. Ensure all checks pass before requesting final review

**AI Agent Control**: See `instructions/taming-copilot.instructions.md` for directives on controlling AI behavior (primacy of user commands, factual verification, surgical code edits).

---

## Project Structure

### This Repository Layout

```
.github/
├── workflows/          # Reusable CI/CD workflows (ci.yml, release.yml, pre-release.yml)
├── instructions/       # Modular AI agent instructions (*.instructions.md)
├── chatmodes/          # AI personas for specialized assistance (*.chatmode.md)
├── prompts/            # Reusable task-specific prompts (*.prompt.md)
├── guidelines/         # Comprehensive Python project guidelines
├── docs/               # Documentation and guides
├── ISSUE_TEMPLATE/     # Org-wide issue templates
├── copilot-instructions.md # This file (overview for AI agents)
├── PULL_REQUEST_TEMPLATE.md
└── CODEOWNERS
```

### Standard Python Project Layout

```
project/
├── .github/
│   ├── workflows/
│   │   └── ci.yml
│   └── ISSUE_TEMPLATE/
├── docs/              # User guides, API reference, tutorials
├── data/              # Sample datasets (optional)
├── notebooks/         # Jupyter notebooks (not in production)
├── src/
│   └── <package>/     # Python source code
│       ├── __init__.py
│       └── ...
├── tests/             # Test suite (mirrors src/ structure)
│   └── test_*.py
├── pyproject.toml     # Build system & project metadata
├── environment.yml    # Mamba environment specification
├── README.md
├── LICENSE
└── CHANGELOG.md
```

### Directory Guidelines

| Directory        | Purpose               | Notes                                                                                                             |
| ---------------- | --------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `docs/`          | Project documentation | User guides, API reference, tutorials                                                                             |
| `data/`          | Sample datasets       | For examples or tests only                                                                                        |
| `notebooks/`     | Jupyter notebooks     | Exploration only, not production                                                                                  |
| `src/<package>/` | Python source code    | Use ["src" layout](https://packaging.python.org/en/latest/tutorials/packaging-projects/#structuring-your-project) |
| `tests/`         | Test suite            | Mirror `src/` structure                                                                                           |

**Language:** All code, comments, and documentation are written in **English** for consistency and clarity.

---

## Dependencies & Environment

### Two-Level Management

#### 1️⃣ Package Requirements (`pyproject.toml`)

Declare runtime dependencies and Python version (≥ 3.12) using PEP 621 standard:

```toml
[project]
name = "mypackage"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "pandas>=2.0.0",
    "numpy>=1.24.0",
    "scikit-learn>=1.3.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]
```

**Preferred Libraries:**

- Data: pandas, NumPy, openpyxl
- ML: scikit-learn
- Visualization: matplotlib, seaborn
- Process Mining: pm4py
- Graphs: networkx

**Guidelines:**

- Use widely adopted, well-maintained libraries
- Pin minimum versions for compatibility
- Allow flexibility for patch updates

#### 2️⃣ Development Environment (`environment.yml`)

Use **mamba** for isolated, reproducible environments:

```yaml
name: myproject
channels:
  - conda-forge
dependencies:
  - python=3.13
  - pandas>=2.0
  - numpy>=1.24
  - pytest>=7.0
  - ruff>=0.1
  - mypy>=1.0
```

**Setup:**

```bash
mamba env create -f environment.yml
mamba activate myproject
```

---

## Detailed Guidelines

### [Coding](instructions/my-code.instructions.md)

Core principles, naming conventions (PEP 8), type hints (Python 3.10+), error handling patterns.

### [Testing](instructions/my-tests.instructions.md)

Pytest framework, AAA pattern, coverage goals (60%→75%→90%), test organization strategies.

### [Documentation](instructions/my-docs.instructions.md)

Documentation standards and best practices for code, APIs, and user guides.

### [CI/CD](instructions/my-ci-cd.instructions.md)

Required CI steps (ruff, mypy, pytest), semantic versioning with python-semantic-release, Git Flow branching.

### [Reviewing](instructions/my-review.instructions.md)

Code review guidelines and best practices for pull requests.

### [Commit Messages](instructions/my-commit-messages.instructions.md)

Detailed conventional commits specification including Jupyter notebook conventions.

### [Taming Copilot](instructions/taming-copilot.instructions.md)

**META-INSTRUCTIONS**: Controls AI agent behavior - primacy of user directives, factual verification over assumptions, surgical code modifications, intelligent tool usage.

---

## Available Prompts

Use prompts with `/` command in Copilot Chat (e.g., `/analyze-dataframe`):

### [Analyze DataFrame](prompts/analyze-dataframe.prompt.md)

**Usage**: `/analyze-dataframe`  
Comprehensive statistical insights, data quality assessment, missing values, outliers, and cleaning recommendations.

### [Document Function](prompts/document-function.prompt.md)

**Usage**: `/document-function`  
Generate NumPy-style docstrings with type hints, parameters, returns, raises, and examples.

### [Generate Pytest](prompts/generate-pytest.prompt.md)

**Usage**: `/generate-pytest`  
Create comprehensive pytest tests with AAA pattern, fixtures, parametrization, and edge case coverage.

### [Create LaTeX Table](prompts/create-latex-table.prompt.md)

**Usage**: `/create-latex-table`  
Convert data into professional LaTeX tables with booktabs formatting, ideal for academic publications.

### [Optimize Code](prompts/optimize-code.prompt.md)

**Usage**: `/optimize-code`  
Identify performance bottlenecks and suggest optimizations with profiling guidance and speedup estimates.

### [Review Commit](prompts/review-commit.prompt.md)

**Usage**: `/review-commit`  
Review staged changes and generate conventional commit messages with detailed body and issue references.

### [AI Safety Review](prompts/ai-prompt-engineering-safety-review.prompt.md)

**Usage**: `/ai-safety-review`  
Comprehensive AI prompt engineering safety review analyzing bias, security, and effectiveness.

---

## Extending These Instructions

**For Individual Projects**: Create `.github/copilot-instructions.md` in your project to:

- Override these defaults entirely, OR
- Reference and extend: `See [default instructions](https://github.com/allabur/.github) for baseline, with these project-specific additions:`

**Adding New Instructions**: Create `*.instructions.md` files in `instructions/` with frontmatter:

```yaml
---
description: "Brief description"
applyTo: "**/*" # or specific glob pattern
---
```

**Using Chat Modes**: Reference chat modes like `chatmodes/4.1-Beast.chatmode.md` for autonomous agent behavior with extensive verification and iteration.

Each of the above points contributes to a project that is maintainable, reliable, and easy to use. By enforcing these guidelines, you ensure that both human contributors and AI assistants (like GitHub Copilot) produce code that is consistent with the project's standards, resulting in a smoother collaboration and a healthier codebase overall.
