tell application "System Events" to if exists process "Things" then
tell application "Things"
set todoList to {}
repeat with aToDo in (to dos of list "Today" whose status is equal to (open))
    set aProject to project of aToDo
    if aProject is not missing value then
        set prefix to "[" & (name of aProject) & "] "
        else
        set prefix to ""
    end if
    set end of todoList to (prefix & name of aToDo)
end repeat
return todoList
end tell
end if
