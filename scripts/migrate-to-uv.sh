#!/usr/bin/env bash
# migrate-to-uv.sh - Migrate Python project from conda/mamba/pip to uv
#
# This script automates the migration process from conda/mamba/pip to uv.
# It handles environment.yml, requirements.txt, and Poetry projects.
#
# Usage:
#   ./migrate-to-uv.sh [options]
#
# Options:
#   --dry-run       Show what would be done without making changes
#   --keep-old      Keep old config files (rename with .old extension)
#   --python VER    Specify Python version (default: 3.12)
#   --help          Show this help message
#
# Prerequisites:
#   - uv must be installed (or use --install-uv flag)
#   - Git repository recommended (for easy rollback)
#
# Example:
#   ./migrate-to-uv.sh --python 3.13 --keep-old

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
DRY_RUN=false
KEEP_OLD=false
PYTHON_VERSION="3.13"
INSTALL_UV=false

# Function to print colored messages
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1" >&2
}

# Function to show usage
show_help() {
    sed -n '/^# migrate-to-uv.sh/,/^$/p' "$0" | sed 's/^# //; s/^#//'
    exit 0
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --keep-old)
            KEEP_OLD=true
            shift
            ;;
        --python)
            PYTHON_VERSION="$2"
            shift 2
            ;;
        --install-uv)
            INSTALL_UV=true
            shift
            ;;
        --help)
            show_help
            ;;
        *)
            error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Banner
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         Python Project Migration to uv                    ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check if in git repository
if git rev-parse --git-dir > /dev/null 2>&1; then
    info "Git repository detected. Good! You can easily rollback if needed."
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        warning "You have uncommitted changes. Consider committing them first."
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
else
    warning "Not a git repository. Consider initializing git for easy rollback."
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    if [[ "$INSTALL_UV" == true ]] || [[ "$DRY_RUN" == true ]]; then
        info "uv not found. Will install it..."
        if [[ "$DRY_RUN" == false ]]; then
            curl -LsSf https://astral.sh/uv/install.sh | sh
            success "uv installed"
            # Add to PATH for current session
            export PATH="$HOME/.cargo/bin:$PATH"
        fi
    else
        error "uv is not installed. Install it with:"
        echo "  curl -LsSf https://astral.sh/uv/install.sh | sh"
        echo ""
        echo "Or run with --install-uv flag"
        exit 1
    fi
else
    success "uv is installed: $(uv --version)"
fi

# Detect project type
info "Detecting project configuration..."

HAS_ENVIRONMENT_YML=false
HAS_REQUIREMENTS_TXT=false
HAS_REQUIREMENTS_DEV=false
HAS_POETRY=false
HAS_PYPROJECT=false

if [[ -f "environment.yml" ]] || [[ -f "environment.yaml" ]]; then
    HAS_ENVIRONMENT_YML=true
    ENV_FILE="environment.yml"
    [[ -f "environment.yaml" ]] && ENV_FILE="environment.yaml"
    info "Found: $ENV_FILE (conda/mamba)"
fi

if [[ -f "requirements.txt" ]]; then
    HAS_REQUIREMENTS_TXT=true
    info "Found: requirements.txt"
fi

if [[ -f "requirements-dev.txt" ]] || [[ -f "dev-requirements.txt" ]]; then
    HAS_REQUIREMENTS_DEV=true
    DEV_FILE="requirements-dev.txt"
    [[ -f "dev-requirements.txt" ]] && DEV_FILE="dev-requirements.txt"
    info "Found: $DEV_FILE"
fi

if [[ -f "pyproject.toml" ]]; then
    HAS_PYPROJECT=true
    if grep -q "tool.poetry" pyproject.toml; then
        HAS_POETRY=true
        info "Found: pyproject.toml (Poetry)"
    else
        info "Found: pyproject.toml (existing)"
    fi
fi

# Exit if nothing to migrate
if [[ "$HAS_ENVIRONMENT_YML" == false ]] && \
   [[ "$HAS_REQUIREMENTS_TXT" == false ]] && \
   [[ "$HAS_POETRY" == false ]]; then
    error "No configuration files found to migrate."
    echo "Looking for: environment.yml, requirements.txt, or Poetry pyproject.toml"
    exit 1
fi

echo ""
info "Migration plan:"
echo "  - Python version: $PYTHON_VERSION"
echo "  - Dry run: $DRY_RUN"
echo "  - Keep old files: $KEEP_OLD"
echo ""

if [[ "$DRY_RUN" == false ]]; then
    read -p "Proceed with migration? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Migration cancelled."
        exit 0
    fi
fi

# Create backup function
backup_file() {
    local file=$1
    if [[ "$KEEP_OLD" == true ]] && [[ -f "$file" ]]; then
        if [[ "$DRY_RUN" == false ]]; then
            cp "$file" "$file.old"
            success "Backed up: $file → $file.old"
        else
            info "[DRY RUN] Would backup: $file → $file.old"
        fi
    fi
}

# Initialize or update pyproject.toml
init_pyproject() {
    if [[ "$HAS_PYPROJECT" == false ]]; then
        info "Creating pyproject.toml..."
        
        if [[ "$DRY_RUN" == false ]]; then
            # Get project name from directory
            PROJECT_NAME=$(basename "$PWD")
            
            cat > pyproject.toml <<EOF
[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "Add description here"
requires-python = ">=$PYTHON_VERSION"
dependencies = []

[project.optional-dependencies]
dev = []

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 88
target-version = "py${PYTHON_VERSION//./}"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=src --cov-report=term-missing"

[tool.mypy]
python_version = "$PYTHON_VERSION"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
EOF
            success "Created pyproject.toml"
        else
            info "[DRY RUN] Would create pyproject.toml"
        fi
    else
        info "pyproject.toml already exists"
    fi
}

# Migrate from environment.yml
migrate_from_conda() {
    info "Migrating from $ENV_FILE..."
    
    backup_file "$ENV_FILE"
    
    # Extract Python version
    PYTHON_VER=$(grep -E "^\s*-?\s*python\s*[=>]" "$ENV_FILE" | sed -E 's/.*python\s*[=>]?\s*([0-9.]+).*/\1/' | head -1)
    if [[ -n "$PYTHON_VER" ]]; then
        PYTHON_VERSION="$PYTHON_VER"
        info "Detected Python version: $PYTHON_VERSION"
    fi
    
    # Extract dependencies
    info "Extracting conda dependencies..."
    
    # This is a simplified parser - may need manual adjustment
    DEPS=$(grep -E "^\s*-\s+[a-zA-Z]" "$ENV_FILE" | grep -v "^\s*-\s*pip:" | sed 's/^\s*-\s*//' | grep -v "^python")
    
    if [[ -n "$DEPS" ]]; then
        info "Found conda packages:"
        echo "$DEPS" | while read -r dep; do
            echo "    - $dep"
        done
        
        if [[ "$DRY_RUN" == false ]]; then
            echo "$DEPS" | while read -r dep; do
                # Convert conda package names to PyPI names (basic conversion)
                pkg=$(echo "$dep" | sed 's/==/>=/')
                uv add "$pkg" 2>/dev/null || warning "Could not add: $pkg (may need manual adjustment)"
            done
        fi
    fi
    
    # Extract pip dependencies
    if grep -q "pip:" "$ENV_FILE"; then
        info "Extracting pip dependencies from environment.yml..."
        PIP_DEPS=$(sed -n '/pip:/,/^[^ ]/p' "$ENV_FILE" | grep '^\s*-' | sed 's/^\s*-\s*//')
        
        if [[ -n "$PIP_DEPS" ]]; then
            echo "$PIP_DEPS" | while read -r dep; do
                echo "    - $dep"
            done
            
            if [[ "$DRY_RUN" == false ]]; then
                echo "$PIP_DEPS" | while read -r dep; do
                    uv add "$dep" || warning "Could not add: $dep"
                done
            fi
        fi
    fi
    
    if [[ "$KEEP_OLD" == false ]] && [[ "$DRY_RUN" == false ]]; then
        rm "$ENV_FILE"
        success "Removed $ENV_FILE"
    fi
}

# Migrate from requirements.txt
migrate_from_requirements() {
    info "Migrating from requirements.txt..."
    
    backup_file "requirements.txt"
    
    if [[ "$DRY_RUN" == false ]]; then
        while IFS= read -r line; do
            # Skip empty lines and comments
            [[ -z "$line" ]] || [[ "$line" =~ ^# ]] && continue
            
            uv add "$line" || warning "Could not add: $line"
        done < requirements.txt
        
        success "Migrated requirements.txt"
        
        if [[ "$KEEP_OLD" == false ]]; then
            rm requirements.txt
            success "Removed requirements.txt"
        fi
    else
        info "[DRY RUN] Would migrate requirements.txt"
    fi
    
    # Migrate dev requirements
    if [[ "$HAS_REQUIREMENTS_DEV" == true ]]; then
        info "Migrating from $DEV_FILE..."
        backup_file "$DEV_FILE"
        
        if [[ "$DRY_RUN" == false ]]; then
            while IFS= read -r line; do
                [[ -z "$line" ]] || [[ "$line" =~ ^# ]] && continue
                uv add --dev "$line" || warning "Could not add dev dependency: $line"
            done < "$DEV_FILE"
            
            success "Migrated $DEV_FILE"
            
            if [[ "$KEEP_OLD" == false ]]; then
                rm "$DEV_FILE"
                success "Removed $DEV_FILE"
            fi
        else
            info "[DRY RUN] Would migrate $DEV_FILE"
        fi
    fi
}

# Migrate from Poetry
migrate_from_poetry() {
    info "Migrating from Poetry..."
    
    warning "Poetry migration requires manual conversion of pyproject.toml"
    warning "This script will help, but you may need to adjust the result"
    
    backup_file "pyproject.toml"
    backup_file "poetry.lock"
    
    if [[ "$DRY_RUN" == false ]]; then
        # Create a backup and convert Poetry format to PEP 621
        info "Converting Poetry pyproject.toml to PEP 621 format..."
        info "You'll need to manually update [tool.poetry] to [project]"
        warning "Run 'uv sync' after manually adjusting pyproject.toml"
        
        if [[ -f "poetry.lock" ]] && [[ "$KEEP_OLD" == false ]]; then
            rm poetry.lock
            success "Removed poetry.lock"
        fi
    else
        info "[DRY RUN] Would convert Poetry pyproject.toml"
    fi
}

# Main migration logic
echo ""
info "Starting migration..."

# Initialize pyproject.toml if needed
if [[ "$HAS_PYPROJECT" == false ]]; then
    init_pyproject
fi

# Install Python version
if [[ "$DRY_RUN" == false ]]; then
    info "Installing Python $PYTHON_VERSION..."
    uv python install "$PYTHON_VERSION" || warning "Could not install Python $PYTHON_VERSION"
    uv python pin "$PYTHON_VERSION"
    success "Python version pinned to $PYTHON_VERSION"
else
    info "[DRY RUN] Would install and pin Python $PYTHON_VERSION"
fi

# Migrate based on detected files
if [[ "$HAS_ENVIRONMENT_YML" == true ]]; then
    migrate_from_conda
fi

if [[ "$HAS_REQUIREMENTS_TXT" == true ]]; then
    migrate_from_requirements
fi

if [[ "$HAS_POETRY" == true ]]; then
    migrate_from_poetry
fi

# Sync environment
echo ""
if [[ "$DRY_RUN" == false ]]; then
    info "Syncing uv environment..."
    uv sync
    success "Environment synced"
else
    info "[DRY RUN] Would run: uv sync"
fi

# Update .gitignore
echo ""
info "Updating .gitignore..."

if [[ ! -f ".gitignore" ]]; then
    if [[ "$DRY_RUN" == false ]]; then
        cat > .gitignore <<EOF
# Virtual environment
.venv/
venv/
env/

# Python
__pycache__/
*.py[cod]
*$py.class
*.so

# Testing
.pytest_cache/
.coverage
htmlcov/

# IDE
.vscode/
.idea/
*.swp

# OS
.DS_Store
EOF
        success "Created .gitignore"
    fi
else
    if ! grep -q "\.venv/" .gitignore; then
        if [[ "$DRY_RUN" == false ]]; then
            echo -e "\n# uv virtual environment\n.venv/" >> .gitignore
            success "Updated .gitignore"
        else
            info "[DRY RUN] Would update .gitignore"
        fi
    else
        success ".gitignore already configured"
    fi
fi

# Remove old virtual environments
echo ""
if [[ -d "venv" ]] || [[ -d "env" ]] || [[ -d ".conda" ]]; then
    warning "Found old virtual environments"
    info "Consider removing old environments:"
    [[ -d "venv" ]] && echo "  rm -rf venv/"
    [[ -d "env" ]] && echo "  rm -rf env/"
    [[ -d ".conda" ]] && echo "  rm -rf .conda/"
fi

# Summary
echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                   Migration Complete!                     ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

if [[ "$DRY_RUN" == true ]]; then
    warning "This was a DRY RUN. No changes were made."
    echo "Run without --dry-run to perform the migration."
else
    success "Your project has been migrated to uv!"
    echo ""
    info "Next steps:"
    echo "  1. Review pyproject.toml and adjust as needed"
    echo "  2. Test your environment: uv run python -c 'import sys; print(sys.version)'"
    echo "  3. Run your tests: uv run pytest"
    echo "  4. Commit changes: git add . && git commit -m 'chore: migrate to uv'"
    echo ""
    info "Useful commands:"
    echo "  uv add <package>        # Add dependency"
    echo "  uv add --dev <package>  # Add dev dependency"
    echo "  uv sync                 # Sync environment"
    echo "  uv run <command>        # Run command in environment"
    echo "  uv lock --upgrade       # Update all dependencies"
    echo ""
    
    if [[ "$KEEP_OLD" == true ]]; then
        info "Old configuration files were kept with .old extension"
        info "Remove them once you've verified the migration:"
        [[ -f "environment.yml.old" ]] && echo "  rm environment.yml.old"
        [[ -f "requirements.txt.old" ]] && echo "  rm requirements.txt.old"
        [[ -f "requirements-dev.txt.old" ]] && echo "  rm requirements-dev.txt.old"
        [[ -f "poetry.lock.old" ]] && echo "  rm poetry.lock.old"
    fi
fi

echo ""
