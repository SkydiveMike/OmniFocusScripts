build:
	$(MAKE) -C templates build

install: build
	$(MAKE) -C templates install
