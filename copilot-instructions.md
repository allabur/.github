# Repository Instructions for GitHub Copilot

## Table of Contents

- [Tech Stack](#tech-stack)
- [Development Workflow](#development-workflow)
- [Project Structure](#project-structure)
- [Dependencies & Environment](#dependencies--environment)
- [Detailed Guidelines](#detailed-guidelines)

---

## Tech Stack

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

**Examples:**

```
feat(api): add user authentication endpoint
fix(parser): handle null values in JSON response
docs: update installation instructions
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

---

## Project Structure

### Standard Layout

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

### [Testing](instructions/my-tests.instructions.md)

### [Documentation](instructions/my-docs.instructions.md)

### [CI/CD](instructions/my-ci-cd.instructions.md)

### [Reviewing](instructions/my-review.instructions.md)

Each of the above points contributes to a project that is maintainable, reliable, and easy to use. By enforcing these guidelines, you ensure that both human contributors and AI assistants (like GitHub Copilot) produce code that is consistent with the project's standards, resulting in a smoother collaboration and a healthier codebase overall.
