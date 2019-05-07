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
#import "Pomodoro.h"
#import "Binder.h"
#import "PomodoroDefaults.h"
#import "AboutController.h"
#import "StatsController.h"
#import "SplashController.h"
#import "ShortcutController.h"
#import "PomodoroNotifier.h"
#import "PomoNotifications.h"
#include <CoreServices/CoreServices.h>

@implementation PomodoroController

@synthesize startPomodoro, finishPomodoro, invalidatePomodoro, interruptPomodoro, internalInterruptPomodoro, resumePomodoro;
@synthesize pomodoro, longBreakCounter, longBreakCheckerTimer;
@synthesize prefs, scriptPanel, namePanel, namesCombo, breakCombo, initialTimeCombo, interruptCombo, longBreakCombo, longBreakResetComboTime, pomodorosForLong;
@synthesize pomodoroMenu, tabView, toolBar;

#pragma mark ---- Helper methods ----

- (void) showTimeOnStatusBar:(NSInteger) time {
    if ([self checkDefault:@"showTimeOnStatusEnabled"]) {
        if ([self checkDefault:@"showTimeWithSeconds"]) {
            //NSLog(@"---------- time %2ld",time);
            [statusItem setTitle:[NSString stringWithFormat:@" %.2ld:%.2ld",time/60, time%60]];
         } else {
            [statusItem setTitle:[NSString stringWithFormat:@" %.2ld",time/60]];
        }
    } else {
        //give enough space
        [statusItem setTitle:@"      "];
    }
}

- (void) longBreakCheckerFinished {
    
    longBreakCounter = 0;
    longBreakCheckerTimer = nil;
    
}

- (void)updateNamesComboData {
    
    NSInteger howMany = [namesCombo numberOfItems];
    NSString* name = _timerName;
    BOOL isNewName = YES;
    NSInteger i = 0;
    while ((isNewName) && (i<howMany)) {
        isNewName = ![name isEqualToString:[namesCombo itemObjectValueAtIndex:i]];
        i++;
    }
    if (isNewName) {
        
        if (howMany>15) {
            [namesCombo removeItemAtIndex:0];
        }
        [namesCombo addItemWithObjectValue:name];
        
    }
}

#pragma mark ---- Window delegate methods ----


- (void)windowDidResignKey:(NSNotification *)notification {
    
    // Commit Editing still in place when closing a panel or losing focus
    [notification.object makeFirstResponder:nil];

}

#pragma mark ---- KVO Utility ----

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

	if ([keyPath isEqualToString:@"showTimeOnStatusEnabled"]) {
		[self showTimeOnStatusBar: _initialTime * 60];
	} else if ([keyPath isEqualToString:@"showTimeWithSeconds"]) {
		[self showTimeOnStatusBar: _initialTime * 60];
	} else if ([keyPath isEqualToString:@"initialTime"]) {
        NSInteger duration = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        [pomodoro setDurationMinutes:duration];
        [self showTimeOnStatusBar: duration * 60];
        
    } else if ([keyPath hasSuffix:@"Volume"]) {
        NSInteger volume = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        NSInteger oldVolume = 0;
        if([NSNull null] != [change objectForKey:NSKeyValueChangeOldKey])
        {
            oldVolume = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        }

		if (volume != oldVolume) {
			float newVolume = volume/100.0;
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


#pragma mark ---- Key management methods ----

-(void) keyMute {
	BOOL muteState = ![self checkDefault:@"mute"];
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:muteState] forKey:@"mute"];
}

-(void) keyStart {
    if ([self.startPomodoro isEnabled]) [self start:nil];
}

-(void) keyReset {
	if ([self.invalidatePomodoro isEnabled]) [self reset:nil];
}

-(void) keyInterrupt {
	if ([self.interruptPomodoro isEnabled]) [self externalInterrupt:nil];
}

-(void) keyInternalInterrupt {
	if ([self.internalInterruptPomodoro isEnabled]) [self internalInterrupt:nil];
}

-(void) keyResume {
	if ([self.resumePomodoro isEnabled]) [self resume:nil];
}

-(void) keyQuickStats {
	
	[self quickStats:nil];

}

#pragma mark ---- Toolbar methods ----

-(IBAction) toolBarIconClicked: (id) sender {
    
    [tabView selectTabViewItem:[tabView tabViewItemAtIndex:[sender tag]]];
    
}

#pragma mark ---- Menu management methods ----

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
	[internalInterruptPomodoro setEnabled:(state == PomoTicking)];
	[resumePomodoro            setEnabled:(state == PomoInterrupted)];
    
}

-(IBAction) resetDefaultValues: (id) sender {
	
	[PomodoroDefaults removeDefaults];
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMResetDefault object:namePanel];
	[self updateMenu];
    
}

-(IBAction) changedCanRestartInBreaks: (id) sender {
	[self updateMenu];	
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
	
	[prefs makeKeyAndOrderFront:self];
}

-(IBAction)stats:(id)sender {
	[stats showWindow:self];
}

- (IBAction) quickStats:(id)sender {
    
    NSInteger time = pomodoro.time;	
	NSString* quickStats = [NSString stringWithFormat:NSLocalizedString(@"QuickStatistics",@"Quick statistic format string"), 
							_timerName, time/60, time%60, 
							pomodoro.externallyInterrupted, pomodoro.internallyInterrupted, pomodoro.resumed,
							_globalPomodoroStarted, _globalPomodoroDone, _globalPomodoroReset,
							_dailyPomodoroStarted, _dailyPomodoroDone, _dailyPomodoroReset,
							_globalExternalInterruptions, _globalInternalInterruptions, _globalPomodoroResumed,
							_dailyExternalInterruptions, _dailyInternalInterruptions, _dailyPomodoroResumed,
                            _pomodorosForLong - (longBreakCounter % _pomodorosForLong)
							];
	
	NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = NSLocalizedString(@"Quick Statistics",@"Growl header for quick statistics");
    notification.informativeText = quickStats;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(IBAction)quit:(id)sender {	
	[NSApp terminate:self];
}


- (void) realStart {
    [pomodoro start];	
	[self updateMenu];
}

-(IBAction) nameCanceled:(id)sender {
	[namePanel close];
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoNameCanceled object:namePanel];
}

-(IBAction) nameGiven:(id)sender {
    [self observeUserDefault:@"initialTime"];

    if (![namePanel makeFirstResponder:namePanel]) {
        [namePanel endEditingFor:nil];
    }
    
    [self updateNamesComboData];
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoNameGiven object:namePanel];

	[namePanel close];
	[self realStart];
}

- (void) setFocusOnPomodoro {
	SetFrontProcess(&psn);
}

- (IBAction) start: (id) sender {
    
	if (_initialTime > 0) {
        
		[about close];
		[splash close];
        [scriptPanel close];
 		[prefs close];
        
        if ([longBreakCheckerTimer isValid]) {
            [longBreakCheckerTimer invalidate];
            longBreakCheckerTimer = nil;
        }
        		
        [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoWillStart object:nil];

		if ([self checkDefault:@"askBeforeStart"] && (![@"direct"  isEqual: sender])) {
			[self setFocusOnPomodoro];

			[namePanel makeKeyAndOrderFront:self];
		} else {
            [self observeUserDefault:@"initialTime"];
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

- (IBAction) externalInterrupt: (id) sender {

	[pomodoro externalInterruptFor: _interruptTime];
	[self updateMenu];
	
}

- (IBAction) internalInterrupt: (id) sender {

    [pomodoro internalInterruptFor:_interruptTime];
    [self updateMenu];
    
}

-(IBAction) resume: (id) sender {
	
	[pomodoro resume];
	[self updateMenu];
	
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {

	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroStarted)+1] forKey:@"dailyPomodoroStarted"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroStarted)+1] forKey:@"globalPomodoroStarted"];
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Working on: %@",@"Tooltip for running Pomodoro"), _timerName];
	[statusItem setToolTip:name];		
		
}

-(void) pomodoroExternallyInterrupted:(NSNotification*) notification {
	
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyExternalInterruptions)+1] forKey:@"dailyExternalInterruptions"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalExternalInterruptions)+1] forKey:@"globalExternalInterruptions"];
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Externally Interrupted: %@",@"Tooltip for Interruption"), _timerName];
	[statusItem setToolTip:name];
			
}

-(void) pomodoroInternallyInterrupted:(NSNotification*) notification {
	
    
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyInternalInterruptions)+1] forKey:@"dailyInternalInterruptions"];
    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalInternalInterruptions)+1] forKey:@"globalInternalInterruptions"];
    
 	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Internally Interrupted: %@",@"Tooltip for Interruption"), _timerName];
	[statusItem setToolTip:name];
    
}


-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {

    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroReset)+1] forKey:@"dailyPomodoroReset"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroReset)+1] forKey:@"globalPomodoroReset"];
    NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Last: %@ (interrupted)",@"Tooltip for interrupt-reset pomodoros"), _timerName];
	[statusItem setToolTip:name];

	[self updateMenu];
	[self showTimeOnStatusBar: _initialTime * 60];
}

-(void) pomodoroReset:(NSNotification*) notification {

    [[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroReset)+1] forKey:@"dailyPomodoroReset"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroReset)+1] forKey:@"globalPomodoroReset"];
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Last: %@ (reset)",@"Tooltip for reset pomodoro"), _timerName];
	[statusItem setToolTip:name];

}

-(void) pomodoroResumed:(NSNotification*) notification {
    
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroResumed)+1] forKey:@"dailyPomodoroResumed"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroResumed)+1] forKey:@"globalPomodoroResumed"];
    NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Working on: %@",@"Tooltip for running Pomodoro"), _timerName];
	[statusItem setToolTip:name];
	[statusItem setImage:pomodoroImage];

}

-(void) breakStarted:(NSNotification*) notification {
	
    NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Break after: %@",@"Tooltip for break"), _timerName];
	[statusItem setToolTip:name];
	[self updateMenu];
}

-(void) breakFinished:(NSNotification*) notification {
	
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Just finished: %@",@"Tooltip for finished pomodoros"), _timerName];
	[statusItem setToolTip:name];
	
	[self updateMenu];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"ringAtBreakEnabled"]) {
		[ringingBreak play];
	}
	
	[self showTimeOnStatusBar: _initialTime * 60];
    
	if ([self checkDefault:@"autoPomodoroRestart"]) {
		[self start:nil];
	} else if ([self checkDefault:@"longbreakResetEnabled"]) {
        
        //NSLog(@"LongBreak Timer started for %d", _longbreakResetTime*60);
        longBreakCheckerTimer = [NSTimer timerWithTimeInterval:_longbreakResetTime*60
                                                    target:self
                                                  selector:@selector(longBreakCheckerFinished)													 
                                                  userInfo:nil
                                                   repeats:NO];	
        [[NSRunLoop currentRunLoop] addTimer:longBreakCheckerTimer forMode:NSRunLoopCommonModes];

    }
}

-(void) pomodoroFinished:(NSNotification*) notification {
    
    
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_dailyPomodoroDone)+1] forKey:@"dailyPomodoroDone"];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithInt:(_globalPomodoroDone)+1] forKey:@"globalPomodoroDone"];
    longBreakCounter++;
    
	NSString* name = [NSString stringWithFormat:NSLocalizedString(@"Just finished: %@",@"Tooltip for finished pomodoros"), _timerName];
	[statusItem setToolTip:name];
	

    Pomodoro* pomo = [notification object];
	[stats.pomos newPomodoro:lround(pomo.realDuration/60.0) withExternalInterruptions:pomo.externallyInterrupted withInternalInterruptions: pomo.internallyInterrupted];
	
	if (![self checkDefault:@"mute"] && [self checkDefault:@"ringAtEndEnabled"]) {
		[ringing play];
	}
		
	if ([self checkDefault:@"breakEnabled"]) {
		NSInteger time = _breakTime;
		if (([self checkDefault:@"longbreakEnabled"]) && ((longBreakCounter % _pomodorosForLong) == 0)) {
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

    // Save stats here in case application is forcefully terminated
    [stats saveState];
}

- (void) oncePerSecondBreak:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
	[self showTimeOnStatusBar: time];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"tickAtBreakEnabled"]) {
		[tick play];
	}
    
    if ([self checkDefault:@"preventSleepDuringPomodoroBreak"]) {
        UpdateSystemActivity(OverallAct);
    }
    
}

- (void) oncePerSecond:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
	[self showTimeOnStatusBar: time];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"tickEnabled"]) {
		[tick play];
	}
    
    if ([self checkDefault:@"preventSleepDuringPomodoro"]) {
        UpdateSystemActivity(OverallAct);
    }

}


#pragma mark ---- Lifecycle methods ----

+ (void)initialize { 
    
	[PomodoroDefaults setDefaults];
	
} 

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    NSLog(@"Pomodoro terminating...");
    [stats saveState];
    [prefs close];
}
	  
- (void)awakeFromNib {
    
    [self registerForAllPomodoroEvents];
    
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	statusItem.button.font = [NSFont monospacedDigitSystemFontOfSize:pomodoroMenu.font.pointSize weight:NSFontWeightRegular];
    
	pomodoroImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoro" ofType:@"png"]];
	pomodoroBreakImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroBreak" ofType:@"png"]];
	pomodoroFreezeImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroFreeze" ofType:@"png"]];
	pomodoroNegativeImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoro_n" ofType:@"png"]];
	pomodoroNegativeBreakImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroBreak_n" ofType:@"png"]];
	pomodoroNegativeFreezeImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pomodoroFreeze_n" ofType:@"png"]];

    
    
    tick = [NSSound soundNamed:@"tick.wav"];
	ringing = [NSSound soundNamed:@"ring.wav"];
	ringingBreak = [NSSound soundNamed:@"ringBreak.wav"];

	[statusItem setImage:pomodoroImage];
	[statusItem setAlternateImage:pomodoroNegativeImage];
		
	[ringing setVolume:_ringVolume/100.0];
	[ringingBreak setVolume:_ringBreakVolume/100.0];
	[tick setVolume:_tickVolume/100.0];

	[initialTimeCombo addItemWithObjectValue: [NSNumber numberWithInt:25]];
	[initialTimeCombo addItemWithObjectValue: [NSNumber numberWithInt:30]];
	[initialTimeCombo addItemWithObjectValue: [NSNumber numberWithInt:35]];
	
    [initialTimeComboInStart addItemWithObjectValue: [NSNumber numberWithInt:25]];
	[initialTimeComboInStart addItemWithObjectValue: [NSNumber numberWithInt:30]];
	[initialTimeComboInStart addItemWithObjectValue: [NSNumber numberWithInt:35]];
    
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
    
    [longBreakResetComboTime addItemWithObjectValue: [NSNumber numberWithInt:3]];
	[longBreakResetComboTime addItemWithObjectValue: [NSNumber numberWithInt:5]];
	[longBreakResetComboTime addItemWithObjectValue: [NSNumber numberWithInt:7]];
	
	[pomodorosForLong addItemWithObjectValue: [NSNumber numberWithInt:4]];
	[pomodorosForLong addItemWithObjectValue: [NSNumber numberWithInt:6]];
	[pomodorosForLong addItemWithObjectValue: [NSNumber numberWithInt:8]];
			
	[statusItem setToolTip:NSLocalizedString(@"Pomodoro Time Management",@"Status Tooltip")];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:pomodoroMenu];
	[self showTimeOnStatusBar: _initialTime * 60];
	
    [toolBar setSelectedItemIdentifier:@"Pomodoro"];

    [pomodoro setDurationMinutes:_initialTime];
    pomodoroNotifier = [[PomodoroNotifier alloc] init];
	[pomodoro setDelegate: pomodoroNotifier];
    
	stats = [[StatsController alloc] init];
	[stats window];

	GetCurrentProcess(&psn);
    
    if(![self checkDefault:@"mute"]){
        [self observeUserDefault:@"ringVolume"];
        [self observeUserDefault:@"ringBreakVolume"];
        [self observeUserDefault:@"tickVolume"];
        [self observeUserDefault:@"initialTime"];
        [self observeUserDefault:@"showTimeOnStatusEnabled"];
    }
	
	
	if ([self checkDefault:@"showSplashScreenAtStartup"]) {
		[self help:nil];
	}	
		
}


@end
