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
   - `\package{NAME}[URL]` – Render package names with optional hyperlinks
   - `\makepackage{cmd}{NAME}{URL}` – Factory to create starred package commands
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

% Package commands (created with \makepackage)
\jax                        % JAX without link
\jax*                       % JAX with link icon
\numpy                      % NumPy without link
\numpy*                     % NumPy with link icon
\scipy                      % SciPy without link
\scipy*                     % SciPy with link icon

% Creating new package commands in your preamble:
% \makepackage{cmdname}{DisplayName}{https://url.to.repo}
```

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
The \euclid{} mission       % EUCLID (acronym formatting)

% Software packages (starred variants include repository links)
\numpy(*)       % NumPy with optional link

% Scientific computing packages
\jax(*)                     % JAX with optional link
\scipy(*)                   % SciPy with optional link

% GalacticDynamics packages
\unxt(*)                    % unxt with optional link
\coordinax(*)               % coordinax with optional link
\galax(*)                   % galax with optional link
\phasecurvefit(*)           % phasecurvefit with optional link
\quaxed(*)                  % quaxed with optional link
\quaxblocks(*)             % quax-blocks with optional link

% nstarman packages
\quax(*)                    % quax with optional link

Code at \github

% Glossary acronyms
Along the \gls{LoS}         % line-of-sight
The \gls{CoM} of the system % center of mass
\gls{CDM} model             % Cold Dark Matter
The \gls{LCDM} model        % Λ Cold Dark Matter
```

## License

See LICENSE file for details.
