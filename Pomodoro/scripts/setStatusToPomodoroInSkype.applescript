tell application "System Events" to if exists process "Skype" then
    tell application "Skype"
        send command "SET USERSTATUS DND" script name "Pomodoro"
        send command "SET PROFILE MOOD_TEXT %@" script name "Pomodoro"
    end tell
end if