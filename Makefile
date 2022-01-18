build:
	$(MAKE) -C "OmniFocusScripts-BrandonPittman/OmniFocus Library" build
	$(MAKE) -C Clear-Dates build
	$(MAKE) -C Defer build
	$(MAKE) -C Done-Wait build
	$(MAKE) -C Engage build
	$(MAKE) -C Focus-Window build
	$(MAKE) -C GoToLink install
	$(MAKE) -C Set-Focus-Scripts build
	$(MAKE) -C templates build

# We presume each sub-directory install has its own build as a predicate
install:
	$(MAKE) -C "OmniFocusScripts-BrandonPittman/OmniFocus Library" install
	$(MAKE) -C Clear-Dates install
	$(MAKE) -C Defer install
	$(MAKE) -C Done-Wait install
	$(MAKE) -C Engage install
	$(MAKE) -C Focus-Window install
	$(MAKE) -C GoToLink install
	$(MAKE) -C Set-Focus-Scripts install
	$(MAKE) -C templates install
