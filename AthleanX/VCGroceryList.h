//
//  VCGroceryList.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AthleanXAppDelegate;
@class MealPlanManager;

@interface VCGroceryList : UIViewController {
	
	IBOutlet UIWebView *webViewGroceryList;
	AthleanXAppDelegate *app;
	
	IBOutlet UILabel *titleLab;
	IBOutlet UIButton *nextBnt;
	IBOutlet UIButton *prevBtn;
	
	MealPlanManager *mp;
}

+ (VCGroceryList *) instance;

- (IBAction) back;

- (IBAction) alert;

- (IBAction) next;
- (IBAction) prev;

- (IBAction) tips;
- (IBAction) staples;

@end
