//
//  PomodoroDefaults.m
//  pomodoro
//
//  Created by ugo landini on 6/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
	
	[defaultValues setObject:@"Have a great pomodoro!" forKey:@"growlStart"];
	[defaultValues setObject:@"Ready, set, go" forKey:@"speechStart"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptStart"];
	
	[defaultValues setObject:@"You have $secs seconds to resume" forKey:@"growlInterrupt"];
	[defaultValues setObject:@"You have $secs seconds to resume" forKey:@"speechInterrupt"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptInterrupt"];
	
	[defaultValues setObject:@"... interruption max time is over, sorry!" forKey:@"growlInterruptOver"];
	[defaultValues setObject:@"interruption over, sorry" forKey:@"speechInterruptOver"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptInterruptOver"];
	
	[defaultValues setObject:@"Not a good one? Just try again!" forKey:@"growlReset"];
	[defaultValues setObject:@"Try again" forKey:@"speechReset"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptReset"];
	
	[defaultValues setObject:@"... and we're back!" forKey:@"growlResume"];
	[defaultValues setObject:@"... and we're back!" forKey:@"speechResume"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptResume"];
	
	[defaultValues setObject:@"Great! A full pomodoro!" forKey:@"growlEnd"];
	[defaultValues setObject:@"Well done!" forKey:@"speechEnd"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptEnd"];
	
	[defaultValues setObject:@"Other $mins minutes passed by. $passed total minutes spent." forKey:@"growlEvery"];
	[defaultValues setObject:@"$time minutes to go" forKey:@"speechEvery"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptEvery"];
	
	[defaultValues setObject:@"Ready for another one?" forKey:@"growlBreakFinished"];
	[defaultValues setObject:@"Ready for next one?" forKey:@"speechBreakFinished"];
	[defaultValues setObject:@"-- insert here your Applescript" forKey:@"scriptBreakFinished"];
	
	[defaultValues setObject:@"Alex" forKey:@"defaultVoice"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"breakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"canRestartAtBreak"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"askBeforeStart"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"longbreakEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtStartEnabled"];
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
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtEndEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"growlAtEveryEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtEveryEnabled"];	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtEveryEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"scriptAtBreakFinishedEnabled"];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"autoPomodoroRestart"];
	
	[defaultValues setObject:[NSNumber numberWithInt:10] forKey:@"ringVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:10] forKey:@"ringBreakVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:8] forKey:@"voiceVolume"];
	[defaultValues setObject:[NSNumber numberWithInt:2] forKey:@"tickVolume"];
		
	[defaultValues setObject:@"Insert here the pomodoro name" forKey:@"pomodoroName"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];

}

+(void)removeDefaults {
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"initialTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"interruptTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlEveryTimeMinutes"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechEveryTimeMinutes"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptEveryTimeMinutes"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"breakTime"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longbreakTime"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptStart"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlInterrupt"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechInterrupt"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptInterrupt"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlInterruptOver"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechInterruptOver"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptInterruptOver"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlReset"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechReset"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptReset"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlResume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechResume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptResume"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlEnd"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechEnd"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptEnd"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlEvery"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechEvery"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptEvery"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlBreakFinished"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechBreakFinished"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptBreakFinished"];
	
	[[NSUserDefaults standardUserDefaults] setObject:@"Alex" forKey:@"defaultVoice"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"breakEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"canRestartAtBreak"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"askBeforeStart"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longbreakEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtStartEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtStartEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtStartEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtInterruptEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtInterruptEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtInterruptEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtInterruptOverEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtInterruptOverEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtInterruptOverEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtResetEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtResetEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtResetEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtResumeEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtResumeEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtResumeEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringAtBreakEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtBreakEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tickEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tickAtBreakEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtEndEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtEndEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtEveryEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtEveryEnabled"];	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtEveryEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"growlAtBreakFinishedEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"speechAtBreakFinishedEnabled"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"scriptAtBreakFinishedEnabled"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ringBreakVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"voiceVolume"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tickVolume"];
	
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"autoPomodoroRestart"];
}

@end
