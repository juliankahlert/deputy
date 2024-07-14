PREFIX ?= /usr/local

.PHONY: all install

all:
	@echo "Nothing to do"

install: deputy
	install -d $(PREFIX)/bin
	install -m 755 deputy $(PREFIX)/bin
