//
//  VCDisclamer.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 18.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCDisclamer.h"
#import "ModelClass.h"

@implementation VCDisclamer

+ (VCDisclamer *) instance
{
	return [[[VCDisclamer alloc] initWithNibName:NIB_NAME(@"VCDisclamer") bundle:nil] autorelease];
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
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

- (void) close
{
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dontShow {
	ModelClass *mc = [[ModelClass alloc] init];
	[mc saveData:@"No" toArchive:@"6Pack"];
	[mc release];
	[self close];
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
