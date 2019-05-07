// Pomodoro Desktop - Copyright (c) 2009-2011, Ugo Landini (ugol@computer.org)
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
	[defaultValues setObject: [NSNumber numberWithInt:5] forKey:@"longbreakResetTime"];

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
	[defaultValues setObject: [NSNumber numberWithShort:44] forKey:@"quickStatsCode"];
	[defaultValues setObject: [NSNumber numberWithUnsignedInteger:10223616] forKey:@"quickStatsFlags"];

	[defaultValues setObject:NSLocalizedString(@"Have a great pomodoro! You have $duration minutes to do '$timerName'.",@"Growl pomodoro start") forKey:@"growlStart"];
	[defaultValues setObject:NSLocalizedString(@"Ready, set, go",@"Speech pomodoro start") forKey:@"speechStart"];
    NSString* script = NSLocalizedString(@"-- insert here your Applescript",@"Applescript placeholder");
	[defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptStart"];
	
	[defaultValues setObject:NSLocalizedString(@"You have $secs seconds to resume.",@"Growl pomodoro interrupt") forKey:@"growlInterrupt"];
	[defaultValues setObject:NSLocalizedString(@"You have $secs seconds to resume",@"Speech pomodoro interrupt") forKey:@"speechInterrupt"];
	[defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptInterrupt"];
	
	[defaultValues setObject:NSLocalizedString(@"... interruption max time is over, sorry!",@"Growl interrupt over") forKey:@"growlInterruptOver"];
	[defaultValues setObject:NSLocalizedString(@"interruption over, sorry",@"Speech interrupt over") forKey:@"speechInterruptOver"];
    [defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptInterruptOver"];
	
	[defaultValues setObject:NSLocalizedString(@"Not a good one? Just try again!",@"Growl pomodoro reset") forKey:@"growlReset"];
	[defaultValues setObject:NSLocalizedString(@"Try again",@"Speech pomodoro reset") forKey:@"speechReset"];
    [defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptReset"];
	[defaultValues setObject:NSLocalizedString(@"I have just reset pomodoro '$timerName'",@"Twitter pomodoro reset") forKey:@"twitterReset"];

	[defaultValues setObject:NSLocalizedString(@"... and we're back!",@"Growl pomodoro resume") forKey:@"growlResume"];
	[defaultValues setObject:NSLocalizedString(@"And we are back!",@"Speech pomodoro resume") forKey:@"speechResume"];
	[defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptResume"];
	
	[defaultValues setObject:NSLocalizedString(@"Great! A full pomodoro!",@"Growl pomodoro end") forKey:@"growlEnd"];
	[defaultValues setObject:NSLocalizedString(@"Well done!",@"Speech pomodoro end") forKey:@"speechEnd"];
	[defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptEnd"];
	
	[defaultValues setObject:NSLocalizedString(@"Other $mins minutes passed by. $passed total minutes spent.",@"Growl every minutes") forKey:@"growlEvery"];
	[defaultValues setObject:NSLocalizedString(@"$time minutes to go",@"Speech every minutes") forKey:@"speechEvery"];
	[defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptEvery"];
	
	[defaultValues setObject:NSLocalizedString(@"Ready for another one?",@"Growl break finsihed") forKey:@"growlBreakFinished"];
	[defaultValues setObject:NSLocalizedString(@"Ready for next one?",@"Speech break finished") forKey:@"speechBreakFinished"];
    [defaultValues setObject:[NSData dataWithData:[script dataUsingEncoding:NSUTF8StringEncoding]] forKey:@"scriptBreakFinished"];
	
	[defaultValues setObject:@"Alex" forKey:@"defaultVoice"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"mute"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"breakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"canRestartAtBreak"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"askBeforeStart"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"longbreakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"longbreakResetEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"stickyStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtStartEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtInterruptEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInterruptOverEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtInterruptOverEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtInterruptOverEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtResetEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtResetEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtResetEnabled"];
	
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
	
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"growlAtEveryEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtEveryEnabled"];	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtEveryEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"stickyBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtBreakFinishedEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"autoPomodoroRestart"];
	
	[defaultValues setObject:[NSNumber numberWithInt:20] forKey:@"ringVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:20] forKey:@"ringBreakVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:20] forKey:@"voiceVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:20] forKey:@"tickVolume"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"showTimeOnStatusEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"showTimeWithSeconds"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"calendarEnabled"];
	[defaultValues setObject:@"Timers" forKey:@"selectedCalendar"];
	[defaultValues setObject:NSLocalizedString(@"$duration minutes Timer '$timerName'", @"Calendar end text") forKey:@"calendarEnd"];

		
	[defaultValues setObject:NSLocalizedString(@"Insert a name",@"Timer name prompt") forKey:@"timerName"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"startOnLoginEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"showSplashScreenAtStartup"];
 	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"preventSleepDuringPomodoro"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"preventSleepDuringPomodoroBreak"];   
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"thingsEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"thingsAddingEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"omniFocusEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"omniFocusAddingEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"remindersEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"remindersAddingEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"ichatEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"skypeEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"adiumEnabled"];
    [defaultValues setObject:NSLocalizedString(@"Timer '$timerName'. Back at $dueTime", @"Mood Message") forKey:@"moodMessageInPomodoro"];
    [defaultValues setObject:NSLocalizedString(@"Resting after Timer '$timerName'", @"Mood Message Break") forKey:@"moodMessageInPomodoroBreak"];


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
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longbreakReset"]; 
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longbreakResetTime"]; 

	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"enableTwitter"];
	
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
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"quickStatsCode"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"quickStatsFlags"];

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
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showTimeWithSeconds"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"calendarEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedCalendar"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"calendarEnd"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autoPomodoroRestart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"startOnLoginEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showSplashScreenAtStartup"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"preventSleepDuringPomodoro"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"preventSleepDuringPomodoroBreak"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"thingsEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"thingsAddingEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"omniFocusEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"omniFocusAddingEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remindersEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"remindersAddingEnabled"];
    
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ichatEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"skypeEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"adiumEnabled"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moodMessageInPomodoro"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"moodMessageInPomodoroBreak"];	

}

@end
