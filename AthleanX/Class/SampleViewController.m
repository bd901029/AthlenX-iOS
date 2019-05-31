//
//  SampleViewController.m
//  AthleanX
//
//  Created by Cai DaRong on 1/15/13.
//
//

#import "SampleViewController.h"

@interface SampleViewController ()

@end

@implementation SampleViewController

+ (id) sampleViewControllerWithURL:(NSURL *)url
{
	return [[[SampleViewController alloc] initWithContentURL:url] autorelease];
}

- (id) initWithContentURL:(NSURL *)contentURL
{
	if ( self = [super initWithContentURL:contentURL] )
	{
		self.moviePlayer.controlStyle = MPMovieControlStyleNone;
		self.moviePlayer.fullscreen = YES;
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
	
	[self.view setFrame:CGRectMake(0, 0, 320, 480)];
	
	UIImage *image = [UIImage imageNamed:@"done_garay.png"];
	UIButton *doneBtn = [[[UIButton alloc] initWithFrame:CGRectMake(20, 20, image.size.width, image.size.height)] autorelease];
	[doneBtn setBackgroundImage:image forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:doneBtn];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (BOOL) shouldAutorotate
{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) doneBtnClicked:(id)sender
{
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) moviePlayerFinished
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
	
	[self.navigationController popViewControllerAnimated:YES];
}

@end
