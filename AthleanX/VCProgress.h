//
//  VCProgress.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AthleanXAppDelegate;
@class ModelClass;

@interface VCProgress : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate>
{
	AthleanXAppDelegate *m_appDelegate;
	ModelClass *mc;
	IBOutlet UIImageView *mainImageView;
	IBOutlet UIView *contentView;
	
	NSArray *daysArray;
	
	int num;
	IBOutlet UIButton *weekBtn;
	
	IBOutlet UIView *calViewMain;
	IBOutlet UIView *calView1_4;
	IBOutlet UIView *calView5_8;
	NSMutableDictionary *dayTraningsArray;
	
	UIAlertView *m_purchaseAlertView;
}

+ (VCProgress *) instance;

- (IBAction) back;
- (IBAction) reset;
- (IBAction) musTest;
- (IBAction) weekBtn;

- (void) setLabelOnDayNumber:(NSInteger)day lableText:(NSString *)text andTranings:(NSInteger)tranId;
- (void) setLabelOnDay2Number:(NSInteger)day lableText:(NSString *)text andTranings:(NSInteger)tranId;

@end
