---
applyTo: "**"
---

# 🧠 AI Coding & Contribution Guidelines

These are the **coding standards, domain practices, and AI preferences** that must be strictly followed when contributing to this project.

### 📌 General Principles

- **Language:** All code, comments, variables, and documentation must be in **English**.
- **Clarity first:** Code should be easy to read, maintain, and extend. Always **optimize for clarity and performance**, without sacrificing one for the other.

### 🧱 Coding Standards

- Follow the **SOLID principles** when designing modules and functions.
- Use **PEP 8** as the style guide for all Python code (e.g. spacing, naming conventions, imports).
- All public classes, functions, and modules must include **docstrings in reStructuredText (reST)** format.
- Document **each functional block** in a function using comments prefixed with `"Step 1"`, `"Step 2"`, etc., **excluding default `kwargs` extraction**, which should not be step-numbered.
- Use **meaningful and descriptive variable and function names**. Avoid abbreviations unless industry-standard (e.g., `df`, `uid`).
- Write functions that **do one thing well**. Prefer multiple small, composable functions over large ones.
- Refactor existing code only when:

  - You **do not change its logic**, or
  - You are fixing bugs or implementing a clearly scoped improvement.

### 🚀 Optimization & Performance

- Optimize every new function for **both performance and readability**.
- Review and refactor code with performance in mind (e.g., vectorize with NumPy/Pandas when possible, avoid unnecessary loops).
- Avoid premature optimization—**measure before optimizing**.

### 🧪 Testing & Reliability

- Every new feature or bug fix must include **unit tests**.
- Use a consistent test naming convention: `test_<functionality>_<expected_behavior>`.
- Aim for **high test coverage** of all edge cases.
- Prefer libraries like `pytest`, `hypothesis`, and `coverage` to maintain test quality.
- All test files in `tests/` must mirror the structure of the `src/` directory.
- For every module or function in `src/`, create a corresponding test file or test class in the same relative path under `tests/`.
- Example: `src/chum/util/io/accessdb/accessdb_export.py` → `tests/util/io/accessdb/test_accessdb_export.py`
- This ensures clarity, maintainability, and easy navigation between code and tests.

### 📚 Documentation

- All public functions, classes, and modules must include:

  - A **reST-style docstring** with `:param`, `:type`, `:return`, and `:rtype`.
  - High-level comments explaining the **intended use** and **inputs/outputs**.
  - Optional: add an `Example` section in the docstring for non-trivial usage.

- Every script or module should start with a brief header (docstring) summarizing its purpose.

### 🔁 Maintenance

- Keep third-party **dependencies up to date**, but pin exact versions in `requirements.txt` or equivalent (`pyproject.toml`, `environment.yml`).
- Prefer using **reliable and proven data science libraries** such as:
  `pandas`, `numpy`, `scikit-learn`, `matplotlib`, `seaborn`, `statsmodels`, `networkx`, `pyproj`, `pm4py`, `openpyxl`, etc.

### ✅ Code Review Checklist (AI and humans)

Before submitting a pull request or delivering a new module, ensure:

- [ ] Follows PEP 8.
- [ ] Has meaningful names.
- [ ] Optimized for readability and performance.
- [ ] Includes full reST-style documentation.
- [ ] Includes well-structured step comments.
- [ ] Has unit tests covering core logic and edge cases.
- [ ] Has **not changed logic** unless explicitly required.
- [ ] All parameters and defaults are clearly exposed and documented.
- [ ] No unused imports or redundant operations.

---

¿Quieres que lo prepare también como un archivo Markdown (`CONTRIBUTING.md` o `AI_GUIDELINES.md`) o en otro formato para integrarlo directamente en tu repositorio?
