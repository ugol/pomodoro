//
//  BGHUDTableCornerView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/29/08.
//  Copyright 2008 none. All rights reserved.
//

#import "BGHUDTableCornerView.h"


@implementation BGHUDTableCornerView

@synthesize themeKey;

- (id)initWithThemeKey:(NSString *)key {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = key;
	}
	
	return self;
}

-(void)drawRect:(NSRect)rect {
	
	//Draw base layer
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellBorderColor] set];
	NSRectFill([self bounds]);
	
	[[[[BGThemeManager keyedManager] themeForKey: self.themeKey] tableHeaderCellNormalFill] drawInRect: NSInsetRect([self bounds], 1, 1) angle: 270];
}

-(void)dealloc {
	
	[themeKey release];
	[super dealloc];
}

@end
