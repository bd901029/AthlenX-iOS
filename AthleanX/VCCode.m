//
//  VCCode.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 25.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "VCCode.h"
#import "ModelClass.h"
#import "VCSettings.h"
#import "VCMasterVault.h"
#import "ExManager.h"

@interface VCCode ()
{
//	NSMutableArray *m_aryEquipTableCell;
}

@end

@implementation VCCode

+ (VCCode *) instance
{
	return [[[VCCode alloc] initWithNibName:NIB_NAME(@"VCCode") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
	
#if 0
	m_aryEquipTableCell = [[NSMutableArray alloc] init];
	for (int i = 0; i < EQUIPMENT_COUNT_MAX; i++)
	{
		NSString *equipment = [[ExManager allEquipmentName] objectAtIndex:i];
		UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];;
		cell.textLabel.text = equipment;
		if ( [equipment isEqualToString:@"No Equipment"] )
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		
		[m_aryEquipTableCell addObject:cell];
	}
	
	SBTableAlert *equipmentAlert = [[SBTableAlert alloc] initWithTitle:@"Select Shuffle Equipment"
													 cancelButtonTitle:@"Cancel"
														 messageFormat:nil];
	[equipmentAlert setType:SBTableAlertTypeMultipleSelct];
	[equipmentAlert.view addButtonWithTitle:@"OK"];
	[equipmentAlert setDelegate:self];
	[equipmentAlert setDataSource:self];
	[equipmentAlert show];
#endif
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	ModelClass *mc = [[ModelClass alloc] init];
	if ( ![mc getSavedFromFile:@"email.plist"] )
	{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void) viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) back
{
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) subm
{
	ModelClass *mc = [[ModelClass alloc] init];
	if ( [mc createSendingEmailPlistAndVeref:textF.text] == YES )
	{
		int myPTS = [mc getPTS] + 6;
		[mc setPTS:myPTS];

		UIAlertView *notValidEmailAlert = [[[UIAlertView alloc] initWithTitle:@"Thank You"
																	 message:@"Thank you for registering your app"
																	delegate:self
														   cancelButtonTitle:@"Ok"
														   otherButtonTitles:nil] autorelease];

		[notValidEmailAlert show];
		
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
	else
	{
		UIAlertView *notValidEmailAlert = [[[UIAlertView alloc] initWithTitle:@"Failed"
																	 message:@"Incorrect code"
																	delegate:self
														   cancelButtonTitle:@"Ok"
														   otherButtonTitles:nil] autorelease];
		[notValidEmailAlert show];
	}
}

- (void) retry
{
#if 0
	ModelClass *mc = [[ModelClass alloc] init];
	[mc deleteFile:@"email.plist"];
	[mc release];
	VCSettings *setings = [[VCSettings alloc] init];
	[self.navigationController pushViewController:setings animated:YES];
	[setings release];
#else
	VCMasterVault *vc = [VCMasterVault instance];
	[self.navigationController pushViewController:vc animated:YES];
#endif
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	[textF resignFirstResponder];
	return YES;
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
	
	[tableAlert release];
}
#endif

@end
