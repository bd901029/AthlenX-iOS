//
//  VCPurchaseAd.m
//  AthleanX
//
//  Created by Dmitriy on 23.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCPurchaseAd.h"


@implementation VCPurchaseAd

+ (VCPurchaseAd *) instance
{
	return [[[VCPurchaseAd alloc] initWithNibName:NIB_NAME(@"VCPurchaseAd") bundle:nil] autorelease];
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

- (void) close
{
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
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
