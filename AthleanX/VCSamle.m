//
//  VCSamle.m
//  AthleanX
//
//  Created by Dmitriy on 12.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCSamle.h"

@implementation VCSamle

@synthesize movieURL = movieURL;

- (NSURL *) localMovieURL
{
	if (self.movieURL == nil)
	{
		NSBundle *bundle = [NSBundle mainBundle];
		if (bundle) 
		{
			NSString *moviePath = [bundle pathForResource:[currentEx sampleVideoPath] ofType:@"mp4"];
			if (moviePath)
			{
				self.movieURL = [NSURL fileURLWithPath:moviePath];
			}
		}
	}
	
	return self.movieURL;
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (id) initExerciceId:(int)exId
{
	if (self)
	{
		initById = exId;
	}
	
	return self;
}

- (void)dealloc
{
//	player = NULL;
//	mc = NULL;
//	currentEx = NULL;
//	
//	[player release];
//	[mc release];
//	[currentEx release];
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[player play];	
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] autorelease];
	[self.view addSubview:volumeView];
	[self.view sendSubviewToBack:volumeView];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
//	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
	
	mc = [[ModelClass alloc] init];
	currentEx = [[NSExercice alloc] init]; 
	
	currentEx = [mc getExercice30ById:initById];
	  
		
	[exerciceName setText:[currentEx exerciseName]];

	NSURL *url = [mc sampleVideoURLWithID:initById];
	player = [[MPMoviePlayerController alloc] initWithContentURL:url];
	player.view.frame = CGRectMake(0, 0, 480, 320);
	[self.view addSubview:player.view];
	player.controlStyle = MPMovieControlStyleNone;
	[player setShouldAutoplay:YES];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(moviePlayBackDidFinish:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:player];
   
	UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
	
	[done setImage:[UIImage imageNamed:@"done_garay.png"] forState:normal];	
	[done addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:done];
	[done release];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
	[self back];
}
 

- (IBAction) back
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:player];		  
	[player stop];
	[player.view removeFromSuperview];
	[player release];

//	if (player) {
//	[player stop];
//	[player autorelease];
//	 }
	
	//[mc release];
	//[currentEx release];
		
	NSLog(@"sample did finish <<<");
//	[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
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
	//return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

#if 1
- (void) endSeeking
{
	
}

- (void) stop
{
	
}

- (void) beginSeekingBackward
{
	
}

- (void) beginSeekingForward
{
	
}

- (void) pause
{
	
}

- (void) play
{
	
}

- (void) prepareToPlay
{
	
}
#endif

@end
