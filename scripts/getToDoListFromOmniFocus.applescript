-- getTodoListFromOmniFocus
-- Pomodoro

-- Created by Ugo Landini on 2/17/11.
-- Copyright 2011 iUgol. All rights reserved.

tell application "OmniFocus"
		
		tell default document
	get name of every inbox task whose completed is false
	--get name of selected task
	end tell
end tell