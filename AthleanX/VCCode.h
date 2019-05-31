//
//  VCCode.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 25.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SBTableAlert.h"

@interface VCCode : UIViewController <UITextFieldDelegate/*, SBTableAlertDelegate, SBTableAlertDataSource*/>
{
	IBOutlet UITextField *textF;
}

+ (VCCode *) instance;

- (IBAction) back;
- (IBAction) subm;
- (IBAction) retry;

@end
