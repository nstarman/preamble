# Contributing

## Running the tests

```sh
make test        # everything: l3build check + the link check
make check       # just the l3build suite
make links       # just the end-to-end link check
```

Both also run in CI on every push and pull request.

## The two test layers

**`l3build` (`testfiles/*.lvt`)** — unit tests for the macros. Each test compiles a small document and its log is compared against a checked-in golden (`*.tlg`). Any difference — a changed URL, a lost fallback, a redefined macro — is a failing diff.

The `\package` renderer typesets, and typeset output does not reach the log. So `testfiles/support/instrument.tex` replaces the renderer's three leaves with log markers:

| what the code does | what the log shows |
| --- | --- |
| `\texttt{JAX}` | `NAME=[JAX]` |
| `\href{URL}{\faCode}` | `LINK=[URL]` |
| registry lookup (`\SHOWLINK`) | `REGISTERED=[URL]` or `MISS=[name]` |

So `\package*{JAX}` logs a `NAME` line and a `LINK` line, while the unregistered fallback logs a `NAME` line and *no* `LINK` line. The goldens read like a specification; see `testfiles/package-render.tlg`.

| test file | what it pins down |
| --- | --- |
| `package-render` | the whole resolution matrix: bare, explicit `[URL]`, starred+registered, starred+unregistered (silent fallback), starred+explicit (explicit wins) |
| `package-registry` | round-trip, overwrite-on-re-register, keys are displayed names, global scope |
| `package-escaping` | `_` and `~` in URLs and in names, hyphenated names |
| `package-alias` | `\makepackagealias` defines `\cmd`/`\cmd*` *and* registers the name |
| `base-acronym` | `\acronym`, including that its size change stays inside its group |
| `math-notation` | argument specifications, and that each `\deriv`/`\pderiv` form builds the structure it advertises (fraction forms contain a fraction; the subscript form does not) |
| `astronomy-units` | units, survey names, glossary acronyms, and that the base module is pulled in |
| `astronomy-registry` | every shipped link, and that the module defines **no** package control sequences |
| `smoke-all` | loads `preamble-starkman` and exercises every public macro: catches missing dependencies and load-order breakage |

**The link check (`tools/check-links.sh`)** — the end-to-end layer. It compiles `tests/links/links.tex`, extracts every `/URI` annotation from the PDF, and diffs the set against `tests/links/expected-uris.txt`. This is the only test that sees what a reader actually clicks, so it also covers hyperref's own handling of the URL. (The document sets `\pdfcompresslevel=0`, so `grep` is the only tool needed — no PDF library anywhere in CI.)

## Changing behaviour: regenerating the fixtures

Both layers are golden-file based, so an intended change means updating the fixtures:

```sh
make goldens     # regenerates every .tlg and expected-uris.txt, in the pinned image
```

Read the resulting diff before committing it — **that diff is the behavioural change under review.** A golden that changes when you did not expect it to is the test suite doing its job.

Adding a package to the registry, for instance, means updating `astronomy-registry.tlg` (new `REGISTERED=` line), adding the name to `tests/links/links.tex`, and updating `expected-uris.txt`.

## A note on TeX Live versions

`.tlg` goldens record TeX's log output, which changes between TeX Live releases. The suite is therefore pinned to **TeX Live 2025**: `texlive/texlive:TL2025-historic` in both `Makefile` and `.github/workflows/ci.yml`, matching the TeX that generated the checked-in goldens. (`-historic` tags are frozen with respect to TeX packages, so CI cannot go red because an upstream image was rebuilt.)

If your local TeX is TL2025, `make check` works directly and `l3build save …` produces goldens CI will accept. Otherwise use `make check-docker` and `make goldens`, which run in the pinned image regardless of what you have installed.

To move to a newer release: bump the image in both files, run `make goldens`, and commit the diff — reading it, as always.

## Adding a test

Add `testfiles/<name>.lvt`, then generate its golden:

```sh
make goldens
```

An `.lvt` file is a small LaTeX document wrapped in `\input{regression-test}` / `\START` / `\END`, with assertions inside `\TEST{description}{...}`. Use `\SHOWLINK{name}` for registry lookups, and `\input{instrument}` (after loading the package) whenever you want to assert on what `\package` renders.

For definitions, mind which inspector you reach for:

- **`\show\cmd`** for macros that take arguments, and for `\NewDocumentCommand` macros (whose argument specification is worth pinning).
- **`\SHOWBODY\cmd`** (from `support/inspect.tex`) for **parameterless** macros.

`\show` prints a macro's prefixes as well as its body, and those are a kernel detail rather than our interface: LaTeX 2025-11 stopped declaring zero-argument `\newcommand` macros as `\long`, so `\show\gaia` prints `\long macro:` on an older kernel and `macro:` on a newer one. That difference broke CI once already. `\SHOWBODY` prints only the replacement text — `BODY=[\textsl {Gaia}]` — which is what the test actually means to assert. Macros that take arguments are still `\long`, so `\show` is stable for them.
