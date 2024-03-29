//
//  VCRedeemAd.m
//  AthleanX
//
//  Created by Dmitriy on 23.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCRedeemAd.h"
#import "VCSettings.h"
#import "ModelClass.h"
#import "VCCode.h"

@implementation VCRedeemAd

+ (VCRedeemAd *) instance
{
	return [[[VCRedeemAd alloc] initWithNibName:NIB_NAME(@"VCRedeemAd") bundle:nil] autorelease];
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

- (void) close{
  //  [self dismissModalViewControllerAnimated:YES]; 
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) showSettings
{
	ModelClass *mc = [[ModelClass alloc] init];
	if (![[mc isSendingEmail] isEqualToString:@"code"])
	{
		VCCode *settingsVC = [VCCode instance];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
	else
	{
		VCSettings *settingsVC = [VCSettings instance];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
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
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
