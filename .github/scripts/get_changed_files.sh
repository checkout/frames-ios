#!/bin/sh

set -o pipefail
git fetch origin main

git diff HEAD origin/main --name-only --diff-filter=d | xargs echo | tr ' ' ','
