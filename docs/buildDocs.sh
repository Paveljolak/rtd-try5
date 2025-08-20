#!/bin/bash
set -e  # exit on first error
set -o pipefail

DOCS_DIR="docs"
BUILD_DIR="${DOCS_DIR}/_build/html"
STATIC_DIR="${DOCS_DIR}/_static"

# Ensure _static exists (prevents theme warnings)
mkdir -p "$STATIC_DIR"

# Activate your virtualenv if needed
# source venv/bin/activate

# Install dependencies
pip install -U sphinx sphinx-rtd-theme sphinx-multiversion

# Navigate to docs
cd "$DOCS_DIR"

# Clean previous builds
rm -rf _build

# Build all branches/tags using sphinx-multiversion
sphinx-multiversion . "$BUILD_DIR"

echo "Docs built successfully at $BUILD_DIR"
