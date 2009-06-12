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

#import <Cocoa/Cocoa.h>

#define _initialTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"initialTime"] intValue]
#define _interruptTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptTime"] intValue]
#define _breakTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"breakTime"] intValue]
#define _longbreakTime [[[NSUserDefaults standardUserDefaults] objectForKey:@"longbreakTime"] intValue]
#define _growlEveryTimeMinutes [[[NSUserDefaults standardUserDefaults] objectForKey:@"growlEveryTimeMinutes"] intValue]
#define _speechEveryTimeMinutes [[[NSUserDefaults standardUserDefaults] objectForKey:@"speechEveryTimeMinutes"] intValue]
#define _speechVoice [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultVoice"]

@class AboutController;
@class StatsController;
@class Pomodoro;
@class GrowlNotifier;
@class PomodoroStats;

@interface PomodoroController : NSObject {

	AboutController* about;
	StatsController* stats;
	
	NSStatusItem* statusItem;	
	IBOutlet NSPanel* prefs;
	IBOutlet NSPanel* namePanel;
	IBOutlet NSMenu* pomodoroMenu;
	IBOutlet NSComboBox* voicesCombo;
	IBOutlet NSComboBox* initialTimeCombo;
	NSArray* voices;
	
	NSMenuItem* startPomodoro;
	NSMenuItem* interruptPomodoro;
	NSMenuItem* invalidatePomodoro;
	NSMenuItem* resumePomodoro;
	NSMenuItem* setupPomodoro;
	
	NSImage* pomodoroImage;
	NSImage* pomodoroBreakImage;
	NSImage* pomodoroFreezeImage;
	NSSound* ringing;
	NSSound* tick;
	NSSpeechSynthesizer* speech;
	
	GrowlNotifier* growl;
	Pomodoro* pomodoro;
	PomodoroStats* pomoStats;
		
}

@property (nonatomic, readonly) NSMenuItem* startPomodoro;
@property (nonatomic, readonly) NSMenuItem* interruptPomodoro;
@property (nonatomic, readonly) NSMenuItem* invalidatePomodoro;
@property (nonatomic, readonly) NSMenuItem* resumePomodoro;

-(void) pomodoroStarted;

-(IBAction) about:(id)sender;
-(IBAction) quit:(id)sender;

-(IBAction) setup:(id)sender;
-(IBAction) stats:(id)sender;

-(IBAction) start: (id) sender;
-(IBAction) nameGiven:(id)sender;
-(IBAction) nameCanceled:(id)sender;
-(IBAction) reset: (id) sender;

-(IBAction) interrupt: (id) sender;
-(IBAction) resume: (id) sender;

@end
