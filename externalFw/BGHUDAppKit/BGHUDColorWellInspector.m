//
//  BGHUDColorWellInspector.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 8/9/08.
//  Copyright 2008 none. All rights reserved.
//

#import "BGHUDColorWellInspector.h"

@implementation BGHUDColorWellInspector

- (NSString *)viewNibName {
    return @"BGHUDColorWellInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects
	[super refresh];
}

-(NSString *)label {
	
	return @"Theme";
}


@end
