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

#import "PomodoroController.h"
#import "GrowlNotifier.h"
#import "Pomodoro.h"
#import "PomodoroStats.h"
#import "AboutController.h"
#import "StatsController.h"


@implementation PomodoroController


#pragma mark ---- Helper methods ----

- (void) showTimeOnStatusBar:(NSInteger) time {
	[statusItem setTitle:[NSString stringWithFormat:@" %.2d:%.2d",time/60, time%60]];
}

- (BOOL) checkDefault:(NSString*) property {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:property] boolValue];
}

#pragma mark ---- Voice combo box delegate/datasource methods ----

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [voices count]; 
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	NSString *v = [voices objectAtIndex:index]; 
    NSDictionary *dict = [NSSpeechSynthesizer attributesForVoice:v]; 
    return [dict objectForKey:NSVoiceName]; 
}


- (void)comboBoxSelectionDidChange:(NSNotification *)notification {

	if ([notification object] == voicesCombo) {
		NSInteger selected = [voicesCombo indexOfSelectedItem];
		[speech setVoice:[voices objectAtIndex:selected]];
	} else if  ([notification object] == initialTimeCombo) {
		NSInteger selected = [[[initialTimeCombo objectValues] objectAtIndex:[initialTimeCombo indexOfSelectedItem]] intValue];
		[pomodoro setDuration:selected];
		[self showTimeOnStatusBar: selected * 60];
	}
}

#pragma mark ---- Menu management methods ----

-(IBAction)about:(id)sender {
	if (!about) {
		about = [[AboutController alloc] init];
	}
	[about showWindow:self];
}

-(IBAction)setup:(id)sender {
	[prefs makeKeyAndOrderFront:self];
}

-(IBAction)stats:(id)sender {
	[stats showWindow:self];
}

-(IBAction)quit:(id)sender {	
	[NSApp terminate:self];
}


- (void) menuReadyToStart {
	[startPomodoro setEnabled:YES];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}

- (void) menuPomodoroInBreak {
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}

- (void) menuAfterStart {
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:YES];
	[interruptPomodoro setEnabled:YES];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:NO];
	
}

- (void) menuAfterInterrupt {
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:YES];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:YES];
	[setupPomodoro setEnabled:NO];
	
}

- (IBAction) start: (id) sender {
	
	[self menuAfterStart];
	[about close];
	[prefs close];
	
	[pomodoro start];
	
}

- (IBAction) reset: (id) sender {
	
	[self menuReadyToStart];
	[self showTimeOnStatusBar: _initialTime * 60];
	[pomodoro reset];
	
}

- (IBAction) interrupt: (id) sender {
	
	[self menuAfterInterrupt];
	[pomodoro interruptFor: _interruptTime];
	
}

-(IBAction) resume: (id) sender {
	
	[self menuAfterStart];
	[pomodoro resume];
	
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted {
	
	pomoStats.pomodoroStarted++;

	if ([self checkDefault:@"growlAtStartEnabled"])
		[growl growlAlert: [[NSUserDefaults standardUserDefaults] objectForKey:@"growlStart"]  title:@"Pomodoro started"];
	
	if ([self checkDefault:@"speechAtStartEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechStart"]];
}

-(void) pomodoroInterrupted {
	// change icon to interrupt icon
	pomoStats.pomodoroInterruptions++;
	NSString* interruptTimeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"];
	if ([self checkDefault:@"growlAtInterruptEnabled"]) {
		NSString* growlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"growlInterrupt"];
		[growl growlAlert: [growlString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString] title:@"Pomodoro interrupted"];
	}
	
	if ([self checkDefault:@"speechAtInterruptEnabled"]) {
		NSString* speechString = [[NSUserDefaults standardUserDefaults] objectForKey:@"speechInterrupt"];
		[speech startSpeakingString: [speechString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString]];
	}
	
}

-(void) pomodoroInterruptionMaxTimeIsOver {
	
	pomoStats.pomodoroReset++;
	if ([self checkDefault:@"growlAtInterruptOverEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlInterruptOver"] title:@"Pomodoro reset"];
	
	if ([self checkDefault:@"speechAtInterruptOverEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechInterruptOver"]];
	[self menuReadyToStart];
	[self showTimeOnStatusBar: _initialTime * 60];
}

-(void) pomodoroReset {
	
	pomoStats.pomodoroReset++;
	if ([self checkDefault:@"growlAtResetEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlReset"] title:@"Pomodoro reset"];
	
	if ([self checkDefault:@"speechAtResetEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechReset"]];
}

-(void) pomodoroResumed {
	
	pomoStats.pomodoroResumes++;
	if ([self checkDefault:@"growlAtResumeEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlResume"] title:@"Pomodoro resumed"];
	
	if ([self checkDefault:@"speechAtResumeEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechResume"]];
	
}

-(void) breakStarted {
	// change icon to break icon
	[self menuPomodoroInBreak];
}

-(void) breakFinished {

	[self menuReadyToStart];
	
	if ([self checkDefault:@"growlAtBreakFinishedEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlBreakFinished"] title:@"Pomodoro break finished"];
	
	if ([self checkDefault:@"speechAtBreakFinishedEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechBreakFinished"]];
	
	if ([self checkDefault:@"ringAtBreakEnabled"]) {
		[ringing play];
	}
	[self showTimeOnStatusBar: _initialTime * 60];
}

-(void) pomodoroFinished {
	[self menuReadyToStart];
	pomoStats.pomodoroDone++;
	[stats.pomos add:self];

	if ([self checkDefault:@"ringAtEndEnabled"]) {
		[ringing play];
	}
	
	if ([self checkDefault:@"growlAtEndEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEnd"] title:@"Pomodoro finished"];
	
	if ([self checkDefault:@"speechAtEndEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEnd"]];
	
	if ([self checkDefault:@"breakEnabled"]) {
		NSInteger time = _breakTime;
		if (([self checkDefault:@"longbreakEnabled"]) && ((pomoStats.pomodoroDone % 4) == 0)) {
			time = _longbreakTime;
		}

		[self showTimeOnStatusBar: time * 60];
		[pomodoro breakFor:time];
	} else {
		[self showTimeOnStatusBar: _initialTime * 60];
	}

}

- (void) oncePerSecondBreak:(NSInteger) time {
	[self showTimeOnStatusBar: time];
}

- (void) oncePerSecond:(NSInteger) time {
	[self showTimeOnStatusBar: time];
	NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%d", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%d", time/60];
	
	if (timePassed%(60 * _growlEveryTimeMinutes) == 0 && time!=0) {	
		if ([self checkDefault:@"growlAtEveryEnabled"]) {
			NSString* msg = [[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEveryTimeMinutes"]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[growl growlAlert:msg title:@"Pomodoro ticking"];
		}
	}
	
	if (timePassed%(60 * _speechEveryTimeMinutes) == 0 && time!=0) {		
		if ([self checkDefault:@"speechAtEveryEnabled"]) {
			NSString* msg = [[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[speech startSpeakingString:msg];
		}
	}
}

#pragma mark ---- Lifecycle methods ----

+ (void)initialize
{ 
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary]; 
	
	[defaultValues setObject: @"25" forKey:@"initialTime"];
	[defaultValues setObject: @"15" forKey:@"interruptTime"];
	[defaultValues setObject: @"2" forKey:@"growlEveryTimeMinutes"];
	[defaultValues setObject: @"5" forKey:@"speechEveryTimeMinutes"];
	[defaultValues setObject: @"5" forKey:@"breakTime"];
	[defaultValues setObject: @"10" forKey:@"longbreakTime"];

	[defaultValues setObject:@"Have a great pomodoro!" forKey:@"growlStart"];
	[defaultValues setObject:@"Ready, set, go" forKey:@"speechStart"];
	[defaultValues setObject:@"You have $secs seconds to resume" forKey:@"growlInterrupt"];
	[defaultValues setObject:@"You have $secs seconds to resume" forKey:@"speechInterrupt"];
	[defaultValues setObject:@"... interruption max time is over, sorry!" forKey:@"growlInterruptOver"];
	[defaultValues setObject:@"interruption over, sorry" forKey:@"speechInterruptOver"];
	[defaultValues setObject:@"Not a good one? Just try again!" forKey:@"growlReset"];
	[defaultValues setObject:@"Try again" forKey:@"speechReset"];
	[defaultValues setObject:@"... and we're back!" forKey:@"growlResume"];
	[defaultValues setObject:@"... and we're back!" forKey:@"speechResume"];
	[defaultValues setObject:@"Great! A full pomodoro!" forKey:@"growlEnd"];
	[defaultValues setObject:@"Well done!" forKey:@"speechEnd"];
	[defaultValues setObject:@"Other $mins minutes passed by. $passed total minutes spent." forKey:@"growlEvery"];
	[defaultValues setObject:@"$time minutes to go" forKey:@"speechEvery"];
	[defaultValues setObject:@"Ready for another one?" forKey:@"growlBreakFinished"];
	[defaultValues setObject:@"Ready for next one?" forKey:@"speechBreakFinished"];

	[defaultValues setObject:@"Alex" forKey:@"defaultVoice"];
	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"breakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"longbreakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtStartEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtInterruptEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtInterruptOverEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtInterruptOverEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtResetEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtResetEnabled"];	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtResumeEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtResumeEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"ringAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"ringAtBreakEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtEndEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"growlAtEveryEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:@"speechAtEveryEnabled"];	
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"growlAtBreakFinishedEnabled"];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:@"speechAtBreakFinishedEnabled"];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	
} 

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
    NSError *error;
    int reply = NSTerminateNow;
	if (stats != nil) {
		if (stats.managedObjectContext != nil) {
			if ([stats.managedObjectContext commitEditing]) {
				if ([stats.managedObjectContext hasChanges] && ![stats.managedObjectContext save:&error]) {
					NSLog(@"Save failed.");
				}
			}
		}
	}
    
    return reply;
}

- (void)awakeFromNib {
	
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
	
	NSBundle *bundle = [NSBundle mainBundle];
	pomodoroImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoro" ofType:@"png"]];
	ringing = [NSSound soundNamed:@"ring.wav"];
	[statusItem setImage:pomodoroImage];
	//[statusItem setAlternateImage:pomodoroImage]; alternate image
	speech = [[NSSpeechSynthesizer alloc] init]; 
	voices = [[NSSpeechSynthesizer availableVoices] retain];
	
	startPomodoro = [pomodoroMenu itemWithTitle:@"Start pomodoro"];
	interruptPomodoro = [pomodoroMenu itemWithTitle:@"Interrupt pomodoro"];
	invalidatePomodoro = [pomodoroMenu itemWithTitle:@"Reset pomodoro"];
	resumePomodoro = [pomodoroMenu itemWithTitle:@"Resume pomodoro"];
	setupPomodoro = [pomodoroMenu itemWithTitle:@"Pomodoro setup"];
		
	[statusItem setToolTip:@"Pomodoro Time Management"];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:pomodoroMenu];
	[self showTimeOnStatusBar: _initialTime * 60];
	
	growl = [[[GrowlNotifier alloc] init] retain];
	NSString* voice = [NSString stringWithFormat:@"com.apple.speech.synthesis.voice.%@", _speechVoice];
	[speech setVoice: [voice stringByReplacingOccurrencesOfString:@" " withString:@""]];
	
	pomodoro = [[[Pomodoro alloc] initWithDuration: _initialTime] retain];
	pomoStats = [[PomodoroStats alloc] init];
	stats = [[StatsController alloc] init];
	[stats window];
	[pomodoro setDelegate: self];
	
}

-(void)dealloc {

	[about release];
	[stats release];
	
    [statusItem release];
	[prefs release];
	[pomodoroMenu release];
	[voicesCombo release];
	[initialTimeCombo release];
	[voices release];

	[startPomodoro release];
	[interruptPomodoro release];
	[invalidatePomodoro release];
	[resumePomodoro release];
	[setupPomodoro release];
	
	[pomodoroImage release];
	[ringing release];
	[speech release];
	
	[growl release];
	[pomodoro release];
	
	[super dealloc];
}

@end
