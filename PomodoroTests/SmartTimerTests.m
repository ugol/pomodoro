//
//  SmartTimerTests.m
//  Pomodoro
//
//  Created by Ugo Landini on 3/24/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import "SmartTimerTests.h"
#import "SmartTimer.h"

@implementation SmartTimerTests

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


- (void)testSmartTimer {
    
    SmartTimer* smart = [[SmartTimer alloc] init];
    STAssertNotNil(smart, @"Correctly instantiated Pomodoro");
    //STFail(@"Unit tests are not implemented yet in PomodoroTests");
}

@end
