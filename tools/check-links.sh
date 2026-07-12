#!/usr/bin/env bash
#
# End-to-end link check.
#
# Compiles tests/links/links.tex against the working tree, extracts every /URI
# annotation from the PDF, and diffs the sorted result against the checked-in
# list in tests/links/expected-uris.txt.
#
# This is the one test that looks at the artifact a reader actually gets: it
# catches anything hyperref might do to a URL on its way into the PDF, which
# the log-level l3build tests cannot see.
#
# The document sets \pdfcompresslevel=0, so the URIs are plain text in the PDF
# and grep is the only tool required.
#
# Usage:  tools/check-links.sh            # check
#         tools/check-links.sh --save     # regenerate expected-uris.txt
#
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
expected="$root/tests/links/expected-uris.txt"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# Find the .sty files in the working tree, not an installed copy.
export TEXINPUTS="$root:"

echo "==> compiling tests/links/links.tex"
for _ in 1 2; do  # twice: glossaries and hyperref both want a second pass
  pdflatex -interaction=nonstopmode -halt-on-error \
           -output-directory="$work" "$root/tests/links/links.tex" \
    >"$work/pdflatex.out" 2>&1 \
    || { echo "!! compilation failed"; cat "$work/pdflatex.out"; exit 1; }
done

# Every URI in the PDF, deduplicated and sorted: we assert on the *set* of
# links, so reordering the document does not churn the fixture.  hyperref writes
# the annotation as `/A<</S/URI/URI(https://...)>>'.
grep -ao '/URI *([^)]*)' "$work/links.pdf" \
  | sed -e 's|^/URI *(||' -e 's|)$||' \
  | sort -u > "$work/actual-uris.txt"

if [[ ! -s "$work/actual-uris.txt" ]]; then
  echo "!! no URIs found in the PDF at all -- did hyperref fail to load,"
  echo "!! or is the PDF compressed (see \\pdfcompresslevel in links.tex)?"
  exit 1
fi

if [[ "${1:-}" == "--save" ]]; then
  cp "$work/actual-uris.txt" "$expected"
  echo "==> wrote $(wc -l < "$expected") URIs to tests/links/expected-uris.txt"
  exit 0
fi

echo "==> comparing against tests/links/expected-uris.txt"
if diff -u "$expected" "$work/actual-uris.txt"; then
  echo "==> OK: $(wc -l < "$expected" | tr -d ' ') links, all as expected"
else
  echo
  echo "!! the links in the PDF do not match tests/links/expected-uris.txt"
  echo "!! (lines starting '-' are missing from the PDF, '+' are unexpected)"
  echo "!! if the change is intended: tools/check-links.sh --save"
  exit 1
fi
