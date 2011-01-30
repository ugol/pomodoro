//
//  BGHUDComboBoxCellIntegration.m
//  BGHUDAppKit
//
//  Created by Alan Rogers on 10/11/08.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <BGHUDAppKit/BGHUDComboBoxCell.h>
#import "BGHUDAppKitInspector.h"

@implementation BGHUDComboBoxCell (Private)

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
	
    [super ibPopulateKeyPaths:keyPaths];
    [[keyPaths objectForKey: IBAttributeKeyPaths] addObjectsFromArray: [NSArray arrayWithObjects: @"themeKey", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
	
    [super ibPopulateAttributeInspectorClasses: classes];
    [classes addObject: [BGHUDAppKitInspector class]];
}

@end
