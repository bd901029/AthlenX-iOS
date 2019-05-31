//
//  VCShuffleWorkout.h
//  AthleanX
//
//  Created by Dmitriy on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLTableAlert.h"

@class AthleanXAppDelegate;

@interface VCShuffleWorkout : UIViewController <UIAlertViewDelegate, MLTableAlertDelegate>
{
	AthleanXAppDelegate *m_appDelegate;
	
	NSMutableArray *m_aryEquipTableCell;
	
	IBOutlet UIActivityIndicatorView *m_progressView;
	
	MLTableAlert *m_selectEquipAlert;
	UIAlertView *m_purchaseEquipAlert;
}

+ (VCShuffleWorkout *) instance;

- (IBAction) back;

- (IBAction) basixLevel;
- (IBAction) nextLevel;
- (IBAction) maxLevel;
- (IBAction) xTremeLevel;

@end
