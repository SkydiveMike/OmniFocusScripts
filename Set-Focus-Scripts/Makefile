build: ./Set-Focus-to-Exclude-Someday-Maybe.applescript ./Set-Focus-to-Blue.applescript ./Set-Focus-to-Exclude-Routines.applescript
	rm -f ./Set-Focus-to-Blue.scpt ./Set-Focus-to-Exclude-Routines.scpt ./Set-Focus-to-Exclude-Someday-Maybe.scpt
	osacompile -o ./Set-Focus-to-Blue.scpt ./Set-Focus-to-Blue.applescript
	osacompile -o ./Set-Focus-to-Exclude-Routines.scpt ./Set-Focus-to-Exclude-Routines.applescript
	osacompile -o ./Set-Focus-to-Exclude-Someday-Maybe.scpt ./Set-Focus-to-Exclude-Someday-Maybe.applescript

install: build
	@echo ""
	@echo "==== Focus Scripts ===="
	@echo "No install for these scripts; Keyboard Maestro calls them directly from this location"
	@echo ""
