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

#import "PomodoroArrayController.h"


@implementation PomodoroArrayController

- (id) newPomodoro:(NSInteger)duration withExternalInterruptions:(NSInteger)externalInterruptions withInternalInterruptions:(NSInteger)internalInterruptions {
	
	id newPomodoro = [super newObject]; 
    NSDate *now = [NSDate date];
	[newPomodoro setValue:now forKey:@"when"]; 
    [newPomodoro setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"timerName"] forKey:@"name"]; 

	[newPomodoro setValue:[NSNumber numberWithLong:duration] forKey:@"durationMinutes"]; 
	[newPomodoro setValue:[NSNumber numberWithLong:externalInterruptions] forKey:@"externalInterruptions"]; 
    [newPomodoro setValue:[NSNumber numberWithLong:internalInterruptions] forKey:@"internalInterruptions"]; 
	
    return newPomodoro;

}

- (id)newObject { 
    return [self newPomodoro:[[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] intValue] withExternalInterruptions:0 withInternalInterruptions:0]; 
}


@end
