build:
	$(MAKE) -C templates build
	$(MAKE) -C Done-Wait build

# We presume each sub-directory install has its own build as a predicate
install:
	$(MAKE) -C templates install
	$(MAKE) -C Done-Wait install
