#!/bin/bash

# FCSP API Build and Publish Script
# This script builds and publishes the package to PyPI

set -e  # Exit on any error

echo "🚗 Building and Publishing FCSP API to PyPI"
echo "=============================================="

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

# Ask for confirmation before uploading
echo ""
echo "📤 Ready to upload to PyPI!"
echo "Files to upload:"
ls -la dist/
echo ""
read -p "🤔 Upload to PyPI? (y/n): " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Uploading to PyPI..."
    twine upload dist/*
    echo "✅ Upload complete!"
    echo ""
    echo "🎉 Your package is now available on PyPI!"
    echo "📦 Install with: pip install fcsp-api"
    echo "🔗 View at: https://pypi.org/project/fcsp-api/"
else
    echo "❌ Upload cancelled"
    echo "💡 To upload later, run: twine upload dist/*"
fi 