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
#import "GrowlNotifier.h"
#import "PomoNotifications.h"

@implementation GrowlController

@synthesize growl, growlStatus, growlEveryCombo;

#pragma mark ---- Growl methods ----

-(IBAction) checkGrowl:(id)sender {
    
    if ([growl isGrowlInstalled] && [growl isGrowlRunning]) {
        [growlStatus setImage:greenButtonImage];
        [sender setToolTip:@"Growl installed and running!"];
        [growlStatus setToolTip:@"Growl installed and running!"];
    } else if ([growl isGrowlInstalled]) {
        [growlStatus setImage:yellowButtonImage];
        [sender setToolTip:@"Growl installed but not running!"];
        [growlStatus setToolTip:@"Growl installed but not running!"];
    } else {
       	[growlStatus setImage:redButtonImage];
        [sender setToolTip:@"Growl not installed and not running!"];
        [growlStatus setToolTip:@"Growl not installed and not running!"];
    }
    
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {

	if ([self checkDefault:@"growlAtStartEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyStartEnabled"];
		[growl growlAlert: [self bindCommonVariables:@"growlStart"]  title:NSLocalizedString(@"Pomodoro started",@"Growl header for pomodoro start") sticky:sticky];
	}

}

- (void) interrupted {
    
    NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	if ([self checkDefault:@"growlAtInterruptEnabled"]) {
        
		NSString* growlString = [self bindCommonVariables:@"growlInterrupt"];		
		[growl growlAlert: [growlString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString] title:NSLocalizedString(@"Pomodoro interrupted",@"Growl title for interruptions")];
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
		[growl growlAlert:[self bindCommonVariables:@"growlInterruptOver"] title:NSLocalizedString(@"Pomodoro reset",@"Growl header for reset")];
    }

}

-(void) pomodoroReset:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtResetEnabled"]) {
		[growl growlAlert:[self bindCommonVariables:@"growlReset"] title:NSLocalizedString(@"Pomodoro reset",@"Growl header for reset")];
	}
    
}

-(void) pomodoroResumed:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtResumeEnabled"]) {
		[growl growlAlert:[self bindCommonVariables:@"growlResume"] title:NSLocalizedString(@"Pomodoro resumed",@"Growl header for resumed pomodoro")];
	}
    
}

-(void) breakStarted:(NSNotification*) notification {
    
}

-(void) breakFinished:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtBreakFinishedEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyBreakFinishedEnabled"];
		[growl growlAlert:[self bindCommonVariables:@"growlBreakFinished"] title:NSLocalizedString(@"Pomodoro break finished",@"Growl header for finished break") sticky:sticky];
	}
    
}

-(void) pomodoroFinished:(NSNotification*) notification {
    
	if ([self checkDefault:@"growlAtEndEnabled"]) {
		BOOL sticky = [self checkDefault:@"stickyEndEnabled"];
		[growl growlAlert:[self bindCommonVariables:@"growlEnd"] title:NSLocalizedString(@"Pomodoro finished",@"Growl header for finished pomodoro") sticky:sticky];
	}
    
}

- (void) oncePerSecondBreak:(NSNotification*) notification {
    
}

- (void) oncePerSecond:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
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
}

#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [self registerForAllPomodoroEvents];
    
    redButtonImage = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"red" ofType:@"png"]] retain];
    greenButtonImage = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"green" ofType:@"png"]] retain];
    yellowButtonImage = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yellow" ofType:@"png"]] retain];
    
    [growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
    [growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
    [growlEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
    
}

- (void)dealloc {
    
    [redButtonImage release];
    [greenButtonImage release];
    [yellowButtonImage release];
    [super dealloc];
    
}

@end
