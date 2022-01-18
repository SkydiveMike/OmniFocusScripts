build: Done-Wait.png ../OmniFocusScripts-CurtClifton/Complete\ and\ Await\ Reply.scpt
	rm -f Done-Wait.scpt
	osacompile -o Done-Wait.scpt ../OmniFocusScripts-CurtClifton/Complete\ and\ Await\ Reply.scpt
	../set-image.py Done-Wait.png Done-Wait.scpt

install: build
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Done-Wait.scpt
	ditto --rsrc  --noqtn Done-Wait.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Done-Wait.scpt
