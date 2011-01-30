// Pomodoro Desktop - Copyright (c) 2009, Ugo Landini (ugol@computer.org)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// * Redistributions of source code must retain the above copyright
// notice, this list of conditions and the following disclaimer.
// * Redistributions in binary form must reproduce the above copyright
// notice, this list of conditions and the following disclaimer in the
// documentation and/or other materials provided with the distribution.
// * Neither the name of the <organization> nor the
// names of its contributors may be used to endorse or promote products
// derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY COPYRIGHT HOLDERS ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <copyright holder> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "PomodoroDefaults.h"


@implementation PomodoroDefaults

+ (void) setDefaults {
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary]; 
		
	[defaultValues setObject: [NSNumber numberWithInt:25] forKey:@"initialTime"];
	[defaultValues setObject: [NSNumber numberWithInt:15] forKey:@"interruptTime"];
	[defaultValues setObject: [NSNumber numberWithInt:2] forKey:@"growlEveryTimeMinutes"];
	[defaultValues setObject: [NSNumber numberWithInt:5] forKey:@"speechEveryTimeMinutes"];
	[defaultValues setObject: [NSNumber numberWithInt:5] forKey:@"scriptEveryTimeMinutes"];
	[defaultValues setObject: [NSNumber numberWithInt:5] forKey:@"breakTime"];
	[defaultValues setObject: [NSNumber numberWithInt:10] forKey:@"longbreakTime"]; 
	[defaultValues setObject: [NSNumber numberWithInt:4] forKey:@"pomodorosForLong"];

	[defaultValues setObject: [NSNumber numberWithShort:29] forKey:@"muteCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:1835008] forKey:@"muteFlags"];
	[defaultValues setObject: [NSNumber numberWithShort:126] forKey:@"startCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:10223616] forKey:@"startFlags"];
	[defaultValues setObject: [NSNumber numberWithShort:125] forKey:@"resetCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:10223616] forKey:@"resetFlags"];
	[defaultValues setObject: [NSNumber numberWithShort:123] forKey:@"interruptCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:10223616] forKey:@"interruptFlags"];
	[defaultValues setObject: [NSNumber numberWithShort:30] forKey:@"internalInterruptCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:1835008] forKey:@"internalInterruptFlags"];
	[defaultValues setObject: [NSNumber numberWithShort:124] forKey:@"resumeCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:10223616] forKey:@"resumeFlags"];

	[defaultValues setObject:@"Have a great pomodoro! You have $duration minutes to do '$pomodoroName'" forKey:@"growlStart"];
	[defaultValues setObject:@"Ready, set, go" forKey:@"speechStart"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptStart"];
	[defaultValues setObject:@"Just started pomodoro '$pomodoroName'" forKey:@"twitterStart"];
	
	[defaultValues setObject:@"You have $secs seconds to resume" forKey:@"growlInterrupt"];
	[defaultValues setObject:@"You have $secs seconds to resume" forKey:@"speechInterrupt"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptInterrupt"];
	
	[defaultValues setObject:@"... interruption max time is over, sorry!" forKey:@"growlInterruptOver"];
	[defaultValues setObject:@"interruption over, sorry" forKey:@"speechInterruptOver"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptInterruptOver"];
	
	[defaultValues setObject:@"Not a good one? Just try again!" forKey:@"growlReset"];
	[defaultValues setObject:@"Try again" forKey:@"speechReset"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptReset"];
	[defaultValues setObject:@"I have just reset pomodoro '$pomodoroName'" forKey:@"twitterReset"];

	[defaultValues setObject:@"... and we're back!" forKey:@"growlResume"];
	[defaultValues setObject:@"... and we're back!" forKey:@"speechResume"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptResume"];
	
	[defaultValues setObject:@"Great! A full pomodoro!" forKey:@"growlEnd"];
	[defaultValues setObject:@"Well done!" forKey:@"speechEnd"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptEnd"];
	[defaultValues setObject:@"Just finished pomodoro '$pomodoroName'" forKey:@"twitterEnd"];
	
	[defaultValues setObject:@"Other $mins minutes passed by. $passed total minutes spent." forKey:@"growlEvery"];
	[defaultValues setObject:@"$time minutes to go" forKey:@"speechEvery"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptEvery"];
	
	[defaultValues setObject:@"Ready for another one?" forKey:@"growlBreakFinished"];
	[defaultValues setObject:@"Ready for next one?" forKey:@"speechBreakFinished"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptBreakFinished"];
	[defaultValues setObject:@"Just finished break after pomodoro '$pomodoroName'" forKey:@"twitterBreakFinished"];
	
	[defaultValues setObject:@"Alex" forKey:@"defaultVoice"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"mute"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"breakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"canRestartAtBreak"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"askBeforeStart"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"longbreakEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"enableTwitter"];
	[defaultValues setObject:@"twitterUser" forKey:@"twitterUser"];
	[defaultValues setObject:@"twitterPwd" forKey:@"twitterPwd"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"stickyStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"twitterAtStartEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtInterruptEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInternalInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"stickyInternalInterruptEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInterruptOverEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtInterruptOverEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtInterruptOverEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtResetEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtResetEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtResetEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"twitterAtResetEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtResumeEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtResumeEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtResumeEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"ringAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"ringAtBreakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtBreakEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"tickEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"tickAtBreakEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"stickyEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"twitterAtEndEnabled"];

	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"growlAtEveryEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtEveryEnabled"];	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtEveryEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"stickyBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"twitterAtBreakFinishedEnabled"];

	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"autoPomodoroRestart"];
	
	[defaultValues setObject:[NSNumber numberWithInt:10] forKey:@"ringVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:10] forKey:@"ringBreakVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:8] forKey:@"voiceVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:2] forKey:@"tickVolume"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"showTimeOnStatusEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"calendarEnabled"];
	[defaultValues setObject:@"Pomodoros" forKey:@"selectedCalendar"];
	[defaultValues setObject:@"$duration minutes Pomodoro '$pomodoroName'" forKey:@"calendarEnd"];

		
	[defaultValues setObject:@"Insert here the pomodoro name" forKey:@"pomodoroName"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];

}

+(void)removeDefaults {
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mute"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"initialTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interruptTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlEveryTimeMinutes"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechEveryTimeMinutes"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptEveryTimeMinutes"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"breakTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longbreakTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"pomodorosForLong"]; 

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"enableTwitter"];
	//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterUser"];
	//[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterPwd"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"muteCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"muteFlags"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startFlags"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"resetCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"resetFlags"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interruptCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interruptFlags"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"internalInterruptCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"internalInterruptFlags"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"resumeCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"resumeFlags"];

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterStart"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlInterrupt"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechInterrupt"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptInterrupt"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlInterruptOver"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechInterruptOver"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptInterruptOver"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlReset"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechReset"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptReset"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterReset"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlResume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechResume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptResume"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlEnd"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechEnd"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptEnd"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterEnd"];

	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlEvery"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechEvery"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptEvery"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlBreakFinished"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechBreakFinished"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptBreakFinished"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterBreakFinished"];
	
	[[NSUserDefaults standardUserDefaults] setObject:@"Alex" forKey:@"defaultVoice"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"breakEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"canRestartAtBreak"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"askBeforeStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longbreakEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtStartEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stickyStartEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtStartEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtStartEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterAtStartEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtInterruptEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtInterruptEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtInterruptEnabled"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtInternalInterruptEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stickyInternalInterruptEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtInterruptOverEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtInterruptOverEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtInterruptOverEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtResetEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtResetEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtResetEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterAtResetEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtResumeEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtResumeEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtResumeEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringAtBreakEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtBreakEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tickEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tickAtBreakEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stickyEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterAtEndEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtEveryEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtEveryEnabled"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtEveryEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtBreakFinishedEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stickyBreakFinishedEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtBreakFinishedEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtBreakFinishedEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"twitterAtBreakFinishedEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringBreakVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"voiceVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tickVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showTimeOnStatusEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"calendarEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedCalendar"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"calendarEnd"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autoPomodoroRestart"];
}

@end
