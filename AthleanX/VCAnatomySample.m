//
//  VCAnatomySample.m
//  AthleanX
//
//  Created by Dmitriy on 29.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCAnatomySample.h"

@implementation VCAnatomySample

@synthesize movieURL;

- (void) play
{
	
}

- (void) stop
{
	
}

- (void) pause
{
	
}

- (void) prepareToPlay
{
	
}

- (void) beginSeekingBackward
{
	
}

- (void) beginSeekingForward
{
	
}

- (void) endSeeking
{
	
}

-(NSURL *)localMovieURL
{
	if (self.movieURL == nil)
	{
		NSBundle *bundle = [NSBundle mainBundle];
		if (bundle) 
		{
			NSString *moviePath = [bundle pathForResource:anatomyCode ofType:@"mp4"];
			if (moviePath)
			{
				self.movieURL = [NSURL fileURLWithPath:moviePath];
			}
		}
	}
	
	return self.movieURL;
}

- (id)initWithCode:(NSString *)code
{
	if ( self = [super init] )
	{
		anatomyCode = code;
	}
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:NIB_NAME(@"VCAnatomySample") bundle:nibBundleOrNil];
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

- (void)dealloc
{
	player = NULL;	   
	[player release];
 
	[super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[player play];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
	CGSize winSize = self.view.frame.size;
	
	player = [[MPMoviePlayerController alloc] initWithContentURL:[self localMovieURL]];
	player.view.frame = CGRectMake(0, 0, 320, 480);
	player.view.center = CGPointMake(winSize.width/2.0f, winSize.height/2.0f);
	[self.view addSubview:player.view];
	
	[player setControlStyle:MPMovieControlStyleNone];
	[player setShouldAutoplay:YES];
	
	UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
	
	[done setImage:[UIImage imageNamed:@"done_garay.png"] forState:normal];	
	[done addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];	
	[self.view addSubview:done];
	[done release];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (IBAction) back
{
	[player release];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
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

- (void) moviePlayerFinished
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end
