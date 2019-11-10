(*
  # DESCRIPTION #

  This script removes flags from all actions in the OmniFocus Perspective “DR-Nightly-Clear-Flags”
  which have not been modified in the last 12 hours.

  # LICENSE #

  Copyright © 2019 Mike McLeabn (contact: mike.mclean@pobox.com)
  Licensed under MIT License (http://www.opensource.org/licenses/mit-license.php)
  (TL;DR: do whatever you want with it.)

  # CHANGE HISTORY #

  2019-11-09 - Initial Version

  # INSTALLATION #

    For manual execution:
    - Copy to ~/Library/Scripts/Applications/Omnifocus
    - If desired, add to the OmniFocus toolbar using View > Customize Toolbar... within OmniFocus

    For Keyboard Focus Execution
    - Configure KM to run it

*)



use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

use application "OmniFocus"
use O : script "omnifocus"


-- To change settings, modify the following property (the group that holds your daily process tasks)
property specialFlagsPerspective : "DR-Nightly-Clear-Flags"

# Setup: Log to a file in the home dir.
property DLOG_TARGETS : {"/Users/mlm/Library/Logs/OmniFocus-Automation.log"}

on clearFlags()
  my dlog("Beginning Daily Flag Clearing")
  -- Get Perspective Window and from that the list of Tasks to Clear Flags
  tell application "OmniFocus"
    set needToClose to false
    tell default document
      set WindowList to every document window whose name is specialFlagsPerspective
    end tell
    set numWindows to length of WindowList
    if numWindows ≤ 0 then
      tell default document
        make new document window with properties {perspective name:specialFlagsPerspective} at end of document windows
        set perspectiveWindow to front document window of front document of application "OmniFocus"
        set perspectiveWindowID to id of front document window
      end tell
      -- If we have to open a new Perspective Window, track that so we can close it
      set needToClose to true
    else
      set perspectiveWindow to first item of WindowList
      set perspectiveWindowID to id of first item of WindowList
    end if
    --  processClearFlagsTasks is every task in the specialFlagsPerspective Window
    set processClearFlagsTasks to leaves of content of perspectiveWindow
  end tell
  --Perform clear flags action
  set successTot to 0 -- Count the number of successes
  set skippedBecauseOfDate to 0 -- Count the number skipped because of modification date (newer than 12 hours)
  if length of processClearFlagsTasks > 0 then
    -- processClearFlagsTasks helps with English pluralization
    if length of processClearFlagsTasks > 1 then
      set processItemNum to "s"
    else
      set processItemNum to ""
    end if
    set autosave to false
    -- Loop the items and process
    repeat with _thisItem in processClearFlagsTasks
      set thisItem to value of _thisItem
      tell application "OmniFocus"
        tell default document
          set modDate to modification date of thisItem
        end tell
      end tell
      if modDate > ((current date) - (12 * hours)) then
        set skippedBecauseOfDate to skippedBecauseOfDate + 1
      else
        set succeeded to my clearFlag(thisItem)
        if succeeded then set successTot to successTot + 1
      end if
    end repeat
    set autosave to true
    -- close window if we opened it
    if needToClose then
      tell perspectiveWindow to close
    end if
    -- alertItemNum helps with English pluralization
    if successTot = 1 then
      set alertItemNum to ""
    else
      set alertItemNum to "s"
    end if
    -- skippedBecauseOfDateNum helps with English pluralization
    if skippedBecauseOfDate = 1 then
      set skippedBecauseOfDateNum to ""
    else
      set skippedBecauseOfDateNum to "s"
    end if
    -- Build Alert dialog
    set alertText to "Processed " & length of processClearFlagsTasks & " Flagged Task" & processItemNum & ". " as string
    set alertText to alertText & "Successfully unflagged " & successTot & " Task" & alertItemNum & ". " as string
    set alertText to alertText & "Skipped " & skippedBecauseOfDate & " Recently Modified Task" & skippedBecauseOfDateNum & "." as string
    my dlog(alertText)
  end if
  return alertText
end clearFlags


on interactiveNotify(alertText)
  set alertName to "General"
  set alertTitle to "Daily Unflag Process"
  my notify(alertName, alertTitle, alertText)
end interactiveNotify

on clearFlag(selectedItem)
  set success to false
  tell application "OmniFocus"
    tell default document
      tell application "OmniFocus" to tell default document to set nameOfThisItem to name of selectedItem
      tell O
        try
          setFlagged(selectedItem, false)
          set success to true
          my dlog({"Unflagging: ", nameOfThisItem, ", Successful:", success})
        on error errStr number errorNumber
          my dlog({"Unflagging: ", nameOfThisItem, ", Successful:", success, "Error Number:", errorNumber, "Error String:", errStr})
        end try
      end tell
    end tell
  end tell
  return success
end clearFlag

on startToday(selectedItem, currDate)
  set success to false
  tell application "OmniFocus"
    try
      set originalStartDateTime to defer date of selectedItem
      if (originalStartDateTime is not missing value) then
        --Set new start date with original start time
        set defer date of selectedItem to (currDate + (time of originalStartDateTime))
        set success to true
      else
        set defer date of selectedItem to (currDate + (startTime * hours))
        set success to true
      end if
    end try
  end tell
  return success
end startToday



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
    «event register» given «class appl»:growlAppName, «class anot»:allNotifications, «class dnot»:enabledNotifications, «class iapp»:iconApplication
    «event notifygr» given «class name»:alertName, «class titl»:alertTitle, «class appl»:growlAppName, «class desc»:alertText
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

on hazelProcessFile(theFile, inputAttributes)
  -- ‘theFile’ is an alias to the file that matched.
  -- ‘inputAttributes’ is an AppleScript list of the values of any attributes you told Hazel to pass in.
  -- Be sure to return true or false (or optionally a record) to indicate whether the file passes this script.
  --  my dlog({"Processing: ", theFile})
  clearFlags()
  return
end hazelProcessFile

on main()
  my interactiveNotify(my clearFlags())
end main

#########################
# Display Log Code - From https://stackoverflow.com/questions/13653358/how-to-log-objects-to-a-console-with-applescript
#########################

# Logs a text representation of the specified object or objects, which may be of any type, typically for debugging.
# Works hard to find a meaningful text representation of each object.
# SYNOPSIS
#   dlog(anyObjOrListOfObjects)
# USE EXAMPLES
#   dlog("before")  # single object
#     dlog({ "front window: ", front window }) # list of objects
# SETUP
#   At the top of your script, define global variable DLOG_TARGETS and set it to a *list* of targets (even if you only have 1 target).
#     set DLOG_TARGETS to {} # must be a list with any combination of: "log", "syslog", "alert", <posixFilePath>
#   An *empty* list means that logging should be *disabled*.
#   If you specify a POSIX file path, the file will be *appended* to; variable references in the path
#   are allowed, and as a courtesy the path may start with "~" to refer to your home dir.
#   Caveat: while you can *remove* the variable definition to disable logging, you'll take an additional performance hit.
# SETUP EXAMPLES
#    For instance, to use both AppleScript's log command *and* display a GUI alert, use:
#       set DLOG_TARGETS to { "log", "alert" }
# Note:
#   - Since the subroutine is still called even when DLOG_TARGETS is an empty list,
#     you pay a performancy penalty for leaving dlog() calls in your code.
#   - Unlike with the built-in log() method, you MUST use parentheses around the parameter.
#   - To specify more than one object, pass a *list*. Note that while you could try to synthesize a single
#     output string by concatenation yourself, you'd lose the benefit of this subroutine's ability to derive
#     readable text representations even of objects that can't simply be converted with `as text`.
on dlog(anyObjOrListOfObjects)
  try
    if length of DLOG_TARGETS is 0 then return
  on error
    return
  end try
  # The following tries hard to derive a readable representation from the input object(s).
  if class of anyObjOrListOfObjects is not list then set anyObjOrListOfObjects to {anyObjOrListOfObjects}
  local lst, i, txt, errMsg, orgTids, oName, oId, prefix, logTarget, txtCombined, prefixTime, prefixDateTime
  set lst to {}
  repeat with anyObj in anyObjOrListOfObjects
    set txt to ""
    repeat with i from 1 to 2
      try
        if i is 1 then
          if class of anyObj is list then
            set {orgTids, AppleScript's text item delimiters} to {AppleScript's text item delimiters, {", "}} # '
            set txt to ("{" & anyObj as string) & "}"
            set AppleScript's text item delimiters to orgTids # '
          else
            set txt to anyObj as string
          end if
        else
          set txt to properties of anyObj as string
        end if
      on error errMsg
        # Trick for records and record-*like* objects:
        # We exploit the fact that the error message contains the desired string representation of the record, so we extract it from there. This (still) works as of AS 2.3 (OS X 10.9).
        try
          set txt to do shell script "egrep -o '\\{.*\\}' <<< " & quoted form of errMsg
        end try
      end try
      if txt is not "" then exit repeat
    end repeat
    set prefix to ""
    if class of anyObj is not in {text, integer, real, boolean, date, list, record} and anyObj is not missing value then
      set prefix to "[" & class of anyObj
      set oName to ""
      set oId to ""
      try
        set oName to name of anyObj
        if oName is not missing value then set prefix to prefix & " name=\"" & oName & "\""
      end try
      try
        set oId to id of anyObj
        if oId is not missing value then set prefix to prefix & " id=" & oId
      end try
      set prefix to prefix & "] "
      set txt to prefix & txt
    end if
    set lst to lst & txt
  end repeat
  set {orgTids, AppleScript's text item delimiters} to {AppleScript's text item delimiters, {" "}} # '
  set txtCombined to lst as string
  set prefixTime to "[" & time string of (current date) & "] "
  set prefixDateTime to "[" & short date string of (current date) & " " & text 2 thru -1 of prefixTime
  set AppleScript's text item delimiters to orgTids # '
  # Log the result to every target specified.
  repeat with logTarget in DLOG_TARGETS
    if contents of logTarget is "log" then
      log prefixTime & txtCombined
    else if contents of logTarget is "alert" then
      display alert prefixTime & txtCombined
    else if contents of logTarget is "syslog" then
      do shell script "logger -t " & quoted form of ("AS: " & (name of me)) & " " & quoted form of txtCombined
    else # assumed to be a POSIX file path to *append* to.
      set fpath to contents of logTarget
      if fpath starts with "~/" then set fpath to "$HOME/" & text 3 thru -1 of fpath
      do shell script "printf '%s\\n' " & quoted form of (prefixDateTime & txtCombined) & " >> \"" & fpath & "\""
    end if
  end repeat
end dlog

main()
