//
//  VCSettings.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"

@class AthleanXAppDelegate;

@interface VCSettings : UIViewController <UIAlertViewDelegate>
{
	IBOutlet UITextField *m_mailTextField;
	AthleanXAppDelegate *m_appDelegate;
	ModelClass *m_modelClass;
	
	IBOutlet UIView *m_btnView;
	
	IBOutlet UIImageView *m_adImageView;
	UIAlertView *m_alertConfirmMailBox;
}

@property (nonatomic, retain) UIView *m_btnView;

+ (VCSettings *) instance;

- (IBAction) back;
- (IBAction) submitClicked;
- (IBAction) notNowClicked:(id)sender;

- (IBAction) adAction; 

@end
