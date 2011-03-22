tell application "System Events" to if exists process "Things" then
    tell application "Things"
        tell list "Today"
            get name of every to do whose status is equal to (open)
        end tell
end tell
end if
