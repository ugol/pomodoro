tell application "System Events" to if exists process "Reminders" then

tell application "Reminders"
set theInput to "%@"
    if theInput contains "[" and theInput contains "]" then
        set theProject to text ((offset of "[" in theInput) + 1) thru ((offset of "]" in theInput) - 1) of theInput
        set theTodoName to text ((offset of "]" in theInput) + 1) thru -1 of theInput
        
        set projects to (name of every list)
        if projects does not contain theProject then
            set aList to make new list with properties {name:theProject}
        end if
        tell list theProject to make new reminder with properties {name:theTodoName}
	else
        --If no project was specified, add to the default list
        make new reminder with properties {name:theInput}
    end if
end tell

end if