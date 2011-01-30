//
//  NGHUDComboBoxCell.m
//  BGHUDAppKit
//
//  Created by Alan Rogers on 10/11/08.
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

#import "BGHUDComboBoxCell.h"

@implementation BGHUDComboBoxCell

@synthesize themeKey;

#pragma mark Drawing Functions

-(id)initTextCell:(NSString *) aString {
	
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

-(id)initWithCoder:(NSCoder *) aDecoder {
	
	if((self = [super initWithCoder: aDecoder])) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
			
		} else {
			
			self.themeKey = @"gradientTheme";
		}
		
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *) coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(id)copyWithZone:(NSZone *) zone {

	BGHUDComboBoxCell *copy = [super copyWithZone: zone];
	
	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];
	
	return copy;
}

-(void)drawWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	
	//Adjust Rect
	cellFrame = NSInsetRect(cellFrame, 1.5f, 1.5f);
	
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
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[path setLineWidth: 1.0f];
		[path stroke];
		
		[NSGraphicsContext restoreGraphicsState];
	}
	
	[path release];
	
	NSRect frame = cellFrame;
	
	//Adjust based on Control size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.size.width = (frame.size.width -21);
			break;
			
		case NSSmallControlSize:
			
			frame.size.width = (frame.size.width - 18);
			break;
			
		case NSMiniControlSize:
			
			frame.size.width += (frame.size.width - 15);			
			break;
	}
	
	// Draw a 'button' around the arrow
	// TODO: Get this behaviour to work...
	//if ([self isBordered]) 

	{
		[self drawButtonInRect: cellFrame];
	}
	
	//Draw the arrow
	[self drawArrowsInRect: cellFrame];
	
	
	// Change the selected text colour
	
	NSTextView* view = (NSTextView*)[[controlView window] fieldEditor:NO forObject:controlView];
	
	NSMutableDictionary *dict = [[[view selectedTextAttributes] mutableCopy] autorelease];
	
	
	if([self showsFirstResponder] && [[[self controlView] window] isKeyWindow])
	{
		[dict setObject:[NSColor darkGrayColor] forKey:NSBackgroundColorAttributeName];
		
		[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];

	}
	else
	{
		[view setTextColor:[NSColor blackColor] range:[view selectedRange]];
	}
		
	[view setSelectedTextAttributes:dict];

	// draw the text field.
	[super drawInteriorWithFrame: frame inView: controlView];
}

-(void)drawButtonInRect:(NSRect) frame {
	NSBezierPath *path = [[NSBezierPath alloc] init];
	
	
	//Adjust based on Control size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += (frame.size.width -20);
			frame.size.width = 20;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += (frame.size.width -17);
			frame.size.width = 17;
				
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += (frame.size.width - 14);
			frame.size.width = 14;

			break;
	}
	
	
	[path appendBezierPathWithRoundedRect: frame xRadius: 3.0f yRadius: 3.0f];
	
	NSRect rect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width/2, frame.size.height);
	[path appendBezierPathWithRect:rect];
	
	[path closePath];

	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInBezierPath: path angle: 90];
	
	[path release];
}

-(void)drawArrowsInRect:(NSRect) frame {
	

	
	CGFloat arrowWidth;
	CGFloat arrowHeight;
	
	//Adjust based on Control size
	switch ([self controlSize]) {
		default: // Silence uninitialized variable warnings
		case NSRegularControlSize:
			
			frame.origin.x += (frame.size.width -21);
			frame.size.width = 21;
			
			arrowWidth = 3.5f;
			arrowHeight = 2.5f;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += (frame.size.width -18);
			frame.size.width = 18;
			
			arrowWidth = 3.5f;
			arrowHeight = 2.5f;
			
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += (frame.size.width - 15);
			frame.size.width = 15;
			
			arrowWidth = 2.5f;
			arrowHeight = 1.5f;
			break;
	}

	NSBezierPath *arrow = [[NSBezierPath alloc] init];
	
	NSPoint points[3];
	
	points[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
	points[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
	points[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + arrowHeight));
	
	[arrow appendBezierPathWithPoints: points count: 3];
	
	if([self isEnabled]) {
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
	} else {
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
	}
	
	[arrow fill];
	
	[arrow release];
		
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

#pragma mark -

@end
