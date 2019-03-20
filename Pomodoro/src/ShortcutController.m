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

#import "ShortcutController.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"
#import "Carbon/Carbon.h"
#import "PomoNotifications.h"

@implementation ShortcutController

@synthesize delegate, startRecorder, interruptRecorder, internalInterruptRecorder, muteRecorder, quickStatsRecorder, resetRecorder, resumeRecorder;

#pragma mark - Shortcut recorder callbacks & support

- (void)switchKey: (NSString*)name forKey:(PTHotKey*)key withMethod:(SEL)method withRecorder:(SRRecorderControl*)recorder {
    
	if (key != nil) {
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: key];
	}
	
	//NSLog(@"Code %d flags: %u, PT flags: %u", [recorder keyCombo].code, [recorder keyCombo].flags, [recorder cocoaToCarbonFlags: [recorder keyCombo].flags]);
    
	key = [[PTHotKey alloc] initWithIdentifier:name keyCombo:[PTKeyCombo keyComboWithKeyCode:[recorder keyCombo].code modifiers:[recorder cocoaToCarbonFlags: [recorder keyCombo].flags]]];
	[key setTarget: self];
	[key setAction: method];
	[[PTHotKeyCenter sharedCenter] registerHotKey: key];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithShort:[recorder keyCombo].code] forKey:[NSString stringWithFormat:@"%@%@", name, @"Code"]];
	[[NSUserDefaults standardUserDefaults] setObject: [NSNumber numberWithUnsignedInteger:[recorder keyCombo].flags] forKey:[NSString stringWithFormat:@"%@%@", name, @"Flags"]];
	
}

- (void)shortcutRecorder:(id)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
    
	if (aRecorder == muteRecorder) {
		[self switchKey:@"mute" forKey:muteKey withMethod:@selector(keyMute) withRecorder:aRecorder];
	} else if (aRecorder == startRecorder) {
		[self switchKey:@"start" forKey:startKey withMethod:@selector(keyStart) withRecorder:aRecorder];
	} else if (aRecorder == resetRecorder) {
		[self switchKey:@"reset" forKey:resetKey withMethod:@selector(keyReset) withRecorder:aRecorder];
	} else if (aRecorder == interruptRecorder) {
		[self switchKey:@"interrupt" forKey:interruptKey withMethod:@selector(keyInterrupt) withRecorder:aRecorder];
	} else if (aRecorder == internalInterruptRecorder) {
		[self switchKey:@"internalInterrupt" forKey:internalInterruptKey withMethod:@selector(keyInternalInterrupt) withRecorder:aRecorder];
	} else if (aRecorder == resumeRecorder) {
		[self switchKey:@"resume" forKey:resumeKey withMethod:@selector(keyResume) withRecorder:aRecorder];
	} else if (aRecorder == quickStatsRecorder) {
		[self switchKey:@"quickStats" forKey:quickStatsKey withMethod:@selector(keyQuickStats) withRecorder:aRecorder];
	} 
}

- (void) updateShortcuts {
    
	muteKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"muteCode"] intValue];
	muteKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"muteFlags"] intValue];
	startKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startCode"] intValue];
	startKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"startFlags"] intValue];
	resetKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resetCode"] intValue];
	resetKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resetFlags"] intValue];
	interruptKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptCode"] intValue];
	interruptKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"interruptFlags"] intValue];
	internalInterruptKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"internalInterruptCode"] intValue];
	internalInterruptKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"internalInterruptFlags"] intValue];
	resumeKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resumeCode"] intValue];
	resumeKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"resumeFlags"] intValue];
	quickStatsKeyCombo.code = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quickStatsCode"] intValue];
	quickStatsKeyCombo.flags = [[[NSUserDefaults standardUserDefaults] objectForKey:@"quickStatsFlags"] intValue];
    
	[muteRecorder setKeyCombo:muteKeyCombo];
	[startRecorder setKeyCombo:startKeyCombo];
	[resetRecorder setKeyCombo:resetKeyCombo];
	[interruptRecorder setKeyCombo:interruptKeyCombo];
	[internalInterruptRecorder setKeyCombo:internalInterruptKeyCombo];
	[resumeRecorder setKeyCombo:resumeKeyCombo];
	[quickStatsRecorder setKeyCombo:quickStatsKeyCombo];
}

#pragma mark ---- Key management methods ----

-(void) keyMute {
    [delegate keyMute];
}

-(void) keyStart {
    [delegate keyStart];	
}

-(void) keyReset {
    [delegate keyReset];
}

-(void) keyInterrupt {
    [delegate keyInterrupt];
}

-(void) keyInternalInterrupt {
    [delegate keyInternalInterrupt];
}

-(void) keyResume {
    [delegate keyResume];
}

-(void) keyQuickStats {
    [delegate keyQuickStats];
}


#pragma mark ---- Lifecycle methods ----

- (void)awakeFromNib {
    
    [self updateShortcuts];
    [self registerForPomodoro:_PMResetDefault method:@selector(updateShortcuts)];


}
@end
