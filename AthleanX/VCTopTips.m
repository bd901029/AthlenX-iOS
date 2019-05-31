//
//  VCTopTips.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 02.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VCTopTips.h"
#import "ModelClass.h"

@implementation VCTopTips

+ (VCTopTips *) instance
{
	return [[[VCTopTips alloc] initWithNibName:NIB_NAME(@"VCTopTips") bundle:nil] autorelease];
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
	mc = [[ModelClass alloc] init];
	currentTip = 0;
	
	tipArray = [[NSArray alloc] initWithArray:[mc getAllTips]];
	
	NSLog(@"%@",tipArray);
	
	//  str = [str stringByAppendingString:@"<html><head> <style> u{display:inline; color: red; font-size: 15px; font-weight: bold; text-decoration: none;}  w{display:inline; color: white; font-size: 15px; } </style></head><body>"];
	
	//str = [str stringByAppendingString:@"<u> Proteins </u><br><w> Boneless, Skinless <br> Tuna </w><br><br><u> Produce </u><br><w> Apples </w><br><w> Bananas </w><br><w> Pears </w><br><w> Salad Mix</w><br><br><u> Dairy </u><br><w> Skim Milk <br> Low Fat String Cheese </w></body></html>"];
	
	[tipsView setBackgroundColor:[UIColor clearColor]];
	[tipsView setOpaque:NO];
	if ([tipArray count]) {
		NSLog(@"%@",[[[[[tipArray objectAtIndex:currentTip] objectForKey:@"description"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"%20" withString:@""]);
		 [tipsView loadHTMLString:[[NSString  stringWithFormat:@"<style>p {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; color:#fff  }  </style><p><b>%@<b></p>",[[tipArray objectAtIndex:currentTip] objectForKey:@"description"]] stringByReplacingOccurrencesOfString:@" " withString:@""] baseURL:nil];
		[tipName setText:[NSString stringWithFormat:@"TOP TIPS %i",currentTip+1]];
	} else {
		[self.navigationController popViewControllerAnimated:YES];
	}
	
//	Don't%20let%20that%20produce%20go%20bad!%20%C2%AC%E2%80%A0Freeze%20your%20berries,%20sliced%20bananas,%20etc%20before%20they%20get%20%0Atoo%20ripe%20and%20use%20them%20in%20your%20smoothies.%20%C2%AC%E2%80%A0They%20serve%20as%20ice%20and%20flavor%20in%20one%20convenient%20shot
   
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
}

 


- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)next {
	
	if (currentTip < [tipArray count]-1) {
		[prevBtn setHidden:NO];
		currentTip++;
		NSLog(@"%@",[[[tipArray objectAtIndex:currentTip] objectForKey:@"description"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
		 [tipsView loadHTMLString:[[NSString  stringWithFormat:@"<style>p {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; color:#fff  }  </style><p><b>%@<b></p>",[[tipArray objectAtIndex:currentTip] objectForKey:@"description"]] stringByReplacingOccurrencesOfString:@" " withString:@""] baseURL:nil];
		[tipName setText:[NSString stringWithFormat:@"TOP TIPS %i",currentTip+1]];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:tipsView cache:YES];
		[UIView commitAnimations];
		
		if (currentTip == [tipArray count]-1) {
			[nextBtn setHidden:YES];
		}
	}
}

- (void)prev {
	
	if (currentTip > 0) {
		[nextBtn setHidden:NO];
		currentTip--;
		[tipsView loadHTMLString:[NSString  stringWithFormat:@"<style>p {margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica; color:#fff  }  </style><p><b>%@<b></p>",[[tipArray objectAtIndex:currentTip] objectForKey:@"description"]] baseURL:nil];
		[tipName setText:[NSString stringWithFormat:@"TOP TIPS %i",currentTip+1]];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:tipsView cache:YES];
		[UIView commitAnimations];
		
		if (currentTip == 0) {
			[prevBtn setHidden:YES];
		}
	}
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
