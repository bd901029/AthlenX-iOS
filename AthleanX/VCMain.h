//
//  VCMain.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"

@class AthleanXAppDelegate;

@interface VCMain : UIViewController <UIAlertViewDelegate>
{
	IBOutlet UIButton *m_celebrityBtn;
	
	ModelClass *m_modelClass;
	AthleanXAppDelegate *m_appDelegate;
	
	UIAlertView *m_purchaseAlertView;
}

+ (VCMain *) instance;

- (IBAction) showInfo;
- (IBAction) showSettings;

- (IBAction) showMealPlan;
- (IBAction) showProgress;
- (IBAction) masterVault;

- (IBAction) shuffleWorkout;
- (IBAction) startSixPackPromise;
- (IBAction) celeratorClicked:(id)sender;

@end
