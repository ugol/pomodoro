//
//  BGHUDPopUpButtonCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/31/08.
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

#import "BGHUDPopUpButtonCell.h"

@implementation BGHUDPopUpButtonCell

@synthesize themeKey;

#pragma mark Drawing Functions

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
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
	}
	
	return self;
}

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(id)copyWithZone:(NSZone *) zone {
	
	BGHUDPopUpButtonCell *copy = [super copyWithZone: zone];
	
	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];
	
	return copy;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	NSRect frame = cellFrame;
	
	//Adjust frame by .5 so lines draw true
	frame.origin.x += .5f;
	frame.origin.y += .5f;
	frame.size.height = [self cellSize].height;
	
	//Make Adjustments to Frame based on Cell Size
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 3;
			frame.size.width -= 7;
			frame.origin.y += 2;
			frame.size.height -= 7;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.y += 1;
			frame.size.height -= 6;
			frame.origin.x += 3;
			frame.size.width -= 7;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 1;
			frame.size.width -= 4;
			frame.size.height -= 2;
			break;
	}
	
	if([self isBordered]) {
		
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect: frame
															 xRadius: 4
															 yRadius: 4];
		
		[NSGraphicsContext saveGraphicsState];
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] dropShadow] set];
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] darkStrokeColor] set];
		[path stroke];
		[NSGraphicsContext restoreGraphicsState];
		
		if([self isEnabled]) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInBezierPath: path angle: 90];
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledNormalGradient] drawInBezierPath: path angle: 90];
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledStrokeColor] set];
		}
		
		[path setLineWidth: 1.0f ];
		[path stroke];
	}
	
	//Draw the arrows
	[self drawArrowsInRect: frame];
	
	//Adjust rect for title drawing
	switch ([self controlSize]) {
			
		case NSRegularControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 1;
			frame.size.width -= 29;
			break;
			
		case NSSmallControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += 2;
			frame.size.width -= 29;
			break;
			
		case NSMiniControlSize:
			
			frame.origin.x += 8;
			frame.origin.y += .5f;
			frame.size.width -= 26;
			break;
	}
	
	NSMutableAttributedString *aTitle = [[NSMutableAttributedString alloc] initWithAttributedString: [self attributedTitle]];
	
	//Make sure aTitle actually contains something
	if([aTitle length] > 0) {
		
		[aTitle beginEditing];
		
		[aTitle removeAttribute: NSForegroundColorAttributeName range: NSMakeRange(0, [aTitle length])];
		
		if([self isEnabled]){
			
			if([self isHighlighted]) {
				
				if([[[self controlView] window] isKeyWindow])
				{
					
					[aTitle addAttribute: NSForegroundColorAttributeName
								   value: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor]
								   range: NSMakeRange(0, [aTitle length])];
				} else {

					[aTitle addAttribute: NSForegroundColorAttributeName
								   value: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor]
								   range: NSMakeRange(0, [aTitle length])];
				}
			} else {
				
				[aTitle addAttribute: NSForegroundColorAttributeName
							   value: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]
							   range: NSMakeRange(0, [aTitle length])];
			}
		} else {
			
			[aTitle addAttribute: NSForegroundColorAttributeName
						   value: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor]
						   range: NSMakeRange(0, [aTitle length])];
		}
		
		[aTitle endEditing];
		
		int arrowAdjustment = 0;
		
		if([self isBordered]) {
			
			cellFrame.size.height -= 2;
			cellFrame.origin.x += 5;
		} /*else {
		
			
		}*/
		
		switch ([self controlSize]) {
				
			case NSRegularControlSize:
				
				arrowAdjustment = 21;
				break;
				
			case NSSmallControlSize:
				
				arrowAdjustment = 18;
				break;
				
			case NSMiniControlSize:
				
				arrowAdjustment = 15;
				break;
		}
		
		NSRect titleFrame = NSMakeRect(cellFrame.origin.x + 5, NSMidY(cellFrame) - ([aTitle size].height/2), cellFrame.size.width - arrowAdjustment, [aTitle size].height);
		NSRect imageFrame = NSMakeRect(cellFrame.origin.x, cellFrame.origin.y, cellFrame.size.width - arrowAdjustment, cellFrame.size.height);

		if([self image]) {

			switch ([self imagePosition]) {
					
				case NSImageLeft:
				case NSNoImage:
					
					titleFrame.origin.x += 6;
					titleFrame.origin.x += [[self image] size].width;
					break;
					
				case NSImageOnly:
					
					titleFrame.size.width = 0;
					//imageRect.origin.x += (frame.size.width /2) - (imageRect.size.width /2);
					break;
					
				case NSImageRight:
					
					//btitleFrame.origin.x += 3;
					//imageRect.origin.x = ((frame.origin.x + frame.size.width) - imageRect.size.width) - 5;
					break;
					
				case NSImageBelow:
					
					break;
					
				case NSImageAbove:
					
					break;
					
				case NSImageOverlaps:
					
					break;
					
				default:
					
					//imageRect.origin.x += 5;
					break;
			}
		}

		[super drawTitle: aTitle withFrame: titleFrame inView: controlView];
		[self drawImage: [self image] withFrame: imageFrame inView: controlView];
	}
	
	[aTitle release];
}

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView {
	
	//Setup per State and Highlight Settings
	if([self showsStateBy] == 0 && [self highlightsBy] == 1) {
		
		if([self isHighlighted]) {
			
			if([self alternateImage]) {
				
				image = [self alternateImage];
			}
		}
	}
	
	if([self showsStateBy] == 1 && [self highlightsBy] == 3) {
		
		if([self state] == 1) {
			
			if([self alternateImage]) {
				
				image = [self alternateImage];
			}
		}
	}
	
	//Calculate Image Position
	NSRect imageRect = frame;
	imageRect.size.height = [image size].height;
	imageRect.size.width = [image size].width;
	imageRect.origin.y += (frame.size.height /2) - (imageRect.size.height /2);
	
	//Setup Position
	switch ([self imagePosition]) {
			
		case NSImageLeft:
		case NSNoImage:
			
			imageRect.origin.x += 6;
			break;
			
		case NSImageOnly:
			
			imageRect.origin.x += (frame.size.width /2) - (imageRect.size.width /2);
			break;
			
		case NSImageRight:
			
			imageRect.origin.x = (NSMaxX(frame) - imageRect.size.width) - 8;
			break;
			
		case NSImageBelow:
			
			break;
			
		case NSImageAbove:
			
			break;
			
		case NSImageOverlaps:
			
			break;
			
		default:
			
			imageRect.origin.x += 5;
			break;
	}
	
	[image setFlipped: YES];
	
	//Draw the image based on enabled state
	if([self isEnabled]) {
		
		[image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] alphaValue]];
	} else {
		[image drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceAtop fraction: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledAlphaValue]];
	}
	
	[image setFlipped: NO];
}

- (void)drawArrowsInRect:(NSRect) frame {
	
	CGFloat arrowsWidth;
	CGFloat arrowsHeight;
	CGFloat arrowWidth;
	CGFloat arrowHeight;
	
	int arrowAdjustment = 0;
	
	//Adjust based on Control size
	switch ([self controlSize]) {
		default: // Silence uninitialized variable warnings
		case NSRegularControlSize:
			
			if([self isBordered]) {
				
				arrowAdjustment = 21;
			} else {
				
				arrowAdjustment = 11;
			}
			
			arrowWidth = 3.5f;
			arrowHeight = 2.5f;
			arrowsHeight = 2;
			arrowsWidth = 2.5f;
			break;
			
		case NSSmallControlSize:
			
			if([self isBordered]) {
				
				arrowAdjustment = 18;
			} else {
				
				arrowAdjustment = 8;
			}
			
			arrowWidth = 3.5f;
			arrowHeight = 2.5f;
			arrowsHeight = 2;
			arrowsWidth = 2.5f;
			
			break;
			
		case NSMiniControlSize:
			
			if([self isBordered]) {
				
				arrowAdjustment = 15;
			} else {
				
				arrowAdjustment = 5;
			}
			
			arrowWidth = 2.5f;
			arrowHeight = 1.5f;
			arrowsHeight = 1.5f;
			arrowsWidth = 2;
			break;
	}
	
	frame.origin.x += (frame.size.width - arrowAdjustment);
	frame.size.width = arrowAdjustment;
	
	if([self pullsDown]) {
		
		NSBezierPath *arrow = [[NSBezierPath alloc] init];
		
		NSPoint points[3];
		
		points[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
		points[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowWidth), frame.origin.y + ((frame.size.height /2) - arrowHeight));
		points[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + arrowHeight));
		
		[arrow appendBezierPathWithPoints: points count: 3];
		
		if([self isEnabled]) {
			
			if([self isHighlighted]) {
				
				if([[[self controlView] window] isKeyWindow])
				{
					
					[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor] set];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor] set];
				}
			} else {
				
				[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] set];
			}
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor] set];
		}
		
		[arrow fill];
		
		[arrow release];
		
	} else {
	
		NSBezierPath *topArrow = [[NSBezierPath alloc] init];
		
		NSPoint topPoints[3];
		
		topPoints[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowsWidth), frame.origin.y + ((frame.size.height /2) - arrowsHeight));
		topPoints[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowsWidth), frame.origin.y + ((frame.size.height /2) - arrowsHeight));
		topPoints[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) - ((arrowsHeight * 2) + 2)));
		
		[topArrow appendBezierPathWithPoints: topPoints count: 3];
		
		if([self isEnabled]) {
			
			if([self isHighlighted]) {
				
				if([[[self controlView] window] isKeyWindow])
				{
					
					[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor] set];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor] set];
				}
			} else {
				
				[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] set];
			}
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor] set];
		}
		[topArrow fill];
		
		NSBezierPath *bottomArrow = [[NSBezierPath alloc] init];
		
		NSPoint bottomPoints[3];
		
		bottomPoints[0] = NSMakePoint(frame.origin.x + ((frame.size.width /2) - arrowsWidth), frame.origin.y + ((frame.size.height /2) + arrowsHeight));
		bottomPoints[1] = NSMakePoint(frame.origin.x + ((frame.size.width /2) + arrowsWidth), frame.origin.y + ((frame.size.height /2) + arrowsHeight));
		bottomPoints[2] = NSMakePoint(frame.origin.x + (frame.size.width /2), frame.origin.y + ((frame.size.height /2) + ((arrowsHeight * 2) + 2)));
		
		[bottomArrow appendBezierPathWithPoints: bottomPoints count: 3];
		
		if([self isEnabled]) {
			
			if([self isHighlighted]) {
				
				if([[[self controlView] window] isKeyWindow])
				{
					
					[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor] set];
				} else {
					
					[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor] set];
				}
			} else {
				
				[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor] set];
			}
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor] set];
		}
		[bottomArrow fill];
		
		[topArrow release];
		[bottomArrow release];
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
