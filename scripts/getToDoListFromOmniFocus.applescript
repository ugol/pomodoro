tell application "System Events" to if exists process "OmniFocus" then
	tell application "OmniFocus"
		tell default document
			set due_soon to a reference to setting id "DueSoonInterval"
			set due_soon_interval to ((value of due_soon) / days) as integer
			set due_date to (current date) + due_soon_interval * days
			get name of every flattened task whose completed is false and blocked is false and ((due date is less than or equal to due_date) or (flagged is true or flagged of containing project is true)) and status of containing project is active
		end tell
	end tell
end if