//
//  BGHUDViewIntegration.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/15/09.
//  Copyright 2009 none. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <BGHUDAppKit/BGHUDView.h>
#import "BGHUDViewInspector.h"

@implementation BGHUDView ( Private )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
    [super ibPopulateKeyPaths:keyPaths];

	// Remove the comments and replace "MyFirstProperty" and "MySecondProperty" 
	// in the following line with a list of your view's KVC-compliant properties.
    //[[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:/* @"MyFirstProperty", @"MySecondProperty",*/ nil]];
	
	[[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects: @"flipGradient", @"drawTopBorder", 
																	  @"drawBottomBorder", @"drawLeftBorder", @"drawRightBorder",
																	  @"borderColor", @"drawTopShadow", @"drawBottomShadow",
																	  @"drawLeftShadow", @"drawRightShadow", @"shadowColor", @"useTheme",
																	  @"themeKey", @"color1", @"color2", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
    [super ibPopulateAttributeInspectorClasses:classes];
	// Replace "BGHUDViewIntegrationInspector" with the name of your inspector class.
    [classes addObject:[BGHUDViewInspector class]];
}

- (NSView *)ibDesignableContentView {
	
	return self;
}

@end
