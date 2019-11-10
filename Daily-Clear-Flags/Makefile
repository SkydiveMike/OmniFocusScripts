build: Daily-Clear-Flags.applescript ~/Library/Script\ Libraries/omnifocus.scpt
	rm -f Daily-Clear-Flags.scpt
	osacompile -o Daily-Clear-Flags.scpt Daily-Clear-Flags.applescript

~/Library/Script\\ Libraries/omnifocus.scpt: ../OmniFocusScripts-BrandonPittman/OmniFocus\ Library/omnifocus.applescript
	cd ../OmniFocusScripts-BrandonPittman/OmniFocus\ Library && make install
