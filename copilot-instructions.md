# Repository Instructions for GitHub Copilot

## About This Repository

Copilot should analyze the repo structure, files, and code to understand the project's
purpose and conventions. This will help you provide relevant suggestions and complete
tasks effectively.

Files giving context: README.md, docs/, pyproject.toml, environment.yml.

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

Aquí tienes una versión reformulada y más limpia, en estilo claro y profesional, adecuada para un archivo GitHub Copilot Instructions.md o CONTRIBUTING.md. He mantenido el tono instructivo y consistente con los estándares de documentación técnica moderna:

### 🚀 Quick Start — Terminal & Environment Setup

1. Preferred shell: Use bash (Mamba is initialized there by default).
2. Check active environment: If your terminal prompt shows (<project-env>), the
   environment is active, proceed to step 8.
3. Confirm the environment name defined in `environment.yml`: <project-env>.
4. Try to activate: `mamba activate <project-env>`. If successful, proceed to step 8.
5. If activation fails: Create the environment using `mamba env create -f environment.yml`.
6. Try to activate again: `mamba activate <project-env>`.
7. If activation fails again: Troubleshoot the issue, then retry activation.
8. If activation is successful: Proceed to set up your development environment.
9. Update dependencies to match environment.yml: `mamba env update -f environment.yml --prune`.
10. Install the package in editable mode with dev dependencies: `pip install -e ".[dev]"`.
11. Run tests and static checks to ensure everything works correctly: `pytest -q && ruff check . && mypy .`.

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
name: <project-env>
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
mamba activate <project-env>
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
