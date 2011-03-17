//
//  CommonController.h
//  Pomodoro
//
//  Created by Ugo Landini on 3/17/11.
//  Copyright 2011 iUgol. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommonController : NSObject {
    
}

- (BOOL) checkDefault:(NSString*) property;
- (NSString*) bindCommonVariables:(NSString*)name;

@end
