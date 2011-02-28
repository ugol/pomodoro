tell application "System Events" to if exists process "Skype" then
	tell application "Skype"
		send command "SET USERSTATUS DND" script name "AppleScript status setter"
	end tell
end if