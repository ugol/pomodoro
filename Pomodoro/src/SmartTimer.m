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

#import "SmartTimer.h"

@implementation SmartTimer

@synthesize lastTimeWhenWentToSleep, delegate, internalTimer;

+ (SmartTimer*) createAndStartRepeatingTimerFor:(NSInteger)seconds withDelegate:(id)delegate {
    return [SmartTimer createAndStartRepeatingTimerFor:seconds withDelegate:delegate inRealTime:YES];
}

+ (SmartTimer*) createAndStartOneShotTimerAfter:(NSInteger)seconds withDelegate:(id)delegate {
    return [SmartTimer createAndStartOneShotTimerAfter:seconds withDelegate:delegate inRealTime:YES ];
}

+ (SmartTimer*) createAndStartRepeatingTimerFor:(NSInteger)seconds withDelegate:(id)delegate inRealTime:(BOOL)real {
    
    SmartTimer* timer = [[SmartTimer alloc] init];
    timer.delegate = delegate;
    
    timer.internalTimer = [NSTimer timerWithTimeInterval:seconds
                                                  target:timer
                                                selector:@selector(repeating:)													 
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer.internalTimer forMode:NSRunLoopCommonModes];
    
    if (real) {
        [timer setRealTime];
    }

    return timer;

}

+ (SmartTimer*) createAndStartOneShotTimerAfter:(NSInteger)seconds withDelegate:(id)delegate inRealTime:(BOOL)real {
    SmartTimer* timer = [[SmartTimer alloc] init];
    timer.delegate = delegate;

    timer.internalTimer = [NSTimer timerWithTimeInterval:seconds
                                                  target:timer
                                                selector:@selector(oneShot:)													 
                                                userInfo:nil
                                                 repeats:NO];   
    [[NSRunLoop currentRunLoop] addTimer:timer.internalTimer forMode:NSRunLoopCommonModes];
    
    if (real) {
        [timer setRealTime];
    }
    
    return timer;   
}

- (void)repeating:(NSTimer *)aTimer {
    if ([delegate respondsToSelector:@selector(repeating:)]) {
        [delegate repeating:self];
    }
}

- (void)oneShot:(NSTimer *)aTimer {
    internalTimer = nil;
    if ([delegate respondsToSelector:@selector(oneShot:)]) {
        [delegate oneShot:self];
    }
}

- (void) reset {
    if ([internalTimer isValid]) {
        [internalTimer invalidate];
        internalTimer = nil;
    }
}


- (void) receiveSleepNote: (NSNotification*) note {
    NSLog(@"receiveSleepNote: %@", [note name]);
    lastTimeWhenWentToSleep = [NSDate date];
    if ([delegate respondsToSelector:@selector(willSleep)]) {
        [delegate willSleep];
    }
}

- (void) receiveWakeNote: (NSNotification*) note {
    NSDate* now = [NSDate date];
    NSTimeInterval secondsPassed = [now timeIntervalSinceDate:lastTimeWhenWentToSleep];
    NSLog(@"receiveWakeNote: %@", [note name]);
    if ([delegate respondsToSelector:@selector(didWakeUp:)]) {
        [delegate didWakeUp:secondsPassed];
    }
}

- (void) setRealTime {

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
                                                           selector: @selector(receiveSleepNote:) 
                                                               name: NSWorkspaceWillSleepNotification object: NULL];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
                                                           selector: @selector(receiveWakeNote:) 
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
}


- (id)init {
    
    if ((self = [super init])) {
        // Initialization code here.
        
    }
    
    return self;
}

@end

