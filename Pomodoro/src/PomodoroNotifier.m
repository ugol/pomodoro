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

#import "PomodoroNotifier.h"
#import "PomoNotifications.h"

@implementation PomodoroNotifier


- (void) pomodoroStarted:(id) pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoStarted object:pomo];
}

- (void) pomodoroFinished:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoFinished object:pomo];
}

- (void) pomodoroExternallyInterrupted:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoExternallyInterrupted object:pomo];
}

- (void) pomodoroInternallyInterrupted:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoInternallyInterrupted object:pomo];
}

- (void) pomodoroInterruptionMaxTimeIsOver:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoInterruptionMaxTimeIsOver object:pomo];
}

- (void) pomodoroReset:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoReset object:pomo];  
}

- (void) pomodoroResumed:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoResumed object:pomo];
}

- (void) breakStarted:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoBreakStarted object:pomo];
}

- (void) breakFinished:(id)pomo {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoBreakFinished object:pomo];
}

- (void) oncePerSecond:(NSInteger) time {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoOncePerSecond object:[NSNumber numberWithLong:time]];
}

- (void) oncePerSecondBreak:(NSInteger) time {
    [[NSNotificationCenter defaultCenter] postNotificationName:_PMPomoOncePerSecondBreak object: [NSNumber numberWithLong:time]];
}

@end
