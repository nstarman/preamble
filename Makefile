# Convenience targets.  Everything here also runs in CI; see
# .github/workflows/ci.yml and CONTRIBUTING.md.
#
# The Docker targets exist because the golden .tlg files record TeX's log
# output, which differs between TeX Live releases: goldens must be generated in
# the same image CI uses, not against whatever TeX you happen to have installed.

TEXLIVE_IMAGE ?= texlive/texlive:latest
DOCKER_RUN = docker run --rm -v "$(CURDIR)":/work -w /work $(TEXLIVE_IMAGE)

.PHONY: check links test goldens check-docker help

help:
	@echo "make test      -- run everything (l3build check + link check)"
	@echo "make check     -- l3build test suite, using your local TeX"
	@echo "make links     -- end-to-end link check, using your local TeX"
	@echo "make goldens   -- regenerate every .tlg in the pinned TeX Live image"
	@echo "make check-docker -- run the test suite in the pinned image, as CI does"

test: check links

check:
	l3build check

links:
	./tools/check-links.sh

# Regenerate the goldens.  Run this whenever a change legitimately alters the
# logged output -- and read the resulting diff before committing it: that diff
# IS the behavioural change under review.
TESTS = $(patsubst testfiles/%.lvt,%,$(wildcard testfiles/*.lvt))

goldens:
	$(DOCKER_RUN) l3build save $(TESTS)
	$(DOCKER_RUN) ./tools/check-links.sh --save

# Reproduce CI exactly, without pushing.
check-docker:
	$(DOCKER_RUN) l3build check
	$(DOCKER_RUN) ./tools/check-links.sh
