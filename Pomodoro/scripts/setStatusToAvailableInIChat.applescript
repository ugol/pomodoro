tell application "System Events" to if exists process "iChat" then
	tell application "iChat"
		set status to available
		delay 1.0E-3
		set status message to "%@"
	end tell
end if