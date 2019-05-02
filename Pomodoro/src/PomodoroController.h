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

#import <Cocoa/Cocoa.h>
#import "CommonController.h"

@class AboutController;
@class StatsController;
@class SplashController;
@class PTHotKey;
@class Scripter;
@class PomodoroNotifier;
@class Pomodoro;

@interface PomodoroController : CommonController {
        	
	IBOutlet NSPanel* __unsafe_unretained prefs;
	IBOutlet NSPanel* __unsafe_unretained namePanel;
    IBOutlet NSComboBox* __unsafe_unretained namesCombo;
    IBOutlet NSPanel* __unsafe_unretained scriptPanel;
    
    IBOutlet NSTabView* __unsafe_unretained tabView;
    IBOutlet NSToolbar* __unsafe_unretained toolBar;
	IBOutlet NSMenu* __unsafe_unretained pomodoroMenu;
	IBOutlet NSComboBox* initialTimeCombo;
	IBOutlet NSComboBox* initialTimeComboInStart;
	IBOutlet NSComboBox* __unsafe_unretained interruptCombo;
	IBOutlet NSComboBox* __unsafe_unretained breakCombo;
	IBOutlet NSComboBox* __unsafe_unretained longBreakCombo;
	IBOutlet NSComboBox* __unsafe_unretained longBreakResetComboTime;
	IBOutlet NSComboBox* __unsafe_unretained pomodorosForLong;
			
	IBOutlet NSMenuItem* __unsafe_unretained startPomodoro;
	IBOutlet NSMenuItem* __unsafe_unretained finishPomodoro;
	IBOutlet NSMenuItem* __unsafe_unretained interruptPomodoro;
	IBOutlet NSMenuItem* __unsafe_unretained internalInterruptPomodoro;
	IBOutlet NSMenuItem* __unsafe_unretained invalidatePomodoro;
	IBOutlet NSMenuItem* __unsafe_unretained resumePomodoro;

	IBOutlet Pomodoro* __unsafe_unretained pomodoro;
    NSInteger longBreakCounter;
    NSTimer* longBreakCheckerTimer;
    PomodoroNotifier* pomodoroNotifier;
    
    ProcessSerialNumber psn;
	AboutController* about;
	SplashController* splash;
	StatsController* stats;
	NSStatusItem* statusItem;
	
	NSImage* pomodoroImage;
	NSImage* pomodoroBreakImage;
	NSImage* pomodoroFreezeImage;
	NSImage* pomodoroNegativeImage;
	NSImage* pomodoroNegativeBreakImage;
	NSImage* pomodoroNegativeFreezeImage;
	
	NSSound* ringing;
	NSSound* ringingBreak;
	NSSound* tick;
			
}

@property (unsafe_unretained) IBOutlet NSPanel* prefs;
@property (unsafe_unretained) IBOutlet NSPanel* namePanel;
@property (unsafe_unretained) IBOutlet NSComboBox* namesCombo;
@property (unsafe_unretained) IBOutlet NSPanel* scriptPanel;

@property (unsafe_unretained) IBOutlet NSTabView* tabView;
@property (unsafe_unretained) IBOutlet NSToolbar* toolBar;
@property (unsafe_unretained) IBOutlet NSMenu* pomodoroMenu;
@property IBOutlet NSComboBox* initialTimeCombo;
@property (unsafe_unretained) IBOutlet NSComboBox* interruptCombo;
@property (unsafe_unretained) IBOutlet NSComboBox* breakCombo;
@property (unsafe_unretained) IBOutlet NSComboBox* longBreakCombo;
@property (unsafe_unretained) IBOutlet NSComboBox* longBreakResetComboTime;
@property (unsafe_unretained) IBOutlet NSComboBox* pomodorosForLong;

@property (unsafe_unretained) IBOutlet Pomodoro* pomodoro;
@property (nonatomic, assign) NSInteger longBreakCounter;
@property (nonatomic) NSTimer* longBreakCheckerTimer;


@property (nonatomic, unsafe_unretained, readonly) IBOutlet NSMenuItem* startPomodoro;
@property (nonatomic, unsafe_unretained, readonly) IBOutlet NSMenuItem* finishPomodoro;
@property (nonatomic, unsafe_unretained, readonly) IBOutlet NSMenuItem* interruptPomodoro;
@property (nonatomic, unsafe_unretained, readonly) IBOutlet NSMenuItem* internalInterruptPomodoro;
@property (nonatomic, unsafe_unretained, readonly) IBOutlet NSMenuItem* invalidatePomodoro;
@property (nonatomic, unsafe_unretained, readonly) IBOutlet NSMenuItem* resumePomodoro;

-(void) keyMute;
-(void) keyStart;
-(void) keyReset;
-(void) keyInterrupt;
-(void) keyInternalInterrupt;
-(void) keyResume;

-(void) showTimeOnStatusBar:(NSInteger) time;
-(void) updateNamesComboData;

-(IBAction) about:(id)sender;
-(IBAction) help:(id)sender;
-(IBAction) quit:(id)sender;

-(IBAction) setup:(id)sender;
-(IBAction) stats:(id)sender;
-(IBAction) quickStats:(id)sender;

-(IBAction) start: (id) sender;
-(IBAction) finish: (id) sender;
-(IBAction) nameGiven:(id)sender;
-(IBAction) nameCanceled:(id)sender;
-(IBAction) reset: (id) sender;

-(IBAction) externalInterrupt: (id) sender;
-(IBAction) internalInterrupt: (id) sender;
-(IBAction) resume: (id) sender;
-(IBAction) resetDefaultValues: (id) sender;
-(IBAction) changedCanRestartInBreaks: (id) sender;

-(IBAction) toolBarIconClicked: (id) sender;

@end
