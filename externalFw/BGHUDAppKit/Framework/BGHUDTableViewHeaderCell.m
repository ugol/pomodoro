//
//  BGHUDTableViewHeaderCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
//
//  Copyright (c) 2008, Tim Davis (BinaryMethod.com, binary.god@gmail.com)
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//		Redistributions of source code must retain the above copyright notice, this
//	list of conditions and the following disclaimer.
//
//		Redistributions in binary form must reproduce the above copyright notice,
//	this list of conditions and the following disclaimer in the documentation and/or
//	other materials provided with the distribution.
//
//		Neither the name of the BinaryMethod.com nor the names of its contributors
//	may be used to endorse or promote products derived from this software without
//	specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS AS IS AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//	IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//	INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
//	OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//	WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//	POSSIBILITY OF SUCH DAMAGE.

#import "BGHUDTableViewHeaderCell.h"

@interface NSTableHeaderCell (AppKitPrivate)
- (void)_drawSortIndicatorIfNecessaryWithFrame:(NSRect)arg1 inView:(id)arg2;
@end

@implementation BGHUDTableViewHeaderCell

@synthesize themeKey;

#pragma mark Drawing Functions

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	//[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(id)copyWithZone:(NSZone *) zone {
	
	BGHUDTableViewHeaderCell *copy = [super copyWithZone: zone];
	
	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];
	
	return copy;
}

- (id)textColor {
	
	return [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor];
}

- (void)_drawThemeContents:(NSRect)frame highlighted:(BOOL)flag inView:(id)view {
	
	//Draw base layer
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellBorderColor] set];
	NSRectFill(frame);
	
	//Adjust fill layer
	//frame.origin.x += 1;	- Removed to fix Issue #31
	frame.size.width -= 1;
	frame.origin.y +=1;
	frame.size.height -= 2;
	
	if(flag) {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellSelectedFill] drawInRect: frame angle: 90];
	} else {
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellNormalFill] drawInRect: frame angle: 90];
	}
	
	//Adjust so text aligns correctly
	frame.origin.x -= 1;
	frame.size.width += 1;
	frame.origin.y -= 1;
	frame.size.height += 2;
	
	// REMOVED - Enabling this line draws two sort arrows, frame alignment issue here.
	//			 Not needed since the Apple drawing routines seem to be updating sort
	//			 arrows fine.
	/*if ([self respondsToSelector:@selector(_drawSortIndicatorIfNecessaryWithFrame:inView:)])
		[super _drawSortIndicatorIfNecessaryWithFrame: frame inView: view];*/
	
	frame.origin.y += (NSMidY(frame) - ([[self font] pointSize] /2)) - 2;
	frame.origin.x += 3;
	
	
	
	[super drawInteriorWithFrame: frame inView: view];
}

- (void)drawSortIndicatorWithFrame:(NSRect) frame inView:(id) controlView ascending:(BOOL) ascFlag priority:(NSInteger) priInt {
	
	frame.origin.y -=1;
	frame.size.height += 2;
	
	if(priInt == 0) {
		
		NSRect arrowRect = [self sortIndicatorRectForBounds: frame];
		
		// Adjust Arrow rect
		arrowRect.size.width -= 2;
		arrowRect.size.height -= 1;
		
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		NSPoint points[3];
		
		if(ascFlag == NO) {
			// Re-center arrow
			arrowRect.origin.y -= 2;
			points[0] = NSMakePoint(NSMinX(arrowRect), NSMinY(arrowRect) +2);
			points[1] = NSMakePoint(NSMaxX(arrowRect), NSMinY(arrowRect) +2);
			points[2] = NSMakePoint(NSMidX(arrowRect), NSMaxY(arrowRect));
		} else {
			
			points[0] = NSMakePoint(NSMinX(arrowRect), NSMaxY(arrowRect) -2);
			points[1] = NSMakePoint(NSMaxX(arrowRect), NSMaxY(arrowRect) -2);
			points[2] = NSMakePoint(NSMidX(arrowRect), NSMinY(arrowRect));
		}
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		if([self isEnabled]) {
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] set];
		} else {
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor] set];
		}
		
		[arrow fill];
		[arrow release];
	}
	
	frame.origin.y += 1;
	frame.size.height -= 2;
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

#pragma mark -

@end
