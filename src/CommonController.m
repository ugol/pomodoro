//
//  CommonController.m
//  Pomodoro
//
//  Created by Ugo Landini on 3/17/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import "CommonController.h"
#import "Binder.h"

@implementation CommonController


- (BOOL) checkDefault:(NSString*) property {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:property] boolValue];
}

- (NSString*) bindCommonVariables:(NSString*)name {
	NSArray* variables = [NSArray arrayWithObjects:@"$pomodoroName", @"$duration", @"$dailyPomodoroDone", @"$globalPomodoroDone",nil];
	//NSString* durationString = [NSString stringWithFormat:@"%d", pomodoro.durationMinutes];
	NSString* durationString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroDurationMinutes"] stringValue];
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

- (void)dealloc
{
    [super dealloc];
}

@end
