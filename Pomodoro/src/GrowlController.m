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

#import "GrowlController.h"
#import "PomoNotifications.h"

@implementation GrowlController

@synthesize growlStatus, growlEveryCombo;

#pragma mark ---- Method-independent notifications ----

-(void) notify:(NSString *)message title:(NSString *)title sticky:(BOOL)sticky {

    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:@"Timer"];
    [notification setSubtitle:title];
    [notification setInformativeText:message];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}


#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {

	if ([self checkDefault:@"growlAtStartEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyStartEnabled"];
		[self notify: [self bindCommonVariables:@"growlStart"]  title:NSLocalizedString(@"Pomodoro started",@"Growl header for pomodoro start") sticky:sticky];
	}
}

- (void) interrupted {
    
    NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	if ([self checkDefault:@"growlAtInterruptEnabled"]) {
        
		NSString* growlString = [self bindCommonVariables:@"growlInterrupt"];		
		[self notify: [growlString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString] title:NSLocalizedString(@"Pomodoro interrupted",@"Growl title for interruptions") sticky:NO];
	}
    
}

-(void) pomodoroExternallyInterrupted:(NSNotification*) notification {
    
	[self interrupted];

}

-(void) pomodoroInternallyInterrupted:(NSNotification*) notification {
    
	[self interrupted];
    
}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {
    
    if ([self checkDefault:@"growlAtInterruptOverEnabled"]) {
		[self notify:[self bindCommonVariables:@"growlInterruptOver"] title:NSLocalizedString(@"Pomodoro reset",@"Growl header for reset") sticky:NO];
    }

}

-(void) pomodoroReset:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtResetEnabled"]) {
		[self notify:[self bindCommonVariables:@"growlReset"] title:NSLocalizedString(@"Pomodoro reset",@"Growl header for reset") sticky:NO];
	}
    
}

-(void) pomodoroResumed:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtResumeEnabled"]) {
		[self notify:[self bindCommonVariables:@"growlResume"] title:NSLocalizedString(@"Pomodoro resumed",@"Growl header for resumed pomodoro") sticky:NO];
	}
    
}

-(void) breakStarted:(NSNotification*) notification {
    
}

-(void) breakFinished:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtBreakFinishedEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyBreakFinishedEnabled"];
		[self notify:[self bindCommonVariables:@"growlBreakFinished"] title:NSLocalizedString(@"Pomodoro break finished",@"Growl header for finished break") sticky:sticky];
	}
    
}

-(void) pomodoroFinished:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtEndEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyEndEnabled"];
		[self notify:[self bindCommonVariables:@"growlEnd"] title:NSLocalizedString(@"Pomodoro finished",@"Growl header for finished pomodoro") sticky:sticky];
	}
    
}

- (void) oncePerSecondBreak:(NSNotification*) notification {
    
}

- (void) oncePerSecond:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
    NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%ld", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%ld", time/60];
	
	if (timePassed%(60 * _growlEveryTimeMinutes) == 0 && time!=0) {	
		if ([self checkDefault:@"growlAtEveryEnabled"]) {
			NSString* msg = [[self bindCommonVariables:@"growlEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[self notify:msg title:@"Pomodoro ticking" sticky:NO];
		}
	}
}

#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [self registerForAllPomodoroEvents];
    
    //Backwards-compatible (dynamic) way to use notification center if available.
    userNotificationCenter = nil;
    Class klass = NSClassFromString(@"NSUserNotificationCenter");
    if (klass)
    {
        //this is a singleton so it shouldn't need to be retained.
        userNotificationCenter = [klass defaultUserNotificationCenter];
    }
    
    redButtonImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"]];
    greenButtonImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"png"]];
    yellowButtonImage = [[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"png"]];
    
    [growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
    [growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
    [growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
    
}

@end
