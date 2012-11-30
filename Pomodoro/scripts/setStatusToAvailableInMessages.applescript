tell application "System Events" to if exists process "Messages" then
tell application "Messages"
    set status to available
    delay 1.0E-3
    set status message to "%@"
end tell
end if