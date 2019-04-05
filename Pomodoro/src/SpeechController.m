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

#import "SpeechController.h"
#import "PomoNotifications.h"

@implementation SpeechController

@synthesize speech, voicesCombo, speechEveryCombo;

#pragma mark ---- Voice Combo box delegate/datasource methods ----

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [voices count]; 
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	NSString *v = [voices objectAtIndex:index]; 
    return [[NSSpeechSynthesizer attributesForVoice:v] objectForKey:NSVoiceName]; 
}

#pragma mark ---- KVO Utility ----

- (void)setVoiceByName:(NSString *)theName {
    for (NSString *voiceId in voices) {
        NSString *voiceName = [[NSSpeechSynthesizer attributesForVoice:voiceId] objectForKey:NSVoiceName];
        if ([voiceName compare:theName] == NSOrderedSame) {
            [speech setVoice:voiceId];
            break;
        }
    }  
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if ([keyPath hasSuffix:@"Volume"]) {
        NSInteger volume = [[change objectForKey:NSKeyValueChangeNewKey] intValue];
        
        NSInteger oldVolume = 0;
        if([NSNull null] != [change objectForKey:NSKeyValueChangeOldKey])
        {
            oldVolume = [[change objectForKey:NSKeyValueChangeOldKey] intValue];
        }
        if (volume != oldVolume) {
            float newVolume = volume/100.0;
            
            [speech setVolume:newVolume];
            [speech startSpeakingString:@"Volume Set"];
            
        }
    } else if ([keyPath hasSuffix:@"Voice"]) {
        [self setVoiceByName:_speechVoice];
        [speech startSpeakingString:@"Yes"];
    }
    	
}


#pragma mark ---- Pomodoro notifications methods ----

-(void) pomodoroStarted:(NSNotification*) notification {
    
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtStartEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechStart"]];
	}
	
}

- (void) interrupted {
    
    NSString* interruptTimeString = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] stringValue];
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtInterruptEnabled"]) {
		NSString* speechString = [self bindCommonVariables:@"speechInterrupt"];
		[speech startSpeakingString: [speechString stringByReplacingOccurrencesOfString:@"$secs" withString:interruptTimeString]];
	}
    
}

-(void) pomodoroExternallyInterrupted:(NSNotification*) notification {
	
    [self interrupted];
	
}

-(void) pomodoroInternallyInterrupted:(NSNotification*) notification {
	
    [self interrupted];
	
}

-(void) pomodoroInterruptionMaxTimeIsOver:(NSNotification*) notification {
    
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtInterruptOverEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechInterruptOver"]];
    }

}

-(void) pomodoroReset:(NSNotification*) notification {
    
    if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtResetEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechReset"]];
    }
    
}

-(void) pomodoroResumed:(NSNotification*) notification {
    
    if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtResumeEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechResume"]];
    }

}

-(void) breakFinished:(NSNotification*) notification {
    
	if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtBreakFinishedEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechBreakFinished"]];
    }

}

-(void) pomodoroFinished:(NSNotification*) notification {
 	
    if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtEndEnabled"]) {
		[speech startSpeakingString:[self bindCommonVariables:@"speechEnd"]];
    }
   
}

- (void) oncePerSecond:(NSNotification*) notification {
    
    NSInteger time = [[notification object] integerValue];
	
	NSInteger timePassed = (_initialTime*60) - time;
	NSString* timePassedString = [NSString stringWithFormat:@"%ld", timePassed/60];
	NSString* timeString = [NSString stringWithFormat:@"%ld", time/60];
	
	if (timePassed%(60 * _speechEveryTimeMinutes) == 0 && time!=0) {		
		if (![self checkDefault:@"mute"] && [self checkDefault:@"speechAtEveryEnabled"]) {
			NSString* msg = [[self bindCommonVariables:@"speechEvery"] stringByReplacingOccurrencesOfString:@"$mins" withString:[[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"] stringValue]];
			msg = [msg stringByReplacingOccurrencesOfString:@"$passed" withString:timePassedString];
			msg = [msg stringByReplacingOccurrencesOfString:@"$time" withString:timeString];
			[speech startSpeakingString:msg];
		}
	}
}

#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [speechEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:2]];
    [speechEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:5]];
    [speechEveryCombo addItemWithObjectValue: [NSNumber numberWithInt:10]];
    voices = [NSSpeechSynthesizer availableVoices];
    
    [speech setVolume:_voiceVolume/100.0];
    [self setVoiceByName:_speechVoice];
   
    [self registerForAllPomodoroEvents];
    [self observeUserDefault:@"voiceVolume"];
    [self observeUserDefault:@"defaultVoice"];

}


@end
