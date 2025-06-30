#!/bin/bash

# FCSP API Test Build Script
# This script tests the package build process without publishing

set -e  # Exit on any error

echo "🧪 Testing FCSP API Package Build"
echo "=================================="

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ] || [ ! -f "setup.py" ]; then
    echo "❌ Error: Please run this script from the fcsp-api root directory"
    exit 1
fi

# Check if required tools are installed
echo "🔧 Checking build tools..."
python -c "import build" 2>/dev/null || {
    echo "❌ Error: 'build' package not found. Install with: pip install build"
    exit 1
}

python -c "import twine" 2>/dev/null || {
    echo "❌ Error: 'twine' package not found. Install with: pip install twine"
    exit 1
}

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info/

# Build the package
echo "📦 Building package..."
python -m build

# Check the built package
echo "🔍 Checking built package..."
twine check dist/*

# Test installation
echo "🧪 Testing installation..."
pip install dist/*.whl --force-reinstall

# Test import
echo "🔍 Testing import..."
python -c "from fcsp_api import FCSP; print('✅ Import successful!')"

# Test command line tool
echo "🔍 Testing command line tool..."
fcsp-scanner --help

echo ""
echo "✅ All tests passed!"
echo "📦 Package builds successfully"
echo "🔧 Ready for publication"
echo ""
echo "💡 To publish to PyPI, run: ./build_and_publish.sh" 