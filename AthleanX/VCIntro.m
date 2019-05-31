//
//  VCIntro.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 11.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCIntro.h"
#import "LLNotificalionClass.h"

@implementation VCIntro

+ (id) instance
{
	return [[[VCIntro alloc] initWithNibName:NIB_NAME(@"VCIntro") bundle:nil] autorelease];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
	
#if 0
	NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"mov"]];
	player = [[MPMoviePlayerController alloc] initWithContentURL:url1];
	[player.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[player.view setBackgroundColor:[UIColor clearColor]];
	[player setControlStyle:MPMovieControlStyleNone];
	[player setShouldAutoplay:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayBackDidFinish:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:player];
	
	[player play];
	[self.view addSubview:player.view];
#endif

	m_vBkgnd = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	[m_vBkgnd setBackgroundColor:[UIColor blackColor]];
	[self.view addSubview:m_vBkgnd];
	[self.view sendSubviewToBack:m_vBkgnd];
	
	[self performSelector:@selector(gotoMainScreen) withObject:nil afterDelay:2];
	
	self.navigationController.navigationBarHidden = YES;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
	[m_ivDefault setHidden:YES];
	[UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseOut animations:^{
//		[player.view setAlpha:0];
	} completion:^(BOOL finished) {
//		[self dismissModalViewControllerAnimated:NO];
		[self.navigationController popViewControllerAnimated:NO];
	}];
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
	return NO;//(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) gotoMainScreen
{
#if 1
	[UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationCurveEaseOut animations:^{
		[self.view setAlpha:0];
	} completion:^(BOOL finished) {
//		[self dismissModalViewControllerAnimated:NO];
		[self.navigationController popViewControllerAnimated:NO];
	}];
#else
	[self dismissModalViewControllerAnimated:NO];
#endif
}

@end
