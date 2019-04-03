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

#import "Pomodoro.h"


@implementation Pomodoro

@synthesize time, resumed, durationMinutes, realDuration, externallyInterrupted, internallyInterrupted, oneSecTimer, breakTimer, interruptionTimer, delegate, state;

- (void) clearTimer: (NSTimer*) timer {
    
    if ([timer isValid]) {
        [timer invalidate];
    }
    
}

- (id) init { 
    if ( (self = [super init]) ) {
        if (!(self = [self initWithDuration:25])) return nil;
    }
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    return self;
}

- (BOOL) userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}

- (id) initWithDuration:(NSInteger) durationTime { 
    if ( (self = [super init]) ) {
        durationMinutes = durationTime;
		state = PomoReadyToStart;
    }
    return self;
}

-(void) startFor: (NSInteger) seconds {
    time = seconds;
	state = PomoTicking;
    
	oneSecTimer = [NSTimer timerWithTimeInterval:1
											   target:self
											 selector:@selector(oncePersecond:)													 
											 userInfo:nil
											  repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:oneSecTimer forMode:NSRunLoopCommonModes];	
}

-(void) start {

    [self clearTimer: breakTimer];
    breakTimer = nil;

    externallyInterrupted = 0;
    internallyInterrupted = 0;
    resumed = 0;    
    realDuration = 0;

	if (durationMinutes > 0) {
		[self startFor: durationMinutes*60];
		if ([delegate respondsToSelector: @selector(pomodoroStarted:)]) {
			[delegate pomodoroStarted:self];
		}
	}
}

-(void) finish {
	time = 1;	
}

-(void) breakFor:(NSInteger)breakMinutes {
	if (oneSecTimer == nil) {
		time = breakMinutes * 60;
		state = PomoInBreak;
		breakTimer = [NSTimer timerWithTimeInterval:1
											  target:self
											selector:@selector(oncePersecondBreak:)													 
											userInfo:nil
											 repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:breakTimer forMode:NSRunLoopCommonModes];
		
		if ([delegate respondsToSelector: @selector(breakStarted:)]) {
			[delegate breakStarted:self];
		}
	}
}

-(void) reset {
    [self clearTimer: oneSecTimer];
    [self clearTimer: interruptionTimer];
    oneSecTimer = nil;
    interruptionTimer = nil;
    
	state = PomoReadyToStart;
	if ([delegate respondsToSelector: @selector(pomodoroReset:)]) {
        [delegate pomodoroReset:self];
	}
}

- (void) interrupt: (NSInteger) seconds  {
    [self clearTimer:oneSecTimer];
    oneSecTimer = nil;
	state = PomoInterrupted;
	interruptionTimer = [NSTimer timerWithTimeInterval:seconds
										  target:self
											  selector:@selector(interruptFinished:)													 
										userInfo:nil
										 repeats:NO];	
	[[NSRunLoop currentRunLoop] addTimer:interruptionTimer forMode:NSRunLoopCommonModes];
	
}

-(void) externalInterruptFor:(NSInteger) seconds {
	externallyInterrupted++;
	[self interrupt: seconds];
    if ([delegate respondsToSelector: @selector(pomodoroExternallyInterrupted:)]) {
        [delegate pomodoroExternallyInterrupted:self];
	}


}

-(void) internalInterruptFor:(NSInteger) seconds {
	internallyInterrupted++;
    [self interrupt: seconds];
    if ([delegate respondsToSelector: @selector(pomodoroInternallyInterrupted:)]) {
        [delegate pomodoroInternallyInterrupted:self];
	}

}

-(void) resume {

	resumed++;
    [self clearTimer:interruptionTimer];
    interruptionTimer = nil;

	[self startFor: time];
	if ([delegate respondsToSelector: @selector(pomodoroResumed:)]) {
        [delegate pomodoroResumed:self];		
	}
}

- (void) checkIfFinished {
	if (time == 0) {
        [self clearTimer:oneSecTimer];
        oneSecTimer = nil;
		state = PomoReadyToStart;
		if ([delegate respondsToSelector: @selector(pomodoroFinished:)]) {
			[delegate pomodoroFinished:self];		
		}		
	}
}

- (void) checkIfBreakFinished {
	if (time == 0) {
        [self clearTimer:breakTimer];
        breakTimer = nil;
		state = PomoReadyToStart;
		if ([delegate respondsToSelector: @selector(breakFinished:)]) {
			[delegate breakFinished:self];		
		}		
	}
}

- (void)oncePersecond:(NSTimer *)aTimer
{
	time--;
	realDuration++;
	[delegate oncePerSecond:time];		
	[self checkIfFinished];		
}

- (void)oncePersecondBreak:(NSTimer *)aTimer
{
	time--;
	[delegate oncePerSecondBreak:time];		
	[self checkIfBreakFinished];		
}

-(void) interruptFinished:(NSTimer *)aTimer {
    [self clearTimer:oneSecTimer];
    [self clearTimer:interruptionTimer];
    oneSecTimer = nil;
    interruptionTimer = nil;
	state = PomoReadyToStart;
	if ([delegate respondsToSelector: @selector(pomodoroInterruptionMaxTimeIsOver:)]) {
        [delegate pomodoroInterruptionMaxTimeIsOver:self];		
	}
}

@end

