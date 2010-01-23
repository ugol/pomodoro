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
#import "Binder.h"
#import "PomodoroStats.h"
#import "PomodoroDefaults.h"
#import "AboutController.h"
#import "StatsController.h"
#import "Carbon/Carbon.h"
#import "SystemUIPlugin.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"

@implementation PomodoroController

@synthesize startPomodoro, invalidatePomodoro, interruptPomodoro,  resumePomodoro;

#pragma mark - Shortcut recorder callbacks & support


- (void)switchKey: (NSString*)name forKey:(PTHotKey**)key withMethod:(SEL)method withRecorder:(SRRecorderControl*)recorder {
	
	//NSLog(@"Switch Key %@", *key);
	
	if (*key != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: *key];
		[*key release];
		*key = nil;
	}
	
	//NSLog(@"Code %d flags: %u, PT flags: %u", [recorder keyCombo].code, [recorder keyCombo].flags, [recorder cocoaToCarbonFlags: [recorder keyCombo].flags]);
		
	*key = [[[PTHotKey alloc] initWithIdentifier:name keyCombo:[PTKeyCombo keyComboWithKeyCode:[recorder keyCombo].code modifiers:[recorder cocoaToCarbonFlags: [recorder keyCombo].flags]]] retain];
	[*key setTarget: self];
	[*key setAction: method];
	[[PTHotKeyCenter sharedCenter] registerHotKey: *key];
	
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithShort:[recorder keyCombo].code] forKey:[NSString stringWithFormat:@"%@%@", name, @"Code"]];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithUnsignedInteger:[recorder keyCombo].flags] forKey:[NSString stringWithFormat:@"%@%@", name, @"Flags"]];
	
}

- (void)shortcutRecorder:(id)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {

	if (aRecorder == muteRecorder) {
		[self switchKey:@"mute" forKey:&muteKey withMethod:@selector(keyMute) withRecorder:aRecorder];
	} else if (aRecorder == startRecorder) {
		[self switchKey:@"start" forKey:&startKey withMethod:@selector(keyStart) withRecorder:aRecorder];
	} else if (aRecorder == resetRecorder) {
		[self switchKey:@"reset" forKey:&resetKey withMethod:@selector(keyReset) withRecorder:aRecorder];
	} else if (aRecorder == interruptRecorder) {
		[self switchKey:@"interrupt" forKey:&interruptKey withMethod:@selector(keyInterrupt) withRecorder:aRecorder];
	} else if (aRecorder == resumeRecorder) {
		[self switchKey:@"resume" forKey:&resumeKey withMethod:@selector(keyResume) withRecorder:aRecorder];
	} 
}

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
	[[NSUserDefaults standardUserDefaults] synchronize];
}		

- (NSString*) bindCommonVariables:(NSString*)name {
	NSArray* variables = [NSArray arrayWithObjects:@"$pomodoroName", @"$duration", nil];
	NSString* durationString = [NSString stringWithFormat:@"%d", pomodoro.duration];

	NSArray* values = [NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"], durationString, nil];
	return [Binder substituteDefault:name withVariables:variables andValues:values];
}	

#pragma mark ---- Open panel delegate methods ----

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel 
             returnCode:(int)returnCode 
            contextInfo:(void *)x 
{ 
    if (returnCode == NSOKButton) { 
		NSButton* sender = (NSButton*)x;
		NSString *path = [openPanel filename]; 
		NSString *script = [[NSString alloc] initWithContentsOfFile:path];
		NSTextView* textView = [textViews objectAtIndex:[sender tag]];
		[textView setString:script];
		[script release];
				
    } 
} 

/*
- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename {
	//NSLog(filename);
	// should return YES only for applescript files
	return YES;
}
 */

- (IBAction)showOpenPanel:(id)sender 
{ 
    NSOpenPanel *panel = [NSOpenPanel openPanel]; 
	[panel setDelegate:self];
    [panel beginSheetForDirectory:nil 
                             file:nil 
							types: [NSArray arrayWithObject:@"pomo"]
                   modalForWindow:prefs 
                    modalDelegate:self 
                   didEndSelector: 
	 @selector(openPanelDidEnd:returnCode:contextInfo:) 
                      contextInfo:sender]; 
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

-(void) keyMute {
	BOOL muteState = ![self checkDefault:@"mute"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:muteState] forKey:@"mute"];
	//NSMenuItem* muteMenu = [pomodoroMenu itemWithTitle:@"Mute all Sounds"];
	//[muteMenu setState:muteState];
}

-(void) keyStart {
	if ([self.startPomodoro isEnabled]) [self start:nil];
}

-(void) keyReset {
	if ([self.invalidatePomodoro isEnabled]) [self reset:nil];
}

-(void) keyInterrupt {
	if ([self.interruptPomodoro isEnabled]) [self interrupt:nil];
}

-(void) keyResume {
	if ([self.resumePomodoro isEnabled]) [self resume:nil];
}

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
	[statusItem setAlternateImage:pomodoroNegativeImage];
	[startPomodoro setEnabled:YES];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}

- (void) menuReadyToStartDuringBreak {
	[statusItem setImage:pomodoroBreakImage];
	[statusItem setAlternateImage:pomodoroNegativeBreakImage];
	[startPomodoro setEnabled:YES];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}


- (void) menuPomodoroInBreak {
	[statusItem setImage:pomodoroBreakImage];
	[statusItem setAlternateImage:pomodoroNegativeBreakImage];
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:NO];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
}

- (void) menuAfterStart {
	[statusItem setImage:pomodoroImage];
	[statusItem setAlternateImage:pomodoroNegativeImage];
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:YES];
	[interruptPomodoro setEnabled:YES];
	[resumePomodoro setEnabled:NO];
	[setupPomodoro setEnabled:YES];
	
}

- (void) menuAfterInterrupt {
	[statusItem setImage:pomodoroFreezeImage];
	[statusItem setAlternateImage:pomodoroNegativeFreezeImage];
	[startPomodoro setEnabled:NO];
	[invalidatePomodoro setEnabled:YES];
	[interruptPomodoro setEnabled:NO];
	[resumePomodoro setEnabled:YES];
	[setupPomodoro setEnabled:YES];
	
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
		if (![prefs makeFirstResponder:prefs]) {
			[prefs endEditingFor:nil];
		}
		[prefs close];
		
		if ([self checkDefault:@"enableTwitter"]) {			
			NSString* user = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUser"];
			NSString* pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterPwd"];
			[twitterEngine setUsername:user password:pwd];			
		}
		
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
	NSString* name = [NSString stringWithFormat:@"%@%@", @"Working on: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"]];
	[statusItem setToolTip:name];

	if ([self checkDefault:@"growlAtStartEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyStartEnabled"];
		[growl growlAlert: [self bindCommonVariables:@"growlStart"]  title:@"Pomodoro started" sticky:sticky];
	}
	
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtStartEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechStart"]];
	}
	
	if ([self checkDefault:@"scriptAtStartEnabled"]) {	
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptStart"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtStartEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterStart"]];
	}
	
}

-(void) pomodoroInterrupted {
	pomoStats.pomodoroInterruptions++;
	NSString* name = [NSString stringWithFormat:@"%@%@", @"Interrupted: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"] ];
	[statusItem setToolTip:name];
	
	NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	if ([self checkDefault:@"growlAtInterruptEnabled"]) {

		NSString* growlString = [self bindCommonVariables:@"growlInterrupt"];		
		[growl growlAlert: [growlString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString] title:@"Pomodoro interrupted"];
	}
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtInterruptEnabled"]) {
		NSString* speechString = [self bindCommonVariables:@"speechInterrupt"];
		[speech startSpeakingString: [speechString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString]];
	}
	
	
	if ([self checkDefault:@"scriptAtInterruptEnabled"]) {		
		NSString* scriptString = [[self bindCommonVariables:@"scriptInterrupt"] stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString];
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:scriptString] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
}

-(void) pomodoroInterruptionMaxTimeIsOver {
	NSString* name = [NSString stringWithFormat:@"%@%@%@", @"Last: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"], @" (interrupted)"];
	[statusItem setToolTip:name];
	pomoStats.pomodoroReset++;
	if ([self checkDefault:@"growlAtInterruptOverEnabled"])
		[growl growlAlert:[self bindCommonVariables:@"growlInterruptOver"] title:@"Pomodoro reset"];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtInterruptOverEnabled"])
		[speech startSpeakingString:[self bindCommonVariables:@"speechInterruptOver"]];
	
	if ([self checkDefault:@"scriptAtInterruptOverEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptInterruptOver"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	[self menuReadyToStart];
	[self showTimeOnStatusBar: _initialTime * 60];
}

-(void) pomodoroReset {

	NSString* name = [NSString stringWithFormat:@"%@%@%@", @"Last: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"], @" (reset)"];
	[statusItem setToolTip:name];
	pomoStats.pomodoroReset++;
	if ([self checkDefault:@"growlAtResetEnabled"])
		[growl growlAlert:[self bindCommonVariables:@"growlReset"] title:@"Pomodoro reset"];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtResetEnabled"])
		[speech startSpeakingString:[self bindCommonVariables:@"speechReset"]];
	
	if ([self checkDefault:@"scriptAtResetEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptReset"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtResetEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterReset"]];
	}
}

-(void) pomodoroResumed {
	NSString* name = [NSString stringWithFormat:@"%@%@", @"Working on: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"]];
	[statusItem setToolTip:name];
	[statusItem setImage:pomodoroImage];
	pomoStats.pomodoroResumes++;
	if ([self checkDefault:@"growlAtResumeEnabled"])
		[growl growlAlert:[self bindCommonVariables:@"growlResume"] title:@"Pomodoro resumed"];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtResumeEnabled"])
		[speech startSpeakingString:[self bindCommonVariables:@"speechResume"]];
	
	if ([self checkDefault:@"scriptAtResumeEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptResume"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
}

-(void) breakStarted {
	NSString* name = [NSString stringWithFormat:@"%@%@", @"Break after: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"]];
	[statusItem setToolTip:name];
	if ([self checkDefault:@"canRestartAtBreak"]) {	
		[self menuReadyToStartDuringBreak];
	} else {
		[self menuPomodoroInBreak];
	}
}

-(void) breakFinished {
	
	NSString* name = [NSString stringWithFormat:@"%@%@", @"Just finished: ", [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"]];
	[statusItem setToolTip:name];

	[self menuReadyToStart];
	
	if ([self checkDefault:@"growlAtBreakFinishedEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyBreakFinishedEnabled"];
		[growl growlAlert:[self bindCommonVariables:@"growlBreakFinished"] title:@"Pomodoro break finished" sticky:sticky];
	}
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtBreakFinishedEnabled"])
		[speech startSpeakingString:[self bindCommonVariables:@"speechBreakFinished"]];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"ringAtBreakEnabled"]) {
		[ringingBreak play];
	}
	
	if ([self checkDefault:@"scriptAtBreakFinishedEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptBreakFinished"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtBreakFinishedEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterBreakFinished"]];
	}
	
	[self showTimeOnStatusBar: _initialTime * 60];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"autoPomodoroRestart"]) {
		[self start:nil];
	}
}

-(void) pomodoroFinished {
	[self menuReadyToStart];
	pomoStats.pomodoroDone++;
	[stats.pomos add:self];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"ringAtEndEnabled"]) {
		[ringing play];
	}
	
	if ([self checkDefault:@"growlAtEndEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyEndEnabled"];
		[growl growlAlert:[self bindCommonVariables:@"growlEnd"] title:@"Pomodoro finished" sticky:sticky];
	}
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtEndEnabled"])
		[speech startSpeakingString:[self bindCommonVariables:@"speechEnd"]];
	
	if ([self checkDefault:@"scriptAtEndEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptEnd"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"enableTwitter"] && [self checkDefault:@"twitterAtEndEnabled"]) {
		[twitterEngine sendUpdate:[self bindCommonVariables:@"twitterEnd"]];
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
	if (![self checkDefault:@"mute"] && [self checkDefault:@"tickAtBreakEnabled"]) {
		[tick play];
	}
}

- (void) oncePerSecond:(NSInteger) time {
	[self showTimeOnStatusBar: time];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"tickEnabled"]) {
		//NSLog(@"Tick volume: %f", tick.volume); 
		[tick play];
	}
	NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%d", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%d", time/60];
	
	if (timePassed%(60 * _growlEveryTimeMinutes) == 0 && time!=0) {	
		if ([self checkDefault:@"growlAtEveryEnabled"]) {
			NSString* msg = [[self bindCommonVariables:@"growlEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[growl growlAlert:msg title:@"Pomodoro ticking"];
		}
	}
	
	if (timePassed%(60 * _speechEveryTimeMinutes) == 0 && time!=0) {		
		if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtEveryEnabled"]) {
			NSString* msg = [[self bindCommonVariables:@"speechEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[speech startSpeakingString:msg];
		}
	}
	
	if (timePassed%(60 * _scriptEveryTimeMinutes) == 0 && time!=0) {		
		if ([self checkDefault:@"scriptAtEveryEnabled"]) {		
			NSString* msg = [[self bindCommonVariables:@"scriptEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:msg] autorelease];
			[playScript executeAndReturnError:nil];
		}
	}
}

#pragma mark ---- MGTwitterEngineDelegate methods ----

- (void)requestSucceeded:(NSString *)requestIdentifier {
    NSLog(@"Request succeeded (%@)", requestIdentifier);
	if ([self checkDefault:@"enableTwitter"]) {
		[twitterTest setEnabled:YES];
	}
	[twitterStatus setImage:greenButtonImage];
	[twitterProgress stopAnimation:self];
}


- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
    NSLog(@"Twitter request failed! (%@) Error: %@ (%@)", 
          requestIdentifier, 
          [error localizedDescription], 
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	if ([self checkDefault:@"enableTwitter"]) {
		[twitterTest setEnabled:YES];
	}
	[twitterStatus setImage:redButtonImage];
	[twitterProgress stopAnimation:self];
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier {}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier {}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier {}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier {}

- (void)imageReceived:(NSImage *)image forRequest:(NSString *)identifier {}

-(IBAction) testTwitterConnection: (id) sender {
	NSLog(@"Testing twitter connection");
	NSString* user = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterUser"];
	NSString* pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterPwd"];
	[twitterEngine setUsername:user password:pwd];
	[twitterEngine testService];
	[twitterTest setEnabled:NO];
	[twitterStatus setImage:nil];
	[twitterProgress startAnimation:self];
}

#pragma mark ---- Lifecycle methods ----

+ (void)initialize { 
    
//	PercentageTransformer *volumeTransformer = [[[PercentageTransformer alloc] init] autorelease];	
//	[NSValueTransformer setValueTransformer:volumeTransformer
//									forName:@"PercentageTransformer"];

	[PomodoroDefaults setDefaults];
	
} 


- (void) updateShortcuts {
	
	NSString* muteCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"muteCode"];
	NSString* muteFlags = [[NSUserDefaults standardUserDefaults] objectForKey:@"muteFlags"];
	NSString* startCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"startCode"];
	NSString* startFlags = [[NSUserDefaults standardUserDefaults] objectForKey:@"startFlags"];
	NSString* resetCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"resetCode"];
	NSString* resetFlags = [[NSUserDefaults standardUserDefaults] objectForKey:@"resetFlags"];
	NSString* interruptCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"interruptCode"];
	NSString* interruptFlags = [[NSUserDefaults standardUserDefaults] objectForKey:@"interruptFlags"];
	NSString* resumeCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"resumeCode"];
	NSString* resumeFlags = [[NSUserDefaults standardUserDefaults] objectForKey:@"resumeFlags"];
	
	[muteRecorder setKeyCombo:SRMakeKeyCombo([muteCode intValue], [muteFlags intValue])];
	[startRecorder setKeyCombo:SRMakeKeyCombo([startCode intValue], [startFlags intValue])];
	[resetRecorder setKeyCombo:SRMakeKeyCombo([resetCode intValue], [resetFlags intValue])];
	[interruptRecorder setKeyCombo:SRMakeKeyCombo([interruptCode intValue], [interruptFlags intValue])];
	[resumeRecorder setKeyCombo:SRMakeKeyCombo([resumeCode intValue], [resumeFlags intValue])];
	
}

-(IBAction) resetDefaultValues: (id) sender {
	
	[PomodoroDefaults removeDefaults];
	[self updateShortcuts];
	[self showTimeOnStatusBar: _initialTime * 60];
		
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
	
    int reply = NSTerminateNow;
	[self saveState];
	if (![prefs makeFirstResponder:prefs]) {
		[prefs endEditingFor:nil];
	}
	[prefs close];
    return reply;
	
}

- (void)awakeFromNib {
	
	NSBundle *bundle = [NSBundle mainBundle];
	
	statusItem = [[[NSStatusBar systemStatusBar] 
				   statusItemWithLength:NSVariableStatusItemLength]
				  retain];
	//statusItem = [[PomodoroMenuExtra alloc] initWithBundle:bundle];
	//statusItem = [[[NSMenuExtra alloc] initWithBundle:bundle] retain];

	pomodoroImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoro" ofType:@"png"]];
	pomodoroBreakImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoroBreak" ofType:@"png"]];
	pomodoroFreezeImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoroFreeze" ofType:@"png"]];
	pomodoroNegativeImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoro_n" ofType:@"png"]];
	pomodoroNegativeBreakImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoroBreak_n" ofType:@"png"]];
	pomodoroNegativeFreezeImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"pomodoroFreeze_n" ofType:@"png"]];
	redButtonImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"red" ofType:@"png"]];
	greenButtonImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"green" ofType:@"png"]];
	ringing = [NSSound soundNamed:@"ring.wav"];
	ringingBreak = [NSSound soundNamed:@"ring.wav"];
	tick = [NSSound soundNamed:@"tick.wav"];
	[statusItem setImage:pomodoroImage];
	[statusItem setAlternateImage:pomodoroNegativeImage];
	
	speech = [[NSSpeechSynthesizer alloc] init]; 
	voices = [[NSSpeechSynthesizer availableVoices] retain];
	textViews = [[NSArray arrayWithObjects:startScriptText, interruptScriptText, interruptOverScriptText, resetScriptText, resumeScriptText, endScriptText, breakScriptText, everyScriptText, nil ] retain];
	
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
	
	startPomodoro = [pomodoroMenu itemWithTitle:@"Start Pomodoro"];
	interruptPomodoro = [pomodoroMenu itemWithTitle:@"Interrupt Pomodoro"];
	invalidatePomodoro = [pomodoroMenu itemWithTitle:@"Reset Pomodoro"];
	resumePomodoro = [pomodoroMenu itemWithTitle:@"Resume Pomodoro"];
	setupPomodoro = [pomodoroMenu itemWithTitle:@"Preferences..."];
		
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

	[self updateShortcuts];

	

	[pomodoro setDelegate: self];
	GetCurrentProcess(&psn);
	
	[self observeUserDefault:@"ringVolume"];
	[self observeUserDefault:@"ringBreakVolume"];
	[self observeUserDefault:@"tickVolume"];
	[self observeUserDefault:@"voiceVolume"];
	
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
		
}

-(void)dealloc {

	[about release];
	[stats release];
	
	[muteKey release];
	[startKey release];
	[resetKey release];
	[interruptKey release];
	[resumeKey release];
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
	[twitterEngine release];
	[twitterTest release];
	[twitterProgress release];
	
	[super dealloc];
}

@end
