use AppleScript version "2.4" -- Yosemite (10.10) or lateruse scripting additionsuse O : script "omnifocus"use OmniFocus : application "OmniFocus"-- If you want to play it safe, set nagMePlease to trueproperty nagMePlease : falseon run	if nagMePlease then		set question to display dialog "Do you want to remove all prefixes?"		if button returned of question is "OK" then			removePrefixes()		end if	else		removePrefixes()	end ifend runon handle_string(argv)	tell O to setPrefix(selectedItems(), argv)end handle_stringon removePrefixes()	tell O to clearPrefixAll(selectedItems())	display notification ¬		"All prefixes removed." with title "Fixxxer"end removePrefixes