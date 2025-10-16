# Configuration Guidelines

This document provides comprehensive guidance for configuration management in Python projects, covering modern tools and best practices.

## Configuration Philosophy

Python projects should follow the [12-Factor App](https://12factor.net/) methodology for configuration:

1. **Store config in the environment** - Use environment variables for deployment-specific config
2. **Strict separation** - Configuration is separate from code
3. **No secrets in code** - Never commit credentials or API keys
4. **Type safety** - Validate configuration at startup
5. **Clear precedence** - Environment variables override defaults

## Configuration Sources and Precedence

Configuration typically follows this precedence hierarchy (highest to lowest):

1. **Command-line arguments** - Explicit user input (highest priority)
2. **Environment variables** - Deployment-specific configuration
3. **Configuration files** - `.env`, `config.yaml`, `settings.toml`
4. **Default values** - Hardcoded defaults in code (lowest priority)

## Primary Configuration File: `pyproject.toml`

Modern Python projects use `pyproject.toml` as the central configuration file (PEP 518, PEP 621):

```toml
[project]
name = "myproject"
version = "1.0.0"
description = "My Python project"
authors = [
    {name = "Your Name", email = "you@example.com"}
]
readme = "README.md"
requires-python = ">=3.10"
license = {text = "MIT"}

keywords = ["python", "example", "api"]
classifiers = [
    "Development Status :: 4 - Beta",
    "Intended Audience :: Developers",
    "License :: OSI Approved :: MIT License",
    "Programming Language :: Python :: 3.10",
    "Programming Language :: Python :: 3.11",
    "Programming Language :: Python :: 3.12",
]

dependencies = [
    "fastapi>=0.104.0",
    "pydantic>=2.0.0",
    "sqlalchemy>=2.0.0",
    "python-dotenv>=1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "pytest-asyncio>=0.21.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
    "interrogate>=1.5.0",
]
docs = [
    "mkdocs>=1.5.0",
    "mkdocs-material>=9.0.0",
    "mkdocstrings[python]>=0.24.0",
]
test = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "pytest-mock>=3.11.0",
]

[project.scripts]
myapp = "myproject.cli:main"

[project.urls]
Homepage = "https://github.com/username/myproject"
Documentation = "https://myproject.readthedocs.io"
Repository = "https://github.com/username/myproject.git"
Issues = "https://github.com/username/myproject/issues"

[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

# Tool-specific configuration
[tool.ruff]
line-length = 88
target-version = "py310"
select = [
    "E",  # pycodestyle errors
    "W",  # pycodestyle warnings
    "F",  # pyflakes
    "I",  # isort
    "N",  # pep8-naming
    "UP", # pyupgrade
]
ignore = []
exclude = [
    ".git",
    ".venv",
    "__pycache__",
    "build",
    "dist",
]

[tool.ruff.isort]
known-first-party = ["myproject"]

[tool.mypy]
python_version = "3.10"
strict = true
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
exclude = [
    "tests/",
    ".venv/",
]

[[tool.mypy.overrides]]
module = "tests.*"
disallow_untyped_defs = false

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = [
    "--cov=myproject",
    "--cov-report=html",
    "--cov-report=term",
    "--cov-fail-under=70",
    "-v",
]
markers = [
    "slow: marks tests as slow",
    "integration: marks tests as integration tests",
    "unit: marks tests as unit tests",
]

[tool.coverage.run]
source = ["src/myproject"]
omit = [
    "*/tests/*",
    "*/test_*.py",
]

[tool.coverage.report]
precision = 2
show_missing = true
skip_covered = false
```
gitflow.branch.hotfix.startPoint=main
gitflow.branch.hotfix.prefix=hotfix/
gitflow.branch.hotfix.upstreamStrategy=merge
gitflow.branch.hotfix.downstreamStrategy=merge
gitflow.branch.hotfix.tag=true
gitflow.branch.hotfix.tagprefix=v
gitflow.branch.hotfix.autoUpdate=false
```

#### Custom Branch Types

You can define custom branch types by setting the appropriate configuration:

```bash
# Example: Support branches
gitflow.branch.support.type=topic
gitflow.branch.support.parent=main
gitflow.branch.support.startPoint=main
gitflow.branch.support.prefix=support/
gitflow.branch.support.tag=true
gitflow.branch.support.tagprefix=support-
```

## Environment Variables

### .env Files

Use `.env` files for local development (never commit to version control):

```bash
# .env
# Database configuration
DATABASE_URL=postgresql://user:password@localhost:5432/mydb
DATABASE_POOL_SIZE=10

# API configuration
API_HOST=0.0.0.0
API_PORT=8000
API_DEBUG=true

# Security
SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=30

# External services
REDIS_URL=redis://localhost:6379/0
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_USER=user@example.com
SMTP_PASSWORD=smtp-password

# Feature flags
ENABLE_FEATURE_X=true
LOG_LEVEL=DEBUG
```

### .env.example

Provide a template for required environment variables:

```bash
# .env.example
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname
DATABASE_POOL_SIZE=10

# API
API_HOST=0.0.0.0
API_PORT=8000
API_DEBUG=false

# Security (REQUIRED)
SECRET_KEY=  # Generate with: openssl rand -hex 32
JWT_ALGORITHM=HS256
JWT_EXPIRE_MINUTES=30

# External Services
REDIS_URL=redis://localhost:6379/0
SMTP_HOST=
SMTP_PORT=587
SMTP_USER=
SMTP_PASSWORD=

# Feature Flags
ENABLE_FEATURE_X=false
LOG_LEVEL=INFO
```

### Loading Environment Variables

```python
from dotenv import load_dotenv
import os

# Load .env file (should be done at application startup)
load_dotenv()

# Access environment variables
database_url = os.getenv("DATABASE_URL")
api_host = os.getenv("API_HOST", "0.0.0.0")  # With default
api_port = int(os.getenv("API_PORT", "8000"))
api_debug = os.getenv("API_DEBUG", "false").lower() == "true"

# Validate required variables
if not database_url:
    raise ValueError("DATABASE_URL environment variable is required")
```

## Configuration Management Patterns

### Pattern 1: Dataclass Configuration

Simple, type-safe configuration using dataclasses:

```python
from dataclasses import dataclass, field
from typing import ClassVar
import os
from dotenv import load_dotenv

@dataclass
class DatabaseConfig:
    """Database configuration."""
    url: str
    pool_size: int = 10
    echo: bool = False
    
    @classmethod
    def from_env(cls) -> "DatabaseConfig":
        """Load from environment variables."""
        return cls(
            url=os.getenv("DATABASE_URL", "sqlite:///./app.db"),
            pool_size=int(os.getenv("DATABASE_POOL_SIZE", "10")),
            echo=os.getenv("DATABASE_ECHO", "").lower() == "true",
        )

@dataclass
class APIConfig:
    """API configuration."""
    host: str = "0.0.0.0"
    port: int = 8000
    debug: bool = False
    
    @classmethod
    def from_env(cls) -> "APIConfig":
        """Load from environment variables."""
        return cls(
            host=os.getenv("API_HOST", "0.0.0.0"),
            port=int(os.getenv("API_PORT", "8000")),
            debug=os.getenv("API_DEBUG", "").lower() == "true",
        )

@dataclass
class Config:
    """Application configuration."""
    database: DatabaseConfig
    api: APIConfig
    secret_key: str
    
    @classmethod
    def from_env(cls) -> "Config":
        """Load configuration from environment."""
        load_dotenv()
        
        config = cls(
            database=DatabaseConfig.from_env(),
            api=APIConfig.from_env(),
            secret_key=os.getenv("SECRET_KEY", ""),
        )
        
        config.validate()
        return config
    
    def validate(self) -> None:
        """Validate configuration."""
        if not self.secret_key:
            raise ValueError("SECRET_KEY must be set")
        if self.api.debug and "production" in os.getenv("ENV", ""):
            raise ValueError("DEBUG mode cannot be enabled in production")

# Usage
config = Config.from_env()
```

### Pattern 2: Pydantic Settings

Robust configuration with validation using Pydantic:

```python
from pydantic import Field, field_validator
from pydantic_settings import BaseSettings, SettingsConfigDict

class DatabaseSettings(BaseSettings):
    """Database settings."""
    url: str = Field(..., description="Database connection URL")
    pool_size: int = Field(10, ge=1, le=100)
    echo: bool = Field(False, description="Echo SQL queries")
    
    model_config = SettingsConfigDict(env_prefix="DATABASE_")

class APISettings(BaseSettings):
    """API settings."""
    host: str = Field("0.0.0.0", description="API host")
    port: int = Field(8000, ge=1, le=65535)
    debug: bool = Field(False, description="Debug mode")
    
    model_config = SettingsConfigDict(env_prefix="API_")

class Settings(BaseSettings):
    """Application settings."""
    # Database
    database: DatabaseSettings = Field(default_factory=DatabaseSettings)
    
    # API
    api: APISettings = Field(default_factory=APISettings)
    
    # Security
    secret_key: str = Field(..., min_length=32)
    jwt_algorithm: str = "HS256"
    jwt_expire_minutes: int = Field(30, ge=1)
    
    # Logging
    log_level: str = Field("INFO", pattern="^(DEBUG|INFO|WARNING|ERROR|CRITICAL)$")
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
        env_nested_delimiter="__",  # Allow DATABASE__URL format
    )
    
    @field_validator("secret_key")
    @classmethod
    def validate_secret_key(cls, v: str) -> str:
        """Ensure secret key is strong enough."""
        if len(v) < 32:
            raise ValueError("SECRET_KEY must be at least 32 characters")
        return v

# Usage
settings = Settings()  # Automatically loads from environment
```

### Pattern 3: YAML Configuration

For complex, hierarchical configuration:

```yaml
# config.yaml
database:
  url: postgresql://user:password@localhost:5432/mydb
  pool_size: 10
  echo: false

api:
  host: 0.0.0.0
  port: 8000
  debug: false
  cors:
    enabled: true
    origins:
      - http://localhost:3000
      - https://example.com

logging:
  level: INFO
  format: "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
  handlers:
    - type: console
    - type: file
      filename: app.log

features:
  enable_caching: true
  enable_metrics: true
  maintenance_mode: false
```

```python
import yaml
from pathlib import Path
from typing import Any

def load_config(config_file: Path = Path("config.yaml")) -> dict[str, Any]:
    """Load configuration from YAML file."""
    if not config_file.exists():
        raise FileNotFoundError(f"Configuration file not found: {config_file}")
    
    with config_file.open() as f:
        config = yaml.safe_load(f)
    
    # Override with environment variables
    if database_url := os.getenv("DATABASE_URL"):
        config["database"]["url"] = database_url
    
    if api_port := os.getenv("API_PORT"):
        config["api"]["port"] = int(api_port)
    
    return config

# Usage
config = load_config()
database_url = config["database"]["url"]
```

## Conda Environment Configuration

For data science and scientific computing projects:

```yaml
# environment.yml
name: myproject
channels:
  - conda-forge
  - defaults

dependencies:
  # Python version
  - python=3.11
  
  # Core dependencies
  - numpy>=1.24.0
  - pandas>=2.0.0
  - scikit-learn>=1.3.0
  - matplotlib>=3.7.0
  - seaborn>=0.12.0
  
  # Database
  - sqlalchemy>=2.0.0
  - psycopg2>=2.9.0
  
  # Web framework (if applicable)
  - fastapi>=0.104.0
  - uvicorn>=0.24.0
  
  # Development tools
  - jupyter>=1.0.0
  - ipython>=8.12.0
  - pytest>=7.4.0
  - pytest-cov>=4.1.0
  - ruff>=0.1.0
  - mypy>=1.5.0
  
  # Pip-only packages
  - pip
  - pip:
      - python-dotenv>=1.0.0
      - pydantic>=2.0.0
      - pydantic-settings>=2.0.0
```

**Create environment:**
```bash
# Create from file
conda env create -f environment.yml

# Activate
conda activate myproject

# Update environment
conda env update -f environment.yml --prune

# Export environment
conda env export > environment.yml
```

## Security Best Practices

### Never Commit Secrets

```gitignore
# .gitignore
# Environment files
.env
.env.local
.env.*.local

# Secrets
secrets/
*.key
*.pem
*.secret

# Configuration with secrets
config.local.yaml
settings.local.toml
```

### Use Environment Variables

```python
# GOOD: Load from environment
api_key = os.getenv("API_KEY")
if not api_key:
    raise ValueError("API_KEY environment variable is required")

# BAD: Hardcoded secret
api_key = "sk-1234567890abcdef"  # NEVER do this
```

### Validate Configuration

```python
def validate_production_config(config: Config) -> None:
    """Validate production configuration."""
    errors = []
    
    # Check debug mode
    if config.api.debug:
        errors.append("DEBUG mode must be disabled in production")
    
    # Check secret key
    if len(config.secret_key) < 32:
        errors.append("SECRET_KEY must be at least 32 characters")
    
    # Check database URL
    if "localhost" in config.database.url:
        errors.append("Database URL should not use localhost in production")
    
    if errors:
        raise ValueError(f"Production config validation failed:\n" + "\n".join(errors))
```

## Configuration Examples

### Web Application

```python
# config.py
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    # Application
    app_name: str = "MyApp"
    app_version: str = "1.0.0"
    
    # Database
    database_url: str
    database_pool_size: int = 10
    
    # API
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_cors_origins: list[str] = ["*"]
    
    # Security
    secret_key: str
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    
    # Redis
    redis_url: str = "redis://localhost:6379"
    
    # Email
    smtp_host: str = ""
    smtp_port: int = 587
    smtp_user: str = ""
    smtp_password: str = ""
    
    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
```

### CLI Tool

```python
# config.py
from pathlib import Path
import os

class Config:
    """CLI tool configuration."""
    
    # Paths
    HOME = Path.home()
    CONFIG_DIR = HOME / ".myapp"
    DATA_DIR = CONFIG_DIR / "data"
    CACHE_DIR = CONFIG_DIR / "cache"
    
    # Settings
    LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")
    CACHE_ENABLED = os.getenv("CACHE_ENABLED", "true").lower() == "true"
    
    # API
    API_BASE_URL = os.getenv("API_BASE_URL", "https://api.example.com")
    API_KEY = os.getenv("API_KEY", "")
    
    @classmethod
    def ensure_dirs(cls) -> None:
        """Ensure configuration directories exist."""
        cls.CONFIG_DIR.mkdir(exist_ok=True)
        cls.DATA_DIR.mkdir(exist_ok=True)
        cls.CACHE_DIR.mkdir(exist_ok=True)

# Initialize on import
Config.ensure_dirs()
```

## Best Practices

1. **Use environment variables for deployment-specific config**
2. **Provide .env.example for required variables**
3. **Validate configuration at startup**
4. **Never commit secrets to version control**
5. **Use type hints and validation (Pydantic)**
6. **Document configuration options**
7. **Provide sensible defaults when possible**
8. **Fail fast on missing required configuration**
9. **Use configuration classes/objects, not dictionaries**
10. **Test configuration loading and validation**

## References

- **PEP 518**: Specifying `pyproject.toml` build system requirements
- **PEP 621**: Storing project metadata in `pyproject.toml`
- **12-Factor App**: [https://12factor.net/config](https://12factor.net/config)
- **Pydantic Settings**: [https://docs.pydantic.dev/latest/concepts/pydantic_settings/](https://docs.pydantic.dev/latest/concepts/pydantic_settings/)
- **python-dotenv**: [https://pypi.org/project/python-dotenv/](https://pypi.org/project/python-dotenv/)

This configuration guide provides patterns and practices for managing configuration in modern Python projects, ensuring security, flexibility, and maintainability.
