//
//  VCShuffleMeal.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCShuffleMeal.h"
#import "VCShuffleResult.h"

@implementation VCShuffleMeal

+ (VCShuffleMeal *) instance
{
	return [[[VCShuffleMeal alloc] initWithNibName:NIB_NAME(@"VCShuffleMeal") bundle:nil] autorelease];
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

- (IBAction) shuffleBreakfast
{
	VCShuffleResult *shuffleResult = [VCShuffleResult instanceWithName:@"BREAKFAST"];
	[self.navigationController pushViewController:shuffleResult animated:YES];
}

- (IBAction) shuffleLunch
{
	VCShuffleResult *shuffleResult = [VCShuffleResult instanceWithName:@"LUNCH"];
	[self.navigationController pushViewController:shuffleResult animated:YES];
}

- (IBAction) shuffleDinner
{
	VCShuffleResult *shuffleResult = [VCShuffleResult instanceWithName:@"DINNER"];
	[self.navigationController pushViewController:shuffleResult animated:YES];
}

- (IBAction) shuffleSnack
{
	VCShuffleResult *shuffleResult = [VCShuffleResult instanceWithName:@"SNACK"];
	[self.navigationController pushViewController:shuffleResult animated:YES];
}

- (IBAction) back
{
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
