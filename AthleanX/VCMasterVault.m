//
//  VCMasterVault.m
//  AthleanX
//
//  Created by Dmitriy on 23.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCMasterVault.h"
#import "VCSamle.h"
#import "VCRedeemAd.h"
#import "VCPurchaseAd.h"
#import "IAPPerchaseViewController.h"
#import "SampleViewController.h"
#import "ExManager.h"

@implementation VCMasterVault

+ (VCMasterVault *) instance
{
    return [[[VCMasterVault alloc] initWithNibName:NIB_NAME(@"VCMasterVault") bundle:nil] autorelease];
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

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[m_remainingPointsLabel setText:[NSString stringWithFormat:@"%i POINTS", [m_modelClass getPTS]]];
}

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	m_modelClass = [[ModelClass alloc] init];  
	
	m_aryMasterVault = [[NSMutableArray alloc] initWithArray:[m_modelClass getAllEx]];

	[m_remainingPointsLabel setText:[NSString stringWithFormat:@"%i POINTS",[m_modelClass getPTS]]];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [m_aryMasterVault count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	ExManager *exManager = [ExManager sharedExManager];
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];				 
	}	

	UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
	
	UILabel *cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(41, 18, 235, 25)];

	UIImageView *imgBGR = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
	[imgBGR setImage:[UIImage imageNamed:@"rowBRG.png"]];
	
	UIImageView *imgPTSMark = [[UIImageView alloc] initWithFrame:CGRectMake(278, 14, 40, 32)];	
	
	UIImageView *imgLockedMark = [[UIImageView alloc] initWithFrame:CGRectMake(2, 14, 37, 32)]; 
	
	NSDictionary *dict = [m_aryMasterVault objectAtIndex:indexPath.row];
	NSNumber *exID = [dict valueForKey:@"ID"];
	if ( ![exManager isFreeWithNo:exID.integerValue] )
	{
	   [imgLockedMark setImage:[UIImage imageNamed:@"MV_locked_Lable.png"]]; 
		
		int point = [[[m_aryMasterVault objectAtIndex:indexPath.row] valueForKey:@"PTS"] integerValue];
		
		if ( point == 1 )
		{
			[imgPTSMark setImage:[UIImage imageNamed:@"MV_1pts.png"]]; 
		}
		
		if ( point == 2 )
		{
			[imgPTSMark setImage:[UIImage imageNamed:@"MV_2pts.png"]]; 
		}
		
		if ( point == 3 )
		{
			[imgPTSMark setImage:[UIImage imageNamed:@"MV_3pts.png"]]; 
		}
		
		if ( point == 4 )
		{
			[imgPTSMark setImage:[UIImage imageNamed:@"MV_4pts.png"]]; 
		}
		
		if ( point == 5 )
		{
			[imgPTSMark setImage:[UIImage imageNamed:@"MV_5pts.png"]]; 
		}
	}

	if ( [exManager isFreeWithNo:exID.integerValue] )
	{
		[imgLockedMark setImage:[UIImage imageNamed:@"MV_unlocked_Lable.png"]];
	}	
			   
	[cellTitle setText:[[m_aryMasterVault objectAtIndex:indexPath.row] valueForKey:@"NAME"]];

	[cellTitle setTextColor:[UIColor whiteColor]];
	[cellTitle setBackgroundColor:[UIColor clearColor]];
	[cellTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
	cellTitle.numberOfLines = 1;
	[cellTitle setTextAlignment:NSTextAlignmentCenter];

	[cellView addSubview:imgBGR];
	[cellView addSubview:imgLockedMark];
	[cellView addSubview:imgPTSMark];
	[cellView addSubview:cellTitle];
	
	cell.backgroundView = cellView;
	
	[cellTitle release];
	[imgLockedMark release];
	[imgPTSMark release];
	
	[cellView release];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	ExManager *exManager = [ExManager sharedExManager];
	
	NSDictionary *dict = [m_aryMasterVault objectAtIndex:indexPath.row];
	NSNumber *exID = [dict valueForKey:@"ID"];
	
	if ( [exManager isFreeWithNo:exID.integerValue] )
	{
		NSURL *sampleURL = [m_modelClass sampleVideoURLWithID:indexPath.row+1];
		SampleViewController *viewController = [SampleViewController sampleViewControllerWithURL:sampleURL];
		[self.navigationController pushViewController:viewController animated:YES];
	}
	else
	{
		m_selectedRowIndex = indexPath.row;
		
		if ([[[m_aryMasterVault objectAtIndex:m_selectedRowIndex] valueForKey:@"PTS"] intValue] <= [m_modelClass getPTS])
		{
			/// check equipment
			MKStoreManager *mkManager = [MKStoreManager sharedManager];
			if ( !mkManager.purchasedGroup1 && !mkManager.purchasedFullVersion )
			{
				NSString *equipment = [m_modelClass getEquipmentWithExNo:m_selectedRowIndex+1];
				if ( !equipment || (![equipment isEqualToString:@"No Equipment"] && ![equipment isEqualToString:@"Tennis Ball"]) )
				{
					UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Sorry"
																		message:@"Only exercises with no equipment or a tennis ball can be selected with free points. Please unlock the packages in order to access all exercises and equipment."
																	   delegate:nil
															  cancelButtonTitle:@"Okay"
															   otherButtonTitles:nil] autorelease];
					[alertView show];
					[tableView deselectRowAtIndexPath:indexPath animated:YES];
					return;
				}
			}
			
			int myPTS = [m_modelClass getPTS] - [[[m_aryMasterVault objectAtIndex:m_selectedRowIndex] valueForKey:@"PTS"] intValue];
			[m_modelClass setPTS:myPTS];
			[m_remainingPointsLabel setText:[NSString stringWithFormat:@"%i POINTS", [m_modelClass getPTS]]];
			
			ExManager *exManager = [ExManager sharedExManager];
			[exManager setFreeWithID:m_selectedRowIndex+1 state:YES];
			
			[m_aryMasterVault removeAllObjects];
			[m_aryMasterVault setArray:[m_modelClass getAllEx]];
			
			[m_masterVaultTableView reloadData];
		}
		else
		{
			UIActionSheet *restAction = [[[UIActionSheet alloc] initWithTitle:nil
																	 delegate:self
															cancelButtonTitle:@"Cancel"
//													   destructiveButtonTitle:@"Unlock"
													   destructiveButtonTitle:nil
															otherButtonTitles:@"Get more points", nil] autorelease];
			[restAction showInView:self.view];
		}
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ( [buttonTitle isEqualToString:@"Unlock"] )
	{
		if ([[[m_aryMasterVault objectAtIndex:m_selectedRowIndex] valueForKey:@"PTS"] intValue] <= [m_modelClass getPTS])
		{
			int myPTS = [m_modelClass getPTS] - [[[m_aryMasterVault objectAtIndex:m_selectedRowIndex] valueForKey:@"PTS"] intValue];			 
			[m_modelClass setPTS:myPTS];
			[m_remainingPointsLabel setText:[NSString stringWithFormat:@"%i POINTS", [m_modelClass getPTS]]];   
			
			ExManager *exManager = [ExManager sharedExManager];
			[exManager setFreeWithID:m_selectedRowIndex+1 state:YES];

			[m_aryMasterVault removeAllObjects];
			[m_aryMasterVault setArray:[m_modelClass getAllEx]];

			[m_masterVaultTableView reloadData];
		}
		else
		{
			VCRedeemAd *redeemAd = [[VCRedeemAd alloc] init];
			[self.navigationController pushViewController:redeemAd animated:YES];
			[redeemAd release];			
		}
	}
	
	if ( [buttonTitle isEqualToString:@"Get more points"] )
	{
		VCRedeemAd *redeemAd = [VCRedeemAd instance];
		[self.navigationController pushViewController:redeemAd animated:YES];
	}
}

- (IBAction) upgrade
{
//	VCPurchaseAd *upgrade = [[VCPurchaseAd alloc] init];
//	[self presentModalViewController:upgrade animated:YES];
//	[upgrade release];
	
	IAPPerchaseViewController *vc = [IAPPerchaseViewController instance];
	[self.navigationController pushViewController:vc animated:YES];
	[vc setProductID:IAP_FULLVERSION];
}

- (IBAction) back
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
