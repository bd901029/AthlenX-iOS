//
//  IAPViewController.m
//  AthleanX
//
//  Created by Cai DaRong on 12/23/12.
//
//

#import "IAPViewController.h"
#import "MKStoreManager.h"

@interface IAPViewController ()

@end

@implementation IAPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		m_productID = IAP_FULLVERSION;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) setProductID:(NSString *)productID
{
	m_productID = productID;
}

- (IBAction) closeBtnClicked:(id)sender
{
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) upgradeBtnClicked:(id)sender
{
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	[storeManager perchaseWithProductID:m_productID];
}

@end
