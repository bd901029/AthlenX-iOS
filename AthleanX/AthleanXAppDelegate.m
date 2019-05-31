//
//  AthleanXAppDelegate.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AthleanXAppDelegate.h"
#import "CoreAudio.h"
#import "VCIntro.h"
#import "VCMain.h"

@implementation AthleanXAppDelegate

@synthesize curentDay, curentWeek, curentDate, curTrainDayNumber, isSixPack, shuffleType, m_coreAudio, isDoWorkout, isPlayBagMusic, isAudioSession, isActiveShuffle, tempTrArray, isBanerShowed, baner1URL, baner2URL, baner3URL;
@synthesize freeCredit = m_freeCredit;
@synthesize orientationMask = m_orientationMask;
@synthesize bIsCanceledSync = m_bIsCanceledSync;
@synthesize bIsShownLockedMealPlan = m_bIsShownLockedMealPlan;
@synthesize bIsShownLockedEquipment = m_bIsShownLockedEquip;

+ (id) sharedDelegate
{
	return (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
}

#if 1
- (void) test
{
	NSArray *activityItems;
	
	if ( self.isSixPack )
	{
		NSString *string = [NSString stringWithFormat:@"I've completed a day workout in 6 Pack Promise. Check it out here!"];
		NSString *url = @"https://itunes.apple.com/us/app/6-pack-promise/id476702710?mt=8";
		activityItems = @[string, url];
	}
	else
	{
		NSString *string = [NSString stringWithFormat:@"I've completed day %i of the 6 Pack Promise. Check it out here!", self.curentDay];
		NSString *url = @"https://itunes.apple.com/us/app/6-pack-promise/id476702710?mt=8";
		activityItems = @[string, url];
	}
	
	UIActivityViewController *activityVC = [[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil] autorelease];
	activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypePostToWeibo, UIActivityTypeMessage];
	
	int activityCount = [[[[[activityVC.view.subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews] count];
	//	if ( IS_IOS7 )
	//		activityCount = [[[[[activityVC.view.subviews objectAtIndex:0] subviews] objectAtIndex:1] subviews] count];
	
#if 1
	for (UIView *view in [[[[activityVC.view.subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews])
	{
		NSLog(@"view = %@", view);
	}
#endif
}

#endif

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	curentDay = 0;
	curentWeek = 1;
	
	curTrainDayNumber = -1;
	
	curentDate = 40;
	
	isSixPack = FALSE;
	
	shuffleType = [[NSString alloc] init];
	
	m_coreAudio = [[CoreAudio alloc] init];
	
	[m_coreAudio stop];
	
	isBanerShowed = NO;
	
	isDoWorkout = NO;
	
	isPlayBagMusic = NO;
	isAudioSession = NO;
	
	isActiveShuffle = NO;
	tempTrArray = [[NSMutableArray alloc] init];
	
	if (![m_coreAudio getAudioType]) {
		[m_coreAudio saveAudioType:4];
	}
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	int credit = [defaults integerForKey:@"Free Credit"];
	if ( credit == 0 )
		m_freeCredit = 30;
	else
		m_freeCredit = credit;
	
	m_bIsCanceledSync = NO;
	m_bIsShownLockedMealPlan = NO;
	m_bIsShownLockedEquip = NO;
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
	VCMain *vc = [VCMain instance];
	self.navigationController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
	
	// Override point for customization after application launch.
	// Add the navigation controller's view to the window and display.
	self.window.rootViewController = self.navigationController;
	[self.window makeKeyAndVisible];
	
	self.orientationMask = UIInterfaceOrientationMaskPortrait;
	
	if ( IS_IOS7 )
	{
		vc.edgesForExtendedLayout = UIRectEdgeNone;
		
		CGRect frame = self.window.bounds;
		frame.origin.y -= 20;
		self.window.bounds = frame;
	}
	
	VCIntro *intro = [VCIntro instance];
//	[self.navigationController presentViewController:intro animated:YES completion:nil];
	[self.navigationController pushViewController:intro animated:NO];
	
//	[self test];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	/*
	 Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	 Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	 */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	/*
	 Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	 If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	 */
	
	[m_coreAudio pause];
	
	m_bIsCanceledSync = NO;
	m_bIsShownLockedEquip = NO;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	if ( isPlayBagMusic )
	{
		[m_coreAudio play];
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	/*
	 Called when the application is about to terminate.
	 Save data if appropriate.
	 See also applicationDidEnterBackground:.
	 */
}

- (void)dealloc
{
	[m_coreAudio release];
	[_window release];
	[_navigationController release];
	[super dealloc];
}

- (void) saveFreeCreditCount
{
	if ( m_freeCredit == 0 )
		m_freeCredit = -1;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:m_freeCredit forKey:@"Free Credit"];
	[defaults synchronize];
}

@end
