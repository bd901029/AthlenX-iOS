//
//  VCMain.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCMain.h"
#import "VCInfo.h"
#import "VCSettings.h"
#import "VCMealPlan.h"
#import "VCProgress.h"
#import "VCShuffleWorkout.h"
#import "VCWorkout.h"
#import "VCLockScreenMealPlan.h"
#import "VCMasterVault.h"
#import "AthleanXAppDelegate.h"
#import "LLNotificalionClass.h"
#import "VCCode.h"
#import "VCbigBaner.h"
#import "XMLReader.h"
#import "MKStoreManager.h"
#import "IAPMainViewController.h"


@implementation VCMain

+ (VCMain *) instance
{
	return [[[VCMain alloc] initWithNibName:NIB_NAME(@"VCMain") bundle:nil] autorelease];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// Custom initialization
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	[self.navigationController.navigationBar setHidden:YES];
	
	m_appDelegate = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	m_modelClass = [[ModelClass alloc] init];

	m_appDelegate.curentDay = [m_modelClass getCurrentTrDay];
	
	[m_modelClass getAllDays];
	
	[m_modelClass fixDB];

	[m_modelClass saveData:nil toArchive:@"bigBanerFirst"];
	
	if (![m_modelClass getDataFromArchive:@"bigBaner"])
	{
		[m_modelClass saveData:@"Yes" toArchive:@"bigBaner"];			
	}
	else
	{
		[m_modelClass saveData:nil toArchive:@"bigBaner"];
	}
	
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( storeManager.purchasedFullVersion || (storeManager.purchasedGroup1 && storeManager.purchasedGroup2) )
	{
		[m_celebrityBtn setEnabled:NO];
//		[m_celebrityBtn setAlpha:1];
	}
	
#if 0
	if ( [m_modelClass connectedToNetwork] )
	{
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			NSString *adXML = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://athleanonline.com/6pp/wsdl/getBanners.php"]
													   encoding:NSUTF8StringEncoding
														  error:nil];
			
			if ( ![[m_modelClass getDataFromArchive:@"xmlSHA1"] isEqual:[m_modelClass sha1:adXML]] )
			{
				[m_modelClass saveData:[m_modelClass sha1:adXML] toArchive:@"xmlSHA1"];
				
				NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[XMLReader dictionaryForXMLString:adXML error:nil]];
				if ( !dict )
					return;
				
				m_appDelegate.baner1URL = [dict valueForKeyPath:@"banners.banner1.t"];
				m_appDelegate.baner2URL = [dict valueForKeyPath:@"banners.banner2.t"];
				m_appDelegate.baner3URL = [dict valueForKeyPath:@"banners.banner3.t"];
				
				NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
				
				NSString *pngFilePath = [NSString stringWithFormat:@"%@/baner1.png", docDir];
				if ( [[NSFileManager defaultManager] fileExistsAtPath:pngFilePath] )
					[[NSFileManager defaultManager] removeItemAtPath:pngFilePath error:nil];
				NSString *bannerURL = [dict valueForKeyPath:@"banners.banner1.src"];
				if ( bannerURL )
				{
					NSData *data1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerURL]];
					[data1 writeToFile:pngFilePath atomically:YES];
				}
				
				NSString *pngFilePath2 = [NSString stringWithFormat:@"%@/baner2.png", docDir];
				if ( [[NSFileManager defaultManager] fileExistsAtPath:pngFilePath2] )
					[[NSFileManager defaultManager] removeItemAtPath:pngFilePath2 error:nil];
				NSString *bannerURL2 = [dict valueForKeyPath:@"banners.banner2.src"];
				if ( bannerURL2 )
				{
					NSData *data2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerURL2]];
					[data2 writeToFile:pngFilePath2 atomically:YES];
				}
				
				NSString *pngFilePath3 = [NSString stringWithFormat:@"%@/baner3.png", docDir];
				if ( [[NSFileManager defaultManager] fileExistsAtPath:pngFilePath3] )
					[[NSFileManager defaultManager] removeItemAtPath:pngFilePath3 error:nil];
				NSString *bannerURL3 = [dict valueForKeyPath:@"banners.banner3.src"];
				if ( bannerURL3 )
				{
					NSData *data3 = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerURL3]];
					[data3 writeToFile:pngFilePath3 atomically:YES];
				}
				
				[dict release];
			}
		});
	}
#endif
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	m_appDelegate.isBanerShowed = NO;
}

- (IBAction) startSixPackPromise
{
	[m_modelClass startDatePlistCreate];

	m_appDelegate.curentDay = [m_modelClass getCurrentTrDay];
	
	/// check IAP
	int currentDay = [[[[m_modelClass getDayByID:m_appDelegate.curentDay] objectAtIndex:0] valueForKey:@"training_Namber"] intValue];;
//	int currentDay = 29;
	MKStoreManager *mkManager = [MKStoreManager sharedManager];
	if ( currentDay > 5 && currentDay < 21 )
	{
		if ( !mkManager.purchasedGroup1 && !mkManager.purchasedFullVersion )
		{
			m_purchaseAlertView = [[[UIAlertView alloc] initWithTitle:@"Alert"
															  message:@"Please purchase the 6 Pack Plus Package or the 8 Pack Premium Package to continue."
															 delegate:self
													cancelButtonTitle:@"Close"
													otherButtonTitles:@"Unlock", nil] autorelease];
			[m_purchaseAlertView show];
			return;
			
			currentDay = 5;
		}
	}
	else if ( currentDay >= 21 )
	{
		if ( !mkManager.purchasedGroup2 && !mkManager.purchasedFullVersion )
		{
			m_purchaseAlertView = [[[UIAlertView alloc] initWithTitle:@"Alert"
															  message:@"Please purchase the 6 Pack Punisher Package or the 8 Pack Premium Package to continue."
															 delegate:self
													cancelButtonTitle:@"Close"
													otherButtonTitles:@"Unlock", nil] autorelease];
			[m_purchaseAlertView show];
			return;
			
			currentDay = 21;
		}
	}
	
	m_appDelegate.curTrainDayNumber = currentDay;
	
	if ( m_appDelegate.curTrainDayNumber != 0 )
	{
		if ( m_appDelegate.curentDay < 56 )
		{
			m_appDelegate.isSixPack = YES;
			VCWorkout *vc = [VCWorkout instance];
			[self.navigationController pushViewController:vc animated:YES];
		}
		else
		{
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
															message:@"All training is completed."
														   delegate:nil
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles: nil] autorelease];
			[alert show];
			return;
		}
	}
	else
	{
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@""
														message:@"No workout today, come back tomorrow"
													   delegate:nil
											  cancelButtonTitle:@"Ok"
											  otherButtonTitles:nil] autorelease];
		[alert show];
		return;
	}
}

- (IBAction) showInfo
{
	VCInfo *infoVC = [[[VCInfo alloc] init] autorelease];
//	[self presentViewController:infoVC animated:YES completion:nil];
	[self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction) showSettings
{
	if (![[m_modelClass isSendingEmail] isEqualToString:@"code"])
	{
		VCCode *settingsVC = [[[VCCode alloc] init] autorelease];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
	else
	{
		VCSettings *settingsVC = [VCSettings instance];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
}

- (IBAction) showMealPlan
{
//	MKStoreManager *storeManager = [MKStoreManager sharedManager];
//	if ( storeManager.purchasedGroup1 == NO && storeManager.purchasedFullVersion == NO )
//	{
//		VCLockScreenMealPlan *vc = [VCLockScreenMealPlan instance];
//		[self.navigationController pushViewController:vc animated:YES];
//		
//		AthleanXAppDelegate *delegate = [AthleanXAppDelegate sharedDelegate];
//		delegate.bIsShownLockedMealPlan = YES;
//		
//		return;
//	}
	
	VCMealPlan *vc = [VCMealPlan instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) showProgress
{
	VCProgress *vc = [VCProgress instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) shuffleWorkout
{
	if ( ![m_modelClass getDataFromArchive:@"dontShowEmail"] )
	{
		VCSettings *settingsVC = [VCSettings instance];
		[self.navigationController pushViewController:settingsVC animated:YES];
	}
	else
	{
#if 0
		if (![m_modelClass getDataFromArchive:@"bigBaner"] && ![m_modelClass getDataFromArchive:@"bigBanerFirst"])
		{
			VCbigBaner *bigBanerView = [[VCbigBaner new] autorelease];
			[self.navigationController pushViewController:bigBanerView animated:YES];
			[m_modelClass saveData:@"Yes" toArchive:@"bigBanerFirst"];
		}
		else
		{
			m_appDelegate.isSixPack = NO;		
			VCShuffleWorkout *shuffleWork = [[[VCShuffleWorkout alloc] init] autorelease];
			[self.navigationController pushViewController:shuffleWork animated:YES];
		}
#else
		VCbigBaner *bigBanerView = [VCbigBaner instance];
		[self.navigationController pushViewController:bigBanerView animated:YES];
		[m_modelClass saveData:@"Yes" toArchive:@"bigBanerFirst"];
#endif
	}
}

- (IBAction) masterVault
{
	VCMasterVault *vc = [VCMasterVault instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) celeratorClicked:(id)sender
{
	IAPMainViewController *viewController = [IAPMainViewController instance];
	[self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *selectedButtonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if ( alertView == m_purchaseAlertView )
	{
		if ( [selectedButtonTitle isEqualToString:@"Unlock"] )
		{
			IAPMainViewController *vc = [IAPMainViewController instance];
			[self.navigationController pushViewController:vc animated:YES];
		}
	}
}

@end
