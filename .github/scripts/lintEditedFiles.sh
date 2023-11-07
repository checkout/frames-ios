#!/bin/sh

set -o pipefail
git fetch origin main
echo "Fetched"

# Use a conditional to check if there are edited files
if EDITED_FILES=$(git diff HEAD origin/main --name-only --diff-filter=d | grep "\.swift" | grep -v "\.swiftlint\.yml" | xargs echo | tr ' ' ','); then
  echo "Got edited files"
  echo $EDITED_FILES

  # Check if EDITED_FILES is empty or null
  if [ -z "$EDITED_FILES" ]; then
    echo "No edited .swift files found."
  else
    swiftlint lint $EDITED_FILES | sed -E -n 's/^(.*):([0-9]+):([0-9]+): error: (.*)/::error file=\1,line=\2,col=\3::\4\n\1:\2:\3/p'
  fi
else
  echo "No changes in .swift files found."
fi
