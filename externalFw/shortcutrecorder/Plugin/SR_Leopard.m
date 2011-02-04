//
//  SR_Leopard.m
//  SR Leopard
//
//  Created by Jesper on 2007-10-19.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <ShortcutRecorder/ShortcutRecorder.h>
#import "SR_Leopard.h"
//#import "SRRecorderControl+LeopardIB.m"

@interface SRRecorderControl (LeopardIBInterface)
- (void)setUpDefaultAttributesInIB;
@end


@implementation SR_Leopard

- (NSArray *)requiredFrameworks {
	NSBundle*    frameworkBundle = [NSBundle bundleWithIdentifier:@"net.wafflesoftware.ShortcutRecorder.framework.Leopard"];
	
    return [NSArray arrayWithObject:frameworkBundle];
}

- (void)document:(IBDocument *)document didAddDraggedObjects:(NSArray *) roots fromDraggedLibraryView:(NSView *) view {
	
	NSLog(@"roots: %@", roots);
	for (id obj in roots) {
		if ([obj isKindOfClass:[SRRecorderControl class]]) {
			SRRecorderControl *srrc = obj;
			[srrc setUpDefaultAttributesInIB];
		}
	}
	
}

- (NSArray *)libraryNibNames {
    return [NSArray arrayWithObject:@"SR_LeopardLibrary"];
}

- (NSString *)label {
	return @"Shortcut Recorder";
}
@end
