//
//  IAPPerchaseViewController.h
//  AthleanX
//
//  Created by Cai DaRong on 1/10/13.
//
//

#import <UIKit/UIKit.h>
#import "MKStoreManager.h"

@interface IAPPerchaseViewController : UIViewController <UIAlertViewDelegate, MKStoreManagerDelegate>
{
	IBOutlet UIImageView *m_bkgndView;
	IBOutlet UILabel *m_costLabel;
	
	NSString *m_productID;
	
	UIAlertView *m_purchaseAlertView;
}

+ (IAPPerchaseViewController *) instance;

- (void) setProductID:(NSString *)productID;

- (IBAction) backBtnClicked:(id)sender;
- (IBAction) optionBtnClicked:(id)sender;

- (IBAction) homeBtnClicked:(id)sender;
- (IBAction) mealPlanBtnClicked:(id)sender;
- (IBAction) progressBtnClicked:(id)sender;
- (IBAction) masterVaultBtnClicked:(id)sender;

- (IBAction) buyBtnClicked:(id)sender;

@end
