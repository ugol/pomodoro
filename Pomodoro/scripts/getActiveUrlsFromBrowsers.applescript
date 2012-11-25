set urllist to {}

tell application "System Events" to if exists process "Safari" then
tell application "Safari"
if frontmost then
    if exists front window then
        set w to front window
        if w is visible then
            if (current tab of w) exists then
                set u to URL of current tab of w
                copy u to the end of urllist
            end if
        end if
    end if
end if
end tell
end if

tell application "System Events" to if exists process "Google Chrome" then
tell application "Google Chrome"
if frontmost then
    if exists front window then
        set w to front window
        if w is visible then
            if (active tab of w) exists then
                set u to URL of active tab of w
                copy u to the end of urllist
            end if
        end if
    end if
end if
end tell
end if

return urllist