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
   - Dependencies: None (base package)

2. **preamble-math-starkman.sty**
   - Mathematical notation and derivative commands
   - Math font shortcuts: `\mcal`, `\mbf`, `\mbs`, `\mrm`
   - Differential notation: `\dif`, `\pdif` (with optional powers via `<n>`)
   - Derivative operators: `\deriv`, `\pderiv` (three forms via `*`, `**`, or default)
   - Dependencies: amsmath, amssymb

3. **preamble-astronomy-starkman.sty**
   - Astronomy units and dataset names
   - Basic units: `\Msun`, `\parsec`, `\year`
   - Derived units: `\mas`, `\kpc`
   - Survey/mission names: `\gaia`, `\euclid`
   - Dependencies: preamble-base-starkman, siunitx

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

### Astronomy Commands

```latex
% Units with siunitx
Mass: \SI{1}{\Msun}         % 1 M☉
Distance: \SI{10}{\kpc}     % 10 kpc
Position: \SI{100}{\mas}    % 100 mas

% Survey names
Data from \gaia             % Gaia (italic)
The \euclid{} mission       % EUCLID (acronym formatting)

% Base utilities
\acronym{HST}               % HST formatted as acronym
```

## License

See LICENSE file for details.
