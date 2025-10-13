# Repository instructions for GitHub Copilot

## Summary

- **Tech & tooling**: Python 3.13+, pytest, ruff, mypy. CI defined in `.github/workflows/ci.yml`.
- **How to run locally**: `pip install -r requirements-dev.txt && pytest -q && ruff check . && mypy .`.
- **Coding style**: PEP 8; format and lint with Ruff; typing mandatory in new/modified code.
- **Commits**: Use Conventional Commits (`feat:`, `fix:`, `refactor:`, `docs:`, `test:`). Include `!` for breaking changes.
- **Issues**: Generate issues using the templates under `.github/ISSUE_TEMPLATE`. Fill Context, Proposed solution, Acceptance criteria, Test plan.
- **PRs**: Open small PRs (≤ 300 lines of diff) with tests and docs updates. Ensure CI is green.
- **Task delegation**: When assigned an Issue, plan work, open a PR, run tests, and iterate on reviewer feedback until checks pass.

## Overview

- **Language:** All code, comments, and documentation are written in **English** for consistency and clarity.
- **Project Structure:** Use a clear, standard layout with separate directories for different components of the project:
  - `docs/` – Project documentation (user guides, API reference, tutorials, etc.).
  - `data/` – Data files or sample datasets (if needed for examples or tests).
  - `notebooks/` – Jupyter notebooks for exploration or tutorials (kept out of production code).
  - `src/` – Python source code in a **package** (use a [“src” layout](https://packaging.python.org/en/latest/tutorials/packaging-projects/#structuring-your-project) to avoid import issues). For example, `src/<your_package>/__init__.py` plus modules.
  - `tests/` – Test suite, mirroring the structure of the `src/` package (e.g., `tests/<module>/test_module.py`).
  - Top-level files: `pyproject.toml` (build system and project metadata), `environment.yml` (mamba environment spec for reproducibility), `README.md`, `LICENSE`, `CHANGELOG.md`, and configuration for CI (`.github/workflows/` if using GitHub Actions).
- **Dependencies & Environment:** Manage packages and Python version at two levels:
  - _Package requirements_: declare runtime dependencies and Python version (>= 3.12) in `pyproject.toml` (PEP 621). Use widely adopted libraries (e.g., **pandas**, **NumPy**, **scikit-learn**, **matplotlib**, **seaborn**, **networkx**, **pm4py**, **openpyxl**) and avoid unnecessary or unmaintained packages. Pin minimum versions if needed for compatibility, but allow flexibility for patch updates.
  - _Development environment_: use **mamba** (**Mamba**) for isolation. Provide a `environment.yml` file to recreate the exact mamba environment for the project. Include Python 3.12 and all core libraries. This ensures collaborators (human or AI) can easily set up a matching environment with `mamba env create -f environment.yml`.
  - Keep development and build tools in a separate dev section (e.g., in `pyproject.toml` or as `environment.yml` dev dependencies), including linters/formatters (**Ruff**), type-checker (**Mypy**), and testing tools.
  - _Imports_: Organize imports into groups: standard library, third-party, then local package imports. Use one import per line and absolute imports for clarity (PEP 8 recommends explicit absolute imports). Automate import sorting with **ruff** to enforce this structure.

## [Coding](instructions/my-code.instructions.md)

## [Testing](instructions/my-tests.instructions.md)

## [Documentation](instructions/my-docs.instructions.md)

## [CI/CD](instructions/my-ci-cd.instructions.md)

## [Reviewing](instructions/my-review.instructions.md)

Each of the above points contributes to a project that is maintainable, reliable, and easy to use. By enforcing these guidelines, you ensure that both human contributors and AI assistants (like GitHub Copilot) produce code that is consistent with the project’s standards, resulting in a smoother collaboration and a healthier codebase overall.
