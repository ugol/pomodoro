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

#import <Foundation/Foundation.h>

@protocol PomodoroDelegate

@optional

- (void) pomodoroStarted:(id) pomo;
- (void) pomodoroFinished:(id)pomo;
- (void) pomodoroExternallyInterrupted:(id)pomo;
- (void) pomodoroInternallyInterrupted:(id)pomo;
- (void) pomodoroInterruptionMaxTimeIsOver:(id)pomo;
- (void) pomodoroReset:(id)pomo;
- (void) pomodoroResumed:(id)pomo;
- (void) breakStarted:(id)pomo;
- (void) breakFinished:(id)pomo;

@required

- (void) oncePerSecond:(NSInteger) time;
- (void) oncePerSecondBreak:(NSInteger) time;

@end

enum PomoState {
	PomoReadyToStart,
	PomoTicking,
	PomoInterrupted,
	PomoInBreak
};

@interface Pomodoro : NSObject<NSUserNotificationCenterDelegate> {

	id delegate;
	
	NSInteger durationMinutes;
	NSInteger realDuration;
	NSInteger externallyInterrupted;
	NSInteger internallyInterrupted;
	NSInteger resumed;

	NSInteger time;
	NSTimer *oneSecTimer;
	NSTimer *breakTimer;
	NSTimer *interruptionTimer;
	
	enum PomoState state;

}

@property (nonatomic, assign, readonly) NSInteger time;
@property (nonatomic, assign, readonly) NSInteger resumed;
@property (nonatomic, assign) NSInteger durationMinutes;
@property (nonatomic, assign, readonly) NSInteger realDuration;
@property (nonatomic, assign) NSInteger externallyInterrupted;
@property (nonatomic, assign) NSInteger internallyInterrupted;
@property (nonatomic, assign, readonly) enum PomoState state;

@property (nonatomic) NSTimer* oneSecTimer;
@property (nonatomic) NSTimer* breakTimer;
@property (nonatomic) NSTimer* interruptionTimer;
@property (nonatomic, strong) id delegate;

- (id) initWithDuration:(NSInteger) durationTime;
- (void) start;
- (void) breakFor:(NSInteger)breakMinutes;
- (void) reset;
- (void) finish;
- (void) internalInterruptFor:(NSInteger) seconds;
- (void) externalInterruptFor:(NSInteger) seconds;
- (void) resume;

@end
