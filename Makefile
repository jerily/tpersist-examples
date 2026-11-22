PREFIX ?= /usr/local
TCLSH ?= tclsh
pkgdir = $(DESTDIR)$(PREFIX)/lib/tpersist-examples0.1.8

.PHONY: install check
install:
	install -d "$(pkgdir)/sql"
	install -m 644 pkgIndex.tcl examples.tcl 0*.tcl README.md LICENSE "$(pkgdir)"
	install -m 644 sql/*.json "$(pkgdir)/sql"

check:
	@set -e; for example in 0*.tcl; do "$(TCLSH)" "$$example"; done
