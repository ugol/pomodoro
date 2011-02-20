tell application "System Events" to if exists process "Adium" then
	tell application "Adium" 
	set the status of every account whose status type is not available to the first status whose title is "Available"
	end tell
end if