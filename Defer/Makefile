build: Defer-Today.png Defer-Tomorrow.png ../OmniFocusScripts-dbyler/Today.applescript ../OmniFocusScripts-dbyler/Tomorrow.applescript
	rm -f Defer-Today.scpt Defer-Tomorrow.scpt
	osacompile -o Defer-Today.scpt ../OmniFocusScripts-dbyler/Today.applescript
	../set-image.py Defer-Today.png Defer-Today.scpt
	osacompile -o Defer-Tomorrow.scpt ../OmniFocusScripts-dbyler/Tomorrow.applescript
	../set-image.py Defer-Tomorrow.png Defer-Tomorrow.scpt


install: build
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Defer-Today.scpt
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Defer-Tomorrow.scpt
	cp Defer-Today.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Defer-Today.scpt
	cp Defer-Tomorrow.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Defer-Tomorrow.scpt
