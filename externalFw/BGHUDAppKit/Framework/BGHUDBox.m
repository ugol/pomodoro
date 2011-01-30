//
//  BGHUDBox.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/16/09.
//  Copyright 2009 none. All rights reserved.
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

#import "BGHUDBox.h"


@implementation BGHUDBox

@synthesize flipGradient;
@synthesize drawTopBorder;
@synthesize drawBottomBorder;
@synthesize drawLeftBorder;
@synthesize drawRightBorder;
@synthesize borderColor;
@synthesize drawTopShadow;
@synthesize drawBottomShadow;
@synthesize drawLeftShadow;
@synthesize drawRightShadow;
@synthesize shadowColor;
@synthesize customGradient;
@synthesize themeKey;
@synthesize useTheme;
@synthesize color1;
@synthesize color2;

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		self.useTheme = YES;
		self.flipGradient = NO;
		self.borderColor = [[NSColor blackColor] retain];
		self.shadowColor = [[NSColor blackColor] retain];
		self.color1 = [[NSColor blackColor] retain];
		self.color2 = [[NSColor whiteColor] retain];
	}
	
	return self;
}

-(id)initWithFrame:(NSRect) frame {
	
	self = [super initWithFrame: frame];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		self.useTheme = YES;
		self.flipGradient = NO;
		self.borderColor = [[NSColor blackColor] retain];
		self.shadowColor = [[NSColor blackColor] retain];
		self.color1 = [[NSColor blackColor] retain];
		self.color2 = [[NSColor whiteColor] retain];
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
		
		self.useTheme = [aDecoder decodeBoolForKey: @"useTheme"];
		self.flipGradient = [aDecoder decodeBoolForKey: @"flipGradient"];
		self.drawTopBorder = [aDecoder decodeBoolForKey: @"drawTopBorder"];
		self.drawBottomBorder = [aDecoder decodeBoolForKey: @"drawBottomBorder"];
		self.drawLeftBorder = [aDecoder decodeBoolForKey: @"drawLeftBorder"];
		self.drawRightBorder = [aDecoder decodeBoolForKey: @"drawRightBorder"];
		
		if([aDecoder containsValueForKey: @"borderColor"]) {
			self.borderColor = [aDecoder decodeObjectForKey: @"borderColor"];
		} else {
			self.borderColor = [NSColor blackColor];
		}
		
		self.drawTopShadow = [aDecoder decodeBoolForKey: @"drawTopShadow"];
		self.drawBottomShadow = [aDecoder decodeBoolForKey: @"drawBottomShadow"];
		self.drawLeftShadow = [aDecoder decodeBoolForKey: @"drawLeftShadow"];
		self.drawRightShadow = [aDecoder decodeBoolForKey: @"drawRightShadow"];
		
		if([aDecoder containsValueForKey: @"shadowColor"]) {
			self.shadowColor = [aDecoder decodeObjectForKey: @"shadowColor"];
		} else {
			self.shadowColor = [NSColor blackColor];
		}
		
		if([aDecoder containsValueForKey: @"color1"]) {
			self.color1 = [aDecoder decodeObjectForKey: @"color1"];
		} else {
			self.color1 = [NSColor blackColor];
		}
		
		if([aDecoder containsValueForKey: @"color2"]) {
			self.color2 = [aDecoder decodeObjectForKey: @"color2"];
		} else {
			self.color2 = [NSColor whiteColor];
		}
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	
	[super encodeWithCoder: aCoder];
	
	[aCoder encodeObject: self.themeKey forKey: @"themeKey"];
	[aCoder encodeBool: self.useTheme forKey: @"useTheme"];
	[aCoder encodeBool: self.flipGradient forKey: @"flipGradient"];
	[aCoder encodeBool: self.drawTopBorder forKey: @"drawTopBorder"];
	[aCoder encodeBool: self.drawBottomBorder forKey: @"drawBottomBorder"];
	[aCoder encodeBool: self.drawLeftBorder forKey: @"drawLeftBorder"];
	[aCoder encodeBool: self.drawRightBorder forKey: @"drawRightBorder"];
	[aCoder encodeObject: self.borderColor forKey: @"borderColor"];
	[aCoder encodeBool: self.drawTopShadow forKey: @"drawTopShadow"];
	[aCoder encodeBool: self.drawBottomShadow forKey: @"drawBottomShadow"];
	[aCoder encodeBool: self.drawLeftShadow forKey: @"drawLeftShadow"];
	[aCoder encodeBool: self.drawRightShadow forKey: @"drawRightShadow"];
	[aCoder encodeObject: self.shadowColor forKey: @"shadowColor"];
	[aCoder encodeObject: self.color1 forKey: @"color1"];
	[aCoder encodeObject: self.color2 forKey: @"color2"];
}

-(void)drawRect:(NSRect) rect {
	
	if([self boxType] == NSBoxCustom) {
		
		rect = [[self contentView] frame];
		
		if(self.useTheme) {
			
			// Issue #16 - Allows a transparent background
			if(![self isTransparent]) {
				
				[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: rect angle: 90];
			}
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
			NSFrameRect(rect);
			
		} else {
			
			NSGradient *gradient;
			
			if(customGradient != nil) {
				
				gradient = [customGradient retain];
			} else {
				
				gradient = [[NSGradient alloc] initWithStartingColor: self.color1 endingColor: self.color2];
			}
			
			if([self cornerRadius] > 0) {

				// Draw Rounded border
				// Respect borderWidth
				// Use borderColor
				// Ignore drop shadows/borders/
				
				NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: rect
																	 xRadius: [self cornerRadius] 
																	 yRadius: [self cornerRadius]];
				
				if(self.flipGradient == 0) {
					
					[gradient drawInBezierPath: path angle: 270];
				} else {
					
					[gradient drawInBezierPath: path angle: 90];
				}
				
				[gradient release];
				
				if([self borderType] != NSNoBorder) {
					
					[[self borderColor] set];
					
					if([self borderWidth] > 0) {
						
						[path setLineWidth: [self borderWidth]];
					} else {
						
						[path setLineWidth: 1.0f];
					}
											 
					[path stroke];
				}
			} else {
				
				NSShadow *dropShadow = [[NSShadow alloc] init];
				
				[dropShadow setShadowColor: self.shadowColor];
				[dropShadow setShadowBlurRadius: 5];
				
				// Issue #16 - Allows a transparent background
				if(![self isTransparent]) {
					
					if(self.flipGradient == 0) {
						
						[gradient drawInRect: rect angle: 270];
					} else {
						
						[gradient drawInRect: rect angle: 90];
					}
				}
				
				[gradient release];
				
				[[NSGraphicsContext currentContext] setShouldAntialias: NO];
				
				[[self borderColor] set];
				
				rect = NSInsetRect(rect, .5f, .5f);
				
				//Draw Borders
				if(self.drawTopBorder) {
					
					[NSGraphicsContext saveGraphicsState];
					
					if(self.drawTopShadow) {
						
						[dropShadow setShadowOffset: NSMakeSize( 0, -1)];
						[dropShadow set];
					}
					
					[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect) , NSMaxY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
					
					[NSGraphicsContext restoreGraphicsState];
				}
				
				if(self.drawBottomBorder) {
					
					[NSGraphicsContext saveGraphicsState];
					
					if(self.drawBottomShadow) {
						
						[dropShadow setShadowOffset: NSMakeSize( 0, 1)];
						[dropShadow set];
					}
					
					[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect))];
					
					[NSGraphicsContext restoreGraphicsState];
				}
				
				if(self.drawLeftBorder) {
					
					[NSGraphicsContext saveGraphicsState];
					
					if(self.drawLeftShadow) {
						
						[dropShadow setShadowOffset: NSMakeSize( 1, 0)];
						[dropShadow set];
					}
					
					[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect))];
					
					[NSGraphicsContext restoreGraphicsState];
				}
				
				if(self.drawRightBorder) {
					
					[NSGraphicsContext saveGraphicsState];
					
					if(self.drawRightShadow) {
						
						[dropShadow setShadowOffset: NSMakeSize( -1, 0)];
						[dropShadow set];
					}
					
					[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
					
					[NSGraphicsContext restoreGraphicsState];
				}
				
				[dropShadow release];
			}
		}
	} else {
		
		[super drawRect: rect];
	}
}

-(void)dealloc {
	
	 
	[color1 release];
	[color2 release];
	[customGradient release];
	[borderColor release];
	[shadowColor release];
	[themeKey release];
	[super dealloc];
}

@end

