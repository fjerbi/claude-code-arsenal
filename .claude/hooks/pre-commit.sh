#!/usr/bin/env bash
set -eu

printf '%s\n' 'Running repo safety checks...'

if git diff --check --quiet; then
  printf '%s\n' 'No whitespace or merge-marker issues.'
else
  printf '%s\n' 'Whitespace or merge markers detected.' >&2
  exit 1
fi

printf '%s\n' 'Safety checks passed.'
