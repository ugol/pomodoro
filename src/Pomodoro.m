// Pomodoro Desktop - Copyright (c) 2009, Ugo Landini (ugol@computer.org)
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

@synthesize time, resumed, durationMinutes, lastPomodoroDurationSeconds, externallyInterrupted, internallyInterrupted, oneSecTimer, breakTimer, interruptionTimer, delegate, state;

- (id) init { 
    if ( self = [super init] ) {
        [self initWithDuration:25];
    }
    return self;
}

- (id) initWithDuration:(NSInteger) durationTime { 
    if ( self = [super init] ) {
        durationMinutes = durationTime;
		state = PomoReadyToStart;
    }
    return self;
}

-(void) startFor: (NSInteger) seconds {
	time = seconds; 
	lastPomodoroDurationSeconds = 0;
	state = PomoTicking;
	oneSecTimer = [NSTimer timerWithTimeInterval:1
											   target:self
											 selector:@selector(oncePersecond:)													 
											 userInfo:nil
											  repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:oneSecTimer forMode:NSRunLoopCommonModes];	

}

-(void) start {
	if (breakTimer != nil) {
		[breakTimer invalidate];
		breakTimer = nil;
	}
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
	if (oneSecTimer != nil) {
		[oneSecTimer invalidate];
		oneSecTimer = nil;
	}
	if (interruptionTimer != nil) {
		[interruptionTimer invalidate];
		interruptionTimer = nil;
	}
	state = PomoReadyToStart;
	if ([delegate respondsToSelector: @selector(pomodoroReset:)]) {
        [delegate pomodoroReset:self];
	}
}

-(void) internalInterrupt {
	internallyInterrupted++;
}

-(void) interruptFor:(NSInteger) seconds {
	externallyInterrupted++;
	if (oneSecTimer != nil) {
		[oneSecTimer invalidate];
		oneSecTimer = nil;
	}
	state = PomoInterrupted;
	interruptionTimer = [NSTimer timerWithTimeInterval:seconds
										  target:self
											  selector:@selector(interruptFinished:)													 
										userInfo:nil
										 repeats:NO];	
	[[NSRunLoop currentRunLoop] addTimer:interruptionTimer forMode:NSRunLoopCommonModes];
	if ([delegate respondsToSelector: @selector(pomodoroInterrupted:)]) {
        [delegate pomodoroInterrupted:self];
	}
}

-(void) resume {

	resumed++;
	[interruptionTimer invalidate];
	interruptionTimer = nil;
	[self startFor: time];
	if ([delegate respondsToSelector: @selector(pomodoroResumed:)]) {
        [delegate pomodoroResumed:self];		
	}
}

- (void) checkIfFinished {
	if (time == 0) {
		if (oneSecTimer != nil) {
			[oneSecTimer invalidate];
			oneSecTimer = nil;
		}
		state = PomoReadyToStart;
		if ([delegate respondsToSelector: @selector(pomodoroFinished:)]) {
			[delegate pomodoroFinished:self];		
		}		
	}
}

- (void) checkIfBreakFinished {
	if (time == 0) {
		[breakTimer invalidate];
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
	lastPomodoroDurationSeconds++;
	//time=time-10;
	[delegate oncePerSecond:time];		
	[self checkIfFinished];		
}

- (void)oncePersecondBreak:(NSTimer *)aTimer
{
	time--;
	//time=time-10;
	[delegate oncePerSecondBreak:time];		
	[self checkIfBreakFinished];		
}

-(void) interruptFinished:(NSTimer *)aTimer {
	if (oneSecTimer != nil) {
		[oneSecTimer invalidate];
		oneSecTimer = nil;
	}
	state = PomoReadyToStart;
	if ([delegate respondsToSelector: @selector(pomodoroInterruptionMaxTimeIsOver:)]) {
        [delegate pomodoroInterruptionMaxTimeIsOver:self];		
	}
}

-(void)dealloc {
	if (oneSecTimer != nil) {
		[oneSecTimer invalidate];
		oneSecTimer = nil;
	}
	if (breakTimer != nil) {
		[breakTimer invalidate];
		breakTimer = nil;
	}
	if (interruptionTimer != nil) {
		[interruptionTimer invalidate];
		interruptionTimer = nil;
	}
	[super dealloc];
}

@end

