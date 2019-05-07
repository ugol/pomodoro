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

#import "CommonController.h"
#import "PomoNotifications.h"
#import "Binder.h"

@implementation CommonController

#pragma mark ---- Helper Methods ----

- (BOOL) checkDefault:(NSString*) property {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:property] boolValue];
}

-(void)observeUserDefault:(NSString*) property{
	
	[[NSUserDefaults standardUserDefaults]  addObserver:self
											forKeyPath:property
											   options:(NSKeyValueObservingOptionNew |
														NSKeyValueObservingOptionOld)
											   context:NULL];
}

- (NSString*) bindCommonVariables:(NSString*)name {
	NSArray* variables = [NSArray arrayWithObjects:@"$timerName", @"$duration", @"$dailyPomodoroDone", @"$globalPomodoroDone",nil];
	NSString* durationString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] stringValue];
	NSString* dailyPomodoroDone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPomodoroDone"] stringValue];
	NSString* globalPomodoroDone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalPomodoroDone"] stringValue];
	
	if (nil == dailyPomodoroDone) {
		dailyPomodoroDone = @"0";
	}
	
	if (nil == globalPomodoroDone) {
		globalPomodoroDone = @"0";
	}
    
	NSArray* values = [NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"timerName"], durationString, dailyPomodoroDone, globalPomodoroDone, nil];
	return [Binder substituteDefault:name withVariables:variables andValues:values];
}	

- (void) registerForPomodoro:(NSString*)name method:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector 
                                                 name:name
                                               object:nil];
}

- (void) registerForAllPomodoroEvents {
    [self registerForPomodoro:_PMPomoStarted method:@selector(pomodoroStarted:)];
    [self registerForPomodoro:_PMPomoFinished method:@selector(pomodoroFinished:)];
    [self registerForPomodoro:_PMPomoExternallyInterrupted method:@selector(pomodoroExternallyInterrupted:)];
    [self registerForPomodoro:_PMPomoInternallyInterrupted method:@selector(pomodoroInternallyInterrupted:)];
    [self registerForPomodoro:_PMPomoInterruptionMaxTimeIsOver method:@selector(pomodoroInterruptionMaxTimeIsOver:)];
    [self registerForPomodoro:_PMPomoReset method:@selector(pomodoroReset:)];
    [self registerForPomodoro:_PMPomoResumed method:@selector(pomodoroResumed:)];
    [self registerForPomodoro:_PMPomoOncePerSecond method:@selector(oncePerSecond:)];
    [self registerForPomodoro:_PMPomoOncePerSecondBreak method:@selector(oncePerSecondBreak:)];
    [self registerForPomodoro:_PMPomoBreakStarted method:@selector(breakStarted:)];
    [self registerForPomodoro:_PMPomoBreakFinished method:@selector(breakFinished:)];
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {
}

-(void) pomodoroExternallyInterrupted:(NSNotification*) notification {
}

-(void) pomodoroInternallyInterrupted:(NSNotification*) notification {
}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {
}

-(void) pomodoroReset:(NSNotification*) notification {
}

-(void) pomodoroResumed:(NSNotification*) notification {
}

-(void) breakStarted:(NSNotification*) notification {
}

-(void) breakFinished:(NSNotification*) notification {
}

-(void) pomodoroFinished:(NSNotification*) notification {    
}

- (void) oncePerSecondBreak:(NSNotification*) notification {
}

- (void) oncePerSecond:(NSNotification*) notification {
}

@end
