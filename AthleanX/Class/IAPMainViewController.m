//
//  IAPMainViewController.m
//  AthleanX
//
//  Created by Cai DaRong on 1/10/13.
//
//

#import "IAPMainViewController.h"
#import "MKStoreManager.h"
#import "VCMealPlan.h"
#import "VCProgress.h"
#import "VCMasterVault.h"
#import "VCCode.h"
#import "VCSettings.h"
#import "IAPPerchaseViewController.h"
#import "MKStoreManager.h"
#import "VCInfo.h"
#import "VCLockScreenMealPlan.h"
#import "AthleanXAppDelegate.h"
#import "ExManager.h"

@interface IAPMainViewController ()

@end

@implementation IAPMainViewController

+ (IAPMainViewController *) instance
{
	return [[[IAPMainViewController alloc] initWithNibName:NIB_NAME(@"IAPMainViewController") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( !storeManager.purchasedGroup1 )
	{
//		[m_lblGroup1 setText:@"Locked"];
//		[m_lblGroup1 setTextColor:[UIColor redColor]];
	}
	else
	{
//		[m_lblGroup1 setText:@"Unlocked"];
//		[m_lblGroup1 setTextColor:[UIColor whiteColor]];
//		[m_lblGroup1 setAlpha:0.8];
		
		[m_btnGroup1 setEnabled:NO];
	}
	
	if ( !storeManager.purchasedGroup2 )
	{
//		[m_lblGroup2 setText:@"Locked"];
//		[m_lblGroup2 setTextColor:[UIColor redColor]];
	}
	else
	{
//		[m_lblGroup2 setText:@"Unlocked"];
//		[m_lblGroup2 setTextColor:[UIColor whiteColor]];
//		[m_lblGroup2 setAlpha:0.8];
		
		[m_btnGroup2 setEnabled:NO];
	}
	
	if ( !storeManager.purchasedFullVersion )
	{
//		[m_lblFullVersion setText:@"Locked"];
//		[m_lblFullVersion setTextColor:[UIColor redColor]];
	}
	else
	{
//		[m_lblFullVersion setText:@"Unlocked"];
//		[m_lblFullVersion setTextColor:[UIColor whiteColor]];
//		[m_lblFullVersion setAlpha:0.8];
		
		[m_btnFullVersion setEnabled:NO];
		
//		[m_lblGroup1 setText:@"Unlocked"];
//		[m_lblGroup1 setTextColor:[UIColor whiteColor]];
//		[m_lblGroup1 setAlpha:0.8];
		
		[m_btnGroup1 setEnabled:NO];
		
//		[m_lblGroup2 setText:@"Unlocked"];
//		[m_lblGroup2 setTextColor:[UIColor whiteColor]];
//		[m_lblGroup2 setAlpha:0.8];
		
		[m_btnGroup2 setEnabled:NO];
	}
	
	if ( storeManager.purchasedGroup1 || storeManager.purchasedGroup2 )
	{
//		[m_lblFullVersion setAlpha:0.8];
		[m_btnFullVersion setEnabled:NO];
	}
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction) backBtnClicked:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction) infoBtnClicked
{
	VCInfo *infoVC = [[[VCInfo alloc] init] autorelease];
//	[self presentViewController:infoVC animated:YES completion:nil];
	[self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction) optionBtnClicked:(id)sender
{
	ModelClass *mc = [[ModelClass alloc] init];
	if (![[mc isSendingEmail] isEqualToString:@"code"])
	{
		VCCode *settingsVC = [[[VCCode alloc] init] autorelease];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
	else
	{
		VCSettings *settingsVC = [VCSettings instance];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
}

- (IBAction) group1BtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( storeManager.purchasedGroup1 )
		return;
		
	IAPPerchaseViewController *vc = [IAPPerchaseViewController instance];
	[self.navigationController pushViewController:vc animated:YES];
	[vc setProductID:IAP_GROUP1];
}

- (IBAction) group2BtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( storeManager.purchasedGroup2 )
		return;
	
	IAPPerchaseViewController *vc = [IAPPerchaseViewController instance];
	[self.navigationController pushViewController:vc animated:YES];
	[vc setProductID:IAP_GROUP2];
}

- (IBAction) fullVersionBtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( storeManager.purchasedFullVersion )
		return;
	
	IAPPerchaseViewController *vc = [IAPPerchaseViewController instance];
	[self.navigationController pushViewController:vc animated:YES];
	[vc setProductID:IAP_FULLVERSION];
}

- (IBAction) restoreBtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	storeManager.delegate = self;
	[storeManager restoreAllPurchases];
}

- (IBAction) homeBtnClicked:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction) mealPlanBtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( storeManager.purchasedFullVersion == NO && storeManager.purchasedGroup1 == NO )
	{
//		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Meal Plan" message:@"Unlock the meal plan?"
//														   delegate:nil
//												  cancelButtonTitle:@"Later"
//												   otherButtonTitles:@"Unlock", nil] autorelease];
//		[alertView show];
		AthleanXAppDelegate *delegate = [AthleanXAppDelegate sharedDelegate];
		if ( delegate.bIsShownLockedMealPlan )
		{
			[self.navigationController popViewControllerAnimated:YES];
		}
		else
		{
			VCLockScreenMealPlan *vc = [VCLockScreenMealPlan instance];
			[self.navigationController pushViewController:vc animated:YES];
		}
		
		return;
	}
	
	VCMealPlan *vc = [VCMealPlan instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) progressBtnClicked:(id)sender
{
	VCProgress *vc = [VCProgress instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) masterVaultBtnClicked:(id)sender
{
	VCMasterVault *vc = [VCMasterVault instance];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - MKStoreManagerDelegate
- (void) mkStoreManagerSuccessed:(MKStoreManager *)storeManager productID:(NSString *)productID
{
	ExManager *exManager = [ExManager sharedExManager];
	if ( [productID isEqualToString:IAP_GROUP1] )
	{
		[exManager purchaseWithType:PurchaseGroup1];
	}
	else if ( [productID isEqualToString:IAP_GROUP2] )
	{
		[exManager purchaseWithType:PurchaseGroup2];
	}
	else if ( [productID isEqualToString:IAP_FULLVERSION] )
	{
		[exManager purchaseWithType:PurchaseFullVersion];
	}
	
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
