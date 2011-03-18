//
//  SpeechController.h
//  Pomodoro
//
//  Created by Ugo Landini on 3/18/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonController.h"

@interface SpeechController : CommonController {
 
    IBOutlet NSSpeechSynthesizer* speech;
	IBOutlet NSComboBox* voicesCombo;
    IBOutlet NSComboBox* speechEveryCombo;

	NSArray* voices;
    
}

@end
