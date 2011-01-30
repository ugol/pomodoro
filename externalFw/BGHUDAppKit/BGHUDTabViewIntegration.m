//
//  BGHUDTabViewIntegration.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/10/09.
//  Copyright 2009 none. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <BGHUDAppKit/BGHUDTabView.h>
#import "BGHUDAppKitInspector.h"


@implementation BGHUDTabView (Private)

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
	
    [super ibPopulateKeyPaths:keyPaths];
    [[keyPaths objectForKey: IBAttributeKeyPaths] addObjectsFromArray: [NSArray arrayWithObjects: @"themeKey", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
	
    [super ibPopulateAttributeInspectorClasses: classes];
    [classes addObject: [BGHUDAppKitInspector class]];
}

@end
