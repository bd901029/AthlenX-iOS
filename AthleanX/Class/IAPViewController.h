//
//  IAPViewController.h
//  AthleanX
//
//  Created by Cai DaRong on 12/23/12.
//
//

#import <UIKit/UIKit.h>

@interface IAPViewController : UIViewController
{
	NSString *m_productID;
}

- (void) setProductID:(NSString *)productID;

- (IBAction) closeBtnClicked:(id)sender;
- (IBAction) upgradeBtnClicked:(id)sender;

@end
