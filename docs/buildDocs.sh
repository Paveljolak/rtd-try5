#!/bin/bash
set -ex
################################################################################
# File:    buildDocs.sh
# Purpose: Build multi-version docs using sphinx-multiversion and deploy to gh-pages
################################################################################

pwd
ls -lah
export SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)

##################
# INSTALL DEPS #
##################
pip install -r required_packages.txt
# pip install -r required_packages_versions.txt  # optional for exact versions

##################
# BUILD DOCS #
##################
# remove old build folder
rm -rf docs/_build/html

# build all versions
sphinx-multiversion docs docs/_build/html \
    -D smv_latest_version=main \
    -D smv_whitelist_branches="main|humble|jazzy|test"

###############################
# DEPLOY TO GH-PAGES #
###############################
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"

# create temporary dir for deployment
docroot=$(mktemp -d)
rsync -av "docs/_build/html/" "${docroot}/"

pushd "${docroot}"

git init
git remote add deploy "https://token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

# check if gh-pages exists remotely
if git ls-remote --exit-code --heads deploy gh-pages; then
    git fetch deploy gh-pages
    git checkout gh-pages
else
    git checkout -b gh-pages
fi

# prevent Jekyll 404 errors for folders starting with _
touch .nojekyll

cat > README.md <<EOF
# GitHub Pages Cache

Multi-version documentation built with sphinx-multiversion.

EOF

git add .

msg="Updating multi-version docs for commit ${GITHUB_SHA} made on $(date -d "@${SOURCE_DATE_EPOCH}" --iso-8601=seconds) from ${GITHUB_REF} by ${GITHUB_ACTOR}"
git commit -am "${msg}"

# push to gh-pages branch
git push deploy gh-pages --force-with-lease

popd
exit 0
