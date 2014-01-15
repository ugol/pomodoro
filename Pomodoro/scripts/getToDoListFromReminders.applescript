tell application "System Events" to if exists process "Reminders" then
tell application "Reminders"

set todoList to {}

repeat with aReminder in (reminders whose completed is false)
    if container of aReminder is equal to default list then
        set prefix to ""
        else
        set prefix to "[" & name of container of aReminder & "] "
    end if
    set end of todoList to (prefix & name of aReminder)
end repeat
return todoList

end tell
end if