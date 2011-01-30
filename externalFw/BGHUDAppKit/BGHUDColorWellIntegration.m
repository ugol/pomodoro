//
//  BGHUDColorWellIntegration.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 8/9/08.
//  Copyright 2008 none. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <BGHUDAppKit/BGHUDColorWell.h>
#import "BGHUDColorWellInspector.h"

@implementation BGHUDColorWell (Private)

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
	
    [super ibPopulateKeyPaths:keyPaths];
    [[keyPaths objectForKey: IBAttributeKeyPaths] addObjectsFromArray: [NSArray arrayWithObjects: @"themeKey", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
	
    [super ibPopulateAttributeInspectorClasses: classes];
    [classes addObject: [BGHUDColorWellInspector class]];
}

@end
