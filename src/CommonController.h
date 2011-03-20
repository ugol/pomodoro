//
//  CommonController.h
//  Pomodoro
//
//  Created by Ugo Landini on 3/17/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _pomodoroName [[NSUserDefaults standardUserDefaults] objectForKey:@"pomodoroName"]
#define _initialTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] intValue]
#define _interruptTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] intValue]
#define _breakTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"breakTime"] intValue]
#define _longbreakTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"longbreakTime"] intValue]
#define _pomodorosForLong [[[NSUserDefaults standardUserDefaults] objectForKey:@"pomodorosForLong"] intValue]
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
