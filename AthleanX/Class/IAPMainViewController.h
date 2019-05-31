//
//  IAPMainViewController.h
//  AthleanX
//
//  Created by Cai DaRong on 1/10/13.
//
//

#import <UIKit/UIKit.h>
#import "MKStoreManager.h"

@interface IAPMainViewController : UIViewController <MKStoreManagerDelegate>
{
#if 0
	IBOutlet UILabel *m_lblGroup1;
	IBOutlet UILabel *m_lblGroup2;
	IBOutlet UILabel *m_lblFullVersion;
#endif
	
	IBOutlet UIButton *m_btnGroup1;
	IBOutlet UIButton *m_btnGroup2;
	IBOutlet UIButton *m_btnFullVersion;
}

+ (IAPMainViewController *) instance;

- (IBAction) backBtnClicked:(id)sender;
- (IBAction) optionBtnClicked:(id)sender;
- (IBAction) group1BtnClicked:(id)sender;
- (IBAction) group2BtnClicked:(id)sender;
- (IBAction) fullVersionBtnClicked:(id)sender;

- (IBAction) homeBtnClicked:(id)sender;
- (IBAction) mealPlanBtnClicked:(id)sender;
- (IBAction) progressBtnClicked:(id)sender;
- (IBAction) masterVaultBtnClicked:(id)sender;

@end
