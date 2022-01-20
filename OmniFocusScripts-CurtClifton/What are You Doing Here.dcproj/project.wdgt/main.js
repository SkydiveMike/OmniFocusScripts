/* 
 This file was generated by Dashcode.  
 You may edit this file to customize your widget or web page 
 according to the license.txt file included in the project.
 */

//
// Function: load()
// Called by HTML body element's onload event when the widget is ready to start
//
function load()
{
    dashcode.setupParts();
    
    // gets stored preferences and makes the back controls match
    includeProjectNames =
        widget.preferenceForKey(dashcode.createInstancePreferenceKey("includeProjectNames"));
    if (includeProjectNames == undefined) {
        includeProjectNames = false;
        widget.setPreferenceForKey(includeProjectNames, 
                                    dashcode.createInstancePreferenceKey("includeProjectNames"));
    }
    var includeProjectNamesCheckbox = document.getElementById("includeProjectNamesCheckbox");
    includeProjectNamesCheckbox.checked = includeProjectNames;
}

//
// Function: remove()
// Called when the widget has been removed from the Dashboard
//
function remove()
{
    // TODO: Stop any timers to prevent CPU usage
    // Removes any preferences as needed
    widget.setPreferenceForKey(null, dashcode.createInstancePreferenceKey("includeProjectNames"));
}

//
// Function: hide()
// Called when the widget has been hidden
//
function hide()
{
    // TODO: Stop any timers to prevent CPU usage
}

//
// Function: show()
// Called when the widget has been shown
//
function show()
{
    // Restart any timers that were stopped on hide
    // TODO: set up a periodic timer to trigger refreshData()
    refreshData();
}

//
// Function: sync()
// Called when the widget has been synchronized with .Mac
//
function sync()
{
    // Retrieve any preference values that you need to be synchronized here
    // Use this for an instance key's value:
    // instancePreferenceValue = widget.preferenceForKey(null, dashcode.createInstancePreferenceKey("your-key"));
    //
    // Or this for global key's value:
    // globalPreferenceValue = widget.preferenceForKey(null, "your-key");
}

//
// Function: showBack(event)
// Called when the info button is clicked to show the back of the widget
//
// event: onClick event from the info button
//
function showBack(event)
{
    var front = document.getElementById("front");
    var back = document.getElementById("back");

    if (window.widget) {
        widget.prepareForTransition("ToBack");
    }

    front.style.display = "none";
    back.style.display = "block";

    if (window.widget) {
        setTimeout('widget.performTransition();', 0);
    }
}

//
// Function: showFront(event)
// Called when the done button is clicked from the back of the widget
//
// event: onClick event from the done button
//
function showFront(event)
{
    var front = document.getElementById("front");
    var back = document.getElementById("back");

    if (window.widget) {
        widget.prepareForTransition("ToFront");
    }

    front.style.display="block";
    back.style.display="none";

    if (window.widget) {
        setTimeout('widget.performTransition();', 0);
    }
    
    // updates data after transition is complete
    setTimeout('refreshData();', 1000)
}

// Reads data from data file and updates display
function refreshData()
{
    alert("refreshing");
    // TODO: Get data, \r-delimited string of desc\rproj\rtaskID
    // CONSIDER: Need to call an Applescript that reads the task IDs from ApplicationData/WhatAreYouDoingHere, checks to see if OF is running, and, if so, returns properly formatted data.  Can lift most of the script from existing script for GeekTools
    var sampleData = "Complete TPS Report\rProject A\rabc123\rFind Stapler\rProject B\rbcd234\rPC Load Letter\rProject C\rcde345";
    listController.displayNewData(sampleData);
}

function includeProjectNamesClicked(event)
{
    var includeProjectNamesCheckbox = document.getElementById("includeProjectNamesCheckbox");
    includeProjectNames = includeProjectNamesCheckbox.checked;
    widget.setPreferenceForKey(includeProjectNames,
                                createInstancePreferenceKey("includeProjectNames"));
}

function setHoverText(text) 
{
    var hoverText = document.getElementById("hoverText");
    hoverText.textContent = text;
}

function markTaskCompleted(taskID)
{
    alert("Completing " + taskID);
    if (taskID != undefined) {
        // TODO: Call Applescript to send command to OF to complete taskID
    }
    // Updates display after 2 seconds.  (Gives time to change mind.)
    setTimeout('refreshData();', 2000)
}

function markTaskUncompleted(taskID)
{
    alert("Uncompleting " + taskID)
    if (taskID != undefined) {
        // TODO: Call Applescript to send command to OF to uncomplete taskID
    }
    refreshData();
}

if (window.widget) {
    widget.onremove = remove;
    widget.onhide = hide;
    widget.onshow = show;
    widget.onsync = sync;
    
    var includeProjectNames;
    
    // data for the display
    var listController = {
        _tasks: [{desc: "Complete TPS Report", proj: "Project A"},
                 {desc: "Find Stapler", proj: "Project B"},
                 {desc: "PC Load Letter", proj: "Project C"}],
        // The List calls this method to find out how many rows should be in the list.
        numberOfRows: function() {
            return this._tasks.length;
        },
        // The List calls this method once for every row.
        prepareRow: function(rowElement, rowIndex, templateElements) {
            // templateElements contains references to all elements that have an id in the template row.
            // Ex: set the value of an element with id="label".
            var label = this._tasks[rowIndex].desc
            if (includeProjectNames) {
                label += (" [" + this._tasks[rowIndex].proj + "]");
            }
            templateElements.actionLabel.innerText = label;

            // Grab the appropriate context name here, since the 'this' reference in the mouseover
            // handler is not bound to this listController object when the handler is invoked.
            var projectName = this._tasks[rowIndex].proj;
            var taskName = this._tasks[rowIndex].desc;
            var taskID = this._tasks[rowIndex].taskID;

            rowElement.onmouseover = function(event) {
                setHoverText(projectName);
            };
            rowElement.onmouseout = function(event) {
                setHoverText("");
            };
            // Assign a click event handler for the row's checkbox
            templateElements.actionCheckbox.onclick = function(event) {
                if (this.checked) {
                    markTaskCompleted(taskID);
                } else {
                    markTaskUncompleted(taskID);
                }
            }
        },
        // Called when new data is available for display
        displayNewData: function(newData) {
            var list = document.getElementById("list");
            var lines = newData.split("\r");
            var newTasks = [];
            var nextIndex = 0;
            for(var i=0; i < lines.length; i+=3) {
                var desc = lines[i];
                var proj = lines[i+1];
                var taskID = lines[i+2];
                newTasks[nextIndex] = {desc: desc, proj: proj, taskID: taskID};
                nextIndex++;
            }
            this._tasks = newTasks;
            list.object.reloadData();
        }
    };
}
