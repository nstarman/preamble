--[[
  l3build configuration for the Starkman preamble packages.

  Common invocations:
    l3build check              -- run the whole test suite
    l3build check <name>       -- run one test, e.g. `l3build check package-render'
    l3build save <name>        -- regenerate the golden .tlg for one test
    l3build save -a            -- regenerate every golden

  The golden .tlg files record the (normalized) log of each test run and are
  therefore tied to a particular TeX Live release.  Always regenerate them in
  the same image CI uses -- `make goldens' does exactly that.  See CONTRIBUTING.
--]]

module = "preamble-starkman"

-- The style files under test.  l3build copies these into the test directory,
-- so the tests always exercise the working tree, never an installed version.
sourcefiles = {"*.sty"}
installfiles = {"*.sty"}

-- Tests.
testfiledir = "testfiles"
supportdir = "testfiles/support"

-- One engine is enough: these packages are plain LaTeX2e + expl3, with no
-- engine-specific code, and the goldens are engine-dependent.
checkengines = {"pdftex"}
stdengine = "pdftex"
checkformat = "latex"

-- Keep long log lines (URLs, macro dumps) from being wrapped, which would
-- otherwise make the goldens depend on the terminal width.
maxprintline = 9999

-- Nothing to typeset or upload: this is a private package, not a CTAN release.
typesetfiles = {}
