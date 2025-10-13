# Repository instructions for GitHub Copilot

## Summary

- **Tech & tooling**: Python 3.12+, pytest, ruff, mypy. CI defined in `.github/workflows/ci.yml`.
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

## Core Code Style

### General Principles

- **PEP 8 Compliance:** Adhere to [PEP 8](https://peps.python.org/pep-0008/) guidelines for code style. Use formatter (**ruff**) to enforce consistent formatting and improve readability. Ensure proper indentation, whitespace, and line breaks as per PEP 8. Consistent style helps both humans and AI assistants read code – remember, _“Readability counts.”_
- **SOLID Design:** Follow SOLID object-oriented design principles for maintainable code. For example, **S**ingle Responsibility – each module or class has one clear purpose; **O**pen/Closed – code is open to extension but closed to modification; etc. This leads to modular, testable components. Keep functions and methods focused (if a function does too many things, consider refactoring). See [SOLID](https://en.wikipedia.org/wiki/SOLID) on Wikipedia.
- **Clarity & Minimalism:** Write code for clarity first, then optimize if necessary. Favor clear, expressive logic over overly clever or terse code. Avoid unnecessary complexity – “simple is better than complex” and “explicit is better than implicit”: [Zen of Python](https://en.wikipedia.org/wiki/Zen_of_Python). Use idiomatic Python constructs (e.g. list comprehensions, context managers) for clarity and brevity when appropriate.
- **Consistency:** Use a consistent coding style and naming scheme across the project. Consistency in how functions are structured or how exceptions are handled is crucial for collaboration. All contributors (human or AI) should follow the same patterns to make the codebase uniform.
- **No Dead Code:** Remove or avoid code that isn’t used. Unused variables, functions, or imports clutter the codebase and can confuse readers. If code is experimental or might be needed later, indicate so clearly (or use source control to retrieve it later rather than keeping it commented out).

### Naming Conventions

Use descriptive, standardized naming conventions for all identifiers. **Follow PEP 8 naming styles** as summarized below:

| Element                | Convention                                                                | Example                                        |
| ---------------------- | ------------------------------------------------------------------------- | ---------------------------------------------- |
| **Package/Module**     | short, **all-lowercase** (avoid underscores unless improving readability) | `analysis.py` (module), `mypackage/` (package) |
| **Class**              | **CapWords** (PascalCase)                                                 | `DataProcessor`                                |
| **Function/Method**    | **snake_case** (lowercase, words separated by `_`)                        | `process_data()`                               |
| **Variable/Attribute** | **snake_case**                                                            | `file_path` , `max_iter`                       |
| **Constant**           | **UPPER_CASE** (all caps with underscores)                                | `MAX_ROWS = 5000`                              |
| **Internal/Private**   | Single leading underscore for internal use                                | `_helper_function()`                           |

Choose **meaningful and concise** names: for example, prefer `count_words()` over `cw()`. Avoid overly long names; strike a balance between descriptiveness and brevity. Ensure that names are **memorable and manageable** for users – a user should be able to type an import or usage quickly (e.g. `from datareader import DataReader`). Check PyPI and GitHub to avoid name collisions before naming a new package.

### Error Handling

- **Use Exceptions for Errors:** Follow Python’s EAFP principle (“Easier to Ask Forgiveness than Permission”) for flow control: if an error condition occurs, raise an appropriate exception rather than using error codes. Do **not** ignore exceptions or silently pass; every caught exception should be handled or logged meaningfully.
- **Catch Specific Exceptions:** Always catch the narrowest exception that you can handle, not a bare `except:` which catches everything. For example, catch a `FileNotFoundError` or a custom exception, not `Exception` wholesale. This prevents hiding unexpected bugs. If an exception is truly unexpected, let it bubble up rather than catching it and continuing in an unknown state.
- **Informative Errors:** Provide helpful messages when raising exceptions. For instance, if a function receives an invalid argument value, raise a `ValueError` with a message explaining the valid range or format. This aids both users and developers (including AI assistants) in understanding what went wrong.
- **Custom Exceptions:** For a large project or library, consider defining custom exception classes (ideally subclassing Python’s built-in exceptions) for specific error situations (e.g., `SimulationError` for domain-specific issues). This makes exception handling more expressive for users of your package.
- **Never Fail Silently:** Avoid empty `except` blocks or `pass` statements in exception handling. If you catch an exception, handle it or at least log it. Failing silently makes bugs hard to find. In test code, consider using `pytest`’s facilities to expect exceptions rather than catching them.
- **Clean Up Resources:** Use `try/finally` or context managers (`with` statements) to ensure that resources (files, network connections, etc.) are properly closed or released even if errors occur. This prevents resource leaks and other unintended side-effects. For example, use `with open('file.txt') as f:` instead of manual open/close, and for acquiring locks or connections, rely on context managers when available.

### Logging & Warnings

- **Logging Practices:** Use the built-in `logging` module for recording runtime information, instead of printing to stdout. Configure a top-level logger in each module and use appropriate log levels (`DEBUG`, `INFO`, `WARNING`, `ERROR`, `CRITICAL`) to categorize messages. For example, use INFO for high-level progress messages, DEBUG for diagnostic details, and ERROR for exceptions or critical failures. Avoid excessive logging in tight loops (to not degrade performance), but ensure important events and errors are logged. Set a default logging configuration (e.g., via `logging.basicConfig`) so that logs are output to console or file as needed. Example logger setup and usage:

```python
import logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(name)s: %(message)s")
logger = logging.getLogger(__name__)

logger.info("Simulation started")           # informational message
logger.debug("Parameters: %r", params)      # debug-level detail
logger.warning("Data size is large")        # warning about a potential issue
```

In library code, the logger should inherit settings from the application using the library; do not call `basicConfig` in library modules (do it in the application entry point). This allows users to configure logging as they wish. Ensure that sensitive information (passwords, secrets) is never logged.

- **Warnings:** Use the `warnings` module to alert users to conditions that aren’t exceptions but merit attention (e.g., deprecated features or suspicious usage). Issue warnings of specific categories (like `DeprecationWarning`, `UserWarning`) so users or testers can filter them. For example, to warn about a deprecated parameter, you might do: `warnings.warn("param X is deprecated, use Y", DeprecationWarning)`. In library code, consider marking deprecations with warnings and documenting timelines for removal.
- **Warnings as Errors in Tests:** To maintain strict code quality, run tests with warnings treated as errors. This ensures that no unexpected warnings go unnoticed. For instance, configure pytest with `-W error` or in code:

```python
import warnings
warnings.filterwarnings("error")  # Treat all warnings as errors during tests
```

This will cause tests to fail if any warning is triggered, forcing the team to address it (either by fixing the cause or explicitly filtering expected warnings). You can be selective (e.g., only turn specific categories into errors) using pytest or warnings filters. During normal usage, warnings can be left as warnings, but in continuous integration they should be zero.

- **Logging vs Warnings:** Use logging for events in normal operation (info, debug, errors), and use warnings module for one-time alerts to the user about usage issues or deprecations. Do not overuse warnings for recoverable errors; if a condition can be handled programmatically or logged, do that. Reserve warnings for signaling to the _user_ of the code that something may require their attention (like using a soon-to-be-removed function).

## Testing

- **Framework:** Use **pytest** for writing and running tests. Write tests as functions in files named `test_*.py` (or classes in those files) and put them under the `tests/` directory. Use descriptive names for test functions (e.g., `test_word_counting_correctness()`) to indicate what they verify. Avoid generic names like `test_functionality()`; instead, be specific about the behavior being tested.
- **Organization:** Organize tests logically, grouping related tests together. Structure the `tests/` directory to mirror the source structure, possibly with subdirectories for unit vs integration tests if it helps organization. Example test file structure: for `src/mypkg/module.py`, create `tests/module/test_module.py` with functions `test_some_behavior()` covering functions of that module. This one-to-one structure makes it easy to locate tests for each part of the code.
- **Coverage:** Aim for **≥ 90% code coverage** by tests. Use **pytest-cov** to measure coverage. Include this in the test run (e.g., `pytest --cov=mypkg` to report coverage on the package). Treat coverage as a helpful metric: focus on covering critical logic, edge cases, and error conditions. Strive to include at least one test for every public function or class method. If coverage drops below the target, add tests to cover the gaps.
- **Types:** Include a mix of **unit tests** (isolated tests for small units of code, e.g., a single function’s output for given inputs) and **integration tests** (ensuring components work together, e.g., a workflow that calls several functions). Keep unit tests fast and focused; integration tests can be fewer but still automated. If applicable, include **regression tests** for bugs (when a bug is fixed, add a test to ensure it doesn’t resurface).
- **Test Data and Fixtures:** Use Pytest **fixtures** to set up and tear down common test resources (e.g., temporary files, sample data sets, or database connections). Define fixtures in fixture modules, and use scopes appropriately (function, module, session) for efficiency. For example, you might have a fixture to provide a pandas DataFrame of test data. This avoids duplicating setup code in many tests. Prefer parametric tests (using `@pytest.mark.parametrize`) over writing many similar tests with different inputs.
- **Deterministic Tests:** Tests should be reliable and deterministic. Avoid tests that depend on external state or randomness (if randomness is needed, set a random seed). This ensures that continuous integration can consistently pass tests. If a test is occasionally flaky, investigate and fix it instead of ignoring it.
- **Failure Handling:** Configure test runs to be strict: treat warnings as errors (as noted above) and consider using `pytest -ra` to show summary of skipped/xfailed tests to ensure you don’t overlook tests being skipped. A failing test should be seen as a top priority to fix (either the code or the test).
- **Test Execution:** Run tests frequently during development (e.g., via a pre-commit hook or continuous integration on each pull request). Use `pytest` command-line options for efficiency, like `-x` to stop on first failure when debugging, or `--ff` (fail-fast / run last failures first) to iterate quickly. In CI, run the full suite with coverage.
- **Continuous Testing:** Integrate tests into the development workflow – e.g., require tests to pass (and coverage to remain high) before merging changes. AI coding assistants generating new code should also ideally produce corresponding tests or at least not break existing tests.

## Documentation

Good documentation is as important as the code itself. Provide multiple levels of documentation so that users (and developers) can easily understand and use the project. Documentation should cover **what** the code does, **how** to use it, and **why** certain decisions were made.

| Documentation           | Typical location | Description                                                                                                                                                                                                                                                                 |
| :---------------------- | :--------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| README                  | Root             | Provides high-level information about the package, e.g., what it does, how to install it, and how to use it.                                                                                                                                                                |
| License                 | Root             | Explains who owns the copyright to your package source and how it can be used and shared.                                                                                                                                                                                   |
| Contributing guidelines | Root             | Explains how to contribute to the project.                                                                                                                                                                                                                                  |
| Code of conduct         | Root             | Defines standards for how to appropriately engage with and contribute to the project and its community.                                                                                                                                                                     |
| Changelog               | Root             | A chronologically ordered list of notable changes to the package over time, usually organized by version.                                                                                                                                                                   |
| Docstrings              | _.py_ files      | Text appearing as the first statement in a function, method, class, or module in Python that describes what the code does and how to use it. Accessible to users via the `help()` command.                                                                                  |
| Typehints               | _.py_ files      | Type annotations of functions and methods that aid in development and documentation.                                                                                                                                                                                        |
| Examples                | _`docs/`_        | Step-by-step, tutorial-like examples showing how the package works in more detail.                                                                                                                                                                                          |
| API reference           | _`docs/`_        | An organized list of the user-facing functionality of your package (i.e., functions, classes, etc.) along with a short description of what they do and how to use them. Typically created automatically from your package's docstrings using the `mkdocs` or `sphinx` tool. |

- **README:** Include a high-level **README.md** at the root that gives an overview of the project – its purpose, main features, how to install it, and a quickstart example of usage. This is the first exposure for users and should be kept up-to-date especially with any major changes.
- **License:** Include a **LICENSE** file at the root of the repository to specify the licensing terms for the project. Choose a license that aligns with your project's goals (e.g., MIT, Apache 2.0). GNU General Public License v3 (GPL-3): less permissive than the above licenses. Any changes made to your software must be recorded, and the complete source code of the original software and modifications of it must be made available under the same GPL-3 license.
- **Contributing Guidelines:** If the project is open to contributions, include a `CONTRIBUTING.md` file that outlines how to contribute (coding style, testing, submitting PRs). This helps set expectations for external contributors (including AI-generated contributions).
- **Code of Conduct:** If the project is public, include a `CODE_OF_CONDUCT.md` to set expectations for community behavior.
- **Changelog:** Maintain a **CHANGELOG.md**, use a tool to generate one from commit history, that records all notable changes for each release. Follow [Keep a Changelog](https://keepachangelog.com/) conventions: categorize changes into Added, Changed, Fixed, Removed, etc., under each version heading. This helps users (and developers) see what’s new or different in each version. Prioritise the use of **Conventional Commits** and **semantic-release**, this can be automated, but ensure the generated content is clear.
- **Docstrings:**

  - Write **NumPy-style docstrings** for all public modules, functions, classes, and methods.
  - A NumPy-style docstring has sections such as **Parameters**, **Returns**, **Examples**, and optionally **Raises**, **Notes**, etc.
  - Document all parameters (with expected types and meaning) and describe the return value(s).
  - Keep docstrings concise but explanatory; they will be accessible via Python’s `help()` and in generated docs, so they should stand on their own.
  - If the function can raise important exceptions for invalid usage, you can document them in a “Raises” section.
  - For example:

  ```python
  def count_words(input_file: str) -> Counter:
      """Count words in a text file.

      Words are made lowercase and punctuation is removed before counting.

      Parameters
      ----------
      input_file : str
          Path to the text file to read.

      Returns
      -------
      collections.Counter
          A Counter mapping words to their frequency in the text.

      Examples
      --------
      >>> count_words("example.txt")
      Counter({'the': 10, 'and': 5, ...})
      """
      # function implementation...
  ```

- **Typehints:** Ensure that function signatures include **type hints** (which will appear in the docs as well) – modern Python allows writing types inline (e.g., `def func(x: int) -> str:`) and this greatly improves clarity in documentation. Use **mypy** for Type Checking: mypy is a static type checker for Python that can catch type errors based on your annotations.
- **Inline Comments & Section Tags:**
  - Write inline comments sparingly – good code should mostly be self-explanatory. Use inline comments for non-obvious logic or important caveats. For example, if using a tricky formula or workaround, a brief `# explanation of why this approach is used` is valuable.
  - Do **not** narrate obvious things (e.g., `i = 0  # set i to zero` is not useful).
  - Keep comments up-to-date as code changes; outdated comments can mislead.
  - For larger code sections, you can use “section tags” or commented headings (e.g., `# --- Data Loading ---` as a separator) to improve readability in long modules. This is optional but can help organize code into logical blocks.
  - When using special tags like `TODO` or `FIXME` in comments, use a consistent format (all caps, often with a colon, e.g., `# TODO: handle edge cases for X`). Many editors/IDEs will recognize these tags, and they serve as actionable notes for future improvements. For example: `# TODO: improve the algorithmic complexity here`. Ensure that such tags are addressed in a timely manner or at least tracked.
- **User Guide & Examples:** In the `docs/` directory, provide a narrative documentation (if applicable) – e.g., usage guides, tutorials, or “how-to” examples demonstrating common use cases of the project. For a data science project, you might include a “getting started” tutorial notebook (placed in `notebooks/`). This helps new users (or new team members) understand the workflow.
- **Reference (API) Docs:** Set up **MkDocs** with **mkdocstrings** plugin for simple projects, or **Sphinx** for complex projects requiring advanced features.
  - **For simple to medium projects (recommended for beginners):** Use **MkDocs** with the **mkdocstrings** plugin to automatically generate API documentation from your NumPy-style docstrings. MkDocs offers a gentle learning curve, Markdown-native authoring, and excellent themes like Material. Setup is minimal and maintenance is straightforward.
  - **For complex projects:** Use **Sphinx** with the `autodoc` or `autoapi` extension and Napoleon extension to parse NumPy-style docstrings. Sphinx provides more advanced features, multiple output formats, and extensive customization options, but requires more setup and maintenance.
  - The API reference should be organized logically (perhaps grouped by module or functionality) and included in the docs build. Verify that all public classes/functions appear and their docs are informative.
- **Documentation in CI:** Treat documentation as part of the build. Use CI to ensure that docs can be built without errors or warnings. For MkDocs, this means running `mkdocs build --strict` to fail on warnings. For Sphinx, use `sphinx-build -W` to treat warnings as errors. Possibly deploy docs automatically (e.g., to **GitHub Pages** or **Read the Docs**). Keeping documentation live and updated ensures users always see docs matching the latest release.

## Releasing & Versioning

- **Semantic Versioning:** Adopt **Semantic Versioning 2.0.0** for project releases. A version number is in the form **MAJOR.MINOR.PATCH**, e.g. 1.4.2. Increase the:
  - **PATCH** for bug fixes or small changes that do not affect the API (no breaking changes).
  - **MINOR** for adding new features or improvements that are backward-compatible.
  - **MAJOR** for changes that break backward compatibility or drop support for something (going from 0.x to 1.0 signals first stable release, then 2.0, etc. for major redesigns).
    Start with version **0.1.0** for initial development, then **1.0.0** for the first production-ready release. Document any breaking changes clearly (in changelog and documentation), and consider deprecating features (with warnings) for a period before removing them to give users time to adapt. The goal is that users (or code written against your package) can trust that upgrades within a major series won’t break things unexpectedly.
- **Version Number Source:** Define a single source of truth for the version number (to avoid discrepancies). Keep this updated when making a release. Consider using tools or scripts to bump versions to avoid human error (or **automate** it via commit messages as discussed below).
- **Conventional Commits:** Use **Conventional Commits v1.0** for commit messages to streamline release management. This format uses prefixes like `feat: ...`, `fix: ...`, `docs: ...`, etc., in commit messages to indicate the nature of changes. For example:
  - `feat(parser): add support for new file format` – a new feature (triggers a minor version bump).
  - `fix(api): handle null values in response` – a bug fix (triggers a patch bump).
  - `perf: improve algorithm speed by 20%` – a performance improvement (treated like a fix in SemVer, assuming no API change).
  - `docs: update usage examples in README` – documentation changes (typically do not affect version).
  - `build: update CI pipeline for tests` – changes to build process or tools.
  - `BREAKING CHANGE:` in commit body – indicates an incompatible API change and forces a major version bump.
    Using this consistent commit language allows automation tools to determine how to bump the version and generate changelog entries. It also makes commit history more readable. Even if not every contributor strictly follows it, aim to enforce this in PR reviews (and it can be auto-formatted by git hooks or a commit-linting tool).
- **Version Bumping:** When preparing a new release, update the version number accordingly (patch/minor/major).
  - If doing this manually, update the version in `pyproject.toml` (or wherever it’s defined), update `CHANGELOG.md` with the new version and changes, then commit with a message like `build: release vX.Y.Z` and create a Git tag for the version (e.g., `git tag -a vX.Y.Z -m "Release vX.Y.Z"`).
  - Make sure to push tags to the repository (tags are how release automation or users find specific versions). Use signed tags if security is a concern.
  - A checklist for releasing a new version might include: all tests passing, docs updated, changelog updated, version bumped, then tag and upload.
- **Building Distributions:** Provide source and binary distributions. Use the modern build system:

```bash
$ python -m build  # builds both sdist (.tar.gz) and wheel (.whl) into the dist/ folder
```

- This relies on the `pyproject.toml` config for build instructions (PEP 517/518).
- Ensure you have **build** (`pip install build`) and a tool like **wheel** installed.
- The output artifacts will be in `dist/`. Inspect them (you can even test install locally with `pip install dist/yourpkg-X.Y.Z-py3-none-any.whl` to verify).
- **Publishing to PyPI:** Use **Twine** to upload distributions to PyPI. Twine is a reliable tool to upload packages:

```bash
$ twine upload dist/*
```

- This will prompt for PyPI credentials (username/password or token).
- It’s recommended to use API tokens (from your PyPI account settings) instead of your password; you can set them in environment variables so that the command is non-interactive.
- Always upload to **TestPyPI** (test.pypi.org) first to ensure everything works, then to the real PyPI. For example, you can run `twine upload --repository testpypi dist/*` to publish to TestPyPI, install from there to smoke test, then upload to PyPI. Automate as much as possible to avoid mistakes (you might include a makefile or script for release).
- **Release Automation:** Consider automating releases using tools like **Python Semantic Release (PSR)** or **release GitHub Actions**.
  - Python Semantic Release can parse commit messages and handle version bumps, changelog, git tags, and even uploading to PyPI. For instance, PSR will examine commits since the last tag and determine the next version (patch/minor/major) automatically. It can update the version in `pyproject.toml`, generate or update the changelog, commit those changes, tag the release, and even publish the new package to PyPI, all in one go.
  - To use this, set it up in CI (e.g., a GitHub Actions workflow) so that on merge to main or on a tag push, it runs the release. This removes human error and effort from the release process. However, it requires strict adherence to conventional commit messages. If you enable this, document the process for contributors.
- **Version Control Tags:** Use **annotated Git tags** for releases, named with the version (e.g., `v2.0.0`). This makes it easy for anyone (or any tool) to checkout code for a specific release. It’s also required for tools like PSR to detect the last release. Push tags to the remote repo. In GitHub, consider creating _Releases_ which can tie to tags and automatically generate tarballs, etc. If using semantic-release, it will handle tagging; otherwise remember to do it manually.
- **Branching Model:** It’s often useful to have a `main` (or `master`) branch where the latest development happens and perhaps stable branches for major versions if you need to backport fixes. Decide on a branching strategy (Git Flow, GitHub Flow, etc.) appropriate for your team. For most projects, a simple approach is: feature branches -> pull requests -> merge into `main` -> tag releases on `main`. When a new version is tagged, that triggers the release process. Document this process for contributors.

## Continuous Integration & Deployment

Leverage CI/CD to maintain code quality and automate the release pipeline. This not only saves time but also ensures consistency.

- **Continuous Integration (CI):** Set up continuous integration (e.g., **GitHub Actions**) to run on each push and pull request. The CI workflow should at minimum:

  - **Install Dependencies:** Set up an environment (use a clean base like an Ubuntu image, install Python 3.12). Cache package installs if possible to speed up builds. Install your project’s dev environment – e.g., `mamba env create -f environment.yml`.
  - **Run Linters/Formatters:** Prefer using **Ruff** (from Astral) as the primary linter and formatter, as it combines the functionality of multiple tools (flake8, black, isort) with significantly better performance. **mypy** for type checking.
  - **Run Tests:** Execute the full test suite with coverage. For example, `pytest --cov=yourpkg` and perhaps fail if coverage drops below 90%. Configure CI to fail on any test failure or unhandled warning (use `-W error` as discussed) to keep quality high.
  - **Coverage Reports:** Optionally, integrate with a coverage reporting service like **Codecov** or **Coveralls**. The CI can upload coverage data for tracking over time. This is helpful to see coverage trends and to annotate pull requests with coverage changes. (Store the Codecov token as a secret in the CI platform and use the Codecov action or script to upload.)
  - **Build Docs:** As part of CI, attempt to build the documentation. This catches any broken references or syntax errors in docs early. You can choose to make docs warnings be treated as errors in CI to enforce quality.
  - **CI Configuration:** Place CI config files in the repo (e.g., `.github/workflows/ci.yml` for GitHub Actions). Use a matrix if you want to test multiple Python versions or platforms, but given this project requires 3.12+, you might just use one unless library compatibility needs testing. Use **mamba** on CI if your dependencies include non-Python packages (since mamba can handle those). A sample GitHub Actions CI might trigger on pull requests to the main branch and include steps as above.

- **Continuous Deployment (CD):** Automate the release deployment so that publishing a new version is less error-prone:

  - **Auto Version & Changelog:** As described, use semantic-release or a similar mechanism in the CI/CD pipeline. For example, a GitHub Actions workflow can have a job that runs on push to `main` (and maybe only if version in pyproject was bumped or a commit message indicates release) to execute `semantic-release version` (which will bump version and tag) and `semantic-release publish` (which will upload to PyPI). This job will need the PyPI token configured as a secret (exposed as an env var like `PYPI_TOKEN`). It should also have Git credentials to push the version bump commit and tag back to the repo. The **py-pkgs-cookiecutter** provides an example: a CI/CD workflow with separate _CI_ job (tests/docs) and _CD_ job that triggers after CI on main branch push, running PSR to handle release.
  - **Conventional Commit Enforcement:** Optionally, use a commit lint tool or a GitHub Action to enforce that commits to main (or PR titles/squash-merge messages) follow the Conventional Commits format. This ensures the CD can do its job of versioning.
  - **Publication:** Once the CD job runs, if everything is green, a new version is on PyPI. Optionally, also create a GitHub Release (with release notes). This can be done with semantic-release or other tools – for instance, PSR can create a release on GitHub with the changelog. Make sure the changelog is updated (PSR does this automatically by default, adding to `CHANGELOG.md` based on commits). If you prefer a manual release process, you might skip automation, but then you should document the manual steps clearly to avoid mistakes.
  - **Environment Secrets:** _Never_ hardcode secrets (like PyPI API tokens) in the repository. Instead, use CI secret storage to inject them at build time. For local development, contributors can use their own tokens or skip deployment steps. Emphasize this practice (for security, but also because AI should not see actual secrets).
  - **Deployment to Other Environments:** If this project has a live service or application component, similar CD principles apply (e.g., deploying a web service on merge). But since the focus here is a package, the main deployment is to PyPI. In some cases, you might also deploy documentation (e.g., push to gh-pages branch or ensure Read the Docs builds the new version) – automate that as well (for example, a GitHub Action that runs on release tag to build docs and deploy to GitHub Pages, if not using RTD).

- **Badges:** It’s a good practice to add badges to your README for build status, coverage, docs, PyPI version, etc. They provide at-a-glance status. For instance, a GitHub Actions badge for the CI status, a Codecov badge for coverage percentage, a PyPI version badge to show the latest release, and a license badge. While not required, they reinforce the presence of CI/CD and quality checks for anyone viewing the project.

By setting up robust CI/CD, you create a feedback loop where code style violations, failing tests, or insufficient coverage are caught early, and releases become a non-event (simply merging code with proper messages triggers a release). This allows both human developers and AI assistants to contribute with confidence, knowing that the automated checks will enforce the guidelines and that deployment is handled consistently.

## Optimization Guidelines

Write code that is efficient, but **only** after ensuring correctness and clarity. Premature or unnecessary optimization can obfuscate code without real benefit. Use these guidelines to optimize wisely:

- **Measure Performance:** _No optimization without measurement._ Use profiling tools to find bottlenecks before changing code for speed. For example, use `%timeit` in IPython for micro-benchmarks and **cProfile** or **line_profiler** for larger sections. Often you may be surprised which part of the code is slow. Let data guide optimizations – this ensures you focus on the true hot spots and can quantify improvement.
- **Vectorization & Efficient Libraries:** In data-heavy computations, prefer **vectorized operations** and array programming via libraries like NumPy and pandas. For example, instead of looping in pure Python to compute element-wise operations on arrays, use NumPy ufuncs or Pandas Series methods which run in C speed. Use list comprehensions or generator expressions in place of manual loops where appropriate – they are not only more Pythonic but often faster for simple operations. Leverage built-in functions (e.g., `sum()`, `any()`, `max()`) and standard library modules (like `itertools`, `functools`) which are optimized in C. In short, **delegate work to optimized libraries** whenever possible (linear algebra to NumPy/SciPy, data manipulations to pandas, etc.).
- **Algorithmic Efficiency:** Consider the algorithmic complexity of your code. Prefer data structures that give optimal performance for your access patterns (e.g., use a set or dict for membership tests instead of a list). If a function is critical, ensure it’s not doing superfluous work (e.g., avoid repeated computations by caching results with `functools.lru_cache` or by storing intermediate results). However, always weigh if the added complexity is justified by a real performance need. Document any non-obvious optimizations so that contributors understand the motivation.
- **Parallelism and Multiprocessing:** If the project involves computationally heavy simulations or data processing that can benefit from parallel processing, consider using Python’s `concurrent.futures` or `multiprocessing` for CPU-bound tasks, or `asyncio` for IO-bound tasks. But be mindful of the complexities (e.g., the GIL for CPU-bound tasks – NumPy releases the GIL in many cases, though). For large data, consider chunking or streaming to avoid high memory usage. Again, only implement these if a clear performance bottleneck is identified.
- **Memory Usage:** Use memory-efficient techniques for large data (e.g., use generators for sequences instead of building large lists in memory if you only need to iterate). When using pandas or NumPy, be aware of data types (using `float32` vs `float64` where appropriate, categoricals for strings in pandas, etc., to reduce footprint). Free or dereference large objects if they are no longer needed (though Python’s GC will handle most, sometimes explicit `del` can help large data in long-running processes).
- **Avoid Premature Optimization:** Keep code clear until you know it needs to be faster. Overly complex “optimized” code that isn’t needed will hurt maintainability. Donald Knuth’s adage _“Premature optimization is the root of all evil”_ holds – optimize after profiling, not before. Write the initial implementation in the clearest way; if performance is acceptable (profile it), stick with it. If not, then optimize with a plan and measure again to ensure the change helped.
- **Use of C Extensions or Alternatives:** If Python is too slow for a particular hotspot, consider using tools like **Numba** (JIT compiler), **Cython**, or writing a C/C++ extension for that part. Also consider if an existing library function can replace your custom Python loop. These steps are advanced and should only be done for genuine bottlenecks in core functionality, given the added complexity.
- **Testing After Optimizing:** After any significant optimization, run the test suite to ensure you haven’t broken anything. Also double-check that the optimization doesn’t change algorithmic results (unless it’s a known acceptable trade-off). If you switch to an approximate method for speed, document the accuracy implications.

### Code Review Checklist

Before merging code (or releasing), use this checklist to ensure all guidelines have been met. This helps maintain quality over time:

- [ ] **Style & Lint:** Does the code pass automated style checks? (Run Black, isort, Flake8 – no lint errors or format issues.) Check that there are no PEP 8 violations and the code is cleanly formatted.
- [ ] **Naming:** Are all new variables, functions, classes, etc., named according to the conventions? (Descriptive, correct case, no typos.) For any public API additions, do the names make sense in context?
- [ ] **Documentation:** Does every public function/class have an up-to-date docstring explaining its purpose, parameters, and return values? Are any important new concepts or workflows added to the project documented in the docs or README? If a feature was modified, was the relevant documentation updated? Ensure that the **README**, usage examples, and any tutorials still work with the changes.
- [ ] **Type Annotations:** Are functions and methods properly type-hinted? (This aids understanding and catches errors via Mypy.) Run Mypy in strict mode – does it report any typing issues? If types are complex, are they still readable/necessary?
- [ ] **Error Handling:** Are exceptions used appropriately (no silent `pass` on error)? Are specific exceptions caught instead of blanket exceptions? If new errors could occur, are they handled or explicitly propagated? Check that no bare `except` or overly broad catches were introduced.
- [ ] **Testing:** Are there tests covering the new code or bug fix? Every new feature or branch of logic should ideally have corresponding tests. Ensure tests cover normal cases and edge cases. Do all tests pass (run `pytest`)? Is test coverage still >= 90% (check the coverage report)? If any test was changed, verify that it was due to intended changes in behavior.
- [ ] **Warnings:** Does the code introduce any new warnings when run (or when tests run)? Run tests with `-W error` to see if any warning pops up – if so, address the cause or explicitly filter it if it’s harmless and unavoidable. No new deprecation warnings or resource warnings should be present.
- [ ] **Performance Impact:** If the code is in a performance-sensitive area, was it profiled or measured? Does it avoid obvious slowdowns (like unnecessary nested loops over large data that could be vectorized)? Conversely, if a lot of complexity was added for optimization, is there evidence (profile results) that it materially improved performance? Verify that no unnecessary premature optimizations complicate the code (e.g., micro-optimizing something that’s not proven slow).
- [ ] **Security & Secrets:** Ensure no credentials, secrets, or personal data are hardcoded. Any API keys or tokens should be loaded from environment variables or config files (and those keys should not be checked into VCS). Check that debug logging or error messages do not accidentally expose sensitive info.
- [ ] **Clarity & Maintainability:** Could another developer (or an AI assistant) understand this code easily? If there are non-obvious sections, are they commented or documented? Is the code following the single-responsibility principle (e.g., not too long or doing too much)? If not, consider refactoring.
- [ ] **Dependencies:** If new external dependencies were added, are they necessary and popular enough? (Avoid adding heavy dependencies for trivial gains.) Are they pinned to an acceptable version range? Check that the dependency is added in `pyproject.toml` and `environment.yml`.
- [ ] **Backward Compatibility:** For a library, does the change maintain backward compatibility? If something had to change (API or behavior), was it marked with a deprecation warning first or otherwise communicated? And is the version bump appropriate (e.g., major if breaking)?
- [ ] **Commits & Changelog:** Are commit messages following Conventional Commits (for those that will be part of the release)? If not, consider squashing or editing messages. Update the `CHANGELOG.md` with a summary of changes under “Unreleased” or the new version section. If using automation, ensure the commit messages will allow the changelog to be generated correctly.
- [ ] **Continuous Integration:** Check that CI pipelines pass for the branch. No lint, test, or doc build failures in CI. Ensure any new CI configuration (if edited) follows best practices (for example, secure usage of secrets, efficient caching, etc.).
- [ ] **Documentation Build:** If documentation was affected (new APIs or changed behavior), run `make html` or equivalent to build docs locally – verify no warnings or errors in doc generation, and that new content is included and well-formatted.
- [ ] **Final Sanity Check:** Pull the branch fresh, recreate the environment, run the full test suite and maybe do a quick manual test of the main functionality. Ensure that installation (via `pip install .` or similar) works from scratch. This catches any missing files or packaging issues before release.

Only after this checklist is satisfied should code be merged and/or released. By rigorously following these steps, you maintain a high-quality codebase. This discipline also trains AI coding assistants to align with these practices – for instance, an AI suggesting code will tend to produce docstrings and tests if it “sees” that as the norm in the repository.

Each of the above points contributes to a project that is maintainable, reliable, and easy to use. By enforcing these guidelines, you ensure that both human contributors and AI assistants (like GitHub Copilot) produce code that is consistent with the project’s standards, resulting in a smoother collaboration and a healthier codebase overall.&#x20;
