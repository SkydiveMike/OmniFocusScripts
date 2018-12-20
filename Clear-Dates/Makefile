build: Clear-Dates.png ../OmniFocusScripts-dbyler/Clear\ Dates.applescript
	rm -f Clear-Dates.scpt
	osacompile -o Clear-Dates.scpt ../OmniFocusScripts-dbyler/Clear\ Dates.applescript
	../set-image.py Clear-Dates.png Clear-Dates.scpt

install: build
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Clear-Dates.scpt
	cp Clear-Dates.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Clear-Dates.scpt
