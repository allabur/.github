# 👥 Contributing to {{ project_name }}

Thank you for your interest in contributing! This guide explains how to get started, what standards to follow, and how to collaborate effectively.

## 🛠️ How to Set Up

1. Clone the repository:

    ```bash
    git clone <your-repo-url>
    cd {{ repo_name }}
    ```

2. Set up a virtual environment:

    ```bash
    # Con uv (recomendado)
    uv venv {{ repo_name }}

    # O con venv tradicional
    python -m venv {{ repo_name }}

    # O con conda
    conda create -n {{ repo_name }} python={{ python_version }}
    # y activarlo
    ```

3. Install dependencies:

    ```bash
    # Con uv (más rápido)
    uv pip install -r requirements.txt
    # o
    uv pip install .

    # Con pip tradicional
    pip install -r requirements.txt
    # o
    pip install .
    ```

4. Run the tests:
    ```bash
    pytest tests/
    ```

---

## ✍️ Contributing Guidelines

-   Follow the [AI Coding Guidelines](./AGENTS.md) for all code and documentation.
-   Write clean, readable Python code.
-   Add unit tests for new functionality.
-   Write meaningful commit messages using [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

### ✅ Commit Message Format (Extended)

We follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) standard with some **extensions** for clarity and automation.

```
<type>(<scope>): <short description>

<body: optional, wrapped at 72 characters>

<footer: optional - links to issues, breaking changes, etc.>
```

#### Examples

```bash
feat(core): add normalization function for admission delays
fix(parser): correct timezone offset handling in timestamp parser
docs(contributing): update commit message format and husky usage

BREAKING CHANGE: 'patient_id' is now a required field.
```

#### Types

-   `feat`: A new feature
-   `fix`: A bug fix
-   `docs`: Documentation only
-   `style`: Formatting (no logic change)
-   `refactor`: Refactor without fixing a bug or adding a feature
-   `test`: Adding or fixing tests
-   `chore`: Maintenance (build tools, CI, etc.)

#### Scopes

Use kebab-case scopes matching folder or domain areas:
`core`, `ed`, `iu`, `parser`, `patient`, `utils`, `docs`, `config`, etc.

#### Setup Commit Linting (optional but recommended)

We use [`commitlint`](https://github.com/conventional-changelog/commitlint) + [`husky`](https://typicode.github.io/husky/) to enforce commit standards automatically.

1. Install:

    ```bash
    npm install --save-dev husky @commitlint/{config-conventional,cli}
    ```

2. Create `commitlint.config.js` and `.husky/commit-msg`.

3. Enable Husky:

    ```bash
    npx husky install
    npm run prepare
    ```

    After cloning the repository run `npm install` to ensure commit hooks work.

4. Every commit will be validated automatically.

-   Use feature branches and submit pull requests.

---

## 🧪 Testing

-   Tests must cover both standard use cases and edge cases.
-   Use `pytest` and keep tests in the `/tests` folder.
-   Run `pytest` before submitting changes.

---

## 📦 Dependencies

-   Keep dependencies minimal and up to date.
-   Add new packages only if needed, and pin versions.

---

## 📩 Submitting a Pull Request

1. Fork the repository and create your branch:

    ```bash
    git checkout -b feature/my-feature
    ```

2. Push your changes and open a PR:

    ```bash
    git push origin feature/my-feature
    ```

3. Describe your changes clearly in the PR description.

4. Follow the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) format for your Git commit messages.

Examples:

```
feat: add config parser for Excel metadata
fix: resolve NaN issue in categorical encoder
docs: update CONTRIBUTING.md with commit guidelines
```

---

## 🙏 Code of Conduct

Please be respectful and inclusive. We follow the [Contributor Covenant](https://www.contributor-covenant.org/) Code of Conduct.

---

## Naming Style Guide

-   **kebab-case**: For documentation files and folders (e.g., `user-guide.md`, `docs/project-overview/`).
-   **snake_case**: For Python files, modules, and variable/function names (e.g., `data_loader.py`, `my_function`).
-   **PascalCase**: For Python class names (e.g., `DataProcessor`).
-   **UPPER_SNAKE_CASE**: For constants in Python (e.g., `MAX_ITERATIONS`).
-   **camelCase**: Only for JavaScript or JSON keys if needed.
-   All names must be in English, descriptive, and consistent.

Apply these conventions to all code, documentation, and generated files in this project.
