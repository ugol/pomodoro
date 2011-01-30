//
//  BGHUDTokenFieldCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/10/08.
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

#import "BGHUDTokenFieldCell.h"


@implementation BGHUDTokenFieldCell

@synthesize themeKey;

#pragma mark Drawing Functions

-(id)initTextCell:(NSString *)aString {

	self = [super initTextCell: aString];

	if(self) {

		self.themeKey = @"gradientTheme";

		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];

		if([self drawsBackground]) {

			fillsBackground = YES;
		}

		[self setDrawsBackground: NO];
	}

	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {

	self = [super initWithCoder: aDecoder];

	if(self) {

		if([aDecoder containsValueForKey: @"themeKey"]) {

			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			self.themeKey = @"gradientTheme";
		}

		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];

		if([self drawsBackground]) {

			fillsBackground = YES;
		}

		[self setDrawsBackground: NO];
	}

	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {

	[super encodeWithCoder: coder];

	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(id)copyWithZone:(NSZone *) zone {

	BGHUDTokenFieldCell *copy = [super copyWithZone: zone];

	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];

	return copy;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {

	//Adjust Rect
	cellFrame = NSInsetRect(cellFrame, 0.5f, 0.5f);

	//Create Path
	NSBezierPath *path = [[NSBezierPath alloc] init];

	if([self bezelStyle] == NSTextFieldRoundedBezel) {

		[path appendBezierPathWithArcWithCenter: NSMakePoint(cellFrame.origin.x + (cellFrame.size.height /2), cellFrame.origin.y + (cellFrame.size.height /2))
										 radius: cellFrame.size.height /2
									 startAngle: 90
									   endAngle: 270];

		[path appendBezierPathWithArcWithCenter: NSMakePoint(cellFrame.origin.x + (cellFrame.size.width - (cellFrame.size.height /2)), cellFrame.origin.y + (cellFrame.size.height /2))
										 radius: cellFrame.size.height /2
									 startAngle: 270
									   endAngle: 90];

		[path closePath];
	} else {

		[path appendBezierPathWithRoundedRect: cellFrame xRadius: 3.0f yRadius: 3.0f];
	}

	//Draw Background
	if(fillsBackground) {

		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textFillColor] set];
		[path fill];
	}

	if([self isBezeled] || [self isBordered]) {

		[NSGraphicsContext saveGraphicsState];

		if([super showsFirstResponder] && [[[self controlView] window] isKeyWindow] &&
		   ([self focusRingType] == NSFocusRingTypeDefault ||
			[self focusRingType] == NSFocusRingTypeExterior)) {

			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] focusRing] set];
		}

		//Check State
		if([self isEnabled]) {

			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		} else {

			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
		}

		[path setLineWidth: 1.0f];
		[path stroke];

		[NSGraphicsContext restoreGraphicsState];
	}

	[path release];

	//Get TextView for this editor
	NSTextView* view = (NSTextView*)[[controlView window] fieldEditor: NO forObject: controlView];
	[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];

	//Get Attributes of the selected text
	NSMutableDictionary *dict = [[[view selectedTextAttributes] mutableCopy] autorelease];

	//If window/app is active draw the highlight/text in active colors
	if([self showsFirstResponder] && [[[self controlView] window] isKeyWindow])
	{
		[dict setObject: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionHighlightActiveColor]
				 forKey: NSBackgroundColorAttributeName];

		[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor]
					 range: [view selectedRange]];
	}
	else
	{
		[dict setObject: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionHighlightInActiveColor]
				 forKey: NSBackgroundColorAttributeName];

		[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor]
					 range: [view selectedRange]];
	}

	[view setSelectedTextAttributes:dict];

	if([self isEnabled]) {

		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
	} else {

		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor]];
	}

	[self drawInteriorWithFrame: cellFrame inView: controlView];
}

-(void)drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {

	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

- (id)setUpTokenAttachmentCell:(NSTokenAttachmentCell *)fp8 forRepresentedObject:(id)fp12 {

	BGHUDTokenAttachmentCell *cell = [[BGHUDTokenAttachmentCell alloc] initTextCell: [fp8 stringValue]];

	[cell setRepresentedObject: fp12];
	[cell setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tokenTextColor]];
	[cell setAttachment: [fp8 attachment]];
	[cell setTokenBorder: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tokenBorder]];
	[cell setTokenFillNormal: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tokenFillNormal]];
	[cell setTokenFillHighlight: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] tokenFillHighlight]];
	[cell setControlSize: [self controlSize]];

	return [cell autorelease];
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj {

	NSText *newText = [[super setUpFieldEditorAttributes: textObj] retain];
	[(NSTextView *)newText setInsertionPointColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
	return [newText autorelease];
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {

	[themeKey release];
	[super dealloc];
}

#pragma mark -

@end
