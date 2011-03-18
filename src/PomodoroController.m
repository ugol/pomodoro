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

#import "PomodoroController.h"
#import "GrowlNotifier.h"
#import "Scripter.h"
#import "Pomodoro.h"
#import "Binder.h"
#import "PomodoroDefaults.h"
#import "AboutController.h"
#import "StatsController.h"
#import "SplashController.h"
#import "Carbon/Carbon.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "CalendarController.h"
#import "PomoNotifications.h"

@implementation PomodoroController

@synthesize startPomodoro, invalidatePomodoro, interruptPomodoro, internalInterruptPomodoro, resumePomodoro;

#pragma mark - Shortcut recorder callbacks & support

- (void)switchKey: (NSString*)name forKey:(PTHotKey**)key withMethod:(SEL)method withRecorder:(SRRecorderControl*)recorder {
		
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
	[*key release];
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
	} else if (aRecorder == internalInterruptRecorder) {
		[self switchKey:@"internalInterrupt" forKey:&internalInterruptKey withMethod:@selector(keyInternalInterrupt) withRecorder:aRecorder];
	} else if (aRecorder == resumeRecorder) {
		[self switchKey:@"resume" forKey:&resumeKey withMethod:@selector(keyResume) withRecorder:aRecorder];
	} else if (aRecorder ==quickStatsRecorder) {
		[self switchKey:@"quickStats" forKey:&quickStatsKey withMethod:@selector(keyQuickStats) withRecorder:aRecorder];
	} 
}

- (void) updateShortcuts {
		
	muteKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"muteCode"] intValue];
	muteKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"muteFlags"] intValue];
	startKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startCode"] intValue];
	startKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startFlags"] intValue];
	resetKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resetCode"] intValue];
	resetKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resetFlags"] intValue];
	interruptKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptCode"] intValue];
	interruptKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptFlags"] intValue];
	internalInterruptKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"internalInterruptCode"] intValue];
	internalInterruptKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"internalInterruptFlags"] intValue];
	resumeKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resumeCode"] intValue];
	resumeKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resumeFlags"] intValue];
	quickStatsKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quickStatsCode"] intValue];
	quickStatsKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quickStatsFlags"] intValue];
		
	[muteRecorder setKeyCombo:muteKeyCombo];
	[startRecorder setKeyCombo:startKeyCombo];
	[resetRecorder setKeyCombo:resetKeyCombo];
	[interruptRecorder setKeyCombo:interruptKeyCombo];
	[internalInterruptRecorder setKeyCombo:internalInterruptKeyCombo];
	[resumeRecorder setKeyCombo:resumeKeyCombo];
	[quickStatsRecorder setKeyCombo:quickStatsKeyCombo];
}

- (void) addListToCombo:(NSString*)action {
	
	NSAppleEventDescriptor* result = [scripter executeScript:action];			
	int howMany = [result numberOfItems];
	for (int i=1; i<= howMany; i++) {
		[namesCombo addItemWithObjectValue:[[result descriptorAtIndex:i] stringValue]];		
	}
	
}

#pragma mark ---- Helper methods ----

- (void) showTimeOnStatusBar:(NSInteger) time {	
	if ([self checkDefault:@"showTimeOnStatusEnabled"]) {
		[statusItem setTitle:[NSString stringWithFormat:@" %.2d:%.2d",time/60, time%60]];
	} else {
		[statusItem setTitle:@""];
	}
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

#pragma mark ---- Scripting panel delegate methods ----

- (void)openPanelDidEnd:(NSOpenPanel *)openPanel 
             returnCode:(int)returnCode 
            contextInfo:(void *)x 
{ 
    if (returnCode == NSOKButton) { 
		//NSButton* sender = (NSButton*)x;
		NSString *path = [openPanel filename]; 
		NSString *script = [[NSString alloc] initWithContentsOfFile:path];
		//NSTextView* textView = [textViews objectAtIndex:[sender tag]];
		[scriptView setSource:script];
		[script release];
				
    } 
} 


- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename {
    if ([[filename pathExtension] isEqualTo:@"pomo"] || [[filename pathExtension] isEqualTo:@"applescript"])
        return YES;
    return NO;
}

- (IBAction)showOpenPanel:(id)sender 
{ 
    NSOpenPanel *panel = [NSOpenPanel openPanel]; 
	[panel setDelegate:self];
    [panel beginSheetForDirectory:nil 
                             file:nil 
							types: [NSArray arrayWithObjects:@"pomo", @"applescript",nil]
                   modalForWindow:scriptPanel 
                    modalDelegate:self 
                   didEndSelector: 
	 @selector(openPanelDidEnd:returnCode:contextInfo:) 
                      contextInfo:sender]; 
} 

- (IBAction)showScriptingPanel:(id)sender {
    
    [scriptView unbind:@"data"];
    NSString* scriptToShow = [NSString stringWithFormat:@"values.script%@", [scriptNames objectAtIndex:[sender tag]]];
    [scriptView bind:@"data" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:scriptToShow options:nil];

    [scriptPanel makeKeyAndOrderFront:self];
    
}


#pragma mark ---- Window delegate methods ----


- (void)windowDidResignKey:(NSNotification *)notification {
    
    // Commit Editing still in place when closing a panel or losing focus
    [notification.object makeFirstResponder:nil];

}

#pragma mark ---- Combo box delegate/datasource methods ----

- (void)controlTextDidEndEditing:(NSNotification *)notification {
	[pomodoro setDurationMinutes:_initialTime];
	[self showTimeOnStatusBar: _initialTime * 60];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {

    NSInteger selected = [[[initialTimeCombo objectValues] objectAtIndex:[initialTimeCombo indexOfSelectedItem]] intValue];
    [pomodoro setDurationMinutes:selected];
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:selected] forKey:@"pomodoroDurationMinutes"];
    [self showTimeOnStatusBar: selected * 60];
    
}

#pragma mark ---- KVO Utility ----

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
	//NSLog(@"Volume changed at %d for %@", volume, keyPath); 
	
	if ([keyPath isEqualToString:@"showTimeOnStatusEnabled"]) {		
		[self showTimeOnStatusBar: _initialTime * 60];		
	} else if ([keyPath hasSuffix:@"Volume"]) {
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
			if ([keyPath isEqual:@"tickVolume"]) {
				[tick setVolume:newVolume];
				[tick play];
			}
		}
	}
	
}

#pragma mark ---- Toolbar methods ----

-(IBAction) toolBarIconClicked: (id) sender {
    //NSLog(@"Clicked from %d", [sender tag]);
    [tabView selectTabViewItem:[tabView tabViewItemAtIndex:[sender tag]]];
    
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

-(void) keyInternalInterrupt {
	if ([self.internalInterruptPomodoro isEnabled]) [self internalInterrupt:nil];
}

-(void) keyResume {
	if ([self.resumePomodoro isEnabled]) [self resume:nil];
}

-(void) keyQuickStats {
	
	NSInteger time = pomodoro.time;	
	NSString* quickStats = [NSString stringWithFormat:NSLocalizedString(@"%@ (%.2d:%.2d)\nInterruptions: %d/%d/%d\n\nGlobal Pomodoros: %d/%d/%d\nDaily Pomodoros: %d/%d/%d\nGlobal Interruptions: %d/%d/%d\nDaily Interruptions: %d/%d/%d",@"Quick statistic format string"), 
							_pomodoroName, time/60, time%60, 
							pomodoro.externallyInterrupted, pomodoro.internallyInterrupted, pomodoro.resumed,
							_globalPomodoroStarted, _globalPomodoroDone, _globalPomodoroReset,
							_dailyPomodoroStarted, _dailyPomodoroDone, _dailyPomodoroReset,
							_globalExternalInterruptions, _globalInternalInterruptions, _globalPomodoroResumed,
							_dailyExternalInterruptions, _dailyInternalInterruptions, _dailyPomodoroResumed
							];
	
	[growl growlAlert:quickStats title:NSLocalizedString(@"Quick Statistics",@"Growl header for quick statistics")];
}

-(IBAction)about:(id)sender {
	if (!about) {
		about = [[AboutController alloc] init];
	}
	[about showWindow:self];
}

-(IBAction)help:(id)sender {
	
	if (!splash) {
		splash = [[SplashController alloc] init];
	}
	[splash showWindow:self];
	
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

- (void) updateMenu {
	enum PomoState state = pomodoro.state;
	
	NSImage * image;
	NSImage * alternateImage;
	switch (state) {
		case PomoTicking:
			image = pomodoroImage;
			alternateImage = pomodoroNegativeImage;
			break;
		case PomoInterrupted:
			image = pomodoroFreezeImage;
			alternateImage = pomodoroNegativeFreezeImage;
			break;
		case PomoInBreak:
			image = pomodoroBreakImage;
			alternateImage = pomodoroNegativeBreakImage;
			break;
		default: // PomoReadyToStart
			image = pomodoroImage;
			alternateImage = pomodoroNegativeImage;
			break;
	}
		
	[statusItem setImage:image];
	[statusItem setAlternateImage:alternateImage];
	
	[startPomodoro             setEnabled:(state == PomoReadyToStart) || ((state == PomoInBreak) && [self checkDefault:@"canRestartAtBreak"])];
	[finishPomodoro            setEnabled:(state == PomoTicking)];
	[invalidatePomodoro        setEnabled:(state == PomoTicking) || (state == PomoInterrupted)];
	[interruptPomodoro         setEnabled:(state == PomoTicking)];
	[internalInterruptPomodoro setEnabled:(state == PomoTicking) || (state == PomoInterrupted)];
	[resumePomodoro            setEnabled:(state == PomoInterrupted)];
	[setupPomodoro             setEnabled:YES];
}

- (void) realStart {
	[pomodoro start];	
	[self updateMenu];
}

-(IBAction) nameCanceled:(id)sender {
	[namePanel close];
	NSInteger howMany = [namesCombo numberOfItems];
	if (howMany > 0) {
		[[NSUserDefaults standardUserDefaults] setObject:[namesCombo itemObjectValueAtIndex:howMany-1] forKey:@"pomodoroName"];
	}
}

-(IBAction) nameGiven:(id)sender {
	
    if (![namePanel makeFirstResponder:namePanel]) {
        [namePanel endEditingFor:nil];
    }
	
	NSInteger howMany = [namesCombo numberOfItems];
	NSString* name = _pomodoroName;
	BOOL isNewName = YES;
	NSInteger i = 0;
	while ((isNewName) && (i<howMany)) {
		isNewName = ![name isEqualToString:[namesCombo itemObjectValueAtIndex:i]];
		i++;
	}
	if (isNewName) {
		
		if (!([self checkDefault:@"thingsEnabled"]) && (![self checkDefault:@"omniFocusEnabled"])) {
			if (howMany>15) {
				[namesCombo removeItemAtIndex:0];
			}
			[namesCombo addItemWithObjectValue:name];
		}
		
		if ([self checkDefault:@"thingsEnabled"] && [self checkDefault:@"thingsAddingEnabled"]) {
			[scripter executeScript:@"addTodoToThings" withParameter:name];
		}
		if ([self checkDefault:@"omniFocusEnabled"] && [self checkDefault:@"omniFocusAddingEnabled"]) {
			[scripter executeScript:@"addTodoToOmniFocus" withParameter:name];
		}
	}
	
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
		[splash close];
        if (![scriptPanel makeFirstResponder:scriptPanel]) {
			[scriptPanel endEditingFor:nil];
		}
        [scriptPanel close];
		if (![prefs makeFirstResponder:prefs]) {
			[prefs endEditingFor:nil];
		}
		[prefs close];
        		
		if ([self checkDefault:@"askBeforeStart"]) {
			[self setFocusOnPomodoro];
			if (([self checkDefault:@"thingsEnabled"]) || ([self checkDefault:@"omniFocusEnabled"])) {
				[namesCombo removeAllItems];
			}

			if ([self checkDefault:@"thingsEnabled"]) {
				[self addListToCombo:@"getToDoListFromThings"];
			}			
			if ([self checkDefault:@"omniFocusEnabled"]) {
				[self addListToCombo:@"getToDoListFromOmniFocus"];
			}
			[namePanel makeKeyAndOrderFront:self];
		} else {
			[self realStart];
		}
	}
	
}

- (IBAction) finish: (id) sender {
	[pomodoro finish];
}

- (IBAction) reset: (id) sender {
	[pomodoro reset];
	[self updateMenu];
	[self showTimeOnStatusBar: _initialTime * 60];
	
}

- (IBAction) interrupt: (id) sender {

	[pomodoro interruptFor: _interruptTime];
	[self updateMenu];
	
}

- (IBAction) internalInterrupt: (id) sender {
	
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyInternalInterruptions)+1] forKey:@"dailyInternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalInternalInterruptions)+1] forKey:@"globalInternalInterruptions"];
	[pomodoro internalInterrupt];
	
	if ([self checkDefault:@"growlAtInternalInterruptEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyInternalInterruptEnabled"];
		[growl growlAlert: NSLocalizedString(@"Internal Interruption",@"Growl header for internal interruptions") title:@"Pomodoro" sticky:sticky];
	}
}

-(IBAction) resume: (id) sender {
	
	[pomodoro resume];
	[self updateMenu];
	
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {
	
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroStarted)+1] forKey:@"dailyPomodoroStarted"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroStarted)+1] forKey:@"globalPomodoroStarted"];

	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Working on: %@",@"Tooltip for running Pomodoro"), _pomodoroName];
	[statusItem setToolTip:name];		

	if ([self checkDefault:@"scriptAtStartEnabled"]) {	
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptStart"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
		
	if ([self checkDefault:@"adiumEnabled"]) {
		[scripter executeScript:@"setStatusToPomodoroInAdium"];
	}
	
	if ([self checkDefault:@"ichatEnabled"]) {
		[scripter executeScript:@"setStatusToPomodoroInIChat"];
	}
	
	if ([self checkDefault:@"skypeEnabled"]) {
		[scripter executeScript:@"setStatusToPomodoroInSkype"];
	}
	
}

-(void) pomodoroInterrupted:(NSNotification*) notification {
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyExternalInterruptions)+1] forKey:@"dailyExternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalExternalInterruptions)+1] forKey:@"globalExternalInterruptions"];

	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Interrupted: %@",@"Tooltip for Interruption"), _pomodoroName];
	[statusItem setToolTip:name];
		
    NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	
	if ([self checkDefault:@"scriptAtInterruptEnabled"]) {		
		NSString* scriptString = [[self bindCommonVariables:@"scriptInterrupt"] stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString];
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:scriptString] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Last: %@ (interrupted)",@"Tooltip for interrupt-reseted pomodoros"), _pomodoroName];
	[statusItem setToolTip:name];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroReset)+1] forKey:@"dailyPomodoroReset"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroReset)+1] forKey:@"globalPomodoroReset"];

	if ([self checkDefault:@"scriptAtInterruptOverEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptInterruptOver"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"adiumEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInAdium"];
	}
	
	if ([self checkDefault:@"ichatEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInIChat"];
	}
	
	if ([self checkDefault:@"skypeEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInSkype"];
	}
	
	
	[self updateMenu];
	[self showTimeOnStatusBar: _initialTime * 60];
}

-(void) pomodoroReset:(NSNotification*) notification {

	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Last: %@ (reset)",@"Tooltip for reseted pomodoro"), _pomodoroName];
	[statusItem setToolTip:name];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroReset)+1] forKey:@"dailyPomodoroReset"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroReset)+1] forKey:@"globalPomodoroReset"];
    
	if ([self checkDefault:@"scriptAtResetEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptReset"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"adiumEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInAdium"];
	}
		
	if ([self checkDefault:@"ichatEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInIChat"];
	}
	
	if ([self checkDefault:@"skypeEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInSkype"];
	}
	
	
}

-(void) pomodoroResumed:(NSNotification*) notification {
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Working on: %@",@"Tooltip for running Pomodoro"), _pomodoroName];
	[statusItem setToolTip:name];
	[statusItem setImage:pomodoroImage];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroResumed)+1] forKey:@"dailyPomodoroResumed"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroResumed)+1] forKey:@"globalPomodoroResumed"];
	
	if ([self checkDefault:@"scriptAtResumeEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptResume"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
}

-(void) breakStarted:(NSNotification*) notification {
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Break after: %@",@"Tooltip for break"), _pomodoroName];
	[statusItem setToolTip:name];
	[self updateMenu];
}

-(void) breakFinished:(NSNotification*) notification {
	
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Just finished: %@",@"Tooltip for finished pomodoros"), _pomodoroName];
	[statusItem setToolTip:name];
	
	[self updateMenu];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"ringAtBreakEnabled"]) {
		[ringingBreak play];
	}
	
	if ([self checkDefault:@"scriptAtBreakFinishedEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptBreakFinished"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	[self showTimeOnStatusBar: _initialTime * 60];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"autoPomodoroRestart"]) {
		[self start:nil];
	}
}

-(void) pomodoroFinished:(NSNotification*) notification {
    
    Pomodoro* pomo = [notification object];
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Just finished: %@",@"Tooltip for finished pomodoros"), _pomodoroName];
	[statusItem setToolTip:name];
	
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroDone)+1] forKey:@"dailyPomodoroDone"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroDone)+1] forKey:@"globalPomodoroDone"];
	
	[stats.pomos newPomodoro:lround([pomo lastPomodoroDurationSeconds]/60.0) withExternalInterruptions:[pomo externallyInterrupted] withInternalInterruptions: [pomo internallyInterrupted]];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"ringAtEndEnabled"]) {
		[ringing play];
	}
		
	if ([self checkDefault:@"scriptAtEndEnabled"]) {		
		NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:[self bindCommonVariables:@"scriptEnd"]] autorelease];
		[playScript executeAndReturnError:nil];
	}
	
	if ([self checkDefault:@"adiumEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInAdium"];
	}	
	
	if ([self checkDefault:@"ichatEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInIChat"];
	}
	
	if ([self checkDefault:@"skypeEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInSkype"];
	}
	
	if ([self checkDefault:@"breakEnabled"]) {
		NSInteger time = _breakTime;
		if (([self checkDefault:@"longbreakEnabled"]) && ((_dailyPomodoroDone % _pomodorosForLong) == 0)) {
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
	[self updateMenu];

}

- (void) oncePerSecondBreak:(NSNotification*) notification {
    NSInteger time = [[notification object] integerValue];
	[self showTimeOnStatusBar: time];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"tickAtBreakEnabled"]) {
		[tick play];
	}
}

- (void) oncePerSecond:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
	[self showTimeOnStatusBar: time];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"tickEnabled"]) {
		[tick play];
	}
	NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%d", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%d", time/60];
	
	if (timePassed%(60 * _scriptEveryTimeMinutes) == 0 && time!=0) {		
		if ([self checkDefault:@"scriptAtEveryEnabled"]) {		
			NSString* msg = [[self bindCommonVariables:@"scriptEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			NSAppleScript *playScript = [[[NSAppleScript alloc] initWithSource:msg] autorelease];
			[playScript executeAndReturnError:nil];
		}
	}
}


#pragma mark ---- Lifecycle methods ----

+ (void)initialize { 
    
	[PomodoroDefaults setDefaults];
	
} 


-(IBAction) resetDefaultValues: (id) sender {
	
	[PomodoroDefaults removeDefaults];
	[self updateShortcuts];
	[self showTimeOnStatusBar: _initialTime * 60];
	[self updateMenu];
		
}

-(IBAction) changedCanRestartInBreaks: (id) sender {
	[self updateMenu];	
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
    
    [self registerForAllPomodoroEvents];
    
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];

	pomodoroImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoro" ofType:@"png"]];
	pomodoroBreakImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroBreak" ofType:@"png"]];
	pomodoroFreezeImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroFreeze" ofType:@"png"]];
	pomodoroNegativeImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoro_n" ofType:@"png"]];
	pomodoroNegativeBreakImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroBreak_n" ofType:@"png"]];
	pomodoroNegativeFreezeImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroFreeze_n" ofType:@"png"]];

	ringing = [NSSound soundNamed:@"ring.wav"];
	ringingBreak = [NSSound soundNamed:@"ring.wav"];
	tick = [NSSound soundNamed:@"tick.wav"];
	[statusItem setImage:pomodoroImage];
	[statusItem setAlternateImage:pomodoroNegativeImage];
		
	[ringing setVolume:_ringVolume/10.0];
	[ringingBreak setVolume:_ringBreakVolume/10.0];
	[tick setVolume:_tickVolume/10.0];

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
	
	[pomodorosForLong addItemWithObjectValue: [NSNumber numberWithInt:4]];
	[pomodorosForLong addItemWithObjectValue: [NSNumber numberWithInt:6]];
	[pomodorosForLong addItemWithObjectValue: [NSNumber numberWithInt:8]];
	
	[scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
	[scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
	[scriptEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
		
	[statusItem setToolTip:NSLocalizedString(@"Pomodoro Time Management",@"Status Tooltip")];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:pomodoroMenu];
	[self showTimeOnStatusBar: _initialTime * 60];

    scriptNames = [[NSArray arrayWithObjects:@"Start",@"Interrupt",@"InterruptOver", @"Reset", @"Resume", @"End", @"BreakFinished", @"Every", nil] retain];
	
    [toolBar setSelectedItemIdentifier:@"Pomodoro"];

    [pomodoro setDurationMinutes:_initialTime];
    pomodoroNotifier = [[[PomodoroNotifier alloc] init] retain];
	[pomodoro setDelegate: pomodoroNotifier];

    [calendar initCalendars];
    
	stats = [[StatsController alloc] init];
	[stats window];

	[self updateShortcuts];

	GetCurrentProcess(&psn);
    
	[self observeUserDefault:@"ringVolume"];
	[self observeUserDefault:@"ringBreakVolume"];
	[self observeUserDefault:@"tickVolume"];
	
	[self observeUserDefault:@"showTimeOnStatusEnabled"];
	
	if ([self checkDefault:@"showSplashScreenAtStartup"]) {
		[self help:nil];
	}	
		
}

-(void)dealloc {

	[about release];
    [splash release];
	[stats release];
    [toolBar release];
	
	[muteKey release];
	[startKey release];
	[resetKey release];
	[interruptKey release];
    [internalInterruptKey release];
	[resumeKey release];
	[quickStatsKey release];
	
    [statusItem release];
	[prefs release];
    [scriptPanel release];
    [scriptView release];
	[pomodoroMenu release];
	[initialTimeCombo release];

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
	
    [scriptNames release];
	
	[super dealloc];
}

@end
