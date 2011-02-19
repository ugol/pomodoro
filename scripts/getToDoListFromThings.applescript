-- getTodoListFromThings
-- Pomodoro

-- Created by Ugo Landini on 2/17/11.
-- Copyright 2011 iUgol. All rights reserved.

tell application "Things"
	tell list "Today"
		get name of every to do whose status is equal to (open)
	end tell
end tell
