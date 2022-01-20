omnifocus.scpt: omnifocus.applescript
	rm -f omnifocus.scpt
	osacompile -o omnifocus.scpt omnifocus.applescript

install: omnifocus.scpt ~/Library/Script\ Libraries
	rm -f ~/Library/Script\ Libraries/omnifocus.scpt
	ditto --rsrc  --noqtn omnifocus.scpt ~/Library/Script\ Libraries

~/Library/Script\ Libraries:
	/bin/mkdir -p ~/Library/Script\ Libraries

build: omnifocus.scpt
