tell application "System Events" to if exists process "Adium" then
    tell application "Adium" to go available with message "%@"
end if