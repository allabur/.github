<!--
INSTRUCTIONS.md
This file provides workspace-specific custom instructions for GitHub Copilot and AI coding assistants.
It is not intended for end users, but for AI agents and Copilot to follow project-specific coding, documentation, and contribution standards.
-->

# Copilot & AI Coding Assistant Instructions

-   All code, comments, and documentation must be in English.
-   Follow SOLID principles, PEP 8, and use reStructuredText (reST) docstrings for all public functions/classes.
-   Use step-wise comments ("Step 1:", "Step 2:", etc.) except for default kwargs extraction.
-   Write clear, descriptive names and optimize for readability and performance.
-   All code must be tested and follow the Conventional Commits format for commit messages.
-   See AGENTS.md for full guidelines.
-   Use the root AGENTS.md and CONTRIBUTING.md for all code and documentation contributions.
-   Use requirements.txt or pyproject.toml with pinned versions for reproducibility.
-   Use a modular, layered architecture with a src/ folder for main code and notebooks/ for Jupyter work.
-   All public code must be documented and tested.
-   Use only well-maintained, widely adopted packages.
-   All contributions must follow the Conventional Commits specification.

For more details, see AGENTS.md and CONTRIBUTING.md in the project root.

---

## Markdown (.md) File Authoring Instructions

When generating or editing `.md` (Markdown) files in this project, follow these guidelines:

-   All documentation must be in English and clear for an international research/engineering audience.
-   Use descriptive titles and section headers (use `#`, `##`, `###` appropriately).
-   Always include a table of contents for files longer than 30 lines.
-   Use bullet points, numbered lists, and code blocks for clarity.
-   Document all public modules, scripts, and workflows with:
    -   Purpose and context
    -   Usage examples (with code blocks)
    -   Inputs/outputs if relevant
-   Reference coding standards and contribution guidelines where appropriate (link to AGENTS.md and CONTRIBUTING.md).
-   For technical documentation, prefer reStructuredText (reST) docstrings in code, but use Markdown for user-facing docs.
-   Use step-wise explanations for complex procedures ("Step 1:", "Step 2:", etc.).
-   All `.md` files must be reviewed for clarity, completeness, and adherence to project standards before merging.
-   Use consistent formatting and avoid excessive length in any single section.
-   For changelogs, use [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.
-   For commit/contribution docs, reference the Conventional Commits specification.

For more details, see AGENTS.md and CONTRIBUTING.md in the project root.

---

## Naming Style Guide

Follow these naming conventions throughout all code and documentation in this project:

-   **kebab-case**: For documentation files and folders (e.g., `user-guide.md`, `data-analysis-notes.md`, `docs/project-overview/`).
-   **snake_case**: For Python files, modules, and variable/function names (e.g., `data_loader.py`, `process_utils.py`, `my_variable`).
-   **PascalCase**: For Python class names (e.g., `DataProcessor`, `EventLogAnalyzer`).
-   **UPPER_SNAKE_CASE**: For constants in Python (e.g., `MAX_ITERATIONS`).
-   **camelCase**: Only for JavaScript or JSON keys if needed (not recommended for Python).

**General rules:**

-   Be descriptive and concise.
-   Avoid abbreviations unless they are well-known.
-   Use English for all names.
-   Keep names consistent across the project.

Apply these conventions to all new files, folders, variables, functions, classes, and documentation.

For more details, see AGENTS.md and CONTRIBUTING.md.
