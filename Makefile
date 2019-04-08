build:
	$(MAKE) -C templates build
	$(MAKE) -C Done-Wait build
	$(MAKE) -C Focus-Window build
	$(MAKE) -C Clear-Dates build
	$(MAKE) -C Defer build
	$(MAKE) -C Set-Focus-Scripts build

# We presume each sub-directory install has its own build as a predicate
install:
	$(MAKE) -C templates install
	$(MAKE) -C Done-Wait install
	$(MAKE) -C Focus-Window install
	$(MAKE) -C Clear-Dates install
	$(MAKE) -C Defer install
	$(MAKE) -C Set-Focus-Scripts install
