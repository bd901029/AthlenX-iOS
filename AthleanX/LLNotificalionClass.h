//
//  LLNotificalionClass.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 14.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ModelClass;

@interface LLNotificalionClass : NSObject <UIAlertViewDelegate> {
	ModelClass *mc;
}
- (void) show;
@end
