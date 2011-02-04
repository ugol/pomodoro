//
//  AppController.m
//  ShortcutRecorder
//
//  Copyright 2006-2007 Contributors. All rights reserved.
//
//  License: BSD
//
//  Contributors:
//      David Dauer
//      Jesper

#import "AppController.h"
#import "PTHotKeyCenter.h"
#import "PTHotKey.h"

@implementation AppController

- (void)awakeFromNib
{
	[mainWindow center];
}

#pragma mark -

- (IBAction)allowedModifiersChanged:(id)sender
{
	NSUInteger newFlags = 0;
	
	if ([allowedModifiersCommandCheckBox state]) newFlags += NSCommandKeyMask;
	if ([allowedModifiersOptionCheckBox state]) newFlags += NSAlternateKeyMask;
	if ([allowedModifiersControlCheckBox state]) newFlags += NSControlKeyMask;
	if ([allowedModifiersShiftCheckBox state]) newFlags += NSShiftKeyMask;
	
	[shortcutRecorder setAllowedFlags: newFlags];
}

- (IBAction)requiredModifiersChanged:(id)sender
{
	NSUInteger newFlags = 0;
	
	if ([requiredModifiersCommandCheckBox state]) newFlags += NSCommandKeyMask;
	if ([requiredModifiersOptionCheckBox state]) newFlags += NSAlternateKeyMask;
	if ([requiredModifiersControlCheckBox state]) newFlags += NSControlKeyMask;
	if ([requiredModifiersShiftCheckBox state]) newFlags += NSShiftKeyMask;
	
	[shortcutRecorder setRequiredFlags: newFlags];
}

- (IBAction)toggleGlobalHotKey:(id)sender
{
	[shortcutRecorder setCanCaptureGlobalHotKeys:[globalHotKeyCheckBox state]];
	if (globalHotKey != nil)
	{
		[[PTHotKeyCenter sharedCenter] unregisterHotKey: globalHotKey];
		[globalHotKey release];
		globalHotKey = nil;
	}

	if (![globalHotKeyCheckBox state]) return;

	globalHotKey = [[PTHotKey alloc] initWithIdentifier:@"SRTest"
											   keyCombo:[PTKeyCombo keyComboWithKeyCode:[shortcutRecorder keyCombo].code
																			  modifiers:[shortcutRecorder cocoaToCarbonFlags: [shortcutRecorder keyCombo].flags]]];
	
	[globalHotKey setTarget: self];
	[globalHotKey setAction: @selector(hitHotKey:)];
	
	[[PTHotKeyCenter sharedCenter] registerHotKey: globalHotKey];
}

- (IBAction)changeAllowsBareKeys:(id)sender {
	BOOL allowsKeyOnly = NO; BOOL escapeKeysRecord = NO;
	NSInteger allowsTag = [allowsBareKeysPopUp selectedTag];
	if (allowsTag > 0)
		allowsKeyOnly = YES;
	if (allowsTag > 1)
		escapeKeysRecord = YES;
	[shortcutRecorder setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
	[delegateDisallowRecorder setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
}

- (IBAction)changeStyle:(id)sender {
	NSInteger style = [stylePopUp selectedTag];
	BOOL animates = NO;
	if (style == 2) {
		style = 1;
		animates = YES;
	}
	[shortcutRecorder setAnimates:animates];
	[shortcutRecorder setStyle:(SRRecorderStyle)style];
	[delegateDisallowRecorder setAnimates:animates];
	[delegateDisallowRecorder setStyle:(SRRecorderStyle)style];
}

#pragma mark -

- (BOOL)shortcutRecorder:(SRRecorderControl *)aRecorder isKeyCode:(NSInteger)keyCode andFlagsTaken:(NSUInteger)flags reason:(NSString **)aReason
{
	if (aRecorder == shortcutRecorder)
	{
		BOOL isTaken = NO;
		
		KeyCombo kc = [delegateDisallowRecorder keyCombo];
		
		if (kc.code == keyCode && kc.flags == flags) isTaken = YES;
		
		*aReason = [delegateDisallowReasonField stringValue];
		
		return isTaken;
	}
	
	return NO;
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
{
	if (aRecorder == shortcutRecorder)
	{
		[self toggleGlobalHotKey: aRecorder];
	}
}

- (void)hitHotKey:(PTHotKey *)hotKey
{
	NSMutableAttributedString *logString = [globalHotKeyLogView textStorage];
	[[logString mutableString] appendString: [NSString stringWithFormat: @"%@ pressed. \n", [shortcutRecorder keyComboString]]];
	
	[globalHotKeyLogView scrollPoint: NSMakePoint(0, [globalHotKeyLogView frame].size.height)];
}

@end
