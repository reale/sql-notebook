# Build prerequisites
#
#   1. a sane GNU system
#   2. embedmd (https://github.com/campoy/embedmd)

.PHONY: all clean

SOURCES := $(sort $(wildcard chapters/*.md))
SQL := $(wildcard chapters/sql/*.sql)
PROCESSED := $(SOURCES:chapters/%.md=manuscript/%.md)

all: $(PROCESSED)

manuscript/%.md: chapters/%.md $(SQL)
	embedmd $< | sed '/^<!-- vim:/d' > $@

clean:
	rm -fr manuscript
