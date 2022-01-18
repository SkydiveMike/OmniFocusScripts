build: GoLinkIcon.png GotoLink.applescript
	rm -f GotoLink.scpt
	osacompile -o GotoLink.scpt GotoLink.applescript
	../set-image.py GoLinkIcon.png GotoLink.scpt

install: build
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/GotoLink.scpt
	ditto --rsrc  --noqtn GotoLink.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/
