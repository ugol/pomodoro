//
//  BGHUDSecureTextFieldCell.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDSecureTextFieldCell.h"


@implementation BGHUDSecureTextFieldCell

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
	
	BGHUDSecureTextFieldCell *copy = [super copyWithZone: zone];
	
	copy->themeKey = nil;
	[copy setThemeKey: [self themeKey]];
	
	return copy;
}

- (NSText *)setUpFieldEditorAttributes:(NSText *)textObj {
	textObj = [super setUpFieldEditorAttributes:textObj];
	NSColor *textColor = [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor];
	[(NSTextView *)textObj setInsertionPointColor:textColor];
	return textObj;
}

-(void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	
	//Adjust Rect
	cellFrame = NSInsetRect(cellFrame, 0.5f, 0.5f);
	
	//Create Path
	NSBezierPath *path = [[NSBezierPath new] autorelease];
	
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
	
	//Get TextView for this editor
	NSTextView* view = (NSTextView*)[[controlView window] fieldEditor: NO forObject: controlView];
	
	//If window/app is active draw the highlight/text in active colors
	if(![self isHighlighted]) {
		
		if([view selectedRange].length > 0) {
			
			//Get Attributes of the selected text
			NSMutableDictionary *dict = [[[view selectedTextAttributes] mutableCopy] autorelease];	
			
			if([[[self controlView] window] isKeyWindow])
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
			dict = nil;
		} else {
			
			// Only change color (marks view as dirty) if it had a selection at some point,
			// thus changing the colors.
			if([view textColor] != [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]) {
				
				[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
				[view setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
			}
		}
	} else {
		
		if([self isEnabled]) {
			
			if([self isHighlighted]) {
				
				if([[[self controlView] window] isKeyWindow])
				{
					
					[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextActiveColor]];
				} else {
					
					[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] selectionTextInActiveColor]];
				}
			} else {
				
				[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] textColor]];
			}
		} else {
			
			[self setTextColor: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] disabledTextColor]];
		}
	}
	
	view = nil;
	
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
			
		case NSRegularControlSize:
			
			if([self bezelStyle] != NSTextFieldRoundedBezel) {
				
				cellFrame.origin.y += 1;
			}
			break;
			
		case NSSmallControlSize:
			
			if([self bezelStyle] == NSTextFieldRoundedBezel) {
				
				cellFrame.origin.y += 1;
			}
			break;
			
		case NSMiniControlSize:
			
			if([self bezelStyle] == NSTextFieldRoundedBezel) {
				
				cellFrame.origin.x += 1;
			}
			break;
			
		default:
			break;
	}
	
	//NSLog(@"Inside Draw With Frame");
	[self drawInteriorWithFrame: cellFrame inView: controlView];}

-(void)drawInteriorWithFrame:(NSRect) cellFrame inView:(NSView *) controlView {
	
	[super drawInteriorWithFrame: cellFrame inView: controlView];
}

#pragma mark -
#pragma mark Helper Methods

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

#pragma mark -

@end
