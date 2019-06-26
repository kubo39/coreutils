.PHONY: all clean

SOURCES = $(wildcard source/*.d)
DC ?= dmd

all: $(patsubst source/%.d,bin/%, $(SOURCES))

bin/arch:
bin/cp:
bin/false:
bin/hostid:
bin/logname:
bin/mkdir:
bin/nproc:
bin/pwd:
bin/sleep:
bin/sync:
bin/tee:
bin/timeout:
bin/true:
bin/uname:
bin/wc:
bin/whoami:

bin/%: source/%.d
	mkdir -p bin
	$(DC) -of=$@ $<

clean:
	$(RM) -fr bin
