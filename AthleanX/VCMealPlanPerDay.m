//
//  VCMailPlanDay.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCMealPlanPerDay.h"
#import "MealPlanManager.h"
#import "AthleanXAppDelegate.h"
#import "ModelClass.h"
#import "MKStoreManager.h"
#import <EventKit/EventKit.h>

@interface VCMealPlanPerDay ()
{
	UIAlertView *m_syncAlertView;
	PickerAlertView *m_setDateAlertView;
	UIAlertView *m_confirmAlertView;
	
	NSDate *m_startingMealPlanDate;
}

@end

@implementation VCMealPlanPerDay

+ (VCMealPlanPerDay *) instance
{
	return [[[VCMealPlanPerDay alloc] initWithNibName:NIB_NAME(@"VCMealPlanPerDay") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if ( self )
	{
		// Custom initialization
	}
	
	return self;
}

- (void) dealloc
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
	
	ModelClass *modelClass = [[ModelClass alloc] init];
	
	m_appDelegate.curentDay = [modelClass getCurrentDayNumber];
	
	if (m_appDelegate.curentDay == 0) 
		m_appDelegate.curentDay = 1;
	
	if (m_appDelegate.curentDay == 1)
	{
		[m_prevBtn setHidden:YES];
	}

	m_mealPlanManager = [[MealPlanManager alloc] init];

	[m_webviewMealPlanDay setBackgroundColor:[UIColor clearColor]];
	[m_webviewMealPlanDay setOpaque:NO];
	[m_webviewMealPlanDay loadHTMLString:[m_mealPlanManager getDayInHTML:m_appDelegate.curentDay] baseURL:nil];
	
	[m_titleLabel setText:[NSString stringWithFormat:@"MEAL PLAN DAY %i", m_appDelegate.curentDay]];
	
	MKStoreManager *mkManager = [MKStoreManager sharedManager];
	if ( mkManager.purchasedGroup1 || mkManager.purchasedFullVersion )
	{
		NSUserDefaults *appSetting = [NSUserDefaults standardUserDefaults];
		NSString *synced = [appSetting valueForKeyPath:@"SYNC"];
		if ( (!synced || [synced isEqualToString:@"NO"]) && !m_appDelegate.bIsCanceledSync )
		{
			m_syncAlertView = [[[UIAlertView alloc] initWithTitle:@"Sync With Calendar"
														  message:@"Do you want to sync meal plan with calendar"
														 delegate:self
												cancelButtonTitle:@"No"
												otherButtonTitles:@"Sync", nil] autorelease];
			[m_syncAlertView show];
			m_appDelegate.bIsCanceledSync = YES;
		}
	}
}

- (IBAction) back
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) next
{
	if (m_appDelegate.curentDay != [m_mealPlanManager getDaysCount])
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:m_webviewMealPlanDay cache:YES];
		[m_titleLabel setText:[NSString stringWithFormat:@"MEAL PLAN DAY %i", m_appDelegate.curentDay+1]];
		[UIView commitAnimations];
		[m_prevBtn setHidden:NO];
		if (m_appDelegate.curentDay == [m_mealPlanManager getDaysCount]-1)
		{
			[m_nextBtn setHidden:YES];
		}
		
		m_appDelegate.curentDay++;
		
		[m_webviewMealPlanDay loadHTMLString:[m_mealPlanManager getDayInHTML:m_appDelegate.curentDay] baseURL:nil];
	}
	else
	{
		[m_nextBtn setHidden:YES];
	}
}

- (void) prev
{
	if (m_appDelegate.curentDay != 1)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:1];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:m_webviewMealPlanDay cache:YES];
		[m_titleLabel setText:[NSString stringWithFormat:@"MEAL PLAN DAY %i",m_appDelegate.curentDay-1]];
		[UIView commitAnimations];
		[m_nextBtn setHidden:NO];
		if (m_appDelegate.curentDay == 2)
		{
			[m_prevBtn setHidden:YES];
		}
		
		m_appDelegate.curentDay--;

		[m_webviewMealPlanDay loadHTMLString:[m_mealPlanManager getDayInHTML:m_appDelegate.curentDay] baseURL:nil];
	}
	else
	{
		[m_prevBtn setHidden:YES];
	}
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

#pragma mark -
#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ( alertView == m_syncAlertView )
	{
		if ( buttonIndex == 1 )
		{
			m_setDateAlertView = [[[PickerAlertView alloc] initWithTitle:@" "
																message:@" "
															   delegate:self
													  cancelButtonTitle:@"Cancel"
													  otherButtonTitles:@"Set", nil] autorelease];
			[m_setDateAlertView show];
		}
	}
	
	if ( alertView == m_setDateAlertView )
	{
		m_startingMealPlanDate = [[NSDate dateWithTimeInterval:0 sinceDate:m_setDateAlertView.datePickerView.date] retain];
		
		if ( buttonIndex == 1 )
		{
			m_confirmAlertView = [[[UIAlertView alloc] initWithTitle:@"Are you sure?"
															 message:@"Please confirm your operation."
															delegate:self
												   cancelButtonTitle:@"Cancel"
												   otherButtonTitles:@"Okay", nil] autorelease];
			[m_confirmAlertView show];
		}
	}
	
	if ( alertView == m_confirmAlertView )
	{
		if ( buttonIndex == 1 )
		{
			[self syncMealPlan];
		}
	}
}

- (void) syncMealPlan
{
	MKStoreManager *mkManager = [MKStoreManager sharedManager];
	if ( !mkManager.purchasedGroup1 && !mkManager.purchasedGroup2 && !mkManager.purchasedFullVersion )
		return;
	
    for (int i = 0; i < 56; i++)
	{
		if ( i < 28 && !mkManager.purchasedGroup1 && !mkManager.purchasedFullVersion)
			continue;
		
		if ( i >= 28 && !mkManager.purchasedGroup2 && !mkManager.purchasedFullVersion )
			continue;
		
		NSDate *date = [NSDate dateWithTimeInterval:i*3600*24 sinceDate:m_startingMealPlanDate];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone* timezone = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:timezone];
        [dateFormatter setDateFormat:@"HH:mm  dd MMM yyyy"];
		
		NSDateFormatter *titleFormater = [[NSDateFormatter alloc] init];
		[titleFormater setTimeZone:timezone];
		[titleFormater setDateFormat:@"yyyy-MM-dd"];
        
		EKEventStore *eventStore = [[EKEventStore alloc] init];
        EKEvent *myEvent  = [EKEvent eventWithEventStore:eventStore];
        
        myEvent.title = [NSString stringWithFormat:@"6 Pack Promise Meal Plan : Day %d", i+1];
		
		NSString *note = [NSString stringWithFormat:@"Breakfast : %@\nSnack 1 : %@\nLaunch : %@\nSnack 2 : %@\nDinner : %@\nSnack 3 : %@",
						  [m_mealPlanManager getBreakfastForDay:i+1],
						  [m_mealPlanManager getSnackForDay:i+1 snackId:1],
						  [m_mealPlanManager getLunchForDay:i+1],
						  [m_mealPlanManager getSnackForDay:i+1 snackId:2],
						  [m_mealPlanManager getDinnerForDay:i+1],
						  [m_mealPlanManager getSnackForDay:i+1 snackId:3]];
		
        myEvent.notes = note;
        
        [myEvent setStartDate:date];
        [myEvent setEndDate:date];
        
        
        if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
		{
            [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                if ( granted )
				{
                    [myEvent setCalendar:[eventStore defaultCalendarForNewEvents]];
                    if (![myEvent isNew])
					{
                        [eventStore removeEvent:myEvent span:EKSpanThisEvent error:&error];
                    }
                    [eventStore saveEvent:myEvent span:EKSpanFutureEvents error:&error];
                    
					NSUserDefaults *appSetting = [NSUserDefaults standardUserDefaults];
					[appSetting setObject:@"YES" forKey:@"SYNC"];
					[appSetting synchronize];
                }
                else
				{
                    NSLog(@"Failed");
                }
            }];
        }
    }
}

@end
