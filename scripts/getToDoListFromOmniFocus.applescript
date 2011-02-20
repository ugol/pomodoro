tell application "System Events" to if exists process "OmniFocus" then
	tell application "OmniFocus"
		tell default document
			get name of every inbox task whose completed is false
		end tell
	end tell
end if
