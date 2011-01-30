//
//  BGHUDAppKitInspector.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDAppKitInspector.h"

@implementation BGHUDAppKitInspector

- (NSString *)viewNibName {
	
	return @"BGHUDAppKitInspector";
}

- (void)refresh {
	// Synchronize your inspector's content view with the currently selected objects.
	[super refresh];
}

-(NSString *)label {
	
	return @"Theme";
}

@end
