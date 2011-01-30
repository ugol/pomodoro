//
//  BGHUDTabView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/10/09.
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

#import "BGHUDTabView.h"

@implementation BGHUDTabView

@synthesize themeKey;

/*-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			
			self.themeKey = @"gradientTheme";
		}
	}
	
	return self;
}*/

-(id)initWithCoder:(NSCoder *) aDecoder {
	
	BOOL isSubclass = YES;
	
	isSubclass = isSubclass && [aDecoder isKindOfClass: [NSKeyedUnarchiver class]]; // no support for 10.1 nibs
	isSubclass = isSubclass && ![self isMemberOfClass: [NSControl class]]; // no raw NSControls
	isSubclass = isSubclass && [self class] != nil; // need to have something to substitute
	isSubclass = isSubclass && [self class] != [self class]; // pointless if same
	
	if( !isSubclass )
	{
		self = [super initWithCoder: aDecoder]; 
	}
	else
	{
		NSKeyedUnarchiver *modDecoder = (id)aDecoder;
		
		[modDecoder setClass: [BGHUDTabViewItem class] forClassName: @"NSTabViewItem"];
		
		self = [super initWithCoder: modDecoder];
		
		[modDecoder setClass: [NSTabViewItem class] forClassName: @"BGHUDTabViewItem"];
		
		if(self) {
			
			if([modDecoder containsValueForKey: @"themeKey"]) {
				
				self.themeKey = [modDecoder decodeObjectForKey: @"themeKey"];
			} else {
				
				self.themeKey = @"gradientTheme";
			}
		}
	}
	
	return self;
}


/*-(id)initWithCoder:(NSCoder *) aDecoder {
	
	[NSKeyedUnarchiver setClass: [BGHUDTabViewItem class]  
				   forClassName: @"NSTabViewItem"]; 
	
	self = [super initWithCoder: aDecoder];
	
	if(self) {
		
		if([aDecoder containsValueForKey: @"themeKey"]) {
			
			self.themeKey = [aDecoder decodeObjectForKey: @"themeKey"];
		} else {
			
			self.themeKey = @"gradientTheme";
		}
	}
	
	return self;
}*/

-(void)encodeWithCoder: (NSCoder *)coder {
	
	[super encodeWithCoder: coder];
	
	[coder encodeObject: self.themeKey forKey: @"themeKey"];
}

-(void)_drawThemeTab:(id) tabItem withState:(NSUInteger) state inRect:(NSRect) aRect {

	NSInteger index = [self indexOfTabViewItem: tabItem];
	int gradientAngle = 90;
	NSBezierPath *path;
	
	aRect = NSInsetRect(aRect, 0.5f, 0.5f);
	
	if([self tabViewType] == NSLeftTabsBezelBorder) {
		
		gradientAngle = 0;
	} else if([self tabViewType] == NSRightTabsBezelBorder) {
		
		gradientAngle = 180;
	}
	
	if(index == 0) {
		
		path = [[NSBezierPath alloc] init];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect) +5)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +5, NSMinY(aRect) +5)
											 radius: 5
										 startAngle: 180
										   endAngle: 270];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) -5, NSMinY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -5, NSMinY(aRect) +5)
											 radius: 5
										 startAngle: 270
										   endAngle: 0];
		} else {
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			
			[path lineToPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect) + 5, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +5, NSMaxY(aRect) -5)
											 radius: 5
										 startAngle: 90
										   endAngle: 180];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect) +5)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +5, NSMinY(aRect) +5)
											 radius: 5
										 startAngle: 180
										   endAngle: 270];
		}
		
		[path closePath];
		
		if(state == 1) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInBezierPath: path angle: gradientAngle];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath: path angle: gradientAngle];
		}

		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[path stroke];
		
		[path release];
	} else if(index > 0 && index < ([self numberOfTabViewItems] -1)) {
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			aRect.origin.y -= 0.5f;
			aRect.size.height += 0.5f;
			
		} else {
			
			aRect.origin.x -= 0.5f;
			aRect.size.width += 0.5f;
		}
		
		if(state == 1) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInRect: aRect angle: gradientAngle];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInRect: aRect angle: gradientAngle];
		}
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))
									  toPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			
		} else {
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))
									  toPoint: NSMakePoint(NSMaxX(aRect), NSMaxY(aRect))];
		}
		
	} else if(index == ([self numberOfTabViewItems] -1)) {
		
		path = [[NSBezierPath alloc] init];
		
		if([self tabViewType] == NSRightTabsBezelBorder ||
		   [self tabViewType] == NSLeftTabsBezelBorder) {
			
			aRect.origin.y -= 1;
			//[path appendBezierPathWithRect: aRect];
			
			[path moveToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect) -5)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(aRect) +5, NSMaxY(aRect) -5)
											 radius: 5
										 startAngle: 180
										   endAngle: 90
										  clockwise: YES];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) -5, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -5, NSMaxY(aRect) -5)
											 radius: 5
										 startAngle: 90
										   endAngle: 0
										  clockwise: YES];
			
		} else {
			aRect.origin.x -= 1;
			aRect.size.width += 1;
			[path moveToPoint: NSMakePoint(NSMinX(aRect), NSMinY(aRect))];
			[path lineToPoint: NSMakePoint(NSMinX(aRect), NSMaxY(aRect))];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect) - 5, NSMaxY(aRect))];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -5, NSMaxY(aRect) -5)
											 radius: 5
										 startAngle: 90
										   endAngle: 0
										  clockwise: YES];
			[path lineToPoint: NSMakePoint(NSMaxX(aRect), NSMinY(aRect) +5)];
			[path appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(aRect) -5, NSMinY(aRect) +5)
											 radius: 5
										 startAngle: 0
										   endAngle: 270
										  clockwise: YES];
		}
		
		[path closePath];
		
		if(state == 1) {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] normalGradient] drawInBezierPath: path angle: gradientAngle];
		} else {
			
			[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] highlightGradient] drawInBezierPath: path angle: gradientAngle];
		}
		
		[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] strokeColor] set];
		[path stroke];
		
		[path release];
	}
}

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

@end
