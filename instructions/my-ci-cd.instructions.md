# My Python CI/CD Instructions

## CI/CD Philosophy

- **Automate everything**: If it can be automated, it should be
- **Fast feedback**: Developers should know about issues within minutes
- **Fail fast**: Catch errors as early as possible
- **Consistent environments**: Same behavior locally and in CI
- **Security first**: Scan for vulnerabilities and secrets

## GitHub Actions Workflows

### Main Testing Workflow

```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    name: Test Python ${{ matrix.python-version }}
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        python-version: ["3.10", "3.11", "3.12"]
    
    steps:
      - name: Check out repository
        uses: actions/checkout@v4
      
      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: 'pip'
      
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -e ".[dev]"
      
      - name: Run linting
        run: |
          ruff check .
          ruff format --check .
      
      - name: Run type checking
        run: mypy src/
      
      - name: Run tests
        run: pytest --cov --cov-report=xml --cov-report=term
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        if: matrix.python-version == '3.11'
        with:
          file: ./coverage.xml
          flags: unittests
          fail_ci_if_error: true
```

### Code Quality Workflow

```yaml
# .github/workflows/quality.yml
name: Code Quality

on: [push, pull_request]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      
      - name: Install dependencies
        run: pip install -e ".[dev]"
      
      - name: Run Ruff
        run: |
          ruff check . --output-format=github
          ruff format --check .
      
      - name: Run mypy
        run: mypy src/ --pretty
      
      - name: Check imports
        run: ruff check --select I .
      
      - name: Security scan
        run: |
          pip install bandit safety
          bandit -r src/ -f json -o bandit-report.json
          safety check --json --output safety-report.json || true
      
      - name: Upload security reports
        uses: actions/upload-artifact@v3
        if: always()
        with:
          name: security-reports
          path: |
            bandit-report.json
            safety-report.json
```

### Documentation Build Workflow

```yaml
# .github/workflows/docs.yml
name: Documentation

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      
      - name: Install dependencies
        run: pip install -e ".[docs]"
      
      - name: Build documentation
        run: mkdocs build --strict
      
      - name: Deploy to GitHub Pages
        if: github.ref == 'refs/heads/main'
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./site
```

### Release Workflow

```yaml
# .github/workflows/release.yml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      id-token: write
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      
      - name: Install build tools
        run: pip install build twine
      
      - name: Build package
        run: python -m build
      
      - name: Check package
        run: twine check dist/*
      
      - name: Create GitHub Release
        uses: softprops/action-gh-release@v1
        with:
          files: dist/*
          generate_release_notes: true
      
      - name: Publish to PyPI
        uses: pypa/gh-action-pypi-publish@release/v1
```

### Dependency Update Workflow

```yaml
# .github/workflows/dependency-update.yml
name: Dependency Updates

on:
  schedule:
    - cron: '0 0 * * 1'  # Weekly on Monday
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install pip-tools
        run: pip install pip-tools
      
      - name: Update requirements
        run: |
          pip-compile --upgrade pyproject.toml -o requirements.txt
          pip-compile --upgrade --extra dev pyproject.toml -o requirements-dev.txt
      
      - name: Create Pull Request
        uses: peter-evans/create-pull-request@v5
        with:
          commit-message: 'chore(deps): update dependencies'
          title: 'chore(deps): update dependencies'
          body: 'Automated dependency update'
          branch: deps/update-dependencies
          labels: dependencies
```

## Pre-commit Hooks

Use pre-commit for local quality checks:

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-json
      - id: check-toml
      - id: check-merge-conflict
      - id: debug-statements
  
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.1.8
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format
  
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.7.1
    hooks:
      - id: mypy
        additional_dependencies: [types-requests]
        args: [--strict]
```

Install pre-commit hooks:

```bash
pip install pre-commit
pre-commit install
pre-commit run --all-files  # Run on all files
```

## Docker for CI

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml .

# Install Python dependencies
RUN pip install --no-cache-dir -e ".[dev]"

# Copy source code
COPY . .

# Run tests
CMD ["pytest", "--cov", "--cov-report=term"]
```

```yaml
# docker-compose.yml
version: '3.8'

services:
  test:
    build: .
    volumes:
      - .:/app
    environment:
      - PYTHONPATH=/app/src
```

## Environment Management

### Development Environment

```yaml
# environment.yml (Conda)
name: myproject
channels:
  - conda-forge
  - defaults
dependencies:
  - python=3.11
  - pip
  - pip:
    - -e .[dev]
```

### CI Environment

Ensure consistent dependencies:

```toml
# pyproject.toml
[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "pytest-mock>=3.12.0",
    "pytest-asyncio>=0.21.0",
    "pytest-xdist>=3.5.0",
    "ruff>=0.1.8",
    "mypy>=1.7.0",
    "pre-commit>=3.6.0",
]
```

## Security Scanning

### Secret Scanning

```yaml
# .github/workflows/security.yml
name: Security

on: [push, pull_request]

jobs:
  secrets:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - name: Gitleaks scan
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  
  vulnerabilities:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: pip install safety bandit
      
      - name: Run Safety
        run: safety check --json
      
      - name: Run Bandit
        run: bandit -r src/ -f json
```

## Continuous Deployment

### Deployment to Production

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  release:
    types: [published]

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: pip install -e .
      
      - name: Deploy to server
        env:
          DEPLOY_KEY: ${{ secrets.DEPLOY_KEY }}
          SERVER_HOST: ${{ secrets.SERVER_HOST }}
        run: |
          # Your deployment script
          ./scripts/deploy.sh
```

## Performance Benchmarking

```yaml
# .github/workflows/benchmark.yml
name: Benchmark

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  benchmark:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: pip install -e ".[dev]" pytest-benchmark
      
      - name: Run benchmarks
        run: pytest tests/benchmarks/ --benchmark-only --benchmark-json=output.json
      
      - name: Store benchmark result
        uses: benchmark-action/github-action-benchmark@v1
        with:
          tool: 'pytest'
          output-file-path: output.json
          github-token: ${{ secrets.GITHUB_TOKEN }}
          auto-push: true
```

## Monitoring and Notifications

### Slack Notifications

```yaml
- name: Notify Slack
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "Build failed for ${{ github.repository }}",
        "blocks": [
          {
            "type": "section",
            "text": {
              "type": "mrkdwn",
              "text": "Build failed for *${{ github.repository }}*\nCommit: ${{ github.sha }}\nAuthor: ${{ github.actor }}"
            }
          }
        ]
      }
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Best Practices

1. **Cache dependencies**: Use caching to speed up workflows
2. **Matrix builds**: Test on multiple Python versions
3. **Fail fast**: Don't waste time on redundant tests
4. **Parallel execution**: Run independent jobs in parallel
5. **Artifact storage**: Save logs, coverage reports, build artifacts
6. **Branch protection**: Require CI checks to pass before merging
7. **Environment secrets**: Use GitHub Secrets for sensitive data
8. **Timeout limits**: Set reasonable timeouts for jobs
9. **Reusable workflows**: Create reusable workflow templates
10. **Monitoring**: Track CI/CD metrics and performance

## Local CI Simulation

Run CI checks locally:

```bash
# Run all pre-commit hooks
pre-commit run --all-files

# Run tests like CI
pytest --cov --cov-report=xml --cov-report=term

# Run type checking
mypy src/

# Run linting
ruff check .
ruff format --check .

# Run security checks
bandit -r src/
safety check
```

## Troubleshooting CI Failures

1. **Check logs**: Review full output in GitHub Actions
2. **Run locally**: Reproduce the failure on your machine
3. **Check dependencies**: Ensure versions match CI
4. **Review changes**: Identify what changed to cause failure
5. **Incremental debugging**: Add debug prints if needed

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [pytest-cov](https://pytest-cov.readthedocs.io/)
- [pre-commit](https://pre-commit.com/)
- [Codecov](https://about.codecov.io/)
