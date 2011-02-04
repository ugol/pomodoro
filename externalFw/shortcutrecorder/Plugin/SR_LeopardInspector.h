//
//  SR_LeopardInspector.h
//  SR Leopard
//
//  Created by Jesper on 2007-10-19.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <InterfaceBuilderKit/InterfaceBuilderKit.h>

@class SRRecorderControl;

@interface SR_LeopardInspector : IBInspector {
	IBOutlet NSSegmentedControl *allowed;
	IBOutlet NSSegmentedControl *required;

	IBOutlet NSPopUpButton *recordBareKeys;
	IBOutlet NSPopUpButton *style;
	IBOutlet NSButton *animates;
	
	IBOutlet SRRecorderControl *initial;
}
- (IBAction)ok:(id)sender;
@end
