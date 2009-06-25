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
#import "PomodoroDefaults.h"
#import "AboutController.h"
#import "StatsController.h"
#import "Carbon/Carbon.h"

#pragma mark ---- HotKey Function (Carbon) ----

OSStatus hotKey(EventHandlerCallRef nextHandler,EventRef anEvent,
						 void *userData)
{
		
	PomodoroController* controller = (PomodoroController*)userData;
	
	EventHotKeyID hkRef;	
    GetEventParameter(anEvent,kEventParamDirectObject,typeEventHotKeyID,NULL,sizeof(hkRef),NULL,&hkRef);

    switch (hkRef.id) {
		case 1: 			
			if ([controller.startPomodoro isEnabled]) [controller start:nil];
            break;
        case 2:
			if ([controller.invalidatePomodoro isEnabled]) [controller reset:nil];
            break;
        case 3:
			if ([controller.interruptPomodoro isEnabled]) [controller interrupt:nil];
            break;
		case 4:
			if ([controller.resumePomodoro isEnabled]) [controller resume:nil];
            break;
    }
	return noErr;
}

@implementation PomodoroController

@synthesize startPomodoro, invalidatePomodoro, interruptPomodoro,  resumePomodoro;

#pragma mark ---- Helper methods ----

- (void) showTimeOnStatusBar:(NSInteger) time {
	[statusItem setTitle:[NSString stringWithFormat:@" %.2d:%.2d",time/60, time%60]];
}

- (BOOL) checkDefault:(NSString*) property {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:property] boolValue];
}


- (void) saveState {
	NSError *error;
	if (stats != nil) {
		if (stats.managedObjectContext != nil) {
			if ([stats.managedObjectContext commitEditing]) {
				if ([stats.managedObjectContext hasChanges] && ![stats.managedObjectContext save:&error]) {
					NSLog(@"Save failed.");
				}
			}
		}
	}
}

- (void) installGlobalHotKeyHandler {
	
	EventHotKeyRef gMyHotKeyRef;
	
	EventHotKeyID startKey;
	EventHotKeyID resetKey;
	EventHotKeyID interruptKey;
	EventHotKeyID resumeKey;
	
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	InstallApplicationEventHandler(&hotKey,1,&eventType,self, NULL);
	
	startKey.signature='strt';
	startKey.id=1;
	RegisterEventHotKey(0x7E, cmdKey+optionKey, startKey,
						GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	resetKey.signature='rest';
	resetKey.id=2;
	RegisterEventHotKey(0x7D, cmdKey+optionKey, resetKey,
						GetApplicationEventTarget(), 0, &gMyHotKeyRef);	
	interruptKey.signature='intr';
	interruptKey.id=3;
	RegisterEventHotKey(0x7B, cmdKey+optionKey, interruptKey,
						GetApplicationEventTarget(), 0, &gMyHotKeyRef);	
	resumeKey.signature='resu';
	resumeKey.id=4;
	RegisterEventHotKey(0x7C, cmdKey+optionKey, resumeKey,
						GetApplicationEventTarget(), 0, &gMyHotKeyRef);	
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
	
- (void)controlTextDidEndEditing:(NSNotification *)aNotification {
	[pomodoro setDuration:_initialTime];
	[self showTimeOnStatusBar: _initialTime * 60];
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

#pragma mark ---- KVO Utility ----

-(void)observeUserDefault:(NSString*) property{
	
	[[NSUserDefaults standardUserDefaults] addObserver:self
											forKeyPath:property
											   options:(NSKeyValueObservingOptionNew |
														NSKeyValueObservingOptionOld)
											   context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
	//NSLog(@"Volume changed at %d for %@", volume, keyPath);
	NSInteger volume = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
	NSInteger oldVolume = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
	
	if (volume != oldVolume) {
		float newVolume = volume/10.0;
		if ([keyPath isEqual:@"ringVolume"]) {
			[ringing setVolume:newVolume];
			[ringing play];
		}
		if ([keyPath isEqual:@"ringBreakVolume"]) {
			[ringingBreak setVolume:newVolume];
			[ringingBreak play];
		}
		if ([keyPath isEqual:@"voiceVolume"]) {
			[speech setVolume:newVolume];
			[speech startSpeakingString:@"Yes"];
		}
		if ([keyPath isEqual:@"tickVolume"]) {
			[tick setVolume:newVolume];
			[tick play];
		}
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
	
	[self saveState];
	[prefs makeKeyAndOrderFront:self];
}

-(IBAction)stats:(id)sender {
	[stats showWindow:self];
}

-(IBAction)quit:(id)sender {	
	[NSApp terminate:self];
}


- (void) menuReadyToStart {
	[statusItem setImage:pomodoroImage];
	[startPomodoro setEnabled:YES];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}

- (void) menuPomodoroInBreak {
	[statusItem setImage:pomodoroBreakImage];
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}

- (void) menuAfterStart {
	[statusItem setImage:pomodoroImage];
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:YES];
	[interruptPomodoro setEnabled:YES];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:NO];
	
}

- (void) menuAfterInterrupt {
	[statusItem setImage:pomodoroFreezeImage];
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:YES];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:YES];
	[setupPomodoro setEnabled:NO];
	
}

- (void) realStart {
	[self menuAfterStart];
	[pomodoro start];	
}

-(IBAction) nameCanceled:(id)sender {
	[namePanel close];
}

-(IBAction) nameGiven:(id)sender {
	[namePanel endEditingFor:nil];
	[namePanel close];
	[self realStart];
}

- (void) setFocusOnPomodoro {
	SetFrontProcess(&psn);
}

- (IBAction) start: (id) sender {
	
	[self saveState];
	if (_initialTime > 0) {
		[about close];
		[prefs endEditingFor:nil];
		[prefs close];
		if ([self checkDefault:@"askBeforeStart"]) {
			[self setFocusOnPomodoro];
			[namePanel makeKeyAndOrderFront:self];
		} else {
			[self realStart];
		}
	}
	
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
	
	//NSLog(@"Speech volume %f", speech.volume);	
	if ([self checkDefault:@"scriptAtStartEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptStart"]];
		[playScript executeAndReturnError:nil];
	}
}

-(void) pomodoroInterrupted {
	pomoStats.pomodoroInterruptions++;
	
	NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	if ([self checkDefault:@"growlAtInterruptEnabled"]) {
		NSString* growlString = [[NSUserDefaults standardUserDefaults] objectForKey:@"growlInterrupt"];
		[growl growlAlert: [growlString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString] title:@"Pomodoro interrupted"];
	}
	
	if ([self checkDefault:@"speechAtInterruptEnabled"]) {
		NSString* speechString = [[NSUserDefaults standardUserDefaults] objectForKey:@"speechInterrupt"];
		[speech startSpeakingString: [speechString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString]];
	}
	
	
	if ([self checkDefault:@"scriptAtInterruptEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptInterrupt"]];
		[playScript executeAndReturnError:nil];
	}
	
}

-(void) pomodoroInterruptionMaxTimeIsOver {
	
	pomoStats.pomodoroReset++;
	if ([self checkDefault:@"growlAtInterruptOverEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlInterruptOver"] title:@"Pomodoro reset"];
	
	if ([self checkDefault:@"speechAtInterruptOverEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechInterruptOver"]];
	
	if ([self checkDefault:@"scriptAtInterruptOverEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptInterruptOver"]];
		[playScript executeAndReturnError:nil];
	}
	
	[self menuReadyToStart];
	[self showTimeOnStatusBar: _initialTime * 60];
}

-(void) pomodoroReset {
	
	pomoStats.pomodoroReset++;
	if ([self checkDefault:@"growlAtResetEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlReset"] title:@"Pomodoro reset"];
	
	if ([self checkDefault:@"speechAtResetEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechReset"]];
	
	if ([self checkDefault:@"scriptAtResetEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptReset"]];
		[playScript executeAndReturnError:nil];
	}
}

-(void) pomodoroResumed {
	[statusItem setImage:pomodoroImage];
	pomoStats.pomodoroResumes++;
	if ([self checkDefault:@"growlAtResumeEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlResume"] title:@"Pomodoro resumed"];
	
	if ([self checkDefault:@"speechAtResumeEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechResume"]];
	
	if ([self checkDefault:@"scriptAtResumeEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptResume"]];
		[playScript executeAndReturnError:nil];
	}
}

-(void) breakStarted {
	[self menuPomodoroInBreak];
}

-(void) breakFinished {
	
	[self menuReadyToStart];
	
	if ([self checkDefault:@"growlAtBreakFinishedEnabled"])
		[growl growlAlert:[[NSUserDefaults standardUserDefaults] objectForKey:@"growlBreakFinished"] title:@"Pomodoro break finished"];
	
	if ([self checkDefault:@"speechAtBreakFinishedEnabled"])
		[speech startSpeakingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"speechBreakFinished"]];
	
	if ([self checkDefault:@"ringAtBreakEnabled"]) {
		[ringingBreak play];
	}
	
	if ([self checkDefault:@"scriptAtBreakFinishedEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptBreakFinished"]];
		[playScript executeAndReturnError:nil];
	}
	
	[self showTimeOnStatusBar: _initialTime * 60];
	if ([self checkDefault:@"autoPomodoroRestart"]) {
		[self start:nil];
	}
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
	
	if ([self checkDefault:@"scriptAtEndEnabled"]) {		
		NSAppleScript *playScript;		
		playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptEnd"]];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"breakEnabled"]) {
		NSInteger time = _breakTime;
		if (([self checkDefault:@"longbreakEnabled"]) && ((pomoStats.pomodoroDone % 4) == 0)) {
			time = _longbreakTime;
		}

		[self showTimeOnStatusBar: time * 60];
		[pomodoro breakFor:time];
	} else {
		[self showTimeOnStatusBar: _initialTime * 60];
		if ([self checkDefault:@"autoPomodoroRestart"]) {
			[self start:nil];
		}
	}

}

- (void) oncePerSecondBreak:(NSInteger) time {
	[self showTimeOnStatusBar: time];
	if ([self checkDefault:@"tickEnabled"]) {
		[tick play];
	}
}

- (void) oncePerSecond:(NSInteger) time {
	[self showTimeOnStatusBar: time];
	if ([self checkDefault:@"tickEnabled"]) {
		//NSLog(@"Tick volume: %f", tick.volume); 
		[tick play];
	}
	NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%d", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%d", time/60];
	
	if (timePassed%(60 * _growlEveryTimeMinutes) == 0 && time!=0) {	
		if ([self checkDefault:@"growlAtEveryEnabled"]) {
			NSString* msg = [[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[growl growlAlert:msg title:@"Pomodoro ticking"];
		}
	}
	
	if (timePassed%(60 * _speechEveryTimeMinutes) == 0 && time!=0) {		
		if ([self checkDefault:@"speechAtEveryEnabled"]) {
			NSString* msg = [[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[speech startSpeakingString:msg];
		}
	}
	
	if (timePassed%(60 * _scriptEveryTimeMinutes) == 0 && time!=0) {		
		if ([self checkDefault:@"scriptAtEveryEnabled"]) {		
			NSAppleScript *playScript;		
			playScript = [[NSAppleScript alloc] initWithSource:[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptEvery"]];
			[playScript executeAndReturnError:nil];
		}
	}
}

#pragma mark ---- Lifecycle methods ----

+ (void)initialize
{ 
    
//	PercentageTransformer *volumeTransformer = [[[PercentageTransformer alloc] init] autorelease];	
//	[NSValueTransformer setValueTransformer:volumeTransformer
//									forName:@"PercentageTransformer"];

	[PomodoroDefaults setDefaults];
	
} 


-(IBAction) resetDefaultValues: (id) sender {
	
	[PomodoroDefaults removeDefaults];
	[self showTimeOnStatusBar: _initialTime * 60];
		
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
    int reply = NSTerminateNow;
	[self saveState];    
    return reply;
	
}


- (void)awakeFromNib {
	
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
	
	NSBundle *bundle = [NSBundle mainBundle];
	pomodoroImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoro" ofType:@"png"]];
	pomodoroBreakImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoroBreak" ofType:@"png"]];
	pomodoroFreezeImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoroFreeze" ofType:@"png"]];
	ringing = [NSSound soundNamed:@"ring.wav"];
	ringingBreak = [NSSound soundNamed:@"ring.wav"];
	tick = [NSSound soundNamed:@"tick.wav"];
	[statusItem setImage:pomodoroImage];
	//[statusItem setAlternateImage:pomodoroImage]; alternate image
	speech = [[NSSpeechSynthesizer alloc] init]; 
	voices = [[NSSpeechSynthesizer availableVoices] retain];
	
	[ringing setVolume:_ringVolume/10.0];
	[ringingBreak setVolume:_ringBreakVolume/10.0];
	[tick setVolume:_tickVolume/10.0];
	[speech setVolume:_voiceVolume/10.0];

	[initialTimeCombo addItemWithObjectValue: [NSNumber numberWithInt:25]];
	[initialTimeCombo addItemWithObjectValue: [NSNumber numberWithInt:30]];
	[initialTimeCombo addItemWithObjectValue: [NSNumber numberWithInt:35]];
	
	[interruptCombo addItemWithObjectValue: [NSNumber numberWithInt:15]];
	[interruptCombo addItemWithObjectValue: [NSNumber numberWithInt:20]];
	[interruptCombo addItemWithObjectValue: [NSNumber numberWithInt:25]];
	[interruptCombo addItemWithObjectValue: [NSNumber numberWithInt:30]];
	[interruptCombo addItemWithObjectValue: [NSNumber numberWithInt:45]];
	
	[breakCombo addItemWithObjectValue: [NSNumber numberWithInt:3]];
	[breakCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
	[breakCombo addItemWithObjectValue: [NSNumber numberWithInt:7]];
	
	[longBreakCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
	[longBreakCombo addItemWithObjectValue: [NSNumber numberWithInt:15]];
	[longBreakCombo addItemWithObjectValue: [NSNumber numberWithInt:20]];

	[growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
	[growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
	[growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];

	[speechEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
	[speechEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
	[speechEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
	
	[scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
	[scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
	[scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
	
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
	
	[self installGlobalHotKeyHandler];

	[pomodoro setDelegate: self];
	GetCurrentProcess(&psn);
	
	[self observeUserDefault:@"ringVolume"];
	[self observeUserDefault:@"ringBreakVolume"];
	[self observeUserDefault:@"tickVolume"];
	[self observeUserDefault:@"voiceVolume"];
		
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
	[pomodoroBreakImage release];
	[pomodoroFreezeImage release];
	
	[ringing release];
	[ringingBreak release];
	[tick release];
	[speech release];
	
	[growl release];
	[pomodoro release];
	
	[super dealloc];
}

@end
