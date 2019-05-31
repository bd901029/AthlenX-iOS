//
//  VCWorkout.m
//  AthleanX
//
//  Created by Dmitriy on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCWorkout.h"
#import "VCSetMusic.h"
#import "VCSamle.h"
#import "VCDoWorkout.h"
#import "AthleanXAppDelegate.h"
#import "VCAnatomySample.h"
#import "VCDisclamer.h"
#import "AthleanXAppDelegate.h"
#import "ExManager.h"
#import "MKStoreManager.h"
#import "IAPMainViewController.h"
#import "ExManager.h"
#import "SampleViewController.h"

@interface VCWorkout ()
{
	NSMutableArray *m_aryTableCell;
}

@end

@implementation VCWorkout

+ (VCWorkout *) instance
{
	return [[[VCWorkout alloc] initWithNibName:NIB_NAME(@"VCWorkout") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self)
	{
		// Custom initialization
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (void) didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void) viewDidLoad
{
	[super viewDidLoad];
	
	m_appDelegate = [AthleanXAppDelegate sharedDelegate];
	m_modelClass = [[ModelClass alloc] init];
	m_aryShuffleTr = [[NSMutableArray alloc] init];

	if (m_appDelegate.isSixPack)
	{
		[m_dayNumberLabel setText:[NSString stringWithFormat:@"DAY %i", m_appDelegate.curTrainDayNumber]];
		[m_shuffleBtn setHidden:YES];
		m_training = [[NSTraining alloc] initWithArray:[m_modelClass getTrainingByDay:m_appDelegate.curTrainDayNumber]];
	}
	else
	{
		[m_dayNumberLabel setText:[NSString stringWithFormat:@"%@ SHUFFLE RESULTS", m_appDelegate.shuffleType]];
		[m_shuffleBtn setHidden:NO];
		
		if (m_appDelegate.isActiveShuffle)
		{
			m_aryShuffleTr = [[NSMutableArray arrayWithArray:m_appDelegate.tempTrArray] retain];
		}
		else
		{
			if ([m_appDelegate.shuffleType isEqual:@"BASIX LEVEL"])
			{
				m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForBasic]] retain];
			}
			if ([m_appDelegate.shuffleType isEqual:@"NEXT LEVEL"])
			{
				m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForNext]] retain];
			}
			if ([m_appDelegate.shuffleType isEqual:@"MAX LEVEL"])
			{
				m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForMax]] retain];
			}
			if ([m_appDelegate.shuffleType isEqual:@"X-TREME LEVEL"])
			{
				m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForXTreme]] retain];
			}
			
			if ( !m_aryShuffleTr || m_aryShuffleTr.count == 0 )
			{
				m_noTrainToMatchAlert = [[[UIAlertView alloc] initWithTitle:@"Error"
																   message:@"There is no training matched."
																  delegate:self
														 cancelButtonTitle:@"OK"
														  otherButtonTitles:nil] autorelease];
				[m_noTrainToMatchAlert show];
				return;
			}

			m_appDelegate.tempTrArray = [NSMutableArray arrayWithArray:m_aryShuffleTr];
			
			m_appDelegate.isActiveShuffle = YES;
		}

		m_training = [[NSTraining alloc] initWithArray:m_aryShuffleTr];
	}

	[m_training load];
	
	[m_exDurationTime setText:[NSString stringWithFormat:@"TOTAL WORKOUT TIME: %@",[m_modelClass second2minut:[m_training getTrainingDuration]]]];
	
	m_aryTimes = [[NSArray alloc] initWithArray:[m_training getTimeArr]];
	m_aryNames = [[NSArray alloc] initWithArray:[m_training getNameArr]];
	m_aryIds = [[NSArray alloc] initWithArray:[m_training getM_aryId]];
	m_aryAnatomyCode = [[NSArray alloc] initWithArray:[m_training getM_aryAnatomyCode]];
	
	[m_bragBtn setHidden:YES];
	[m_closeBtn setHidden:YES];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(workOutFinished:) name:WorkOutFinishedNotification object:nil];
	
	m_aryTableCell = [[NSMutableArray alloc] init];
	for (int i = 0; i < m_aryNames.count; i++)
	{
		int index = m_aryTableCell.count;
		UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(10, 14, 37, 32)] autorelease];
		
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		UIView *cellView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		
		UILabel *cellTitle = [[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 230, 25)] autorelease];
		UILabel *cellTitleDetal = [[[UILabel alloc] initWithFrame:CGRectMake(60, 40, 230, 10)] autorelease];
		
		UIImageView *imgBGR = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		[imgBGR setImage:[UIImage imageNamed:@"rowBRG.png"]];
		
		[btn setImage:[UIImage imageNamed:@"viedeoMark.png"] forState:UIControlStateNormal];
		btn.tag = index;
		[btn addTarget:self action:@selector(videoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		UIImageView *imgVideoMark = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 37, 32)] autorelease];
		[imgVideoMark setImage:[UIImage imageNamed:@"viedeoMark.png"]];
		
		UIImageView *imgRedMark = [[[UIImageView alloc] initWithFrame:CGRectMake(300, 23, 12, 14)] autorelease];
		[imgRedMark setImage:[UIImage imageNamed:@"redMark.png"]];
		
		[cellTitle setText:[m_aryNames objectAtIndex:index]];
		[cellTitleDetal setText:[NSString stringWithFormat:@"%@ seconds", [m_aryTimes objectAtIndex:index]]];
		
		[cellTitleDetal setTextColor:[UIColor whiteColor]];
		[cellTitleDetal setBackgroundColor:[UIColor clearColor]];
		[cellTitleDetal setFont:[UIFont systemFontOfSize:12]];
		cellTitleDetal.numberOfLines = 1;
		[cellTitleDetal setTextAlignment:NSTextAlignmentCenter];
		
		[cellTitle setTextColor:[UIColor whiteColor]];
		[cellTitle setBackgroundColor:[UIColor clearColor]];
		[cellTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
		cellTitle.numberOfLines = 1;
		[cellTitle setTextAlignment:NSTextAlignmentCenter];
		
		[cellView addSubview:imgBGR];
		[cellView addSubview:imgRedMark];
		[cellView addSubview:cellTitleDetal];
		[cellView addSubview:cellTitle];
		
		[cell.contentView addSubview:nil];
		
		for ( UIButton *btn1 in [cell.contentView subviews] )
		{
			[btn1 removeFromSuperview];
		}
		
		if ( [[m_aryIds objectAtIndex:index] intValue] > 0 )
		{
			[cell.contentView addSubview:btn];
		}
		else
		{
			
		}
		
		cell.backgroundView = cellView;
		
		[m_aryTableCell addObject:cell];
	}
	
	[m_traningTableView reloadData];
	
	[m_progressView stopAnimating];
}

- (void) viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	if ( m_appDelegate.isSixPack && ![m_modelClass getDataFromArchive:@"6Pack"] && m_bShownDisclamer == NO )
	{
		m_bShownDisclamer = YES;
		
		VCDisclamer *vc = [VCDisclamer instance];
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	m_appDelegate.isDoWorkout = NO;
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
    return UIInterfaceOrientationPortrait;
}

- (void) videoBtnClicked:(UIButton *)btn
{
	if ([[m_aryIds objectAtIndex:btn.tag] intValue] != -1)
	{
		NSURL *sampleURL = [m_modelClass sampleVideoURLWithID:[m_aryIds[btn.tag] intValue]];
		SampleViewController *viewController = [SampleViewController sampleViewControllerWithURL:sampleURL];
		[self.navigationController pushViewController:viewController animated:YES];
	}
}

- (void) showProgressView
{
//	dispatch_async(kBgQueue, ^{
		[m_progressView setHidden:NO];
		[m_progressView startAnimating];
//	});
}

- (void) hideProgressView
{
//	dispatch_async(kBgQueue, ^{
		[m_progressView stopAnimating];
//	});
}

- (IBAction) reshuffle
{
	[NSThread detachNewThreadSelector:@selector(showProgressView) toTarget:self withObject:nil];
	
	m_training = nil;
	[m_training release];
	[m_aryTimes release];
	[m_aryNames release];
	[m_aryIds release];
	[m_aryAnatomyCode release];
	
	if ([m_appDelegate.shuffleType isEqual:@"BASIX LEVEL"])
	{
		m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForBasic]] retain];
	}
	
	if ([m_appDelegate.shuffleType isEqual:@"NEXT LEVEL"])
	{
		m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForNext]] retain];
	}
	
	if ([m_appDelegate.shuffleType isEqual:@"MAX LEVEL"])
	{
		m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForMax]] retain];
	}
	
	if ([m_appDelegate.shuffleType isEqual:@"X-TREME LEVEL"])
	{
		m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass generateTraningForXTreme]] retain];
	}
	
	if ( !m_aryShuffleTr || m_aryShuffleTr.count == 0 )
	{
		m_noTrainToMatchAlert = [[[UIAlertView alloc] initWithTitle:@"Error"
															message:@"There is no training matched."
														   delegate:self
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil] autorelease];
		[m_noTrainToMatchAlert show];
		return;
	}
	
	m_appDelegate.tempTrArray = [NSMutableArray arrayWithArray:m_aryShuffleTr];
	
	m_training = [[NSTraining alloc] initWithArray:m_aryShuffleTr];
	
	[m_training load];
	
	[m_exDurationTime setText:[NSString stringWithFormat:@"TOTAL WORKOUT TIME: %@",[m_modelClass second2minut:[m_training getTrainingDuration]]]];
	
	m_aryTimes = [[NSArray alloc] initWithArray:[m_training getTimeArr]];
	m_aryNames = [[NSArray alloc] initWithArray:[m_training getNameArr]];
	m_aryIds = [[NSArray alloc] initWithArray:[m_training getM_aryId]];
	m_aryAnatomyCode = [[NSArray alloc] initWithArray:[m_training getM_aryAnatomyCode]];
	
#if 1
	if ( m_aryTableCell )
		[m_aryTableCell release];
	m_aryTableCell = [[NSMutableArray alloc] init];
	for (int i = 0; i < m_aryNames.count; i++)
	{
		int index = m_aryTableCell.count;
		UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(10, 14, 37, 32)] autorelease];
		
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
		
		UIView *cellView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		
		UILabel *cellTitle = [[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 230, 25)] autorelease];
		UILabel *cellTitleDetal = [[[UILabel alloc] initWithFrame:CGRectMake(60, 40, 230, 10)] autorelease];
		
		UIImageView *imgBGR = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
		[imgBGR setImage:[UIImage imageNamed:@"rowBRG.png"]];
		
		[btn setImage:[UIImage imageNamed:@"viedeoMark.png"] forState:UIControlStateNormal];
		btn.tag = index;
		[btn addTarget:self action:@selector(videoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
		
		UIImageView *imgVideoMark = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 37, 32)] autorelease];
		[imgVideoMark setImage:[UIImage imageNamed:@"viedeoMark.png"]];
		
		UIImageView *imgRedMark = [[[UIImageView alloc] initWithFrame:CGRectMake(300, 23, 12, 14)] autorelease];
		[imgRedMark setImage:[UIImage imageNamed:@"redMark.png"]];
		
		[cellTitle setText:[m_aryNames objectAtIndex:index]];
		[cellTitleDetal setText:[NSString stringWithFormat:@"%@ seconds", [m_aryTimes objectAtIndex:index]]];
		
		[cellTitleDetal setTextColor:[UIColor whiteColor]];
		[cellTitleDetal setBackgroundColor:[UIColor clearColor]];
		[cellTitleDetal setFont:[UIFont systemFontOfSize:12]];
		cellTitleDetal.numberOfLines = 1;
		[cellTitleDetal setTextAlignment:NSTextAlignmentCenter];
		
		[cellTitle setTextColor:[UIColor whiteColor]];
		[cellTitle setBackgroundColor:[UIColor clearColor]];
		[cellTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
		cellTitle.numberOfLines = 1;
		[cellTitle setTextAlignment:NSTextAlignmentCenter];
		
		[cellView addSubview:imgBGR];
		[cellView addSubview:imgRedMark];
		[cellView addSubview:cellTitleDetal];
		[cellView addSubview:cellTitle];
		
		[cell.contentView addSubview:nil];
		
		for ( UIButton *btn1 in [cell.contentView subviews] )
		{
			[btn1 removeFromSuperview];
		}
		
		if ( [[m_aryIds objectAtIndex:index] intValue] > 0 )
		{
			[cell.contentView addSubview:btn];
		}
		else
		{
			
		}
		
		cell.backgroundView = cellView;
		
		[m_aryTableCell addObject:cell];
	}
	
#endif
	[m_traningTableView reloadData];
	
	[NSThread detachNewThreadSelector:@selector(hideProgressView) toTarget:self withObject:nil];
}

- (IBAction) setMusic
{
	if (m_appDelegate.isSixPack)
	{
		m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass getTrainingByDay:m_appDelegate.curTrainDayNumber]] retain];
		VCSetMusic *setMusik = [[VCSetMusic alloc] initWithArray:m_aryShuffleTr];
		[self.navigationController pushViewController:setMusik animated:YES];
		[setMusik release];		
	}
	else
	{
		VCSetMusic *setMusik = [[VCSetMusic alloc] initWithArray:m_aryShuffleTr];
		[self.navigationController pushViewController:setMusik animated:YES];
		[setMusik release];
	}
}

- (IBAction) onStartBtnClicked
{
	m_appDelegate.isDoWorkout = YES;
	m_appDelegate.isPlayBagMusic = YES;
	m_appDelegate.isAudioSession = YES;
	
	if (m_appDelegate.isSixPack)
	{
		m_aryShuffleTr = [[NSMutableArray arrayWithArray:[m_modelClass getTrainingByDay:m_appDelegate.curTrainDayNumber]] retain];
		
		VCDoWorkout *vc = [[[VCDoWorkout alloc] initWithArray:m_aryShuffleTr] autorelease];
		[self.navigationController pushViewController:vc animated:YES];
	}
	else
	{
		VCDoWorkout *doWorkout = [[[VCDoWorkout alloc] initWithArray:m_aryShuffleTr] autorelease];
		[self.navigationController pushViewController:doWorkout animated:YES];
	}
}

- (IBAction) onBackBtnClicked
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction) bragBtnClicked:(id)sender
{
	NSArray *activityItems;
	
	if ( m_appDelegate.isSixPack )
	{
		NSString *string = [NSString stringWithFormat:@"I've completed a day workout in 6 Pack Promise. Check it out here!"];
		NSString *url = @"https://itunes.apple.com/us/app/6-pack-promise/id476702710?mt=8";
		activityItems = @[string, url];
	}
	else
	{
		NSString *string = [NSString stringWithFormat:@"I've completed day %i of the 6 Pack Promise. Check it out here!", m_appDelegate.curentDay];
		NSString *url = @"https://itunes.apple.com/us/app/6-pack-promise/id476702710?mt=8";
		activityItems = @[string, url];
	}
	
	UIActivityViewController *activityVC = [[[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil] autorelease];
	activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMail, UIActivityTypePostToWeibo, UIActivityTypeMessage];

	if ( !IS_IOS7 )
	{
		int activityCount = [[[[[activityVC.view.subviews objectAtIndex:0] subviews] objectAtIndex:0] subviews] count];
		if ( activityCount <= 0 )
		{
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Notice"
																 message:@"In order to use this feature, please link your device to Facebook or Twitter through the device settings."
																delegate:nil
													   cancelButtonTitle:@"Okay"
													   otherButtonTitles:nil] autorelease];
			[alertView show];
			return;
		}
	}
	else
	{
		if ( [self existingAvailableActivity:activityVC.view] != YES )
		{
			UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Notice"
																 message:@"In order to use this feature, please link your device to Facebook or Twitter through the device settings."
																delegate:nil
													   cancelButtonTitle:@"Okay"
													   otherButtonTitles:nil] autorelease];
			[alertView show];
			return;
		}
	}
	
	
	[self presentViewController:activityVC animated:YES completion:nil];
}

- (BOOL) existingAvailableActivity:(UIView *)view
{
	if ( [view isKindOfClass:[UICollectionView class]] )
	{
		UICollectionView *collectionView = (UICollectionView *)view;
		int count = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:0];
		if ( count >= 1 )
			return YES;
	}
	
	if ( view.subviews.count == 0 )
	{
		return NO;
	}
	
	for (UIView *subView in view.subviews)
	{
		if ([self existingAvailableActivity:subView] == YES)
			return YES;
	}
	
	return NO;
}

- (void) workOutFinished:(NSNotification *)notification
{
	[m_bragBtn setHidden:NO];
	[m_closeBtn setHidden:NO];
	
	[m_startBtn setHidden:YES];
	[m_setMusicBtn setHidden:YES];
}

- (IBAction) closeBtnClicked:(id)sender
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([[m_aryIds objectAtIndex:indexPath.row] intValue] != -1)
	{
#if 0
		ExManager *exManager = [ExManager sharedExManager];
		BOOL isFree = [exManager isFreeWithName:[m_aryNames objectAtIndex:indexPath.row]];
		if ( isFree )
		{
			VCAnatomySample *anatomySampleView = [[VCAnatomySample alloc] initWithCode:[[m_aryAnatomyCode objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
			[self presentModalViewController:anatomySampleView animated:YES];
			[anatomySampleView release];
		}
		else
		{
			m_iapAlertView = [[[UIAlertView alloc] initWithTitle:@"Sorry"
														 message:@"Please Perchase Current Excercise."
														delegate:self
											   cancelButtonTitle:@"Later"
											   otherButtonTitles:@"Yes, Now", nil] autorelease];
			[m_iapAlertView show];
		}
#else
		VCAnatomySample *anatomySampleView = [[[VCAnatomySample alloc] initWithCode:[[m_aryAnatomyCode objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] autorelease];
//		[self presentViewController:anatomySampleView animated:YES completion:nil];
		[self.navigationController pushViewController:anatomySampleView animated:YES];
#endif
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	return [m_aryNames count];
	return m_aryTableCell.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 1
	return [m_aryTableCell objectAtIndex:indexPath.row];
#else
	static NSString *CellIdentifier = @"Cell";
	
	UIButton *btn = [[[UIButton alloc] initWithFrame:CGRectMake(10, 14, 37, 32)] autorelease];
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
	}
	
	UIView *cellView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
	
	UILabel *cellTitle = [[[UILabel alloc] initWithFrame:CGRectMake(60, 15, 230, 25)] autorelease];
	UILabel *cellTitleDetal = [[[UILabel alloc] initWithFrame:CGRectMake(60, 40, 230, 10)] autorelease];
	
	UIImageView *imgBGR = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)] autorelease];
	[imgBGR setImage:[UIImage imageNamed:@"rowBRG.png"]];
	
	[btn setImage:[UIImage imageNamed:@"viedeoMark.png"] forState:UIControlStateNormal];
	btn.tag = indexPath.row;
	[btn addTarget:self action:@selector(videoBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	UIImageView *imgVideoMark = [[[UIImageView alloc] initWithFrame:CGRectMake(10, 14, 37, 32)] autorelease];
	[imgVideoMark setImage:[UIImage imageNamed:@"viedeoMark.png"]];
	
	UIImageView *imgRedMark = [[[UIImageView alloc] initWithFrame:CGRectMake(300, 23, 12, 14)] autorelease];
	[imgRedMark setImage:[UIImage imageNamed:@"redMark.png"]];
	
	[cellTitle setText:[m_aryNames objectAtIndex:indexPath.row]];
	[cellTitleDetal setText:[NSString stringWithFormat:@"%@ seconds", [m_aryTimes objectAtIndex:indexPath.row]]];
	
	[cellTitleDetal setTextColor:[UIColor whiteColor]];
	[cellTitleDetal setBackgroundColor:[UIColor clearColor]];
	[cellTitleDetal setFont:[UIFont systemFontOfSize:12]];
	cellTitleDetal.numberOfLines = 1;
	[cellTitleDetal setTextAlignment:UITextAlignmentCenter];
	
	[cellTitle setTextColor:[UIColor whiteColor]];
	[cellTitle setBackgroundColor:[UIColor clearColor]];
	[cellTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
	cellTitle.numberOfLines = 1;
	[cellTitle setTextAlignment:UITextAlignmentCenter];
	
	[cellView addSubview:imgBGR];
	[cellView addSubview:imgRedMark];
	[cellView addSubview:cellTitleDetal];
	[cellView addSubview:cellTitle];
	
	[cell.contentView addSubview:nil];
	
	for ( UIButton *btn1 in [cell.contentView subviews] )
	{
		[btn1 removeFromSuperview];
	}
	
	if ( [[m_aryIds objectAtIndex:indexPath.row] intValue] > 0 )
	{
		[cell.contentView addSubview:btn];
	}
	else
	{
		
	}
	
	cell.backgroundView = cellView;
	
	return cell;
#endif
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ( alertView == m_iapAlertView )
	{
		if ( buttonIndex == 1 )
		{
			IAPMainViewController *vc = [IAPMainViewController instance];
			[self.navigationController pushViewController:vc animated:YES];
		}
	}
	
	if ( alertView == m_noTrainToMatchAlert )
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

@end
