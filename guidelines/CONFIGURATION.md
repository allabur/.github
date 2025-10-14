# Python Configuration Guidelines

## Project Configuration

### pyproject.toml (Recommended)

Modern Python projects use `pyproject.toml` for configuration:

```toml
[build-system]
requires = ["setuptools>=61.0", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "my-package"
version = "0.1.0"
description = "A Python package for data processing"
readme = "README.md"
requires-python = ">=3.10"
license = {text = "MIT"}
authors = [
    {name = "Your Name", email = "your.email@example.com"}
]
keywords = ["data", "processing", "analysis"]
classifiers = [
    "Development Status :: 3 - Alpha",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]

dependencies = [
    "requests>=2.31.0",
    "pydantic>=2.0.0",
    "click>=8.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "pytest-mock>=3.12.0",
    "pytest-asyncio>=0.21.0",
    "ruff>=0.1.8",
    "mypy>=1.7.0",
    "pre-commit>=3.6.0",
]
docs = [
    "mkdocs>=1.5.0",
    "mkdocs-material>=9.0.0",
    "mkdocstrings[python]>=0.24.0",
]
test = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "pytest-xdist>=3.5.0",
]

[project.urls]
Homepage = "https://github.com/username/project"
Documentation = "https://project.readthedocs.io"
Repository = "https://github.com/username/project"
Issues = "https://github.com/username/project/issues"
Changelog = "https://github.com/username/project/blob/main/CHANGELOG.md"

[project.scripts]
my-tool = "my_package.cli:main"

[tool.setuptools.packages.find]
where = ["src"]

[tool.setuptools.package-data]
my_package = ["py.typed", "data/*.json"]
```

### Tool Configuration in pyproject.toml

#### Ruff

```toml
[tool.ruff]
line-length = 88
target-version = "py310"
src = ["src", "tests"]

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "A",   # flake8-builtins
    "C4",  # flake8-comprehensions
    "DTZ", # flake8-datetimez
    "EM",  # flake8-errmsg
    "ISC", # flake8-implicit-str-concat
    "PIE", # flake8-pie
    "PT",  # flake8-pytest-style
    "RET", # flake8-return
    "SIM", # flake8-simplify
    "ARG", # flake8-unused-arguments
    "PL",  # pylint
    "RUF", # ruff-specific
]

ignore = [
    "E501",    # line too long (handled by formatter)
    "PLR0913", # too many arguments
]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = [
    "S101",    # assert allowed in tests
    "PLR2004", # magic values OK in tests
    "ARG001",  # unused arguments (fixtures)
]

[tool.ruff.lint.isort]
known-first-party = ["my_package"]
force-single-line = false
lines-after-imports = 2

[tool.ruff.lint.pydocstyle]
convention = "google"
```

#### mypy

```toml
[tool.mypy]
python_version = "3.10"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_any_generics = true
disallow_subclassing_any = true
disallow_untyped_calls = true
disallow_incomplete_defs = true
check_untyped_defs = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
strict_equality = true
strict_concatenate = true

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false
disallow_untyped_calls = false

[[tool.mypy.overrides]]
module = "third_party_module.*"
ignore_missing_imports = true
```

#### pytest

```toml
[tool.pytest.ini_options]
minversion = "7.0"
testpaths = ["tests"]
python_files = ["test_*.py", "*_test.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--strict-markers",
    "--strict-config",
    "--cov=src",
    "--cov-branch",
    "--cov-report=term-missing:skip-covered",
    "--cov-report=html",
    "--cov-report=xml",
    "-ra",
    "--tb=short",
]
markers = [
    "unit: Unit tests (fast, isolated)",
    "integration: Integration tests (slower)",
    "slow: Slow tests",
    "requires_db: Tests requiring database",
    "requires_network: Tests requiring network access",
]
filterwarnings = [
    "error",
    "ignore::DeprecationWarning",
]
```

#### Coverage

```toml
[tool.coverage.run]
source = ["src"]
branch = true
omit = [
    "*/tests/*",
    "*/test_*.py",
    "*/__init__.py",
    "*/conftest.py",
]

[tool.coverage.report]
precision = 2
show_missing = true
skip_covered = false
exclude_lines = [
    "pragma: no cover",
    "def __repr__",
    "def __str__",
    "raise AssertionError",
    "raise NotImplementedError",
    "if __name__ == .__main__.:",
    "if TYPE_CHECKING:",
    "@abstractmethod",
    "@abc.abstractmethod",
]

[tool.coverage.html]
directory = "htmlcov"

[tool.coverage.xml]
output = "coverage.xml"
```

## Environment Configuration

### environment.yml (Conda)

```yaml
name: my-project
channels:
  - conda-forge
  - defaults

dependencies:
  # Python
  - python=3.11
  
  # Core dependencies
  - numpy>=1.24.0
  - pandas>=2.0.0
  - scikit-learn>=1.3.0
  
  # Development tools
  - pip
  - pip:
    - -e .[dev]  # Install package in editable mode with dev dependencies
    
  # Optional: Jupyter for development
  - jupyter
  - ipython
  
  # Optional: System dependencies
  - postgresql  # If needed
```

### .env File (Environment Variables)

```bash
# .env (DO NOT COMMIT - add to .gitignore)
# Use python-dotenv to load these

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# API Keys (NEVER commit these)
API_KEY=your-secret-api-key
SECRET_KEY=your-secret-key

# Application settings
DEBUG=false
LOG_LEVEL=INFO
MAX_WORKERS=4

# External services
REDIS_URL=redis://localhost:6379
```

Load environment variables in Python:

```python
# config.py
import os
from pathlib import Path
from dotenv import load_dotenv

# Load .env file
load_dotenv()

# Access variables
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///default.db")
DEBUG = os.getenv("DEBUG", "false").lower() == "true"
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
```

### config.py Module

```python
"""Application configuration."""

from dataclasses import dataclass, field
from pathlib import Path
import os
from typing import Any

@dataclass
class DatabaseConfig:
    """Database configuration."""
    url: str
    pool_size: int = 5
    echo: bool = False
    
    @classmethod
    def from_env(cls) -> "DatabaseConfig":
        """Load from environment variables."""
        return cls(
            url=os.getenv("DATABASE_URL", "sqlite:///app.db"),
            pool_size=int(os.getenv("DB_POOL_SIZE", "5")),
            echo=os.getenv("DB_ECHO", "false").lower() == "true",
        )

@dataclass
class Config:
    """Application configuration."""
    
    # Application
    app_name: str = "MyApp"
    version: str = "0.1.0"
    debug: bool = False
    
    # Paths
    base_dir: Path = field(default_factory=lambda: Path(__file__).parent)
    data_dir: Path | None = None
    log_dir: Path | None = None
    
    # Database
    database: DatabaseConfig = field(default_factory=DatabaseConfig)
    
    # Logging
    log_level: str = "INFO"
    log_format: str = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
    
    # API
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_workers: int = 4
    
    def __post_init__(self) -> None:
        """Initialize computed paths."""
        if self.data_dir is None:
            self.data_dir = self.base_dir / "data"
        if self.log_dir is None:
            self.log_dir = self.base_dir / "logs"
    
    @classmethod
    def from_env(cls) -> "Config":
        """Load configuration from environment variables."""
        return cls(
            app_name=os.getenv("APP_NAME", "MyApp"),
            debug=os.getenv("DEBUG", "false").lower() == "true",
            database=DatabaseConfig.from_env(),
            log_level=os.getenv("LOG_LEVEL", "INFO"),
            api_host=os.getenv("API_HOST", "0.0.0.0"),
            api_port=int(os.getenv("API_PORT", "8000")),
            api_workers=int(os.getenv("API_WORKERS", "4")),
        )
    
    @classmethod
    def from_file(cls, path: Path) -> "Config":
        """Load configuration from TOML file."""
        import tomllib
        
        with path.open("rb") as f:
            data = tomllib.load(f)
        
        return cls(
            app_name=data.get("app_name", "MyApp"),
            debug=data.get("debug", False),
            database=DatabaseConfig(**data.get("database", {})),
            log_level=data.get("log_level", "INFO"),
            api_host=data.get("api", {}).get("host", "0.0.0.0"),
            api_port=data.get("api", {}).get("port", 8000),
            api_workers=data.get("api", {}).get("workers", 4),
        )

# Global config instance
_config: Config | None = None

def get_config() -> Config:
    """Get or create global config instance."""
    global _config
    if _config is None:
        _config = Config.from_env()
    return _config

def set_config(config: Config) -> None:
    """Set global config instance."""
    global _config
    _config = config
```

### config.toml (Application Configuration)

```toml
# config.toml
[app]
name = "MyApp"
version = "0.1.0"
debug = false

[database]
url = "postgresql://user:password@localhost:5432/mydb"
pool_size = 10
echo = false

[api]
host = "0.0.0.0"
port = 8000
workers = 4

[logging]
level = "INFO"
format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"

[features]
enable_caching = true
enable_metrics = true
max_upload_size = 10485760  # 10MB
```

## Docker Configuration

### Dockerfile

```dockerfile
FROM python:3.11-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy dependency files
COPY pyproject.toml .
COPY README.md .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -e .[dev]

# Copy source code
COPY src/ src/
COPY tests/ tests/

# Run tests
RUN pytest

# Default command
CMD ["python", "-m", "my_package"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/.venv  # Exclude venv
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/mydb
      - DEBUG=true
    depends_on:
      - db
      - redis
    command: python -m my_package
  
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=mydb
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
  
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

## .gitignore

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
venv/
env/
.venv/
ENV/

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.hypothesis/

# mypy
.mypy_cache/
.dmypy.json
dmypy.json

# Ruff
.ruff_cache/

# Environment variables
.env
.env.local
.env.*.local

# Logs
*.log
logs/

# OS
.DS_Store
Thumbs.db

# Documentation
docs/_build/
site/

# Data files (adjust as needed)
*.csv
*.xlsx
*.db
*.sqlite
*.sqlite3
```

## Pre-commit Configuration

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
        args: ['--maxkb=1000']
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
        additional_dependencies: [types-requests, pydantic]
        args: [--strict]
```

## References

- [PEP 517](https://peps.python.org/pep-0517/) - Build System Interface
- [PEP 518](https://peps.python.org/pep-0518/) - pyproject.toml
- [PEP 621](https://peps.python.org/pep-0621/) - Project Metadata
- See `/instructions/python.instructions.md` for Python project setup
- See `/instructions/my-code.instructions.md` for coding standards
- See `/instructions/my-ci-cd.instructions.md` for CI/CD configuration
