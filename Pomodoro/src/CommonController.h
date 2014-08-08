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

#define _timerName [[NSUserDefaults standardUserDefaults] objectForKey:@"timerName"]
#define _initialTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] intValue]
#define _interruptTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] intValue]
#define _breakTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"breakTime"] intValue]
#define _longbreakTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"longbreakTime"] intValue]
#define _pomodorosForLong [[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodorosForLong"] intValue]
#define _longbreakResetTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"longbreakResetTime"] intValue]

#define _growlEveryTimeMinutes [[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEveryTimeMinutes"] intValue]
#define _speechEveryTimeMinutes [[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"] intValue]
#define _scriptEveryTimeMinutes [[[NSUserDefaults standardUserDefaults] objectForKey:@"scriptEveryTimeMinutes"] intValue]

#define _ringVolume [[[NSUserDefaults standardUserDefaults] objectForKey:@"ringVolume"] intValue]
#define _ringBreakVolume [[[NSUserDefaults standardUserDefaults] objectForKey:@"ringBreakVolume"] intValue]
#define _voiceVolume [[[NSUserDefaults standardUserDefaults] objectForKey:@"voiceVolume"] intValue]
#define _tickVolume [[[NSUserDefaults standardUserDefaults] objectForKey:@"tickVolume"] intValue]

#define _speechVoice [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultVoice"]

#define _dailyInternalInterruptions [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyInternalInterruptions"] intValue]
#define _dailyExternalInterruptions [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyExternalInterruptions"] intValue]
#define _dailyPomodoroStarted [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPomodoroStarted"] intValue]
#define _dailyPomodoroResumed [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPomodoroResumed"] intValue]
#define _dailyPomodoroDone [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPomodoroDone"] intValue]
#define _dailyPomodoroReset [[[NSUserDefaults standardUserDefaults] objectForKey:@"dailyPomodoroReset"] intValue]

#define _globalInternalInterruptions [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalInternalInterruptions"] intValue]
#define _globalExternalInterruptions [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalExternalInterruptions"] intValue]
#define _globalPomodoroStarted [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalPomodoroStarted"] intValue]
#define _globalPomodoroResumed [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalPomodoroResumed"] intValue]
#define _globalPomodoroDone [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalPomodoroDone"] intValue]
#define _globalPomodoroReset [[[NSUserDefaults standardUserDefaults] objectForKey:@"globalPomodoroReset"] intValue]

@interface CommonController : NSObject {
    
}

- (BOOL) checkDefault:(NSString*) property;
- (NSString*) bindCommonVariables:(NSString*)name;
- (void) observeUserDefault:(NSString*) property;
- (void) registerForPomodoro:(NSString*)name method:(SEL)selector;
- (void) registerForAllPomodoroEvents;

@end
