use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
use O : script "omnifocus"

on handle_string(argv)
	main(argv)
end handle_string

on run
	set sel to selectedItems() of O
	tell application "OmniFocus"
		tell default document
			set LandS to findProject("Engaged (Max 3/Day)") of O
			
			repeat with _sel in sel
				if class of _sel is project then
					set duplicatedTask to make new task with properties {name:"Develop: " & name of _sel, flagged:false} at end of tasks of LandS
					tell O to deferDaily(duplicatedTask)
					tell O to setContext(duplicatedTask, "Anywhere")
					set note of duplicatedTask to "omnifocus:///task/" & id of _sel
				else
					display notification "\"" & name of _sel & "\"" & " is not a project."
				end if
			end repeat
			
			tell application "OmniFocus" to tell default document to make new document window
			tell O to openPerspective("Navigation")
		end tell
	end tell
end run

on main(argv)
	set sel to selectedItems() of O
	tell application "OmniFocus"
		tell default document
			set LandS to findProject("Engaged (Max 3)") of O
			
			try
				set channel to task ("Channel " & argv) of LandS
			on error
				display alert "No channel specified."
			end try
			
			
			repeat with _sel in sel
				if class of _sel is project then
					set duplicatedTask to make new task with properties {name:"Develop: " & name of _sel, flagged:false} at end of tasks of channel
					tell O to deferDaily(duplicatedTask)
					--          set note of duplicatedTask to "omnifocus:///task/" & id of _sel
					set note of duplicatedTask to "testing"
					set value of attribute named "link" of style of paragraph 1 of note of duplicatedTask to "omnifocus:///task/" & id of _sel
				else
					display notification "\"" & name of _sel & "\"" & " is not a project."
				end if
			end repeat
			
			tell O to openPerspective("Navigation")
		end tell
	end tell
end main
