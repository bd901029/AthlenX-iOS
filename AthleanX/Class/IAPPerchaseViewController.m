//
//  IAPPerchaseViewController.m
//  AthleanX
//
//  Created by Cai DaRong on 1/10/13.
//
//

#import "IAPPerchaseViewController.h"
#import "VCMealPlan.h"
#import "VCProgress.h"
#import "VCMasterVault.h"
#import "VCCode.h"
#import "VCSettings.h"
#import "ExManager.h"
#import "VCInfo.h"


@interface IAPPerchaseViewController ()
{
	UIAlertView *m_perchaseConfirmAlert;
}

@end

@implementation IAPPerchaseViewController

+ (IAPPerchaseViewController *) instance
{
    return [[[IAPPerchaseViewController alloc] initWithNibName:NIB_NAME(@"IAPPerchaseViewController") bundle:nil] autorelease];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void) setProductID:(NSString *)productID
{
	m_productID = productID;

	if ( [m_productID isEqualToString:IAP_GROUP1] )
	{
		[m_bkgndView setImage:[UIImage imageNamed:@"group1Bkgnd.png"]];
		m_costLabel.text = @"Unlock for $0.99";
	}
	else if ( [m_productID isEqualToString:IAP_GROUP2] )
	{
		[m_bkgndView setImage:[UIImage imageNamed:@"group2Bkgnd.png"]];
		m_costLabel.text = @"Unlock for $0.99";
	}
	else if ( [m_productID isEqualToString:IAP_FULLVERSION] )
	{
		[m_bkgndView setImage:[UIImage imageNamed:@"fullBkgnd.png"]];
		m_costLabel.text = @"Unlock for $1.99";
	}
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

- (IBAction) homeBtnClicked:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction) mealPlanBtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( storeManager.purchasedFullVersion == NO && storeManager.purchasedGroup1 == NO )
	{
		UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Meal Plan" message:@"Unlock the meal plan?"
															delegate:nil
												   cancelButtonTitle:@"Later"
												   otherButtonTitles:@"Unlock", nil] autorelease];
		[alertView show];
		
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

- (IBAction) buyBtnClicked:(id)sender
{
	m_perchaseConfirmAlert = [[[UIAlertView alloc] initWithTitle:@"Let's Go"
														 message:@"Please confirm your in App Purchase and Find a Perfect Workout."
														delegate:self
											   cancelButtonTitle:@"Cancel"
											   otherButtonTitles:@"OK", nil] autorelease];
	[m_perchaseConfirmAlert show];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( alertView == m_perchaseConfirmAlert )
	{
		if ( buttonIndex == 1 )
		{
			MKStoreManager *storeManager = [MKStoreManager sharedManager];
			[storeManager setDelegate:self];
			[storeManager perchaseWithProductID:m_productID];
		}
	}
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
