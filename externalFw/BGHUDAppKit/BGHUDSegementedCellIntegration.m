//
//  BGHUDSegementedCellIntegration.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/1/08.
//  Copyright 2008 none. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <BGHUDAppKit/BGHUDSegmentedCell.h>
#import "BGHUDAppKitInspector.h"


@implementation BGHUDSegmentedCell (Private)

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
	
    [super ibPopulateKeyPaths:keyPaths];
    [[keyPaths objectForKey: IBAttributeKeyPaths] addObjectsFromArray: [NSArray arrayWithObjects: @"themeKey", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
	
    [super ibPopulateAttributeInspectorClasses: classes];
    [classes addObject: [BGHUDAppKitInspector class]];
}

@end
