//
//  SRRecorderControl+LeopardIB.m
//  SR Leopard
//
//  Created by Jesper on 2007-10-19.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>
#import <ShortcutRecorder/SRCommon.h>
#import <ShortcutRecorder/SRRecorderControl.h>
#import "SR_LeopardInspector.h"


@implementation SRRecorderControl ( LeopardIB )

- (void)ibPopulateKeyPaths:(NSMutableDictionary *)keyPaths {
    [super ibPopulateKeyPaths:keyPaths];
	
	// Remove the comments and replace "MyFirstProperty" and "MySecondProperty" 
	// in the following line with a list of your view's KVC-compliant properties.
    [[keyPaths objectForKey:IBAttributeKeyPaths] addObjectsFromArray:[NSArray arrayWithObjects:@"allowedFlags", @"style", @"allowsKeyOnly", @"escapeKeysRecord", nil]];
}

- (void)ibPopulateAttributeInspectorClasses:(NSMutableArray *)classes {
    [super ibPopulateAttributeInspectorClasses:classes];
    [classes addObject:[SR_LeopardInspector class]];
}

- (void)setUpDefaultAttributesInIB {
	[self setStyle:SRGreyStyle];
	[self setAllowsKeyOnly:NO escapeKeysRecord:NO];	
//	NSLog(@"- (void)setUpDefaultAttributesInIB %@", self);
}

- (NSArray *)ibDefaultChildren {
	return [NSArray array];
}

- (NSSize)ibMinimumSize {
	return NSMakeSize(SRMinWidth, SRMaxHeight);
}

- (NSSize)ibMaximumSize {
	return NSMakeSize(CGFLOAT_MAX, SRMaxHeight);
}

- (NSView *)ibDesignableContentView {
	return self;
}

@end
