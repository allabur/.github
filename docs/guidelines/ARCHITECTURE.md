# Python Project Architecture Guide

This document outlines architectural patterns and project structure conventions for Python projects, following modern best practices and the Python ecosystem standards.

## Project Structure

Python projects should follow a clear, standardized structure that separates concerns and facilitates maintenance:

```
my-python-project/
├── src/
│   └── mypackage/           # Main package (importable)
│       ├── __init__.py      # Package initialization
│       ├── core/            # Core business logic
│       │   ├── __init__.py
│       │   ├── models.py    # Data models (dataclasses, Pydantic)
│       │   └── services.py  # Business logic services
│       ├── api/             # API layer (if applicable)
│       │   ├── __init__.py
│       │   ├── routes.py    # API route definitions
│       │   └── schemas.py   # Request/response schemas
│       ├── data/            # Data access layer
│       │   ├── __init__.py
│       │   ├── repository.py # Data repository pattern
│       │   └── database.py   # Database connection/session
│       ├── utils/           # Utility functions and helpers
│       │   ├── __init__.py
│       │   ├── logging.py   # Logging configuration
│       │   └── config.py    # Configuration management
│       └── cli.py           # CLI entry point (if applicable)
├── tests/                   # Test suite (mirrors src structure)
│   ├── __init__.py
│   ├── unit/               # Unit tests
│   │   ├── test_models.py
│   │   └── test_services.py
│   ├── integration/        # Integration tests
│   │   └── test_api.py
│   ├── conftest.py         # Pytest fixtures and configuration
│   └── fixtures/           # Test data and fixtures
├── docs/                   # Documentation
│   ├── index.md           # Main documentation page
│   ├── api/               # API documentation
│   ├── guides/            # User guides and tutorials
│   └── mkdocs.yml         # MkDocs configuration
├── scripts/               # Utility scripts
│   ├── setup_dev.sh       # Development environment setup
│   └── deploy.sh          # Deployment script
├── .github/               # GitHub configuration
│   └── workflows/         # CI/CD workflows
│       ├── ci.yml         # Main CI workflow
│       └── release.yml    # Release automation
├── pyproject.toml         # Project metadata and dependencies
├── environment.yml        # Conda environment specification
├── README.md              # Project overview and quick start
├── CHANGELOG.md           # Version history
└── LICENSE                # License information
```

### Key Organizational Principles

- **src/ layout**: Uses the `src/` layout to prevent accidental imports of non-installed code
- **Package naming**: Use lowercase, single-word names or underscores (`mypackage`, `my_package`)
- **Separation of concerns**: Clear boundaries between API, business logic, and data layers
- **Test organization**: Tests mirror source structure for easy navigation
- **Configuration**: Centralized in `pyproject.toml` and environment files

## Core Architecture Patterns

### Layered Architecture

Python projects commonly follow a layered architecture pattern that separates concerns:

#### Presentation Layer (API/CLI)
- Handles user/system interaction
- Input validation and serialization
- Framework-specific code (FastAPI, Flask, Django, Click)
- Examples: REST endpoints, CLI commands, GraphQL resolvers

#### Business Logic Layer
- Core application logic
- Domain models and business rules
- Framework-agnostic code
- Examples: Service classes, domain models, use cases

#### Data Access Layer
- Database and external service interactions
- Repository pattern implementation
- ORM/query abstraction
- Examples: SQLAlchemy models, repository classes, API clients

#### Infrastructure Layer
- Cross-cutting concerns
- Configuration management
- Logging and monitoring
- Examples: Config loaders, loggers, metrics collectors

### Dependency Injection

Modern Python projects use dependency injection to improve testability:

```python
from typing import Protocol

class UserRepository(Protocol):
    """Protocol defining user repository interface."""
    def get_user(self, user_id: int) -> User | None: ...
    def save_user(self, user: User) -> None: ...

class UserService:
    """Business logic for user operations."""
    
    def __init__(self, repository: UserRepository):
        self.repository = repository
    
    def activate_user(self, user_id: int) -> User:
        user = self.repository.get_user(user_id)
        if not user:
            raise ValueError(f"User {user_id} not found")
        user.is_active = True
        self.repository.save_user(user)
        return user
```

Benefits:
- Testable code (easy to mock dependencies)
- Loose coupling between components
- Clear dependency boundaries
- Framework compatibility (FastAPI's `Depends`, pytest fixtures)

### Repository Pattern

The Repository pattern abstracts data access, providing a clean interface for data operations:

```python
from abc import ABC, abstractmethod
from typing import Sequence

class BaseRepository(ABC):
    """Abstract base repository."""
    
    @abstractmethod
    def get_by_id(self, id: int) -> Model | None:
        """Retrieve entity by ID."""
        pass
    
    @abstractmethod
    def get_all(self) -> Sequence[Model]:
        """Retrieve all entities."""
        pass
    
    @abstractmethod
    def save(self, entity: Model) -> Model:
        """Save entity."""
        pass
    
    @abstractmethod
    def delete(self, id: int) -> bool:
        """Delete entity by ID."""
        pass

class SQLAlchemyRepository(BaseRepository):
    """Concrete repository using SQLAlchemy."""
    
    def __init__(self, session: Session, model_class: type[Model]):
        self.session = session
        self.model_class = model_class
    
    def get_by_id(self, id: int) -> Model | None:
        return self.session.get(self.model_class, id)
    
    def get_all(self) -> Sequence[Model]:
        return self.session.query(self.model_class).all()
    
    def save(self, entity: Model) -> Model:
        self.session.add(entity)
        self.session.commit()
        self.session.refresh(entity)
        return entity
    
    def delete(self, id: int) -> bool:
        entity = self.get_by_id(id)
        if entity:
            self.session.delete(entity)
            self.session.commit()
            return True
        return False
```

### Data Models

Use modern Python data structures for domain models:

#### Dataclasses (Built-in)
For simple data containers with type hints:

```python
from dataclasses import dataclass, field
from datetime import datetime

@dataclass
class User:
    """User domain model."""
    id: int
    email: str
    name: str
    is_active: bool = True
    created_at: datetime = field(default_factory=datetime.now)
    
    def activate(self) -> None:
        """Activate user account."""
        self.is_active = True
    
    def deactivate(self) -> None:
        """Deactivate user account."""
        self.is_active = False
```

#### Pydantic Models
For validation and serialization (especially in APIs):

```python
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

class UserCreate(BaseModel):
    """Schema for creating a user."""
    email: EmailStr
    name: str = Field(..., min_length=1, max_length=100)
    password: str = Field(..., min_length=8)

class UserResponse(BaseModel):
    """Schema for user response."""
    id: int
    email: EmailStr
    name: str
    is_active: bool
    created_at: datetime
    
    class Config:
        from_attributes = True  # For SQLAlchemy models
```

## Configuration Management

### Configuration Sources

Python projects typically use multiple configuration sources with a clear hierarchy:

1. **Default values** (in code)
2. **Configuration files** (`pyproject.toml`, `config.yaml`)
3. **Environment variables** (12-factor app pattern)
4. **Command-line arguments** (highest priority)

### Configuration Patterns

#### Environment-Based Configuration

```python
import os
from dataclasses import dataclass
from dotenv import load_dotenv

@dataclass
class Config:
    """Application configuration."""
    # Database
    database_url: str
    database_pool_size: int = 10
    
    # API
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    api_debug: bool = False
    
    # Security
    secret_key: str
    jwt_algorithm: str = "HS256"
    jwt_expire_minutes: int = 30
    
    @classmethod
    def from_env(cls) -> "Config":
        """Load configuration from environment variables."""
        load_dotenv()
        
        return cls(
            database_url=os.getenv("DATABASE_URL", "sqlite:///./app.db"),
            database_pool_size=int(os.getenv("DB_POOL_SIZE", "10")),
            api_host=os.getenv("API_HOST", "0.0.0.0"),
            api_port=int(os.getenv("API_PORT", "8000")),
            api_debug=os.getenv("API_DEBUG", "").lower() == "true",
            secret_key=os.getenv("SECRET_KEY", ""),
            jwt_algorithm=os.getenv("JWT_ALGORITHM", "HS256"),
            jwt_expire_minutes=int(os.getenv("JWT_EXPIRE_MINUTES", "30")),
        )
    
    def validate(self) -> None:
        """Validate configuration."""
        if not self.secret_key:
            raise ValueError("SECRET_KEY must be set")
        if not self.database_url:
            raise ValueError("DATABASE_URL must be set")

# Usage
config = Config.from_env()
config.validate()
```

#### Pydantic Settings

For more robust configuration with validation:

```python
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    """Application settings with automatic environment loading."""
    
    # Database
    database_url: str
    database_pool_size: int = 10
    
    # API
    api_host: str = "0.0.0.0"
    api_port: int = 8000
    
    # Security
    secret_key: str
    jwt_algorithm: str = "HS256"
    
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

settings = Settings()  # Automatically loads from .env
```

### pyproject.toml

Modern Python projects use `pyproject.toml` for metadata and tool configuration:

```toml
[project]
name = "mypackage"
version = "1.0.0"
description = "My Python project"
authors = [{name = "Your Name", email = "you@example.com"}]
readme = "README.md"
requires-python = ">=3.10"
license = {text = "MIT"}
keywords = ["python", "example"]
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
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0.0",
    "pytest-cov>=4.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]

[project.scripts]
myapp = "mypackage.cli:main"

[build-system]
requires = ["setuptools>=65", "wheel"]
build-backend = "setuptools.build_meta"

[tool.ruff]
line-length = 88
target-version = "py310"
select = ["E", "F", "I", "N", "W"]
ignore = []

[tool.ruff.isort]
known-first-party = ["mypackage"]

[tool.mypy]
python_version = "3.10"
strict = true
warn_return_any = true
warn_unused_configs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
addopts = "--cov=mypackage --cov-report=html --cov-report=term"
```

## Example Project Architectures

### 1. FastAPI Web Application

RESTful API with clean architecture:

```
fastapi-app/
├── src/
│   └── myapi/
│       ├── api/
│       │   ├── routes/
│       │   │   ├── users.py
│       │   │   └── auth.py
│       │   └── dependencies.py
│       ├── core/
│       │   ├── config.py
│       │   ├── security.py
│       │   └── database.py
│       ├── models/
│       │   ├── user.py
│       │   └── base.py
│       ├── schemas/
│       │   ├── user.py
│       │   └── token.py
│       ├── services/
│       │   ├── user_service.py
│       │   └── auth_service.py
│       └── main.py
├── tests/
│   ├── test_api/
│   ├── test_services/
│   └── conftest.py
└── pyproject.toml
```

**Key features:**
- Separation of API routes, schemas, and business logic
- FastAPI dependency injection for services
- Pydantic models for request/response validation
- SQLAlchemy for database ORM

### 2. Data Processing Pipeline

ETL/data analysis application:

```
data-pipeline/
├── src/
│   └── pipeline/
│       ├── extract/
│       │   ├── csv_extractor.py
│       │   ├── api_extractor.py
│       │   └── db_extractor.py
│       ├── transform/
│       │   ├── cleaner.py
│       │   ├── validator.py
│       │   └── aggregator.py
│       ├── load/
│       │   ├── db_loader.py
│       │   └── file_loader.py
│       ├── core/
│       │   ├── pipeline.py
│       │   └── config.py
│       └── cli.py
├── tests/
│   ├── test_extract/
│   ├── test_transform/
│   └── test_load/
├── notebooks/
│   └── exploration.ipynb
└── environment.yml
```

**Key features:**
- Clear ETL stages (Extract, Transform, Load)
- Pandas/NumPy for data processing
- CLI for pipeline execution
- Jupyter notebooks for exploration

### 3. CLI Tool

Command-line application with rich features:

```
cli-tool/
├── src/
│   └── mytool/
│       ├── commands/
│       │   ├── init.py
│       │   ├── process.py
│       │   └── deploy.py
│       ├── core/
│       │   ├── processor.py
│       │   └── config.py
│       ├── utils/
│       │   ├── file_utils.py
│       │   └── logger.py
│       └── cli.py
├── tests/
│   ├── test_commands/
│   └── test_core/
└── pyproject.toml
```

**Key features:**
- Click or Typer for CLI framework
- Pluggable command architecture
- Rich for beautiful terminal output
- Configuration file support

## Design Patterns

### Service Layer Pattern

Encapsulates business logic and orchestrates operations:

```python
class UserService:
    """Service for user-related operations."""
    
    def __init__(
        self,
        user_repo: UserRepository,
        email_service: EmailService,
        logger: logging.Logger,
    ):
        self.user_repo = user_repo
        self.email_service = email_service
        self.logger = logger
    
    def register_user(
        self,
        email: str,
        password: str,
        name: str,
    ) -> User:
        """Register a new user."""
        # Validation
        if self.user_repo.get_by_email(email):
            raise ValueError(f"User with email {email} already exists")
        
        # Create user
        user = User(
            email=email,
            password_hash=hash_password(password),
            name=name,
            is_active=False,
        )
        
        # Save to database
        user = self.user_repo.save(user)
        
        # Send verification email
        try:
            self.email_service.send_verification(user)
        except EmailError as e:
            self.logger.error(f"Failed to send verification email: {e}")
            # Don't fail registration if email fails
        
        return user
```

### Factory Pattern

Creates objects without exposing instantiation logic:

```python
from typing import Protocol

class DataExtractor(Protocol):
    """Protocol for data extractors."""
    def extract(self, source: str) -> pd.DataFrame: ...

class CSVExtractor:
    """Extract data from CSV files."""
    def extract(self, source: str) -> pd.DataFrame:
        return pd.read_csv(source)

class JSONExtractor:
    """Extract data from JSON files."""
    def extract(self, source: str) -> pd.DataFrame:
        return pd.read_json(source)

class ExtractorFactory:
    """Factory for creating extractors based on file type."""
    
    _extractors: dict[str, type[DataExtractor]] = {
        "csv": CSVExtractor,
        "json": JSONExtractor,
    }
    
    @classmethod
    def create(cls, file_type: str) -> DataExtractor:
        """Create extractor for given file type."""
        extractor_class = cls._extractors.get(file_type)
        if not extractor_class:
            raise ValueError(f"Unsupported file type: {file_type}")
        return extractor_class()

# Usage
extractor = ExtractorFactory.create("csv")
data = extractor.extract("data.csv")
```

### Strategy Pattern

Encapsulates algorithms and makes them interchangeable:

```python
from abc import ABC, abstractmethod

class ValidationStrategy(ABC):
    """Abstract validation strategy."""
    
    @abstractmethod
    def validate(self, data: dict[str, any]) -> bool:
        pass

class StrictValidation(ValidationStrategy):
    """Strict validation with all fields required."""
    
    def validate(self, data: dict[str, any]) -> bool:
        required_fields = ["name", "email", "age"]
        return all(field in data for field in required_fields)

class LenientValidation(ValidationStrategy):
    """Lenient validation with optional fields."""
    
    def validate(self, data: dict[str, any]) -> bool:
        return "email" in data

class DataProcessor:
    """Process data with configurable validation."""
    
    def __init__(self, validation_strategy: ValidationStrategy):
        self.validation_strategy = validation_strategy
    
    def process(self, data: dict[str, any]) -> dict[str, any]:
        if not self.validation_strategy.validate(data):
            raise ValueError("Validation failed")
        # Process data...
        return data

# Usage
processor = DataProcessor(StrictValidation())
result = processor.process({"name": "Alice", "email": "alice@example.com", "age": 30})
```

## Testing Architecture

### Test Organization

Tests should mirror source structure for easy navigation:

```
tests/
├── unit/                    # Fast, isolated tests
│   ├── test_models.py
│   ├── test_services.py
│   └── test_utils.py
├── integration/             # Tests with external dependencies
│   ├── test_api.py
│   ├── test_database.py
│   └── test_repository.py
├── conftest.py             # Shared fixtures
└── fixtures/               # Test data
    ├── sample_data.json
    └── test_users.csv
```

### Test Fixtures

Use pytest fixtures for reusable test components:

```python
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

@pytest.fixture
def db_session() -> Session:
    """Provide a test database session."""
    engine = create_engine("sqlite:///:memory:")
    Base.metadata.create_all(engine)
    SessionLocal = sessionmaker(bind=engine)
    session = SessionLocal()
    try:
        yield session
    finally:
        session.close()

@pytest.fixture
def user_repository(db_session: Session) -> UserRepository:
    """Provide a user repository with test database."""
    return SQLAlchemyUserRepository(db_session)

@pytest.fixture
def sample_user() -> User:
    """Provide a sample user for testing."""
    return User(
        id=1,
        email="test@example.com",
        name="Test User",
        is_active=True,
    )
```

### Mocking

Use mocks for external dependencies:

```python
from unittest.mock import Mock, patch

def test_user_registration_sends_email(user_repository):
    """Test that user registration triggers email."""
    # Arrange
    email_service = Mock()
    user_service = UserService(user_repository, email_service)
    
    # Act
    user = user_service.register_user(
        email="new@example.com",
        password="password123",
        name="New User"
    )
    
    # Assert
    assert user.email == "new@example.com"
    email_service.send_verification.assert_called_once_with(user)
```

## Best Practices

### Code Organization

1. **Keep modules focused**: Each module should have a single, well-defined purpose
2. **Avoid circular dependencies**: Use dependency injection and protocols
3. **Use relative imports within packages**: `from .models import User`
4. **Keep business logic framework-agnostic**: Separate from FastAPI/Flask/Django code

### Dependency Management

1. **Pin dependencies**: Use `==` for exact versions in production
2. **Use dependency groups**: Separate `dev`, `test`, and `docs` dependencies
3. **Lock dependencies**: Use `requirements.txt` or `poetry.lock`
4. **Regular updates**: Keep dependencies updated for security

### Documentation

1. **README.md**: Project overview, installation, quick start
2. **API documentation**: Auto-generate from docstrings (Sphinx/MkDocs)
3. **Architecture docs**: Explain design decisions and patterns
4. **Inline docstrings**: NumPy-style for all public functions/classes

## References

For detailed guidelines on each aspect, refer to:

- **Coding standards**: `/instructions/my-code.instructions.md`
- **Testing practices**: `/instructions/my-tests.instructions.md`
- **Documentation**: `/instructions/my-docs.instructions.md`
- **CI/CD**: `/instructions/my-ci-cd.instructions.md`
- **Python specifics**: `/instructions/python.instructions.md`

This architecture guide provides a foundation for building maintainable, scalable Python applications following modern best practices and design patterns.