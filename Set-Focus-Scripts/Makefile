build: ./Set-Focus-to-Blue.applescript ./Set-Focus-to-Exclude-Routines.applescript
	rm -f ./Set-Focus-to-Blue.scpt ./Set-Focus-to-Exclude-Routines.scpt
	osacompile -o ./Set-Focus-to-Blue.scpt ./Set-Focus-to-Blue.applescript
	osacompile -o ./Set-Focus-to-Exclude-Routines.scpt ./Set-Focus-to-Exclude-Routines.applescript

install: build
	@echo "No install for these scripts; Keyboard Maestro calls them directly from this location"
