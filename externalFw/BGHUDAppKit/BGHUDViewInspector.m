//
//  BGHUDViewInspector.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/15/09.
//  Copyright 2009 none. All rights reserved.
//

#import "BGHUDViewInspector.h"

@implementation BGHUDViewInspector

- (NSString *)viewNibName {
    return @"BGHUDViewInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

-(NSString *)label {
	
	return @"Appearence/Theme";
}

@end
