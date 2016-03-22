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

#import "GettingThingsDoneController.h"
#import "PomoNotifications.h"
#import "Pomodoro.h"
#import "Scripter.h"


@implementation GettingThingsDoneController

@synthesize namesCombo, scripter, dateFormatter;

#pragma mark ---- Pomodoro helper methods ----

- (void) addListToCombo:(NSString*)action {
	
	NSAppleEventDescriptor* result = [scripter executeScript:action];			
	NSInteger howMany = [result numberOfItems];
	for (int i=1; i<= howMany; i++) {
		[namesCombo addItemWithObjectValue:[[result descriptorAtIndex:i] stringValue]];		
	}
	
}

- (NSString *) updateMoodMessage:(Pomodoro*) pomo forVariable:(NSString*)variable {
    
    NSDate* date = [NSDate date];  
    NSDate* dueDate = [date dateByAddingTimeInterval:(pomo.durationMinutes * 60)];
    
    NSString* startedAt = [dateFormatter stringFromDate:date];
    NSString* dueTime = [dateFormatter stringFromDate:dueDate];
    
    NSString* moodMessage = [self bindCommonVariables:variable];
    moodMessage = [moodMessage stringByReplacingOccurrencesOfString:@"$startedAt" withString:startedAt];    
    moodMessage = [moodMessage stringByReplacingOccurrencesOfString:@"$dueTime" withString:dueTime];
    return moodMessage;
    
}

#pragma mark ---- Pomodoro notifications methods ----

-(void) setPomodoroNametoLastBeforeCancel:(NSNotification*)notification {
	   
	NSInteger howMany = [namesCombo numberOfItems];
	if (howMany > 0) {
		[[NSUserDefaults standardUserDefaults] setObject:[namesCombo itemObjectValueAtIndex:howMany-1] forKey:@"pomodoroName"];
	}
    
}

-(void) pomodoroNameGiven:(NSNotification*) notification {
    
    NSInteger howMany = [namesCombo numberOfItems];
    NSString* name = _pomodoroName;
    BOOL isNewName = YES;
    NSInteger i = 0;
    while ((isNewName) && (i<howMany)) {
        isNewName = ![name isEqualToString:[namesCombo itemObjectValueAtIndex:i]];
        i++;
    }
    if (isNewName) {
        
        if (!([self checkDefault:@"thingsEnabled"]) && (![self checkDefault:@"omniFocusEnabled"]) && (![self checkDefault:@"remindersEnabled"])) {
            if (howMany>15) {
                [namesCombo removeItemAtIndex:0];
            }
            [namesCombo addItemWithObjectValue:name];
        }
        
        if ([self checkDefault:@"thingsEnabled"] && [self checkDefault:@"thingsAddingEnabled"]) {
            [scripter executeScript:@"addTodoToThings" withParameter:name];
        }
        if ([self checkDefault:@"omniFocusEnabled"] && [self checkDefault:@"omniFocusAddingEnabled"]) {
            [scripter executeScript:@"addTodoToOmniFocus" withParameter:name];
        }
        if ([self checkDefault:@"remindersEnabled"] && [self checkDefault:@"remindersAddingEnabled"]) {
            [scripter executeScript:@"addTodoToReminders" withParameter:name];
        }
    }
    
}

-(void) pomodoroWillStart:(NSNotification*) notification {

    if (([self checkDefault:@"thingsEnabled"]) || ([self checkDefault:@"omniFocusEnabled"]) || ([self checkDefault:@"remindersEnabled"])) {
        [namesCombo removeAllItems];
    }
    
    if ([self checkDefault:@"thingsEnabled"]) {
        [self addListToCombo:@"getToDoListFromThings"];
    }			
    if ([self checkDefault:@"omniFocusEnabled"]) {
        [self addListToCombo:@"getToDoListFromOmniFocus"];
    }
    if ([self checkDefault:@"remindersEnabled"]) {
        [self addListToCombo:@"getToDoListFromReminders"];
    }
}

-(void) pomodoroStarted:(NSNotification*) notification {
        
    Pomodoro* pomo = [notification object];

    NSString* moodMessage = [self updateMoodMessage: pomo forVariable:@"moodMessageInPomodoro"];
    
	if ([self checkDefault:@"adiumEnabled"]) {
		[scripter executeScript:@"setStatusToPomodoroInAdium" withParameter:moodMessage];
	}
	
	if ([self checkDefault:@"iChatEnabled"]) {
		[scripter executeScript:@"setStatusToPomodoroInIChat" withParameter:moodMessage];
	}
    
    if ([self checkDefault:@"messagesEnabled"]) {
        [scripter executeScript:@"setStatusToPomodoroInMessages" withParameter:moodMessage];
    }
	
	if ([self checkDefault:@"skypeEnabled"]) {
		[scripter executeScript:@"setStatusToPomodoroInSkype" withParameter:moodMessage];
	}

}

- (void) setStatusToAvailable:(Pomodoro*) pomo {
    
    NSString* moodMessage = [self updateMoodMessage: pomo forVariable:@"moodMessageInPomodoroBreak"];
    if ([self checkDefault:@"adiumEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInAdium" withParameter:moodMessage];
	}
	
	if ([self checkDefault:@"iChatEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInIChat" withParameter:moodMessage];
	}
    
    if ([self checkDefault:@"messagesEnabled"]) {
        [scripter executeScript:@"setStatusToAvailableInMessages" withParameter:moodMessage];
    }
	
	if ([self checkDefault:@"skypeEnabled"]) {
		[scripter executeScript:@"setStatusToAvailableInSkype" withParameter:moodMessage];
	}

}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {
    
    [self setStatusToAvailable:[notification object]];

}

-(void) pomodoroReset:(NSNotification*) notification {
    
    [self setStatusToAvailable:[notification object]];
	
}

-(void) pomodoroFinished:(NSNotification*) notification {    
    
    [self setStatusToAvailable:[notification object]];

}


#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [self registerForPomodoro:_PMPomoStarted method:@selector(pomodoroStarted:)];
    [self registerForPomodoro:_PMPomoInterruptionMaxTimeIsOver method:@selector(pomodoroInterruptionMaxTimeIsOver:)];
    [self registerForPomodoro:_PMPomoReset method:@selector(pomodoroReset:)];
    [self registerForPomodoro:_PMPomoFinished method:@selector(pomodoroFinished:)];
    [self registerForPomodoro:_PMPomoNameCanceled method:@selector(setPomodoroNametoLastBeforeCancel:)];
    [self registerForPomodoro:_PMPomoNameGiven method:@selector(pomodoroNameGiven:)];
    [self registerForPomodoro:_PMPomoWillStart method:@selector(pomodoroWillStart:)];    
   
}


@end
