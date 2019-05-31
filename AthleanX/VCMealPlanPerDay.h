//
//  VCMailPlanDay.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerAlertView.h"

@class AthleanXAppDelegate;
@class MealPlanManager;


@interface VCMealPlanPerDay : UIViewController <UIAlertViewDelegate>
{
	IBOutlet UIWebView *m_webviewMealPlanDay;
	AthleanXAppDelegate *m_appDelegate;
	MealPlanManager *m_mealPlanManager;
	
	IBOutlet UILabel *m_titleLabel;
	IBOutlet UIButton *m_nextBtn;
	IBOutlet UIButton *m_prevBtn;
	
}

+ (VCMealPlanPerDay *) instance;

- (IBAction) back;
- (IBAction) next;
- (IBAction) prev;

@end
