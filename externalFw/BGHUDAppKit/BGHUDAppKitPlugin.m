//
//  BGHUDAppKitPlugin.m
//  BGHUDAppKitPlugin
//
//  Created by BinaryGod on 6/23/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BGHUDAppKitPlugin.h"

@implementation BGHUDAppKitPlugin

- (NSArray *)libraryNibNames {
	
    return [NSArray arrayWithObject: @"BGHUDAppKitLibrary"];
}

- (NSArray*)requiredFrameworks {
	
    NSBundle *frameworkBundle = [NSBundle bundleWithIdentifier: @"com.binarymethod.BGHUDAppKit"];
	
    return [NSArray arrayWithObject: frameworkBundle];
}

-(NSString *)label {
	
	return @"BGHUDAppKit";
}

@end
