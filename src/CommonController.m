//
//  CommonController.m
//  Pomodoro
//
//  Created by Ugo Landini on 3/17/11.
//  Copyright 2011 iUgol. All rights reserved.
//

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
	NSArray* variables = [NSArray arrayWithObjects:@"$pomodoroName", @"$duration", @"$dailyPomodoroDone", @"$globalPomodoroDone",nil];
	NSString* durationString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] stringValue];
	NSString* dailyPomodoroDone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPomodoroDone"] stringValue];
	NSString* globalPomodoroDone = [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalPomodoroDone"] stringValue];
	
	if (nil == dailyPomodoroDone) {
		dailyPomodoroDone = @"0";
	}
	
	if (nil == globalPomodoroDone) {
		globalPomodoroDone = @"0";
	}
    
	NSArray* values = [NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"], durationString, dailyPomodoroDone, globalPomodoroDone, nil];
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
    [self registerForPomodoro:_PMPomoInterrupted method:@selector(pomodoroInterrupted:)];
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

-(void) pomodoroInterrupted:(NSNotification*) notification {
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

#pragma mark ---- Lifecycle methods ----

- (void)dealloc {
    [super dealloc];
}

@end
