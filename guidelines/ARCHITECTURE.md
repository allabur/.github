# Python Project Architecture Guidelines

## Architecture Philosophy

Python projects should follow these principles:

- **Simplicity over complexity**: Start simple, add complexity only when needed
- **Explicit over implicit**: Be clear about intentions and dependencies
- **Modularity**: Keep components loosely coupled and highly cohesive
- **Testability**: Design for easy testing
- **Scalability**: Structure should support growth

## Project Structure

### Standard Python Package Layout

```
project-name/
├── .github/
│   └── workflows/           # GitHub Actions CI/CD
│       ├── test.yml
│       ├── quality.yml
│       └── release.yml
├── docs/                    # Documentation
│   ├── conf.py             # Sphinx config or
│   ├── mkdocs.yml          # MkDocs config
│   ├── index.md
│   └── api/
├── src/
│   └── package_name/       # Main package
│       ├── __init__.py
│       ├── __main__.py     # Entry point for -m
│       ├── core/           # Core business logic
│       │   ├── __init__.py
│       │   ├── models.py
│       │   └── services.py
│       ├── api/            # API layer (if applicable)
│       │   ├── __init__.py
│       │   ├── routes.py
│       │   └── schemas.py
│       ├── cli/            # CLI interface (if applicable)
│       │   ├── __init__.py
│       │   └── commands.py
│       ├── utils/          # Utility functions
│       │   ├── __init__.py
│       │   └── helpers.py
│       └── config.py       # Configuration management
├── tests/
│   ├── __init__.py
│   ├── conftest.py         # pytest fixtures
│   ├── unit/               # Unit tests
│   │   └── test_models.py
│   ├── integration/        # Integration tests
│   │   └── test_api.py
│   └── fixtures/           # Test data
│       └── sample_data.json
├── .gitignore
├── .pre-commit-config.yaml
├── CHANGELOG.md
├── LICENSE
├── README.md
├── pyproject.toml          # Project metadata and config
└── environment.yml         # Conda env (optional)
```

## Architectural Patterns

### 1. Layered Architecture

Organize code into logical layers:

```
┌─────────────────────────────────┐
│     Presentation Layer          │  CLI, API endpoints, UI
│  (cli/, api/, web/)             │
├─────────────────────────────────┤
│     Application Layer           │  Business logic, use cases
│  (services/, handlers/)         │
├─────────────────────────────────┤
│     Domain Layer                │  Core models, domain logic
│  (models/, entities/)           │
├─────────────────────────────────┤
│     Infrastructure Layer        │  Database, external services
│  (repositories/, clients/)      │
└─────────────────────────────────┘
```

**Example:**

```python
# src/myapp/models/user.py (Domain Layer)
from dataclasses import dataclass

@dataclass
class User:
    """User domain model."""
    id: int
    username: str
    email: str
    
    def is_valid_email(self) -> bool:
        """Check if email format is valid."""
        return "@" in self.email

# src/myapp/repositories/user_repository.py (Infrastructure Layer)
from typing import Protocol

class UserRepository(Protocol):
    """Repository interface for user data."""
    
    def get_by_id(self, user_id: int) -> User | None:
        """Get user by ID."""
        ...
    
    def save(self, user: User) -> None:
        """Save user."""
        ...

# src/myapp/services/user_service.py (Application Layer)
class UserService:
    """Service for user operations."""
    
    def __init__(self, repository: UserRepository) -> None:
        self.repository = repository
    
    def get_user(self, user_id: int) -> User | None:
        """Get user by ID."""
        return self.repository.get_by_id(user_id)
    
    def create_user(self, username: str, email: str) -> User:
        """Create new user."""
        user = User(id=0, username=username, email=email)
        if not user.is_valid_email():
            raise ValueError("Invalid email")
        self.repository.save(user)
        return user

# src/myapp/api/routes.py (Presentation Layer)
from fastapi import APIRouter, Depends

router = APIRouter()

@router.get("/users/{user_id}")
def get_user(user_id: int, service: UserService = Depends()) -> dict:
    """Get user endpoint."""
    user = service.get_user(user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return {"id": user.id, "username": user.username, "email": user.email}
```

### 2. Repository Pattern

Separate data access from business logic:

```python
# models.py
from dataclasses import dataclass

@dataclass
class Article:
    """Article domain model."""
    id: int
    title: str
    content: str

# repositories.py
from abc import ABC, abstractmethod

class ArticleRepository(ABC):
    """Abstract repository for articles."""
    
    @abstractmethod
    def get_by_id(self, article_id: int) -> Article | None:
        """Get article by ID."""
        pass
    
    @abstractmethod
    def get_all(self) -> list[Article]:
        """Get all articles."""
        pass
    
    @abstractmethod
    def save(self, article: Article) -> None:
        """Save article."""
        pass

class SQLArticleRepository(ArticleRepository):
    """SQL implementation of article repository."""
    
    def __init__(self, db_session) -> None:
        self.db = db_session
    
    def get_by_id(self, article_id: int) -> Article | None:
        """Get article by ID from database."""
        row = self.db.query(ArticleModel).filter_by(id=article_id).first()
        return self._to_domain(row) if row else None
    
    def get_all(self) -> list[Article]:
        """Get all articles from database."""
        rows = self.db.query(ArticleModel).all()
        return [self._to_domain(row) for row in rows]
    
    def save(self, article: Article) -> None:
        """Save article to database."""
        model = self._to_model(article)
        self.db.add(model)
        self.db.commit()
    
    def _to_domain(self, model: ArticleModel) -> Article:
        """Convert database model to domain model."""
        return Article(id=model.id, title=model.title, content=model.content)
    
    def _to_model(self, article: Article) -> ArticleModel:
        """Convert domain model to database model."""
        return ArticleModel(id=article.id, title=article.title, content=article.content)
```

### 3. Dependency Injection

Use dependency injection for loose coupling:

```python
# config.py
from dataclasses import dataclass

@dataclass
class Config:
    """Application configuration."""
    database_url: str
    api_key: str
    debug: bool = False

# container.py
from typing import Protocol

class Container:
    """Dependency injection container."""
    
    def __init__(self, config: Config) -> None:
        self.config = config
        self._services: dict[type, object] = {}
    
    def register(self, interface: type, implementation: object) -> None:
        """Register a service."""
        self._services[interface] = implementation
    
    def resolve(self, interface: type) -> object:
        """Resolve a service."""
        if interface not in self._services:
            raise ValueError(f"Service {interface} not registered")
        return self._services[interface]

# main.py
def create_app(config: Config) -> Application:
    """Create application with dependencies."""
    container = Container(config)
    
    # Register dependencies
    db_session = create_database_session(config.database_url)
    container.register(Database, db_session)
    
    article_repo = SQLArticleRepository(db_session)
    container.register(ArticleRepository, article_repo)
    
    article_service = ArticleService(article_repo)
    container.register(ArticleService, article_service)
    
    return Application(container)
```

### 4. Service Layer Pattern

Encapsulate business logic in services:

```python
# services.py
import logging
from typing import Protocol

logger = logging.getLogger(__name__)

class EmailService(Protocol):
    """Protocol for email sending."""
    
    def send(self, to: str, subject: str, body: str) -> None:
        """Send email."""
        ...

class UserService:
    """Service for user-related operations."""
    
    def __init__(
        self,
        user_repo: UserRepository,
        email_service: EmailService,
    ) -> None:
        self.user_repo = user_repo
        self.email_service = email_service
    
    def register_user(self, username: str, email: str, password: str) -> User:
        """Register a new user.
        
        Args:
            username: Desired username.
            email: User's email address.
            password: Plain text password.
            
        Returns:
            Created user instance.
            
        Raises:
            ValueError: If username already exists or email is invalid.
        """
        # Validate
        if self.user_repo.get_by_username(username):
            raise ValueError(f"Username {username} already exists")
        
        # Create user
        hashed_password = hash_password(password)
        user = User(
            id=0,
            username=username,
            email=email,
            password_hash=hashed_password,
        )
        
        # Save
        self.user_repo.save(user)
        logger.info("User registered: %s", username)
        
        # Send welcome email
        self.email_service.send(
            to=email,
            subject="Welcome!",
            body=f"Welcome {username}!",
        )
        
        return user
```

## Design Patterns

### 1. Factory Pattern

```python
from abc import ABC, abstractmethod

class Parser(ABC):
    """Abstract parser."""
    
    @abstractmethod
    def parse(self, content: str) -> dict:
        """Parse content."""
        pass

class JSONParser(Parser):
    """JSON parser."""
    
    def parse(self, content: str) -> dict:
        """Parse JSON content."""
        import json
        return json.loads(content)

class YAMLParser(Parser):
    """YAML parser."""
    
    def parse(self, content: str) -> dict:
        """Parse YAML content."""
        import yaml
        return yaml.safe_load(content)

class ParserFactory:
    """Factory for creating parsers."""
    
    @staticmethod
    def create(format: str) -> Parser:
        """Create parser for given format.
        
        Args:
            format: Format type ('json' or 'yaml').
            
        Returns:
            Appropriate parser instance.
            
        Raises:
            ValueError: If format is not supported.
        """
        match format.lower():
            case "json":
                return JSONParser()
            case "yaml":
                return YAMLParser()
            case _:
                raise ValueError(f"Unsupported format: {format}")
```

### 2. Strategy Pattern

```python
from typing import Protocol

class CompressionStrategy(Protocol):
    """Protocol for compression strategies."""
    
    def compress(self, data: bytes) -> bytes:
        """Compress data."""
        ...
    
    def decompress(self, data: bytes) -> bytes:
        """Decompress data."""
        ...

class GzipCompression:
    """Gzip compression strategy."""
    
    def compress(self, data: bytes) -> bytes:
        import gzip
        return gzip.compress(data)
    
    def decompress(self, data: bytes) -> bytes:
        import gzip
        return gzip.decompress(data)

class ZstdCompression:
    """Zstandard compression strategy."""
    
    def compress(self, data: bytes) -> bytes:
        import zstandard as zstd
        return zstd.compress(data)
    
    def decompress(self, data: bytes) -> bytes:
        import zstandard as zstd
        return zstd.decompress(data)

class FileStorage:
    """File storage with compression."""
    
    def __init__(self, compression: CompressionStrategy) -> None:
        self.compression = compression
    
    def save(self, path: str, data: bytes) -> None:
        """Save data with compression."""
        compressed = self.compression.compress(data)
        Path(path).write_bytes(compressed)
    
    def load(self, path: str) -> bytes:
        """Load and decompress data."""
        compressed = Path(path).read_bytes()
        return self.compression.decompress(compressed)
```

### 3. Observer Pattern

```python
from typing import Protocol

class Observer(Protocol):
    """Observer protocol."""
    
    def update(self, event: str, data: dict) -> None:
        """Handle event."""
        ...

class Subject:
    """Subject that observers can subscribe to."""
    
    def __init__(self) -> None:
        self._observers: list[Observer] = []
    
    def attach(self, observer: Observer) -> None:
        """Attach an observer."""
        self._observers.append(observer)
    
    def detach(self, observer: Observer) -> None:
        """Detach an observer."""
        self._observers.remove(observer)
    
    def notify(self, event: str, data: dict) -> None:
        """Notify all observers."""
        for observer in self._observers:
            observer.update(event, data)

class UserAccount(Subject):
    """User account with event notifications."""
    
    def __init__(self, username: str) -> None:
        super().__init__()
        self.username = username
        self._balance = 0.0
    
    def deposit(self, amount: float) -> None:
        """Deposit money."""
        self._balance += amount
        self.notify("deposit", {"username": self.username, "amount": amount})
    
    def withdraw(self, amount: float) -> None:
        """Withdraw money."""
        if amount > self._balance:
            raise ValueError("Insufficient funds")
        self._balance -= amount
        self.notify("withdraw", {"username": self.username, "amount": amount})

class EmailNotifier:
    """Email notification observer."""
    
    def update(self, event: str, data: dict) -> None:
        """Send email on account events."""
        if event == "deposit":
            send_email(f"Deposit: ${data['amount']}")
        elif event == "withdraw":
            send_email(f"Withdrawal: ${data['amount']}")
```

## Configuration Management

```python
# config.py
from pathlib import Path
from typing import Any
import os
from dataclasses import dataclass, field

@dataclass
class DatabaseConfig:
    """Database configuration."""
    url: str
    pool_size: int = 5
    echo: bool = False

@dataclass
class Config:
    """Application configuration."""
    
    app_name: str
    debug: bool = False
    database: DatabaseConfig = field(default_factory=lambda: DatabaseConfig(url=""))
    
    @classmethod
    def from_env(cls) -> "Config":
        """Load configuration from environment variables."""
        return cls(
            app_name=os.getenv("APP_NAME", "MyApp"),
            debug=os.getenv("DEBUG", "false").lower() == "true",
            database=DatabaseConfig(
                url=os.getenv("DATABASE_URL", "sqlite:///app.db"),
                pool_size=int(os.getenv("DB_POOL_SIZE", "5")),
                echo=os.getenv("DB_ECHO", "false").lower() == "true",
            ),
        )
    
    @classmethod
    def from_file(cls, path: Path) -> "Config":
        """Load configuration from file."""
        import tomllib
        with path.open("rb") as f:
            data = tomllib.load(f)
        return cls(**data)
```

## Error Handling Architecture

```python
# exceptions.py
class AppException(Exception):
    """Base exception for application."""
    pass

class ValidationError(AppException):
    """Validation error."""
    pass

class NotFoundError(AppException):
    """Resource not found."""
    pass

class AuthenticationError(AppException):
    """Authentication failed."""
    pass

class AuthorizationError(AppException):
    """Authorization failed."""
    pass

# error_handler.py
import logging
from typing import Any

logger = logging.getLogger(__name__)

class ErrorHandler:
    """Central error handling."""
    
    def handle(self, error: Exception) -> dict[str, Any]:
        """Handle error and return response."""
        match error:
            case ValidationError():
                logger.warning("Validation error: %s", error)
                return {"error": "validation_error", "message": str(error)}
            case NotFoundError():
                logger.info("Not found: %s", error)
                return {"error": "not_found", "message": str(error)}
            case AuthenticationError():
                logger.warning("Authentication failed: %s", error)
                return {"error": "authentication_error", "message": "Invalid credentials"}
            case _:
                logger.error("Unexpected error: %s", error, exc_info=True)
                return {"error": "internal_error", "message": "An error occurred"}
```

## References

- See `/instructions/my-code.instructions.md` for coding standards
- See `/instructions/python.instructions.md` for Python best practices
- See `/instructions/my-tests.instructions.md` for testing architecture
- See `/instructions/my-review.instructions.md` for code review guidelines
