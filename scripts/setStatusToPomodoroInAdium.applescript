tell application "System Events" to if exists process "Adium" then
	tell application "Adium"
		set stati to every status where title is "Pomodoro"
		if (count of stati) is 0 then
			set pomodoro to make new status with properties {title:"Pomodoro", status type:away}
		else
			set pomodoro to item 1 of stati
		end if
		set status message of pomodoro to "I am busy right now"
		set autoreply of pomodoro to "I am busy rigth now"
		set the status of every account whose status type is available to pomodoro
	end tell
end if
