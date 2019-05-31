//
//  VCShuffleWorkout.m
//  AthleanX
//
//  Created by Dmitriy on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCShuffleWorkout.h"
#import "VCWorkout.h"
#import "AthleanXAppDelegate.h"
#import "ExManager.h"
#import "MKStoreManager.h"
#import "IAPMainViewController.h"
#import "MLTableAlert.h"

@implementation VCShuffleWorkout

+ (VCShuffleWorkout *) instance
{
	return [[[VCShuffleWorkout alloc] initWithNibName:NIB_NAME(@"VCShuffleWorkout") bundle:nil] autorelease];
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

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
	m_appDelegate = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	
	m_appDelegate.isActiveShuffle = NO;
	
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	m_aryEquipTableCell = [[NSMutableArray alloc] init];
	for (int i = 0; i < EQUIPMENT_COUNT_MAX; i++)
	{
		NSString *equipment = [[ExManager allEquipmentName] objectAtIndex:i];
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];;
		cell.textLabel.text = equipment;
		if ( [equipment isEqualToString:@"No Equipment"] )
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		else if ( ([equipment isEqualToString:@"Chinup or Hanging Bar"] ||
				   [equipment isEqualToString:@"Resistance Band"] ||
				   [equipment isEqualToString:@"Physioball"]) &&
				 (!storeManager.purchasedGroup1 && !storeManager.purchasedFullVersion))
		{
			cell.userInteractionEnabled = NO;
			cell.textLabel.alpha = 0.5;
		}
		
		[m_aryEquipTableCell addObject:cell];
	}
	
	if ( !storeManager.purchasedFullVersion && !storeManager.purchasedGroup1 && !m_appDelegate.bIsShownLockedEquipment )
	{
		m_purchaseEquipAlert = [[[UIAlertView alloc] initWithTitle:@"Equipment Selection"
														  message:@"Some features are locked. Purchase the 6 Pack PLUS Package in order to unlock the equipment selection fully!"
														 delegate:self
												cancelButtonTitle:@"Later"
												 otherButtonTitles:@"Unlock", nil] autorelease];
		[m_purchaseEquipAlert show];
		m_appDelegate.bIsShownLockedEquipment = YES;
	}
	else
	{
		[self showEquipmentAlert];
	}
}

- (IBAction) basixLevel
{
	m_appDelegate.shuffleType = @"BASIX LEVEL";

	[m_progressView setHidden:NO];
	[m_progressView startAnimating];
	
	[NSThread detachNewThreadSelector:@selector(gotoWorkout) toTarget:self withObject:nil];
}

- (IBAction) nextLevel
{
	m_appDelegate.shuffleType = @"NEXT LEVEL";
	
	[m_progressView setHidden:NO];
	[m_progressView startAnimating];
	
	[NSThread detachNewThreadSelector:@selector(gotoWorkout) toTarget:self withObject:nil];
}

- (IBAction) maxLevel
{
	m_appDelegate.shuffleType = @"MAX LEVEL";
	
	[m_progressView setHidden:NO];
	[m_progressView startAnimating];
	
	[NSThread detachNewThreadSelector:@selector(gotoWorkout) toTarget:self withObject:nil];
}

- (IBAction) xTremeLevel
{
	m_appDelegate.shuffleType = @"X-TREME LEVEL";
	
	[m_progressView setHidden:NO];
	[m_progressView startAnimating];
	
	[NSThread detachNewThreadSelector:@selector(gotoWorkout) toTarget:self withObject:nil];
}

- (void) gotoWorkout
{
	[m_progressView stopAnimating];
	[m_progressView setHidden:YES];
	
	VCWorkout *vc = [VCWorkout instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (IBAction) back
{
	[self.navigationController popToRootViewControllerAnimated:YES];
	//[self.navigationController popViewControllerAnimated:YES];
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

#if 0
#pragma mark - SBTableAlertDataSource
- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [m_aryEquipTableCell objectAtIndex:indexPath.row];
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section
{
	return [ExManager allEquipmentName].count;
}

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert
{
	return 1;
}

- (NSString *)tableAlert:(SBTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section
{
	return nil;
}

#pragma mark - SBTableAlertDelegate
- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableAlert.type == SBTableAlertTypeMultipleSelct)
	{
		UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:indexPath];
		if ( ![cell.textLabel.text isEqualToString:@"No Equipment"] )
		{
			if (cell.accessoryType == UITableViewCellAccessoryNone)
				[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
			else
				[cell setAccessoryType:UITableViewCellAccessoryNone];
		}
		else
		{
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}
		
		[tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [tableAlert.view buttonTitleAtIndex:buttonIndex];
	if ( [buttonTitle isEqualToString:@"OK"] )
	{
		NSMutableArray *arySelectedEquipment = [NSMutableArray arrayWithCapacity:0];
		for (int i = 0; i < EQUIPMENT_COUNT_MAX; i++)
		{
			UITableViewCell *cell = [m_aryEquipTableCell objectAtIndex:i];
			if ( cell.accessoryType == UITableViewCellAccessoryCheckmark )
			{
				NSString *equipName = [[ExManager allEquipmentName] objectAtIndex:i];
				[arySelectedEquipment addObject:equipName];
			}
		}
		
		ExManager *exManager = [ExManager sharedExManager];
		[exManager setEquipment:arySelectedEquipment];
	}
	else if ( [buttonTitle isEqualToString:@"Cancel"] )
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	
	[tableAlert release];
}
#endif

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
	if ( alertView == m_purchaseEquipAlert )
	{
		if ( [buttonTitle isEqualToString:@"Unlock"] )
		{
			IAPMainViewController *vc = [IAPMainViewController instance];
			[self.navigationController pushViewController:vc animated:YES];
		}
		else
		{
#if 0
			m_selectEquipAlert = [[SBTableAlert alloc] initWithTitle:@"Select Shuffle Equipment"
												   cancelButtonTitle:@"Cancel"
													   messageFormat:nil];
			[m_selectEquipAlert setType:SBTableAlertTypeMultipleSelct];
			[m_selectEquipAlert.view addButtonWithTitle:@"OK"];
			[m_selectEquipAlert setDelegate:self];
			[m_selectEquipAlert setDataSource:self];
			[m_selectEquipAlert show];
#else
			[self showEquipmentAlert];
#endif
		}
	}
}

- (void) showEquipmentAlert
{
	m_selectEquipAlert = [MLTableAlert instanceWithTitle:@"Select Shuffle Equipment"
											  tableCells:m_aryEquipTableCell];
	m_selectEquipAlert.delegate = self;
	// Setting custom alert height
	m_selectEquipAlert.height = 350;
	
	// configure actions to perform
	[m_selectEquipAlert configureSelectionBlock:^(NSIndexPath *selectedIndex){
		//				self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
	} andCompletionBlock:^{
		//				self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
	}];
	
	// show the alert
	[m_selectEquipAlert show];
}

#pragma mark - MLTableAlert
- (void) mlTableAlertViewSelected:(MLTableAlert *)alertView
{
	if ( alertView == m_selectEquipAlert )
	{
		NSMutableArray *arySelectedEquipment = [NSMutableArray arrayWithCapacity:0];
		for (int i = 0; i < EQUIPMENT_COUNT_MAX; i++)
		{
			UITableViewCell *cell = [m_aryEquipTableCell objectAtIndex:i];
			if ( cell.accessoryType == UITableViewCellAccessoryCheckmark )
			{
				NSString *equipName = [[ExManager allEquipmentName] objectAtIndex:i];
				[arySelectedEquipment addObject:equipName];
			}
		}
		
		ExManager *exManager = [ExManager sharedExManager];
		[exManager setEquipment:arySelectedEquipment];
	}
}

- (void) mlTableAlertViewCancelled:(MLTableAlert *)alertView
{
	if ( alertView == m_selectEquipAlert )
	{
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

@end
