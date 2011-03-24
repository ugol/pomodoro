//
//  PomodoroTests.m
//  PomodoroTests
//
//  Created by Ugo Landini on 3/24/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import "PomodoroTests.h"
#import "Pomodoro.h"

@implementation PomodoroTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    Pomodoro* pomodoro = [[Pomodoro alloc] initWithDuration:1];
    STAssertNotNil(pomodoro, @"Correctly instantiated Pomodoro");
    //STFail(@"Unit tests are not implemented yet in PomodoroTests");
}

@end
