//
//  VCGroceryList.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCGroceryList.h"
#import "AthleanXAppDelegate.h"
#import "MealPlanManager.h"
#import "VCTopTips.h"
#import "VCStaples.h"


@implementation VCGroceryList

+ (VCGroceryList *) instance
{
	return [[[VCGroceryList alloc] initWithNibName:NIB_NAME(@"VCGroceryList") bundle:nil] autorelease];
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
	app = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	

	mp = [[MealPlanManager alloc] init];
	
  //  NSLog(@"%@",[mp getWeekInHTML:2]);


   
	[super viewDidLoad];
	
	
  //  str = [str stringByAppendingString:@"<html><head> <style> u{display:inline; color: red; font-size: 15px; font-weight: bold; text-decoration: none;}  w{display:inline; color: white; font-size: 15px; } </style></head><body>"];
	
	//str = [str stringByAppendingString:@"<u> Proteins </u><br><w> Boneless, Skinless <br> Tuna </w><br><br><u> Produce </u><br><w> Apples </w><br><w> Bananas </w><br><w> Pears </w><br><w> Salad Mix</w><br><br><u> Dairy </u><br><w> Skim Milk <br> Low Fat String Cheese </w></body></html>"];
	
	[webViewGroceryList setBackgroundColor:[UIColor clearColor]];
	[webViewGroceryList setOpaque:NO];
	[webViewGroceryList loadHTMLString:[mp getWeekInHTML:app.curentWeek] baseURL:nil];
	
	[titleLab setText:[NSString stringWithFormat:@"GROCERY LIST: WEEK %i",app.curentWeek]];
}

- (void)alert{
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:@"text" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//	[alert show];
//	[alert release];	
}

- (IBAction) back{	
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)next {
	
  
	
	if (app.curentWeek != 9) {
	   // [nextBnt setHidden:NO];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:webViewGroceryList cache:YES];
		[UIView commitAnimations];
		[prevBtn setHidden:NO];
		if (app.curentWeek == 7) {
			[nextBnt setHidden:YES];
		}
		app.curentWeek++;
		[titleLab setText:[NSString stringWithFormat:@"GROCERY LIST: WEEK %i",app.curentWeek]];
		[webViewGroceryList loadHTMLString:[mp getWeekInHTML:app.curentWeek] baseURL:nil];
	} else {
	   // [nextBnt setHidden:YES];
	}
	
	

	
	
}

- (void)prev {

	
	if (app.curentWeek != 1) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:webViewGroceryList cache:YES];
		[UIView commitAnimations];
		[nextBnt setHidden:NO];
		if (app.curentWeek == 2) {
			[prevBtn setHidden:YES];
		}
	  //  [prevBtn setHidden:NO];
		app.curentWeek--;
	   // 
	 

		[titleLab setText:[NSString stringWithFormat:@"GROCERY LIST: WEEK %i",app.curentWeek]];
		[webViewGroceryList loadHTMLString:[mp getWeekInHTML:app.curentWeek] baseURL:nil];
	} else {
	   // [prevBtn setHidden:YES];
	}
}

- (void)staples {
	VCStaples *staples = [VCStaples instance];
	[self.navigationController pushViewController:staples animated:YES];
}

- (void)tips
{
	VCTopTips *vc = [VCTopTips instance];
	[self.navigationController pushViewController:vc animated:YES];
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
