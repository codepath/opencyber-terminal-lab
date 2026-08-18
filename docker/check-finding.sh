#!/bin/sh
# check-finding — self-check for the Terminal + SSH lab, Part 3 threat hunt.
# You give it the NAME of the file you think is malicious; it tells you if you're right.
# The answer is stored only as a hash, so this script does not reveal it.
#
#   Usage:  check-finding <filename>
#   Example: check-finding some-script.sh

ANSWER_HASH="e2dd08057b706ea7291eb6829fa246c93b4e38d1c2bf24ea06d1271301b98189"

if [ -z "$1" ]; then
  echo "Usage: check-finding <filename>"
  echo "  e.g.  check-finding update-something.sh"
  echo "Give just the file's name (a path like ./scripts/x.sh is fine too)."
  exit 2
fi

# Normalize the guess so formatting doesn't trip anyone up: take the base name,
# drop whitespace, lowercase it.
guess=$(basename "$1" | tr -d '[:space:]' | tr '[:upper:]' '[:lower:]')
guess_hash=$(printf '%s' "$guess" | sha256sum | cut -d' ' -f1)

if [ "$guess_hash" = "$ANSWER_HASH" ]; then
  echo "CORRECT - '$1' is the malicious file. Now make sure findings.txt also"
  echo "names the address it talks to (the one that shows up in the logs), then remove it."
else
  echo "NOT THIS ONE - '$1' isn't it. Re-read the scripts: which one does something"
  echo "a real helper never would? Tip: check what address each script contacts, then"
  echo "grep the box for that address - the malicious one also appears in the logs."
fi
