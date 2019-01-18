(*

  Automatically open items linked from an OmniFocus Task Note.

  This script is designed to be assigned to a hotkey using an app such
  as FastScripts, Alfred, or Keyboard Maestro. To use it, simply
  select a task in OmniFocus and hit the assigned key.

  If the task's note contains a URI of any kind, it will be
  automatically opened in the appropriate app. This is a handy way to
  open not only web pages, but other OmniFocus perspectives (using the
  omnifocus:///perspective/perspective-name URI), sending an email
  (mailto:// URI) or even placing calls via Handoff using the tel://
  URI).

  Since most apps on OS X don't offer URI handlers, however, an extra
  routine looks for a note beginning with the prefix "App:" followed
  by the name of an OS X app, as it appears in your Applications
  folder. This allows specific apps to be launched directly from a
  task in OmniFocus.

  Original Script Copyright © 2016 Jesse David Hollington (jesse@hollington.ca)
  Licensed under MIT License (http://www.opensource.org/licenses/mit-license.php)

  2019-01-18 - Updates by Mike McLean mike.mclean@pobox.com

*)


# The name of your "Dashboard" perspective
set dashboard_perspective to "Today (Dashboard) - All"

# This just initializes some variables, since we may not set them otherwise.
set target to ""
set theItem to ""

tell application "OmniFocus"

  # Get the currently selected item

  tell content of first document window of front document
    try
      set theItem to value of first item of (selected trees where class of its value is not item and class of its value is not folder)

      # Only do something if there's a note in the selected item

      if note of theItem is not "" then
        if value of attribute named "link" of style of paragraph 1 of note of theItem is not "" then
          set target to value of attribute named "link" of style of paragraph 1 of note of theItem
        else
          set target to note of theItem
        end if
      end if
    end try

  end tell

  # If NO item is selected, return to the Hotlist context. This
  # provides an easy way to switch back and forth between the
  # "dashboard" list using the same hotkey.

  if theItem is "" then tell the default document to tell the front document window to set perspective name to dashboard_perspective

end tell

# If the note begins with the word "App:" then we can assume anything
# after that is an application name to be launched or brought to the
# forefront. Anything that looks like a URI gets launched with the
# standard OS X "Open" command. Anything else in the note field is
# simply ignored.

if target begins with "App:" then

  set target to text 6 thru -1 of target as string

  tell application target to activate

else if target contains "://" then

  do shell script "open " & target

end if
