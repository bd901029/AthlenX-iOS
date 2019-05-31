//
//  VCProgress.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCProgress.h"
#import "AthleanXAppDelegate.h"
#import "VCWorkout.h"
#import "ModelClass.h"
#import "CoreAudio.h"
#import "MKStoreManager.h"
#import "IAPMainViewController.h"

@implementation VCProgress

+ (VCProgress *) instance
{
	return [[[VCProgress alloc] initWithNibName:NIB_NAME(@"VCProgress") bundle:nil] autorelease];
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

- (void) dealloc
{
	[super dealloc];
}

#pragma mark - View lifecycle
- (void) viewDidLoad
{
	[super viewDidLoad];
	dayTraningsArray = [[NSMutableDictionary alloc] init];
	
	m_appDelegate = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	mc = [[ModelClass alloc] init];
	
	num = 1;
	
	NSLog( @"%i", [mc getCurrentDayNumber] );
	daysArray = [[NSArray alloc] initWithArray:[mc getAllDays]];
	
	if ( IS_IPHONE5 )
	{
		for ( int i = 1; i < 56; i++ )
		{
			if ( i == 1 )
			{
				[mc startDatePlistCreate];
				m_appDelegate.curentDay = [mc getCurrentDayNumber];
			}
			
			[self configureDayNumberIPhone5:[[[daysArray objectAtIndex:i-1] objectForKey:@"id"] integerValue] lableText:[[[daysArray objectAtIndex:i-1] objectForKey:@"passed"] stringValue] andTranings:[[[daysArray objectAtIndex:i-1] objectForKey:@"training_Namber"] integerValue]];
		}
	}
	else
	{
		for ( int i = 1; i < 56; i++ )
		{
			if ( i < 29 )
			{
				if ( i == 1 )
				{
					[mc startDatePlistCreate];
					m_appDelegate.curentDay = [mc getCurrentDayNumber];
				}
				
				[self setLabelOnDayNumber:[[[daysArray objectAtIndex:i-1] objectForKey:@"id"] integerValue] lableText:[[[daysArray objectAtIndex:i-1] objectForKey:@"passed"] stringValue] andTranings:[[[daysArray objectAtIndex:i-1] objectForKey:@"training_Namber"] integerValue]];
			}
			else
			{
				[self setLabelOnDay2Number:[[[daysArray objectAtIndex:i-1] objectForKey:@"id"] integerValue]-28 lableText:[[[daysArray objectAtIndex:i-1] objectForKey:@"passed"] stringValue] andTranings:[[[daysArray objectAtIndex:i-1] objectForKey:@"training_Namber"] integerValue]];
			}
		}
		
		if ( [mc getCurrentTrDay ] > 28)
		{
			[self weekBtn];
		}
	}
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload
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

- (void) drawGrayForDay:(NSInteger)day workOutId:(NSInteger)WId
{
	day--;	
	NSInteger weekNamber = day/7;	
	NSInteger dayNamber = day - weekNamber * 7;
	
	UIImageView *lableImage = [[[UIImageView alloc] initWithFrame:CGRectMake(33+(44*dayNamber),138+(44*weekNamber), 15, 15)] autorelease];
	
	UILabel *textLable = [[[UILabel alloc] initWithFrame:CGRectMake(0,0, 15, 15)] autorelease];
	[textLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:9]];
	[textLable setTextColor:[UIColor whiteColor]];
	[textLable setTextAlignment:NSTextAlignmentCenter];
	[textLable setBackgroundColor:[UIColor clearColor]];
	[textLable setText:[NSString stringWithFormat:@"%i",WId]];
	
	[lableImage setBackgroundColor:[UIColor grayColor]];
	[lableImage addSubview:textLable];
	[self.view addSubview:lableImage];
}

- (void) configureDayNumberIPhone5:(NSInteger)day lableText:(NSString *)text andTranings:(NSInteger)tranId
{
	NSArray *aryY = @[@"125", @"170", @"215", @"258", @"300", @"340", @"380", @"425"];

	day--;
	NSInteger weekNamber = day/7;
	NSInteger dayNamber = day - weekNamber * 7;
	
	UIImageView *labelImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 22, 22)] autorelease];
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5+45*dayNamber, 128+45*weekNamber, 24, 24)];
	
	CGRect frame = btn.frame;
	frame.origin.y = ((NSString *)[aryY objectAtIndex:weekNamber]).integerValue;
	[btn setFrame:frame];
	
	[labelImage setCenter:CGPointMake(12, 12)];
	[labelImage setImage:[UIImage imageNamed:@"pross_1.png"]];
	btn.tag = tranId;
	[dayTraningsArray setObject:[NSNumber numberWithInteger:day] forKey:[NSString stringWithFormat:@"%i", tranId]];
	if ( tranId != 0 )
	{
		if ( [[[daysArray objectAtIndex:day] objectForKey:@"passed"] intValue] == 1 )
		{
			[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
			
			[labelImage setImage:[UIImage imageNamed:@"pross_2.png"]];
		}
		else
		{
#if 1
			int dayIndex = [[[daysArray objectAtIndex:day] objectForKey:@"id"] integerValue];
			if ( dayIndex <= [mc getCurrentTrDay] )
			{
				[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
			}
			else
			{
				if ( dayIndex > [mc getCurrentDayNumber] - 1 )
				{
					[btn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
				}
			}
#else
			[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
#endif
		}
		
		UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,0, 24, 12)] autorelease];
		[textLabel setText:[NSString stringWithFormat:@"%i", num]];
		[textLabel setCenter:CGPointMake(11, 11)];
		[textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
		[textLabel setTextColor:[UIColor blackColor]];
		[textLabel setTextAlignment:NSTextAlignmentCenter];
		[textLabel setBackgroundColor:[UIColor clearColor]];
		
		[labelImage addSubview:textLabel];
		[btn addSubview:labelImage];
		
		[btn addSubview:labelImage];
		[self.view addSubview:btn];
		
		num++;
	}
}

- (void) setLabelOnDayNumber:(NSInteger)day lableText:(NSString *)text andTranings:(NSInteger)tranId
{
	day--;
	NSInteger weekNamber = day/7;	
	NSInteger dayNamber = day - weekNamber * 7;
	   
	UIImageView *labelImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 21, 21)] autorelease];
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5+45*dayNamber,13+45*weekNamber, 45, 45)];
	[labelImage setCenter:CGPointMake(22, 22)];
	btn.tag = tranId;
	
	[dayTraningsArray setObject:[NSNumber numberWithInteger:day] forKey:[NSString stringWithFormat:@"%i", tranId]];
	if ( tranId != 0 )
	{
		if ( [[[daysArray objectAtIndex:day] objectForKey:@"passed"] intValue] == 1 )
		{
			[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
			
			UILabel *textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,0, 24, 12)] autorelease];
			[textLabel setText:[NSString stringWithFormat:@"%i", num]];
			[textLabel setCenter:CGPointMake(10, 10)];
			[textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
			[textLabel setTextColor:[UIColor blackColor]];
			[textLabel setTextAlignment:NSTextAlignmentCenter];
			[textLabel setBackgroundColor:[UIColor clearColor]];
			
			num++;

			[labelImage setImage:[UIImage imageNamed:@"pross_2.png"]];
			[labelImage addSubview:textLabel];
			[btn addSubview:labelImage];
		}
		else
		{
#if 1
			int dayIndex = [[[daysArray objectAtIndex:day] objectForKey:@"id"] integerValue];
			if ( dayIndex <= [mc getCurrentTrDay] )
			{
				[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
			}
			else
			{
				if ( dayIndex > [mc getCurrentDayNumber] - 1 )
				{
					[btn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
				}
			}
#else
			[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
#endif
		}
		
		[calView1_4 addSubview:btn];
	}
}

- (void) setLabelOnDay2Number:(NSInteger)day lableText:(NSString *)text andTranings:(NSInteger)tranId
{
	day--;
	NSInteger weekNamber = day/7;	
	NSInteger dayNamber = day - weekNamber * 7;
	
	UIImageView *lableImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 21, 21)] autorelease];
//	UIImageView *lableImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pross_2.png"]] autorelease];
	UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(5+45*dayNamber,13+45*weekNamber, 45, 45)];
	[lableImage setCenter:CGPointMake(22, 22)];
	btn.tag = tranId;
	[dayTraningsArray setObject:[NSNumber numberWithInteger:day+28] forKey:[NSString stringWithFormat:@"%i",tranId]];
	if ( tranId != 0 )
	{
		if ( [[[daysArray objectAtIndex:day+28] objectForKey:@"passed"] intValue] == 1 )
		{
			[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
			UILabel *textLable = [[[UILabel alloc] initWithFrame:CGRectMake(0,0, 24, 12)] autorelease];
			[textLable setCenter:CGPointMake(10, 10)];
			[textLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
			[textLable setTextColor:[UIColor blackColor]];
			[textLable setTextAlignment:NSTextAlignmentCenter];
			[textLable setBackgroundColor:[UIColor clearColor]];
			[textLable setText:[NSString stringWithFormat:@"%i",num]];
			num++;

			[lableImage setImage:[UIImage imageNamed:@"pross_2.png"]];
			[lableImage addSubview:textLable];
			[btn addSubview:lableImage];		
		}
		else
		{
#if 1
			if ( [[[daysArray objectAtIndex:day+28] objectForKey:@"id"] integerValue] <= [mc getCurrentTrDay] )
			{
				[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
			}
			else
			{
				if ( day + 28 > [mc getCurrentDayNumber] - 1 )
				{
					[btn addTarget:self action:@selector(click2:) forControlEvents:UIControlEventTouchUpInside];
				}
			}
#else
			[btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
#endif
		}
		[calView5_8 addSubview:btn];
	}
}

- (void) click:(UIButton *)btn
{
	m_appDelegate.curTrainDayNumber = btn.tag;
	NSLog(@"btn tag = %d", btn.tag);
	
	/// Check IAP
	MKStoreManager *storeManager = [MKStoreManager sharedManager];
	if ( btn.tag > 5 && btn.tag < 21  )
	{
		if ( !storeManager.purchasedGroup1 && !storeManager.purchasedFullVersion )
		{
			m_purchaseAlertView = [[[UIAlertView alloc] initWithTitle:@"Alert"
															 message:@"Please purchase the 6 Pack Plus Package or the 8 Pack Premium Package to continue."
															delegate:self
												   cancelButtonTitle:@"Close"
													otherButtonTitles:@"Unlock", nil] autorelease];
			[m_purchaseAlertView show];
			return;
		}
	}
	else if ( btn.tag >= 21 )
	{
		if ( !storeManager.purchasedGroup2 && !storeManager.purchasedFullVersion )
		{
			m_purchaseAlertView = [[[UIAlertView alloc] initWithTitle:@"Alert"
															  message:@"Please purchase the 6 Pack Punisher Package or the 8 Pack Premium Package to continue."
															 delegate:self
													cancelButtonTitle:@"Close"
													otherButtonTitles:@"Unlock", nil] autorelease];
			[m_purchaseAlertView show];
			return;
		}
	}
	
	m_appDelegate.curentDay = [[dayTraningsArray objectForKey:[NSString stringWithFormat:@"%i", btn.tag]] integerValue]+1;

	m_appDelegate.isSixPack = YES;
		
	VCWorkout *vc = [VCWorkout instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void) click2:(UIButton *)btn
{
	UIAlertView *al = [[[UIAlertView alloc] initWithTitle:@"Sorry!"
												 message:@"You are not able to skip workouts. Please complete the workouts leading up to this workout"
												delegate:nil
									   cancelButtonTitle:@"OK"
									   otherButtonTitles:nil] autorelease];
	[al show];
}

- (IBAction) back
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) reset
{
	if ( [mc getCurrentDayNumber] )
	{
		UIActionSheet *resetActionSheet = [[[UIActionSheet alloc] initWithTitle:@"Do you really want to reset progress?"
														 delegate:self
												cancelButtonTitle:@"NO"
										   destructiveButtonTitle:@"YES"
												otherButtonTitles: nil] autorelease];
		[resetActionSheet showInView:self.view];
	}
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	if ( [buttonTitle isEqualToString:@"YES"] )
	{
		[mc resetAllDays];
		[mc deleteFile:@"startDate.plist"];
		for (int i = 0; i < [self.view.subviews count]; i++)
		{
			if ([[self.view.subviews objectAtIndex:i] isKindOfClass:[UIButton class]])
			{
				UIButton *bnt = [self.view.subviews objectAtIndex:i];
				
				if (bnt.tag != 0)
				{
					[[self.view.subviews objectAtIndex:i] removeFromSuperview];
				}
			}
		}
		
		m_appDelegate.curentDay = 0;
		[self back];
	}
}

- (void) musTest
{
}

- (void) weekBtn
{
	if ([[[calViewMain subviews] objectAtIndex:0] isEqual:calView1_4])
	{
		[calView1_4 removeFromSuperview];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:calViewMain cache:YES];
		[UIView commitAnimations];
		
		[calViewMain addSubview:calView5_8];
		[weekBtn setBackgroundImage:[UIImage imageNamed:@"weeksBnt_1.png"] forState:UIControlStateNormal];
	}
	else
	{
		[calView5_8 removeFromSuperview];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:calViewMain cache:YES];
		[UIView commitAnimations];
		
		[calViewMain addSubview:calView1_4];
		[weekBtn setBackgroundImage:[UIImage imageNamed:@"weeksBnt_2.png"] forState:UIControlStateNormal];
	}
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
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
