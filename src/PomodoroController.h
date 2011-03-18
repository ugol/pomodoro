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
#import <ShortcutRecorder/SRRecorderControl.h>
#import <OSAKit/OSAScriptView.h>
#import <OSAKit/OSAScriptController.h>
#import "PomodoroNotifier.h"
#import "CommonController.h"

@class AboutController;
@class StatsController;
@class SplashController;
@class GrowlNotifier;
@class PTHotKey;
@class Scripter;
@class CalendarController;

@interface PomodoroController : CommonController <NSOpenSavePanelDelegate> {

	ProcessSerialNumber psn;
	AboutController* about;
	SplashController* splash;
	StatsController* stats;
	IBOutlet CalendarController* calendar;
    
	NSStatusItem* statusItem;	
	IBOutlet NSPanel* prefs;
	IBOutlet NSPanel* namePanel;
    IBOutlet NSPanel* scriptPanel;
    IBOutlet OSAScriptView* scriptView;
	IBOutlet NSComboBox* namesCombo;
    
    IBOutlet NSTabView* tabView;
    IBOutlet NSToolbar* toolBar;
	IBOutlet NSMenu* pomodoroMenu;
	IBOutlet NSComboBox* initialTimeCombo;
	IBOutlet NSComboBox* interruptCombo;
	IBOutlet NSComboBox* breakCombo;
	IBOutlet NSComboBox* longBreakCombo;
	IBOutlet NSComboBox* pomodorosForLong;
	IBOutlet NSComboBox* scriptEveryCombo;
		
    IBOutlet SRRecorderControl* muteRecorder;
    IBOutlet SRRecorderControl* startRecorder;
    IBOutlet SRRecorderControl* resetRecorder;
    IBOutlet SRRecorderControl* interruptRecorder;
    IBOutlet SRRecorderControl* internalInterruptRecorder;
    IBOutlet SRRecorderControl* resumeRecorder;
    IBOutlet SRRecorderControl* quickStatsRecorder;
	
	PTHotKey *muteKey;
	PTHotKey *startKey;
	PTHotKey *resetKey;
	PTHotKey *interruptKey;
	PTHotKey *internalInterruptKey;
	PTHotKey *resumeKey;
	PTHotKey *quickStatsKey;
	
	KeyCombo muteKeyCombo;
	KeyCombo startKeyCombo;
	KeyCombo resetKeyCombo;
	KeyCombo interruptKeyCombo;
	KeyCombo internalInterruptKeyCombo;
	KeyCombo resumeKeyCombo;
	KeyCombo quickStatsKeyCombo;

	NSArray* textViews;
    NSArray* scriptNames;
	
	IBOutlet NSMenuItem* startPomodoro;
	IBOutlet NSMenuItem* finishPomodoro;
	IBOutlet NSMenuItem* interruptPomodoro;
	IBOutlet NSMenuItem* internalInterruptPomodoro;
	IBOutlet NSMenuItem* invalidatePomodoro;
	IBOutlet NSMenuItem* resumePomodoro;
	IBOutlet NSMenuItem* setupPomodoro;
	
	NSImage* pomodoroImage;
	NSImage* pomodoroBreakImage;
	NSImage* pomodoroFreezeImage;
	NSImage* pomodoroNegativeImage;
	NSImage* pomodoroNegativeBreakImage;
	NSImage* pomodoroNegativeFreezeImage;
	
	NSSound* ringing;
	NSSound* ringingBreak;
	NSSound* tick;
	
	IBOutlet GrowlNotifier* growl;
	IBOutlet Pomodoro* pomodoro;
    PomodoroNotifier* pomodoroNotifier;
	IBOutlet Scripter* scripter;
			
}

@property (nonatomic, readonly) NSMenuItem* startPomodoro;
@property (nonatomic, readonly) NSMenuItem* interruptPomodoro;
@property (nonatomic, readonly) NSMenuItem* internalInterruptPomodoro;
@property (nonatomic, readonly) NSMenuItem* invalidatePomodoro;
@property (nonatomic, readonly) NSMenuItem* resumePomodoro;

-(void) keyMute;
-(void) keyStart;
-(void) keyReset;
-(void) keyInterrupt;
-(void) keyInternalInterrupt;
-(void) keyResume;

-(IBAction)showOpenPanel:(id)sender;
-(IBAction)showScriptingPanel:(id)sender;

-(IBAction) about:(id)sender;
-(IBAction) help:(id)sender;
-(IBAction) quit:(id)sender;

-(IBAction) setup:(id)sender;
-(IBAction) stats:(id)sender;

-(IBAction) start: (id) sender;
-(IBAction) finish: (id) sender;
-(IBAction) nameGiven:(id)sender;
-(IBAction) nameCanceled:(id)sender;
-(IBAction) reset: (id) sender;

-(IBAction) interrupt: (id) sender;
-(IBAction) internalInterrupt: (id) sender;
-(IBAction) resume: (id) sender;
-(IBAction) resetDefaultValues: (id) sender;
-(IBAction) changedCanRestartInBreaks: (id) sender;

-(IBAction) toolBarIconClicked: (id) sender;

@end
