//
//  VCDoWorkout.m
//  AthleanX
//
//  Created by Dmitriy on 12.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCDoWorkout.h"
#import <AVFoundation/AVFoundation.h>
#import "AthleanXAppDelegate.h"
#import "CoreAudio.h"
#import "VCWorkout.h"
#import "VCSamle.h"
#import "AVAudioPlayer2.h"
#import "ExManager.h"
#import "IAPMainViewController.h"
#import "SampleViewController.h"

@implementation VCDoWorkout

+ (VCDoWorkout *) instance
{
	return [[[VCDoWorkout alloc] initWithNibName:NIB_NAME(@"VCDoWorkout") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:NIB_NAME(@"VCDoWorkout") bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)dealloc
{
	[namesArr release];
	[idArray release];
   // [playerEquipment release];
	[m_player1 release];
	[super dealloc];
}

- (id) initWithArray:(NSArray *)arr
{
	self = [super initWithNibName:NIB_NAME(@"VCDoWorkout") bundle:nil];
	if (self) {
		m_training = [[NSTraining alloc] initWithArray:arr]; // NUMBER OF TRANING!
	}
	return self;
}

- (id)initWithTranningId:(int)trID
{
	self = [super init];
	if (self) {
		m_training = [[NSTraining alloc] initWithArray:[m_modelClass getTrainingByDay:trID]]; // NUMBER OF TRANING!
	}
	return self;
}


#pragma mark - View lifecycle
- (void) viewDidLoad
{
	[super viewDidLoad];
	
	m_appDelegate = [AthleanXAppDelegate sharedDelegate];
	
	MPVolumeView *volumeView = [[[MPVolumeView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] autorelease];
	[self.view addSubview:volumeView];
	[self.view sendSubviewToBack:volumeView];
	
	[[UIApplication sharedApplication] setStatusBarHidden:NO];
	
	if ( m_appDelegate.isDoWorkout )
	{
		m_appDelegate.isDoWorkout = NO;
		m_modelClass = [[ModelClass alloc] init];
		
		isPlay = YES;
		
		if ( !m_slideToCancel )
		{
			// Create the slider
			m_slideToCancel = [[SlideToCancelViewController alloc] init];
			m_slideToCancel.delegate = self;
			
			// Position the slider off the bottom of the view, so we can slide it up
			CGRect sliderFrame = m_slideToCancel.view.frame;
			sliderFrame.origin.y = self.view.frame.size.height;
			m_slideToCancel.view.frame = sliderFrame;
			
			// Add slider to the view
			[self.view addSubview:m_slideToCancel.view];
		}
		
		[UIApplication sharedApplication].idleTimerDisabled = YES;
		
		[m_training load];
		
		equipmentArray = [[NSMutableArray alloc] initWithArray:[m_training getEquipment]];
		[equipmentArray insertObject:@"1_WelcomeToSixPackPromise" atIndex:0];
		currentEquipment = 0;
		
		namesArr = [[NSArray alloc] initWithArray:[m_training getNameArr]];
		idArray = [[NSArray alloc] initWithArray:[m_training getM_aryId]];
		
		[currExName setText:[namesArr objectAtIndex:[m_training currentExNumber]]];
		if ([m_training currentExNumber] == [m_training m_exCount]-1)
		{
			[nextExName setText:@"Last"];
		}
		else
		{
			[nextExName setText:[NSString stringWithFormat:@"Next Up: %@",[namesArr objectAtIndex:[m_training currentExNumber]+1]]];
		}
		
		timeRemaining = [m_training getTrainingDuration];
		
		[timeRemainingLabel setText:[NSString stringWithFormat:@"WORKOUT TIME REMAINING: %@",[m_modelClass second2minut:[m_training getTrainingDuration]]]];
		
//		NSLog(@"allEx - %i",[m_training m_exCount]);
//		NSLog(@"currExname - %i) %@ (%i)",[m_training currentExNumber] ,[m_training getCurrentExName], [m_training getCurrentExDuration]);
		
		[m_audioVolumeSlider setHidden:YES];
		
		[[AVAudioSession sharedInstance] setDelegate: self];
		[[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryAmbient error: nil];
		[[AVAudioSession sharedInstance] setActive: YES error: nil];
		
		pathLeft30 = [[NSBundle mainBundle] pathForResource:@"11_30SecondsLeft" ofType:@"wav"];
		m_playerLeft30 = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathLeft30] error:NULL];
		[m_playerLeft30 setDelegate:self];
		[m_playerLeft30 setVolume:1.0f];
		[m_playerLeft30 prepareToPlay];
		
		pathLeft15 = [[NSBundle mainBundle] pathForResource:@"12_15SecondsLeft" ofType:@"wav"];
		m_playerLeft15 = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathLeft15] error:NULL];
		[m_playerLeft15 setDelegate:self];
		[m_playerLeft15 setVolume:1.0f];
		[m_playerLeft15 prepareToPlay];
		
		m_pathLeft10 = [[NSBundle mainBundle] pathForResource:@"13_10SecondsLeft" ofType:@"wav"];
		m_playerLeft10 = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:m_pathLeft10] error:NULL];
		[m_playerLeft10 setDelegate:self];
		[m_playerLeft10 setVolume:1.0f];
		[m_playerLeft10 prepareToPlay];
		
		m_pathPause20 = [[NSBundle mainBundle] pathForResource:@"pause20" ofType:@"wav"];
		m_playerPause20 = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:m_pathPause20] error:NULL];
		[m_playerPause20 setDelegate:self];
		[m_playerPause20 setVolume:1.0f];
		[m_playerPause20 prepareToPlay];
		
		m_pathPause60 = [[NSBundle mainBundle] pathForResource:@"pause60" ofType:@"wav"];
		m_playerPause60 = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:m_pathPause60] error:NULL];
		[m_playerPause60 setDelegate:self];
		[m_playerPause60 setVolume:1.0f];
		[m_playerPause60 prepareToPlay];
		
		m_pathEnd = [[NSBundle mainBundle] pathForResource:@"compl" ofType:@"wav"];
		m_playerEnd = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:m_pathEnd] error:NULL];
		[m_playerEnd setDelegate:self];
		[m_playerEnd setVolume:1.0f];
		[m_playerEnd prepareToPlay];
		
		
		m_audioIsPaused = NO;
		sec = [m_training getCurrentExDuration];
		secPause = 0;
		[timeLabel setText:[NSString stringWithFormat:@"%i",sec]];
		
		[self playEquipment];
		
		MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame:m_audioVolumeSlider.frame];
		
		[playerView addSubview: myVolumeView];
		[myVolumeView release];
		
		[m_appDelegate.m_coreAudio prepareToPlay];
		[m_appDelegate.m_coreAudio play];
		if ([m_appDelegate.m_coreAudio isPlaying])
		{
			m_audioName.text = [m_appDelegate.m_coreAudio getPlayingName];
			m_audioName2.text = [m_appDelegate.m_coreAudio getPlayingArtistName];
		}
	}
	else
	{
		[currExName setText:[namesArr objectAtIndex:[m_training currentExNumber]]];
		if ( [m_training currentExNumber] == [m_training m_exCount] - 1 )
		{
			[nextExName setText:@"Last"];
		}
		else
		{
			[nextExName setText:[NSString stringWithFormat:@"Next Up: %@",[namesArr objectAtIndex:[m_training currentExNumber]+1]]];
		}
		
		[self pauseShow:YES];
	}
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - Base Proc
- (IBAction) lock
{
	m_slideToCancel.enabled = YES;
	
	// Slowly move up the slider from the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[sampleButton setAlpha:0];
	[muzButton setAlpha:0];
	[lockButton setAlpha:0];
	
	[m_slideToCancel.view setAlpha:1];
	CGPoint sliderCenter = m_slideToCancel.view.center;
	sliderCenter.y -= m_slideToCancel.view.bounds.size.height;
	m_slideToCancel.view.center = sliderCenter;
	[UIView commitAnimations];
}

- (void) cancelled
{
	// Disable the slider and re-enable the button
	m_slideToCancel.enabled = NO;

	// Slowly move down the slider off the bottom of the screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[sampleButton setAlpha:1];
	[muzButton setAlpha:1];
	[lockButton setAlpha:1];
	
	[m_slideToCancel.view setAlpha:0];
	CGPoint sliderCenter = m_slideToCancel.view.center;
	sliderCenter.y += m_slideToCancel.view.bounds.size.height;
	m_slideToCancel.view.center = sliderCenter;
	[UIView commitAnimations];
}

#pragma mark - Control Proc
- (IBAction) playVideoSample
{
	if ([[idArray objectAtIndex:[m_training currentExNumber]] intValue] != -1)
	{
		[self pauseShow:YES];
		m_appDelegate.isAudioSession = YES;
		
#if 0
		VCSamle *sampleView = [[VCSamle alloc] initExerciceId:[[idArray objectAtIndex:[m_training currentExNumber]] intValue]];
		[self presentModalViewController:sampleView animated:YES];
		[sampleView release];
#else
		NSURL *sampleURL = [m_modelClass sampleVideoURLWithID:[[idArray objectAtIndex:[m_training currentExNumber]] intValue]];
		SampleViewController *viewController = [SampleViewController sampleViewControllerWithURL:sampleURL];
//		[self presentViewController:viewController animated:YES completion:nil];
		[self.navigationController pushViewController:viewController animated:YES];
#endif
	}
}

- (void) playEquipment
{
	NSString *equipmentName = [equipmentArray objectAtIndex:currentEquipment];
	m_pathEquipment = [[NSBundle mainBundle] pathForResource:equipmentName ofType:@"wav"];
	
	NSURL *url = [NSURL fileURLWithPath:m_pathEquipment];
	m_playerEquipment = [[AVAudioPlayer2 alloc] initWithContentsOfURL:url error:NULL];
	[m_playerEquipment setDelegate:self];
	[m_playerEquipment setVolume:1.0f];
	[m_playerEquipment prepareToPlay];
	if ( [[AthleanXAppDelegate sharedDelegate] isSixPack] && [equipmentName isEqualToString:@"No Equipment"] && equipmentArray.count > 2 )
	{
		[self audioPlayerDidFinishPlaying:m_playerEquipment successfully:YES];
	}
	else
	{
		[m_playerEquipment play];
	}
}

- (void) playSound
{
	NSString* path = [[NSBundle mainBundle] pathForResource:[m_training getCurrentExNameSaund] ofType:@"wav"];
	m_player1 = [[AVAudioPlayer2 alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];
	[m_player1 setDelegate:self];
	[m_player1 setVolume:1.0f];
	[m_player1 prepareToPlay];  
	[m_player1 play];
}

- (void) tic
{
//	AthleanXAppDelegate *delegate = [AthleanXAppDelegate sharedDelegate];
//	ExManager *exManger = [ExManager sharedExManager];
	
	if ( !m_audioIsPaused )
	{
		sec--;
		timeRemaining--;
		[timeLabel setText:[NSString stringWithFormat:@"%i", sec]];
		[timeRemainingLabel setText:[NSString stringWithFormat:@"WORKOUT TIME REMAINING : %@",[m_modelClass second2minut:timeRemaining]]];
		
#if 0
		if ( sec == 0 )
#else
		if ( sec != 0 )
#endif
		{
			[timer invalidate];
			timer = nil;			 
			if ( [m_training currentExNumber] == [m_training m_exCount] - 1 )
			{
				if (m_appDelegate.isSixPack)
					[m_modelClass setPassedDayByID:m_appDelegate.curentDay];
				
				[m_playerEnd play];
			}
			else
			{
				[m_training nextExercice];
				NSString *currentExName = [namesArr objectAtIndex:[m_training currentExNumber]];
//				int currentPoint = [exManger pointWithName:currentExName];
				
#if 0
				if ( ![exManger isFreeWithName:currentExName] )
				{
					if ( delegate.freeCredit > currentPoint )
					{
						delegate.freeCredit -= currentPoint;
						[delegate saveFreeCreditCount];
					}
					else
					{
						m_iapAlertView = [[[UIAlertView alloc] initWithTitle:@"Sorry"
																	 message:@"Please perchase current exercise in $0.99."
																	delegate:self
														   cancelButtonTitle:@"Later"
														   otherButtonTitles:@"Yes, Now", nil] autorelease];
						[m_iapAlertView show];
						return;
					}
				}
#endif
				
				[currExName setText:currentExName];
				if ([m_training currentExNumber] == [m_training m_exCount] - 1)
				{
					[nextExName setText:@"Last"];
				}
				else
				{
					[nextExName setText:[NSString stringWithFormat:@"Next Up: %@",[namesArr objectAtIndex:[m_training currentExNumber]+1]]];
				}
				
				sec = [m_training getCurrentExDuration];
				[timeLabel setText:[NSString stringWithFormat:@"%i", sec]];
				[self playSound];
			}
		}

		if (sec == 11)
		{
			[m_playerLeft10 play];
		}
	}
}

- (IBAction) player
{
	if ([m_appDelegate.m_coreAudio getAudioType] == 4)
	{
		m_audioName.text = @"No Music Selected";
	}
	
	if (playerView.hidden)
	{
		[playerView setHidden:NO];
		[self pauseShow:NO];
		if ([m_appDelegate.m_coreAudio isPlaying])
		{
			m_audioName.text = [m_appDelegate.m_coreAudio getPlayingName];
			m_audioName2.text = [m_appDelegate.m_coreAudio getPlayingArtistName];
		}
	}
	else
	{
		[playerView setHidden:YES];
		[self pauseHide:NO];
	}
}

- (void) ticPause
{
	if (m_audioIsPaused)
	{
		secPause++;
		[pauseTimeLabel setText:[NSString stringWithFormat:@"%i",secPause]];
		if (secPause == 20) 
			[m_playerPause20 play];
		
		if (secPause == 60) 
			[m_playerPause60 play];
	}
}

- (IBAction) pauseBtn
{
	if (m_pauseView.alpha == 0)
	{
		[self pauseShow:YES];
	}
	else
	{
		[self pauseHide:YES];
	}
}

- (void) pauseShow:(BOOL)audioStop
{
	[pauseTimeLabel setHidden:NO];
	m_audioIsPaused = YES;
	[pauseTimeLabel setText:[timeLabel text]];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];	
	[m_pauseView setFrame:CGRectMake(0, 0, 320, 480)]; 
	[m_pauseView setAlpha:1];
	[UIView commitAnimations];
	
	timerPause = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ticPause) userInfo:nil repeats:YES];
	[pauseTimeLabel setText:[NSString stringWithFormat:@"%i", secPause]];
	
	if (audioStop)
	{
		[m_appDelegate.m_coreAudio pause];
	}
}

- (void) pauseHide:(BOOL)audioStop
{
	[pauseTimeLabel setHidden:NO];
	m_audioIsPaused = NO;
	[pauseTimeLabel setHidden:YES];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.4];	
	[m_pauseView setFrame:CGRectMake(0, -500, 320, 480)]; 
	[m_pauseView setAlpha:0];
	[UIView commitAnimations];
	
	[timerPause invalidate];
	timerPause = nil;
	[m_playerPause20 stop];
	[m_playerPause60 stop];
	
	secPause = 0;
	
	if ( audioStop )
	{
		if ( isPlay )
		{
			[m_appDelegate.m_coreAudio play];
		}
	}
}

- (void) pause:(BOOL)audioStop
{
	[pauseTimeLabel setHidden:NO];
}

- (IBAction) stop
{
	[self pause:YES];
 
	UIActionSheet *popupQuery = [[[UIActionSheet alloc] initWithTitle:nil
															delegate:self
												   cancelButtonTitle:@"Cancel"
											  destructiveButtonTitle:@"End Workout"
												   otherButtonTitles:nil] autorelease];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
}


- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
		[timerPause invalidate];
		timerPause = nil;
		[timer invalidate];
		timer = nil;
		[m_appDelegate.m_coreAudio stop];
	 
		if (m_player1.playing)
			[m_player1 stop];

		if (m_playerLeft30.playing)
			[m_playerLeft30 stop];
		
		if (m_playerLeft15.playing)
			[m_playerLeft15 stop];
		
		if (m_playerLeft10.playing)
			[m_playerLeft10 stop];
		
		if (m_playerPause20.playing)
			[m_playerPause20 stop];
		
		if (m_playerPause60.playing)
			[m_playerPause60 stop];
		
		if (m_playerEquipment.playing)
		{
			[m_playerEquipment stop];
		}
		
		m_appDelegate.isPlayBagMusic = NO;
		
		if (m_appDelegate.isBanerShowed)
		{
			[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
		}
		else
		{
			[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
		}
	}
	else if (buttonIndex == 1)
	{
		[self pause:NO];
	}
}

- (NSString *) second2minut:(float)time
{	
	float minutes = floor(time/60);
	float seconds = round(time - minutes * 60);
	if ( seconds < 10 )
	{
		return [NSString stringWithFormat:@"%0.0f.0%0.0f",minutes, seconds];
	}	
	return [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];  
}

#pragma mark -
#pragma mark - Audio
- (IBAction) playPause
{
	if ([m_appDelegate.m_coreAudio getAudioType] != 4)
	{
		if ([m_appDelegate.m_coreAudio isPlaying])
		{
			isPlay = NO;
			[m_appDelegate.m_coreAudio pause];
		}
		else
		{
			isPlay = YES;
			[m_appDelegate.m_coreAudio play];
		}
		
		m_audioName.text = [m_appDelegate.m_coreAudio getPlayingName];
		m_audioName2.text = [m_appDelegate.m_coreAudio getPlayingArtistName];
	}
}

- (IBAction) playNext
{
	if ([m_appDelegate.m_coreAudio getAudioType] != 4)
	{
		[m_appDelegate.m_coreAudio next];
		m_audioName.text = [m_appDelegate.m_coreAudio getPlayingName];
		m_audioName2.text = [m_appDelegate.m_coreAudio getPlayingArtistName];
	}
}

- (IBAction) playPlav
{
	if ([m_appDelegate.m_coreAudio getAudioType] != 4)
	{
		[m_appDelegate.m_coreAudio prev];
		m_audioName.text = [m_appDelegate.m_coreAudio getPlayingName];
		m_audioName2.text = [m_appDelegate.m_coreAudio getPlayingArtistName];
	}
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( alertView == m_iapAlertView )
	{
		if ( buttonIndex == 1 )
		{
			IAPMainViewController *viewController = [IAPMainViewController instance];
			[self.navigationController pushViewController:viewController animated:YES];
		}
		else if ( buttonIndex == 0 )
		{
			[self.navigationController popToRootViewControllerAnimated:YES];
		}
	}
}

#pragma mark -
#pragma mark - AVAudioPlayerDelegate
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	if ( [player isEqual:m_player1] )
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tic) userInfo:nil repeats:YES];
	}
	
	if ( [player isEqual:m_playerEnd] )
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:WorkOutFinishedNotification object:nil];
		
		[m_appDelegate.m_coreAudio stop];
		m_appDelegate.isPlayBagMusic = NO;
		[self.navigationController popViewControllerAnimated:YES];
	}
	
	if ( [player isEqual:m_playerEquipment] )
	{
		if ( currentEquipment < [equipmentArray count] - 1 )
		{
			currentEquipment++;
			[self playEquipment];
		}
		else
		{
			[self playSound];
		}
	}
	else
	{
		if ( isPlay == YES )
		{
			AudioSessionSetActive(0);
		}
	}
}

@end
