.SUFFIXES: .scpt .applescript
.applescript.scpt:
	osacompile -o $@ $^

gotolink.scpt: gotolink.applescript gotolink.png
	osacompile -o $@ gotolink.applescript
	../set-image.py $(*F).png $@

install: gotolink.scpt
		rm -f ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/gotolink.scpt
		cp gotolink.scpt ~/Library/Application\ Scripts/com.omnigroup.OmniFocus3/
