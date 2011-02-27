tell application "System Events" to if exists process "OmniFocus" then

	set today to date "11:59:59 PM" of (current date)
	tell application "OmniFocus"
		tell default document
			get name of every flattened task whose completed is false and ((due date is less than or equal to today) or (flagged is true))
	        end tell
	end tell
end if
