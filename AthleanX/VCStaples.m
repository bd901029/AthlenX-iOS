//
//  VCStaples.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 02.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VCStaples.h"
#import "VCTopTips.h"
#import "MealPlanManager.h"

@implementation VCStaples

+ (VCStaples *) instance
{
	return [[[VCStaples alloc] initWithNibName:NIB_NAME(@"VCStaples") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
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
	MealPlanManager *mp = [[MealPlanManager alloc] init];
	
	[stablesWebView setBackgroundColor:[UIColor clearColor]];
	[stablesWebView setOpaque:NO];
	[stablesWebView loadHTMLString:[mp getWeekInHTML:10] baseURL:nil];
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)tips {
	VCTopTips *topTips = [VCTopTips instance];
	[self.navigationController pushViewController:topTips animated:YES];
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
