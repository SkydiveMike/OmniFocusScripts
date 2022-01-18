build: Play.png ../Kourosh-Dini-Flow/Engage.applescript
	rm -f Engage.scpt
	osacompile -o Engage.scpt ../Kourosh-Dini-Flow/Engage.applescript
	../set-image.py Play.png Engage.scpt

install: build
	rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Engage.scpt
	ditto --rsrc  --noqtn Engage.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/Engage.scpt


Play.png: ../omnifocus-perspective-icons/v3/play/icon-rounded-fuchsia@2x.png
	ditto --rsrc  --noqtn ../omnifocus-perspective-icons/v3/play/icon-rounded-fuchsia@2x.png Play.png
