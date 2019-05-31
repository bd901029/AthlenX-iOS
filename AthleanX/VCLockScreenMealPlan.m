//
//  VCLockScreenMealPlan.m
//  AthleanX
//
//  Created by Dmitriy on 09.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCLockScreenMealPlan.h"
#import "IAPMainViewController.h"
#import "AthleanXAppDelegate.h"


@implementation VCLockScreenMealPlan

+ (VCLockScreenMealPlan *) instance
{
	return [[[VCLockScreenMealPlan alloc] initWithNibName:NIB_NAME(@"VCLockScreenMealPlan") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

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
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) back
{
	AthleanXAppDelegate *delegate = [AthleanXAppDelegate sharedDelegate];
	delegate.bIsShownLockedMealPlan = NO;
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) closeBtnClicked:(id)sender
{
	AthleanXAppDelegate *delegate = [AthleanXAppDelegate sharedDelegate];
	delegate.bIsShownLockedMealPlan = NO;
	
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) upgradeBtnClicked:(id)sender
{
	IAPMainViewController *vc = [IAPMainViewController instance];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
