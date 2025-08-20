#!/bin/bash
set -e  # Exit on any error
set -o pipefail

# Ensure Python environment has sphinx and sphinx-multiversion
pip install --upgrade sphinx sphinx-multiversion

DOCS_SRC="docs"
BUILD_DIR="docs/_build"
STATIC_DIR="${DOCS_SRC}/_static"

# Ensure _static exists
mkdir -p "$STATIC_DIR"

# Clean previous builds
rm -rf "$BUILD_DIR"

# Build docs with sphinx-multiversion
sphinx-multiversion "$DOCS_SRC" "$BUILD_DIR/html" \
  --latest-version main \
  --whitelist-branches main humble jazzy test \
  --ignore ".*"

# Deploy to GitHub Pages
# Configure Git if needed
git config --global user.email "docs-bot@example.com"
git config --global user.name "Docs Bot"

# Use temporary directory for deployment
DEPLOY_DIR=$(mktemp -d)
git clone --branch gh-pages "https://github.com/<YOUR_USER>/<YOUR_REPO>.git" "$DEPLOY_DIR"
rm -rf "$DEPLOY_DIR"/*
cp -r "$BUILD_DIR/html"/* "$DEPLOY_DIR"/

cd "$DEPLOY_DIR"
git add --all
git commit -m "Update docs [ci skip]" || true  # Avoid error if no changes
git push origin gh-pages --force
