# Repository Instructions for GitHub Copilot

## About This Repository

You should analyze the repo structure, files, and code to understand the project's
purpose and conventions. This will help you provide relevant suggestions and complete
tasks effectively. If README.md exists check it.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Development Workflow](#development-workflow)
- [Project Structure](#project-structure)
- [Dependencies & Environment](#dependencies--environment)
- [Detailed Guidelines](#detailed-guidelines)

---

## Tech Stack

You should analyze the codebase to identify the tech stack. The default stack includes:

| Tool   | Purpose                | Version |
| ------ | ---------------------- | ------- |
| Python | Language               | 3.13+   |
| pytest | Testing                | Latest  |
| ruff   | Linting & Formatting   | Latest  |
| mypy   | Type Checking          | Latest  |
| mamba  | Environment Management | Latest  |

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

### [Commit Guidelines](copilot/my-commit-messages.instructions.md)

### [Issues](ISSUE_TEMPLATE/)

Generate issues using templates in `.github/ISSUE_TEMPLATE/`. Required sections:

1. **Context** - Background and problem description
2. **Proposed Solution** - Recommended approach
3. **Acceptance Criteria** - Definition of done
4. **Test Plan** - How to verify the fix

### [Pull Requests](copilot/my-pull-request.instructions.md)

### Task Delegation

When assigned an issue:

1. Plan the work and break it into steps
2. Open a draft PR early
3. Run tests locally before pushing
4. Iterate on reviewer feedback
5. Ensure all checks pass before requesting final review

**AI Agent Control**: See `copilot/taming-copilot.instructions.md` for directives on controlling AI behavior (primacy of user commands, factual verification, surgical code edits).

---

## Project Structure

### This Repository Layout

Check the structure of the repo to understand it correctly. I use to work with src-layout.

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

- **`docs/`**: Project documentation including user guides, API reference, and tutorials
- **`data/`**: Sample datasets for examples or tests only
- **`notebooks/`**: Jupyter notebooks for exploration only, not for production use
- **`src/<package>/`**: Python source code following the ["src" layout](https://packaging.python.org/en/latest/tutorials/packaging-projects/#structuring-your-project)
- **`tests/`**: Test suite that mirrors the `src/` structure

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

### [Coding](copilot/my-code.instructions.md)

Core principles, naming conventions (PEP 8), type hints (Python 3.10+), error handling patterns.

### [Testing](copilot/my-tests.instructions.md)

Pytest framework, AAA pattern, coverage goals (60%→75%→90%), test organization strategies.

### [Documentation](copilot/my-docs.instructions.md)

Documentation standards and best practices for code, APIs, and user guides.

### [CI/CD](copilot/my-ci-cd.instructions.md)

Required CI steps (ruff, mypy, pytest), semantic versioning with python-semantic-release, Git Flow branching.

### [Reviewing](copilot/my-review.instructions.md)

Code review guidelines and best practices for pull requests.

### [Commit Messages](copilot/my-commit-messages.instructions.md)

Detailed conventional commits specification including Jupyter notebook conventions.

### [Taming Copilot](copilot/taming-copilot.instructions.md)

**META-INSTRUCTIONS**: Controls AI agent behavior - primacy of user directives, factual verification over assumptions, surgical code modifications, intelligent tool usage.

Each of the above points contributes to a project that is maintainable, reliable, and easy to use. By enforcing these guidelines, you ensure that both human contributors and AI assistants (like GitHub Copilot) produce code that is consistent with the project's standards, resulting in a smoother collaboration and a healthier codebase overall.
