#!/bin/bash
# Development environment setup script for DES4Py
# Automatically detects and uses the best available package manager

set -e

echo "🚀 Setting up DES4Py development environment..."
echo "📍 Project: $(basename $(pwd))"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to activate conda environment
activate_conda_env() {
    local env_name="des4py-dev"
    echo "To activate the environment, run:"
    echo "  $1 activate $env_name"
    echo ""
    echo "Then verify installation with:"
    echo "  python -c 'import des4py; print(\"✅ DES4Py installed successfully!\")'"
}

# Check for uv (fastest option)
if command_exists uv; then
    echo "⚡ Using uv for ultra-fast package management..."

    # Create virtual environment with Python 3.13
    echo "📦 Creating virtual environment..."
    uv venv --python 3.13

    # Activate environment
    echo "🔧 Activating environment..."
    source .venv/bin/activate

    # Install development dependencies
    echo "📚 Installing development dependencies..."
    uv pip install -e ".[dev,docs,process-mining]"

    # Setup pre-commit hooks
    if command_exists pre-commit; then
        echo "🔧 Setting up pre-commit hooks..."
        pre-commit install
    fi

    echo "✅ Environment setup complete with uv!"
    echo "Environment activated. Ready for development!"

# Check for mamba (best for scientific computing)
elif command_exists mamba; then
    echo "🐍 Using mamba for environment management..."

    # Create environment from YAML
    echo "📦 Creating conda environment..."
    mamba env create -f environment.yml --force

    echo "✅ Environment created successfully!"
    activate_conda_env "mamba"

# Check for conda (fallback)
elif command_exists conda; then
    echo "🐍 Using conda for environment management..."

    # Create environment from YAML
    echo "📦 Creating conda environment..."
    conda env create -f environment.yml --force

    echo "✅ Environment created successfully!"
    activate_conda_env "conda"

# Fallback to pip with venv
else
    echo "📦 Using pip with virtual environment..."

    # Create virtual environment
    echo "📦 Creating virtual environment..."
    python -m venv .venv

    # Activate environment
    echo "🔧 Activating environment..."
    source .venv/bin/activate

    # Upgrade pip and install dependencies
    echo "📚 Installing dependencies..."
    pip install --upgrade pip
    pip install -e ".[dev,docs,process-mining]"

    # Setup pre-commit hooks
    if command_exists pre-commit; then
        echo "🔧 Setting up pre-commit hooks..."
        pre-commit install
    fi

    echo "✅ Environment setup complete with pip!"
    echo "Environment activated. Ready for development!"
fi

# Verify installation
echo ""
echo "🧪 Verifying installation..."
python -c "import sys; print(f'Python version: {sys.version}')"

# Run a quick test if pytest is available
if python -c "import pytest" 2>/dev/null; then
    echo "🧪 Running quick test..."
    python -m pytest tests/ -x -q || echo "⚠️  Some tests failed, but setup is complete"
fi

echo ""
echo "🎉 DES4Py development environment is ready!"
echo ""
echo "Next steps:"
echo "  📖 Read the documentation in docs/"
echo "  🧪 Run tests: pytest"
echo "  🔍 Check code quality: ruff check ."
echo "  📝 Format code: ruff format ."
echo "  🎯 Type check: mypy src/"
echo ""
echo "Happy coding! 🚀"
