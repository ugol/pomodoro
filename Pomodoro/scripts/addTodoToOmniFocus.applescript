tell application "System Events" to if exists process "OmniFocus" then
    tell application "OmniFocus"
        tell default document
            set newTask to make new inbox task with properties {name:"%@"}
        end tell
end tell
end if