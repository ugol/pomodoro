//
//  BGHUDSearchFieldCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/21/08.
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

#import "BGHUDSearchFieldCell.h"

// TODO: Find out why NSSmallControlSize/NSMiniControlSize revert to original dark images
NSImage *searchButtonImage() {
	
    static NSImage *__image = nil;
    if(!__image) {
        __image = [[NSImage alloc] initWithSize:NSMakeSize(14, 14)];
        [__image lockFocus];
        [[NSColor clearColor] set];
        NSRectFill(NSMakeRect(0, 0, 14, 14));
        
        NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(1, 4, 8, 8)];
        [path setLineWidth:1.9];
        [path moveToPoint:NSMakePoint(7, 6)];
        [path lineToPoint:NSMakePoint(12, 1)];
        [[NSColor whiteColor] set];
        [path stroke];
        [__image unlockFocus];
    }
    return [__image copy];
}

NSImage *cancelButtonImageUp() {

    static NSImage *__image = nil;
    if(!__image) {
        __image = [[NSImage alloc] initWithSize:NSMakeSize(14, 14)];
        [__image lockFocus];
        [[NSColor clearColor] set];
        NSRectFill(NSMakeRect(0, 0, 14, 14));
        
        NSBezierPath *circle = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(1, 1, 12, 12)];
        [[NSColor colorWithDeviceWhite:1.0 alpha:1.0] set];
        [circle fill];
		
        NSBezierPath *cross = [NSBezierPath bezierPath];
        [cross setLineWidth:1.1];
        [cross moveToPoint:NSMakePoint(4, 4)];
        [cross lineToPoint:NSMakePoint(10, 10)];
        [cross moveToPoint:NSMakePoint(4, 10)];
        [cross lineToPoint:NSMakePoint(10, 4)];
        [[NSColor colorWithDeviceWhite:0.0 alpha:0.7] set];
        [cross stroke];
        
        [__image unlockFocus];
    }
    return [__image copy];
}

@interface NSSearchFieldCell (Private)

-(NSRect)searchTextRectForBounds:(NSRect) aRect;
-(NSRect)searchButtonRectForBounds:(NSRect) aRect;
-(NSRect)cancelButtonRectForBounds:(NSRect) aRect;

@end

@implementation BGHUDSearchFieldCell

@synthesize themeKey;

#pragma mark Drawing Functions

- (id)initTextCell:(NSString *)aString {
	
	self = [super initTextCell: aString];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
		[[self searchButtonCell] setImage:searchButtonImage()];
		[[self cancelButtonCell] setImage:cancelButtonImageUp()];
		[[self cancelButtonCell] setAlternateImage:nil];
		
		if([self controlSize] == NSSmallControlSize) {
			
			[[[self searchButtonCell] image] setScalesWhenResized: YES];
			[[[self searchButtonCell] image] setSize: NSMakeSize(12, 12)];
			[[[self cancelButtonCell] image] setScalesWhenResized: YES];
			[[[self cancelButtonCell] image] setSize: NSMakeSize(12, 12)];
		} else if ([self controlSize] == NSMiniControlSize) {
			
			[[[self searchButtonCell] image] setScalesWhenResized: YES];
			[[[self searchButtonCell] image] setSize: NSMakeSize(10, 10)];
			[[[self cancelButtonCell] image] setScalesWhenResized: YES];
			[[[self cancelButtonCell] image] setSize: NSMakeSize(10, 10)];
		}
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *) aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
		
		if([self drawsBackground]) {
			
			fillsBackground = YES;
		}
		
		[self setDrawsBackground: NO];
		[[self searchButtonCell] setImage:searchButtonImage()];
		[[self cancelButtonCell] setImage:cancelButtonImageUp()];
		[[self cancelButtonCell] setAlternateImage:nil];
		
		if([self controlSize] == NSSmallControlSize) {
			
			[[[self searchButtonCell] image] setScalesWhenResized: YES];
			[[[self searchButtonCell] image] setSize: NSMakeSize(12, 12)];
			[[[self cancelButtonCell] image] setScalesWhenResized: YES];
			[[[self cancelButtonCell] image] setSize: NSMakeSize(12, 12)];
		} else if ([self controlSize] == NSMiniControlSize) {
			
			[[[self searchButtonCell] image] setScalesWhenResized: YES];
			[[[self searchButtonCell] image] setSize: NSMakeSize(10, 10)];
			[[[self cancelButtonCell] image] setScalesWhenResized: YES];
			[[[self cancelButtonCell] image] setSize: NSMakeSize(10, 10)];
		}
	}
	
	return self;
}

-(id)copyWithZone:(NSZone *) zone {
	
	BGHUDSearchFieldCell *copy = [super copyWithZone: zone];
	
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
	
	// Check to see if the attributed placeholder has been set or not
	//if(![self placeholderAttributedString]) {
	if(![self placeholderAttributedString] && [self placeholderString]) {
		
		//Nope lets create it
		NSDictionary *attribs = [[NSDictionary alloc] initWithObjectsAndKeys: 
								 [[[BGThemeManager keyedManager] themeForKey: self.themeKey] placeholderTextColor] , NSForegroundColorAttributeName, nil];
		
		//Set it
		[self setPlaceholderAttributedString: [[[NSAttributedString alloc] initWithString: [self placeholderString] attributes: [attribs autorelease]] autorelease]];
	}
	
	//Adjust Frame so Text Draws correctly
	switch ([self controlSize]) {
			
		case NSSmallControlSize:
			
			cellFrame.origin.y += 1;
			break;
			
		case NSMiniControlSize:
			
			cellFrame.origin.y += 1;
			
		default:
			break;
	}
	
	[self drawInteriorWithFrame: cellFrame inView: controlView];
}

-(void)drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			cellFrame.origin.x += 5;
			cellFrame.size.width -= 5;
			break;
			
		case NSSmallControlSize:
			
			cellFrame.origin.x += 1;
			cellFrame.size.width -= 3;
			break;
			
		case NSMiniControlSize:
			
			//cellFrame.origin.x += 5;
			//cellFrame.size.width -= 5;
			break;
			
		default:
			break;
	}
	
	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

// This adjusts the drawing location of the Search Button
-(NSRect)searchButtonRectForBounds:(NSRect) aRect {
	
	NSRect nRect = [super searchButtonRectForBounds: aRect];
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			nRect.origin.x -= 5;
			nRect.origin.y -= 1;
			break;
			
		case NSSmallControlSize:
			
			nRect.origin.x -= 1;
			nRect.origin.y -= 2;
			break;
			
		case NSMiniControlSize:
			
			nRect.origin.x -= 2;
			nRect.origin.y -= 2;
			break;
			
		default:
			break;
	}
	
	
	return nRect;
}

// This adjusts the drawing location of the Cancel Button
-(NSRect)cancelButtonRectForBounds:(NSRect) aRect {
	
	NSRect nRect = [super cancelButtonRectForBounds: aRect];
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			nRect.origin.y -= 1;
			break;
			
		case NSSmallControlSize:
			
			nRect.origin.y -= 1.5;
			nRect.origin.x += 2;
			break;
			
		case NSMiniControlSize:
			
			nRect.origin.y -= 2;
			break;
			
		default:
			break;
	}
	
	return nRect;
}

// Set insertion point to white
-(NSText *)setUpFieldEditorAttributes:(NSText *) textObj {
	
    textObj = [super setUpFieldEditorAttributes:textObj];
    if([textObj isKindOfClass:[NSTextView class]]) {
        [(NSTextView *)textObj setInsertionPointColor:[self textColor]];
    }
    return textObj;
}

// TODO: Add proper sizeing for NSSmallControlSize/NSMiniControlSize
// Change Editing Text Rect
- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent {
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			aRect.origin.x += 5;
			aRect.size.width -= 5;
			break;
			
		case NSSmallControlSize:
			
			aRect.origin.x += 1;
			aRect.size.width -= 3;
			break;
			
		case NSMiniControlSize:
			
			//aRect.origin.x += 5;
			//aRect.size.width -= 5;
			break;
			
		default:
			break;
	}
	
	[super editWithFrame: aRect inView: controlView editor: textObj delegate: anObject event: theEvent];
}

// TODO: Add proper sizeing for NSSmallControlSize/NSMiniControlSize
// Chnage the Selected Text Rect
- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(NSInteger)selStart length:(NSInteger)selLength {
	
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			aRect.origin.x += 5;
			aRect.size.width -= 5;
			break;
			
		case NSSmallControlSize:
			
			aRect.origin.x += 1;
			aRect.size.width -= 3;
			break;
			
		case NSMiniControlSize:
			
			//aRect.origin.x += 5;
			//aRect.size.width -= 5;
			break;
			
		default:
			break;
	}
	
	[super selectWithFrame: aRect inView: controlView editor: textObj delegate: anObject start: selStart length: selLength];
}

-(void)setControlSize:(NSControlSize)size {

	[super setControlSize: size];
	
	if([self controlSize] == NSSmallControlSize) {
		
		[[[self searchButtonCell] image] setScalesWhenResized: YES];
		[[[self searchButtonCell] image] setSize: NSMakeSize(12, 12)];
		[[[self cancelButtonCell] image] setScalesWhenResized: YES];
		[[[self cancelButtonCell] image] setSize: NSMakeSize(12, 12)];
	} else if ([self controlSize] == NSMiniControlSize) {
		
		[[[self searchButtonCell] image] setScalesWhenResized: YES];
		[[[self searchButtonCell] image] setSize: NSMakeSize(10, 10)];
		[[[self cancelButtonCell] image] setScalesWhenResized: YES];
		[[[self cancelButtonCell] image] setSize: NSMakeSize(10, 10)];
	}
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

#pragma mark -

@end
