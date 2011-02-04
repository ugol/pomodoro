//
//  SR_LeopardInspector.m
//  SR Leopard
//
//  Created by Jesper on 2007-10-19.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SR_LeopardInspector.h"
#import <ShortcutRecorder/ShortcutRecorder.h>

@implementation SR_LeopardInspector

- (NSString *)viewNibName {
	return @"SR_LeopardInspector";
}

- (NSString *)label {
	return @"Shortcut Recorder";
}

+ (BOOL)supportsMultipleObjectInspection {
	return NO; /** Ridiculously large fixme. */
}

#define	SRInspectorCommandTag	10
#define	SRInspectorShiftTag		20
#define	SRInspectorOptionTag	40
#define	SRInspectorControlTag	80
// shift, opt, ctrl

- (NSUInteger)cocoaFlagsForSegmentedControl:(NSSegmentedControl *)segC {
	NSSegmentedCell *seg = [segC cell];
	NSInteger max = [seg segmentCount];
//	NSLog(@"cocoaFlagsForSegmentedControl: %@, seg count: %d", segC, max);
	NSUInteger mask = ShortcutRecorderEmptyFlags;
	for (NSInteger i = 0; i < max; i++) {
		if (![seg isSelectedForSegment:i]) continue;
		NSInteger tag = [seg tagForSegment:i];
//		NSLog(@"seg %d is selected; tag %d", i, tag);
		switch (tag) {
			case SRInspectorShiftTag:
//		NSLog(@"shift");
				mask |= NSShiftKeyMask;
				break;
			case SRInspectorOptionTag:
//		NSLog(@"opt");
				mask |= NSAlternateKeyMask;
				break;
			case SRInspectorCommandTag:
//		NSLog(@"cmd");
				mask |= NSCommandKeyMask;
				break;
			case SRInspectorControlTag:
//		NSLog(@"ctrl");
				mask |= NSControlKeyMask;
				break;
		}
	}
	NSLog(@"mask is: %ld", mask);
	return mask;
}

- (void)selectInSegmentedControl:(NSSegmentedControl *)segC basedOnCocoaFlags:(NSUInteger)mask {
	NSSegmentedCell *seg = [segC cell];
//	NSLog(@"---");
//	NSLog(@"mask: %d", mask);
	NSInteger max = [seg segmentCount];
	for (NSInteger i = 0; i < max; i++) {
		NSInteger tag = [seg tagForSegment:i];
//		NSLog(@"segment %d, tag %d", i, tag);
		BOOL toselect = NO;
		switch (tag) {
			case SRInspectorShiftTag:
//				NSLog(@"shift: %d (%d) = %d", NSShiftKeyMask, mask, !!(mask & NSShiftKeyMask));
				toselect = !!(mask & NSShiftKeyMask);
				break;
			case SRInspectorOptionTag:
//				NSLog(@"opt: %d (%d) = %d", NSAlternateKeyMask, mask, !!(mask & NSAlternateKeyMask));
				toselect = !!(mask & NSAlternateKeyMask);
				break;
			case SRInspectorCommandTag:
//				NSLog(@"cmd: %d (%d) = %d", NSCommandKeyMask, mask, !!(mask & NSCommandKeyMask));
				toselect = !!(mask & NSCommandKeyMask);
				break;
			case SRInspectorControlTag:
//				NSLog(@"ctrl: %d (%d) = %d", NSControlKeyMask, mask, !!(mask & NSControlKeyMask));
				toselect = !!(mask & NSControlKeyMask);
				break;
		}
//		NSLog(@" - select? %d", toselect);
		[seg setSelected:toselect forSegment:i];
	}
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects.
	
	NSArray *objs = [self inspectedObjects];
	if ([objs count] == 0) {
		[super refresh];
		return;
	}
	SRRecorderControl *rec = [objs objectAtIndex:0];
//	NSLog(@"rec: %@", rec);
	
//	NSLog(@"refresh");
	[self selectInSegmentedControl:allowed basedOnCocoaFlags:[rec allowedFlags]];
	[self selectInSegmentedControl:required basedOnCocoaFlags:[rec requiredFlags]];
	
	BOOL allowsKeyOnly = NO; BOOL escapeKeysRecord = NO;
	allowsKeyOnly = [rec allowsKeyOnly];
	escapeKeysRecord = [rec escapeKeysRecord];
	[recordBareKeys selectItemWithTag:(allowsKeyOnly ? (escapeKeysRecord ? 2 : 1) : 0)];
	
	[style selectItemWithTag:[rec style]];
	[animates setEnabled:[SRRecorderCell styleSupportsAnimation:[rec style]]];
	[animates setState:([rec animates] ? NSOnState : NSOffState)];
	
	[initial setKeyCombo:[rec keyCombo]];
	[initial setDelegate:self];
	
	[super refresh];
}

- (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo {
	if (aRecorder == initial) {
		NSArray *objs = [self inspectedObjects];
		if ([objs count] == 0) {
			return;
		}
		SRRecorderControl *rec = [objs objectAtIndex:0];
		
		[rec setKeyCombo: [initial keyCombo]];
	}
}

- (IBAction)ok:(id)sender {
	NSArray *objs = [self inspectedObjects];
	if ([objs count] == 0) return;
	
	SRRecorderControl *rec = [objs objectAtIndex:0];
	
	NSUInteger allowedF = [self cocoaFlagsForSegmentedControl:allowed];
//	NSLog(@"allowedF: %d", allowedF);
//	NSLog(@"-----");
	NSUInteger requiredF = [self cocoaFlagsForSegmentedControl:required];
//	NSLog(@"requiredF: %d", requiredF);
//	NSLog(@"-----");
	[rec setAllowedFlags:allowedF];
//	NSLog(@"set allowed!");
	[rec setRequiredFlags:requiredF];
//	NSLog(@"set required!");
	
	[initial setAllowedFlags:allowedF];
	[initial setRequiredFlags:requiredF];
	
	BOOL allowsKeyOnly = NO; BOOL escapeKeysRecord = NO;
	NSInteger allowsTag = [recordBareKeys selectedTag];
	if (allowsTag > 0)
		allowsKeyOnly = YES;
	if (allowsTag > 1)
		escapeKeysRecord = YES;
	
	[rec setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
	[initial setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
	
	SRRecorderStyle rst = (SRRecorderStyle)[style selectedTag];
	[rec setStyle:rst];
	[animates setEnabled:[SRRecorderCell styleSupportsAnimation:rst]];
	[rec setAnimates:([animates state] == NSOnState)];
	[rec setKeyCombo:[initial keyCombo]];
	
	
}

/*
 - (void)ok:(id)sender
 {
 SRRecorderControl *recorder = (SRRecorderControl *)[self object];
 unsigned int allowedFlags = 0, requiredFlags = 0;
 
 // Undo support - TO COME
 //[self beginUndoGrouping];
 //[self noteAttributesWillChangeForObject: recorder];
 
 // Set allowed flags
 if ([allowedModifiersCommandCheckBox state]) allowedFlags += NSCommandKeyMask;
 if ([allowedModifiersOptionCheckBox state]) allowedFlags += NSAlternateKeyMask;
 if ([allowedModifiersControlCheckBox state]) allowedFlags += NSControlKeyMask;
 if ([allowedModifiersShiftCheckBox state]) allowedFlags += NSShiftKeyMask;
 [recorder setAllowedFlags: allowedFlags];
 [initialShortcutRecorder setAllowedFlags: allowedFlags];
 
 // Set required flags	
 if ([requiredModifiersCommandCheckBox state]) requiredFlags += NSCommandKeyMask;
 if ([requiredModifiersOptionCheckBox state]) requiredFlags += NSAlternateKeyMask;
 if ([requiredModifiersControlCheckBox state]) requiredFlags += NSControlKeyMask;
 if ([requiredModifiersShiftCheckBox state]) requiredFlags += NSShiftKeyMask;
 [recorder setRequiredFlags: requiredFlags];
 [initialShortcutRecorder setRequiredFlags: requiredFlags];
 
 // Set autosave name
 [recorder setAutosaveName: [autoSaveNameTextField stringValue]];
 
 BOOL allowsKeyOnly = NO; BOOL escapeKeysRecord = NO;
 int allowsTag = [allowsBareKeysPopUp selectedTag];
 if (allowsTag > 0)
 allowsKeyOnly = YES;
 if (allowsTag > 1)
 escapeKeysRecord = YES;
 
 [recorder setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
 [initialShortcutRecorder setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
 
 int style = [stylePopUp selectedTag];
 BOOL supportsAnimates = [SRRecorderCell styleSupportsAnimation:(SRRecorderStyle)style];
 [animatesButton setEnabled:supportsAnimates];
 if ([animatesButton state] && !supportsAnimates) {
 [animatesButton setState:NSOffState];
 }
 [recorder setStyle:(SRRecorderStyle)style];
 
 // Set initial combo
 [recorder setKeyCombo: [initialShortcutRecorder keyCombo]];
 
 [recorder setEnabled: [enabledButton state]];
 [recorder setHidden: [hiddenButton state]];
 [recorder setAnimates: [animatesButton state]];
 
 [super ok: sender];
 }
 
 - (void)revert:(id)sender
 {
 SRRecorderControl *recorder = (SRRecorderControl *)[self object];
 unsigned int allowedFlags = [recorder allowedFlags], requiredFlags = [recorder requiredFlags];
 
 // Set allowed checkbox values
 [allowedModifiersCommandCheckBox setState: (allowedFlags & NSCommandKeyMask) ? NSOnState : NSOffState];
 [allowedModifiersOptionCheckBox setState: (allowedFlags & NSAlternateKeyMask) ? NSOnState : NSOffState];
 [allowedModifiersControlCheckBox setState: (allowedFlags & NSControlKeyMask) ? NSOnState : NSOffState];
 [allowedModifiersShiftCheckBox setState: (allowedFlags & NSShiftKeyMask) ? NSOnState : NSOffState];
 
 // Set required checkbox values
 [requiredModifiersCommandCheckBox setState: (requiredFlags & NSCommandKeyMask) ? NSOnState : NSOffState];
 [requiredModifiersOptionCheckBox setState: (requiredFlags & NSAlternateKeyMask) ? NSOnState : NSOffState];
 [requiredModifiersControlCheckBox setState: (requiredFlags & NSControlKeyMask) ? NSOnState : NSOffState];
 [requiredModifiersShiftCheckBox setState: (requiredFlags & NSShiftKeyMask) ? NSOnState : NSOffState];
 
 // Set autosave name
 if ([[recorder autosaveName] length]) [autoSaveNameTextField setStringValue: [recorder autosaveName]];
 else [autoSaveNameTextField setStringValue: @""];
 
 BOOL allowsKeyOnly = [recorder allowsKeyOnly]; BOOL escapeKeysRecord = [recorder escapeKeysRecord];
 int allowsTag = 0;
 if (allowsKeyOnly && !escapeKeysRecord)
 allowsTag = 1;
 if (allowsKeyOnly && escapeKeysRecord)
 allowsTag = 2;
 
 [allowsBareKeysPopUp selectItemWithTag:allowsTag];
 
 [stylePopUp selectItemWithTag:(int)[recorder style]];
 
 [initialShortcutRecorder setStyle:[recorder style]];
 [initialShortcutRecorder setAllowsKeyOnly:allowsKeyOnly escapeKeysRecord:escapeKeysRecord];
 [initialShortcutRecorder setAnimates:[recorder animates]];
 
 [animatesButton setEnabled:[SRRecorderCell styleSupportsAnimation:[recorder style]]];
 
 // Set initial keycombo
 [initialShortcutRecorder setKeyCombo: [recorder keyCombo]];
 
 [enabledButton setState: [recorder isEnabled]];
 [hiddenButton setState: [recorder isHidden]];
 [animatesButton setState: [recorder animates]];
 
 [super revert: sender];
 }
 
 - (void)shortcutRecorder:(SRRecorderControl *)aRecorder keyComboDidChange:(KeyCombo)newKeyCombo
 {
 if (aRecorder == initialShortcutRecorder)
 {
 SRRecorderControl *recorder = (SRRecorderControl *)[self object];
 [recorder setKeyCombo: [initialShortcutRecorder keyCombo]];
 
 [[self inspectedDocument] drawObject: recorder];
 }
 }
 */

@end
