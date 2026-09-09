# Preamble

A LaTeX preamble used by Nathaniel Starkman.

## Overview

This package provides a modular system of LaTeX utilities organized into specialized modules that can be used independently or together. It includes mathematical notation commands, astronomy-specific units and names, and common formatting utilities.

## Structure

The preamble system consists of four main packages:

### Core Packages

1. **preamble-base-starkman.sty**
   - Base commands and formatting utilities shared across all modules
   - `\acronym{TEXT}` – Format acronyms in small caps
   - `\registerpackagename{NAME}{URL}` – Register a package's canonical link
   - `\package{NAME}[URL]` – Render package names with optional hyperlinks; the starred form `\package*{NAME}` uses the registered link
   - `\makepackagealias{cmd}{NAME}{URL}` – Register a name *and* define `\cmd` / `\cmd*` as a shorthand (use sparingly)
   - Dependencies: hyperref, fontawesome

2. **preamble-math-starkman.sty**
   - Mathematical notation and derivative commands
   - Math font shortcuts: `\mcal`, `\mbf`, `\mbs`, `\mrm`
   - Differential notation: `\dif`, `\pdif` (with optional powers via `<n>`)
   - Derivative operators: `\deriv`, `\pderiv` (three forms via `*`, `**`, or default)
   - Probability: `\pdf` – probability distribution function
   - Vector notation: `\vec` – vector formatting using bold symbols
   - Dependencies: amsmath, amssymb

3. **preamble-astronomy-starkman.sty**
   - Astronomy units and dataset names with glossary support
   - Basic units: `\Msun`, `\parsec`, `\year`
   - Derived units: `\mas`, `\kpc`
   - Survey/mission names: `\gaia`, `\euclid`
   - Acronyms: `\gls{LoS}`, `\gls{CoM}`, `\gls{CDM}`, `\gls{LCDM}`
   - Software: a registry of package names → PyPI project URLs (`\package*{galax}`, …), defining no new control sequences
   - Dependencies: preamble-base-starkman, siunitx, glossaries

4. **preamble-starkman.sty** (Main Package)
   - Loads all modules and additional standard packages
   - Includes: graphicx, lipsum, siunitx, xcolor
   - AASTeX-compatible siunitx configuration
   - Dependencies: All above packages

## Usage

### Option 1: Load Everything
```latex
\usepackage{preamble-starkman}
```
This provides all utilities, standard packages, and features.

### Option 2: Load Individual Modules
```latex
\usepackage{preamble-base-starkman}      % Base utilities only
\usepackage{preamble-math-starkman}      % Math commands only
\usepackage{preamble-astronomy-starkman} % Astronomy utilities only
```

## Examples

### Base Commands

```latex
% Acronym formatting
\acronym{NASA}              % NASA in small caps
\acronym{ESA}               % ESA in small caps

% Package references (manual)
\package{siunitx}           % siunitx in typewriter font
\package{siunitx}[https://ctan.org/pkg/siunitx]  % with link icon

% Package references (registered link, written once in the preamble)
\registerpackagename{siunitx}{https://ctan.org/pkg/siunitx}
\package*{siunitx}          % siunitx with link icon, URL taken from the registry
\package*{unregistered}     % no registered link -> just the name, unchanged
\package*{siunitx}[https://example.com]  % an explicit [URL] always wins

% Packages registered by preamble-astronomy-starkman
\package{JAX}               % JAX without link
\package*{JAX}              % JAX with link icon
\package*{NumPy}            % NumPy with link icon
\package*{SciPy}            % SciPy with link icon

% Registering your own in your preamble:
% \registerpackagename{DisplayName}{https://pypi.org/project/name}

% Or, if you really want a dedicated control sequence:
% \makepackagealias{cmdname}{DisplayName}{URL}  % defines \cmdname and \cmdname*
```

#### The package link registry

`\registerpackagename{NAME}{URL}` stores `URL` in a global lookup table keyed on `NAME`, so a package's link is written down exactly once. Resolution order for `\package`:

| Form | Link used |
| --- | --- |
| `\package{NAME}` | none – bare name |
| `\package{NAME}[URL]` | the explicit `URL` |
| `\package*{NAME}` | the URL registered for `NAME` |
| `\package*{NAME}` (unregistered) | none – falls back silently to the bare name |
| `\package*{NAME}[URL]` | the explicit `URL` (overrides the registry) |

`\makepackagealias{cmd}{NAME}{URL}` registers `NAME → URL` *and* defines `\cmd` / `\cmd*` as a shorthand for `\package{NAME}` / `\package*{NAME}`.

Use it sparingly. Every alias is a new control sequence that can collide with another package, the document class, or your own macros — and `\NewDocumentCommand` errors out if the name is already taken. Reserve it for the few packages you name so often that the saved keystrokes are worth the risk, and only for names you're confident are unclaimed. For everything else, register the name and write `\package*{NAME}` — which is why `preamble-astronomy-starkman` defines no aliases at all: it's `\package*{galax}`, not `\galax*`.

URLs are detokenized when stored, so `_` and `~` (common in repository links) round-trip safely. Literal `%` and `#` must still be escaped as `\%` and `\#`, as anywhere else in LaTeX.

The *name*, by contrast, is ordinary text: a `_` in it must be escaped (`\_`) both at registration and at the call site — `\registerpackagename{is\_annotated}{…}` is looked up by `\package*{is\_annotated}`.

### Math Commands

```latex
% Font shortcuts
$\mcal{M}$ produces calligraphic M
$\mbf{v}$ produces bold v
$\mbs{\alpha}$ produces bold symbol alpha
$\mrm{d}$ produces roman d

% Differentials
\dif{x}        % dx
\dif<2>{x}     % d^2 x
\pdif{y}       % ∂y
\pdif<3>{y}    % ∂^3 y

% Derivatives (ordinary)
\deriv{f}           % df/dx
\deriv*{f}          % d/dx(f)
\deriv**{f}         % d_x f
\deriv[y]<2>{f}     % d^2 f/dy^2

% Derivatives (partial)
\pderiv{f}          % ∂f/∂x
\pderiv*{f}         % ∂/∂x(f)
\pderiv**{f}        % ∂_x f
```

### Probability and Tensors

```latex
% Probability
The \pdf{} of X       % The pdf of X (in italics)

% Vector/tensor notation
\vec{v}              % bold vector v
\vec{F}              % bold vector F
```

### Astronomy Commands

```latex
% Units with siunitx
Mass: \SI{1}{\Msun}         % 1 M☉
Distance: \SI{10}{\kpc}     % 10 kpc
Position: \SI{100}{\mas}    % 100 mas

% Survey names
Data from \gaia             % Gaia (italic)
The \euclid{} mission       % Euclid (italic)

% Software packages: registered names, used via \package / \package*
% (the starred form appends an icon linking to the package's PyPI page)

% Scientific computing packages
\package*{JAX}              % JAX with link
\package*{NumPy}            % NumPy with link
\package*{SciPy}            % SciPy with link
\package{SciPy}             % ... or the bare name

% GalacticDynamics packages
\package*{unxt}
\package*{coordinax}
\package*{galax}
\package*{phasecurvefit}
\package*{quaxed}
\package*{quax-blocks}

% nstarman packages
\package*{quax}

% Supporting utility packages
\package*{dataclassish}
\package*{diffraxtra}
\package*{is\_annotated}     % note the escaped underscore
\package*{jaxmore}
\package*{oncequinox}
\package*{zeroth}

Code at \github

% Glossary acronyms
Along the \gls{LoS}         % line-of-sight
The \gls{CoM} of the system % center of mass
\gls{CDM} model             % cold dark matter
The \gls{LCDM} model        % Λ cold dark matter
```

## Tests

```sh
make test     # l3build unit tests + the end-to-end link check
```

Two layers, both run in CI on every push:

- **`l3build` unit tests** (`testfiles/*.lvt`) — the macro behaviour: the full `\package` resolution matrix, registry semantics, escaping rules, aliases, the derivative forms, and a smoke test that loads everything and uses every command.
- **An end-to-end link check** (`tools/check-links.sh`) — compiles a document and diffs every `/URI` in the resulting PDF against `tests/links/expected-uris.txt`, so the links a reader actually clicks are pinned down, hyperref included.

Both are golden-file based: an intended change means running `make goldens` and reviewing the diff. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

See LICENSE file for details.
