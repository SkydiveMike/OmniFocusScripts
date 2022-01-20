(*
	# DESCRIPTION #
	
	Appends a note to the most recently created task in OmniFocus.
	-	By default, the clipboard contents are used for the note
	-	If triggered from LaunchBar or Alfred, you can use different text	

	See https://github.com/dbyler/omnifocus-scripts for updates


	# LICENSE #

	Copyright � 2015-2017 Dan Byler (contact: dbyler@gmail.com)
	Licensed under MIT License (http://www.opensource.org/licenses/mit-license.php)
	(TL;DR: no warranty, do whatever you want with it.)


	# CHANGE HISTORY #
	
	2017-04-22
	-	Minor update to notification code

	1.0.1 (2015-05-17)
	-	Fix for attachments being overwritten by the note
	-	Use Notification Center instead of an alert when not running Growl. Requires Mountain Lion or newer
	
	1.0 (2015-05-09) Original release.
	
*)


-- To change settings, modify the following properties
property showSummaryNotification : true --if true, will display success notifications

-- Don't change these
property growlAppName : "Dan's Scripts"
property allNotifications : {"General", "Error"}
property enabledNotifications : {"General", "Error"}
property iconApplication : "OmniFocus.app"

on main(q)
	if q is missing value then
		set q to (the clipboard)
	end if
	tell application "OmniFocus"
		tell front document
			set myTask to my getLastAddedTask()
			if myTask is false then
				my notify("Error", "Error", "No recent items available")
				return
			end if
			tell myTask
				insert q & "
			
			" at before first paragraph of note
			end tell
			if showSummaryNotification then
				set alertName to "General"
				set alertTitle to q
				if length of alertTitle > 20 then
					set alertTitle to (text 1 thru 20 of alertTitle) & "�"
				end if
				set alertText to "Note appended to: 
" & name of myTask
				my notify(alertName, alertTitle, alertText)
			end if
			
		end tell
	end tell
end main

on getLastAddedTask()
	tell application "OmniFocus"
		tell front document
			set allTasks to {}
			set maxAge to 8
			repeat while length of allTasks is 0 and maxAge � 524288
				set maxAge to maxAge * 2
				set earliestTime to (current date) - maxAge * 60
				set allTasks to (every flattened task whose (creation date is greater than earliestTime �
					and repetition is missing value))
			end repeat
			if length of allTasks > 0 then
				set lastTask to first item of allTasks
				set lastTaskDate to creation date of lastTask
				repeat with i from 1 to length of allTasks
					if creation date of (item i of allTasks) > lastTaskDate then
						set lastTask to (item i of allTasks)
						set lastTaskDate to creation date of lastTask
					end if
				end repeat
				return lastTask
			else
				return false
			end if
		end tell
	end tell
end getLastAddedTask

(* Begin notification code *)
on notify(alertName, alertTitle, alertText)
	--Call this to show a normal notification
	my notifyMain(alertName, alertTitle, alertText, false)
end notify

on notifyWithSticky(alertName, alertTitle, alertText)
	--Show a sticky Growl notification
	my notifyMain(alertName, alertTitle, alertText, true)
end notifyWithSticky

on IsGrowlRunning()
	tell application "System Events" to set GrowlRunning to (count of (every process where creator type is "GRRR")) > 0
	return GrowlRunning
end IsGrowlRunning

on notifyWithGrowl(growlHelperAppName, alertName, alertTitle, alertText, useSticky)
	tell my application growlHelperAppName
		�event register� given �class appl�:growlAppName, �class anot�:allNotifications, �class dnot�:enabledNotifications, �class iapp�:iconApplication
		�event notifygr� given �class name�:alertName, �class titl�:alertTitle, �class appl�:growlAppName, �class desc�:alertText
	end tell
end notifyWithGrowl

on NotifyWithoutGrowl(alertText, alertTitle)
	display notification alertText with title alertTitle
end NotifyWithoutGrowl

on notifyMain(alertName, alertTitle, alertText, useSticky)
	set GrowlRunning to my IsGrowlRunning() --check if Growl is running...
	if not GrowlRunning then --if Growl isn't running...
		set GrowlPath to "" --check to see if Growl is installed...
		try
			tell application "Finder" to tell (application file id "GRRR") to set strGrowlPath to POSIX path of (its container as alias) & name
		end try
		if GrowlPath is not "" then --...try to launch if so...
			do shell script "open " & strGrowlPath & " > /dev/null 2>&1 &"
			delay 0.5
			set GrowlRunning to my IsGrowlRunning()
		end if
	end if
	if GrowlRunning then
		tell application "Finder" to tell (application file id "GRRR") to set growlHelperAppName to name
		notifyWithGrowl(growlHelperAppName, alertName, alertTitle, alertText, useSticky)
	else
		NotifyWithoutGrowl(alertText, alertTitle)
	end if
end notifyMain
(* end notification code *)

main(missing value)

on alfred_script(q)
	main(q)
end alfred_script

on handle_string(q)
	main(q)
end handle_string
