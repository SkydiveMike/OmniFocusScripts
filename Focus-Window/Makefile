build: Focus-Window.png ../OmniFocusScripts-dbyler/Focus\ in\ New\ Window.applescript
	rm -f Focus-Window.scpt
	osacompile -o Focus-Window.scpt ../OmniFocusScripts-dbyler/Focus\ in\ New\ Window.applescript
	../set-image.py Focus-Window.png Focus-Window.scpt

install: build
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Focus-Window.scpt
	cp Focus-Window.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Focus-Window.scpt
