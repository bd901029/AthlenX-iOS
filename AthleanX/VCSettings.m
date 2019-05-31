//
//  VCSettings.m
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCSettings.h"
#import "ASIFormDataRequest.h"
#import "VCCode.h"
#import "VCShuffleWorkout.h"
#import "AthleanXAppDelegate.h"

@implementation VCSettings

@synthesize m_btnView;

+ (VCSettings *) instance
{
	return [[[VCSettings alloc] initWithNibName:NIB_NAME(@"VCSettings") bundle:nil] autorelease];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
	m_appDelegate = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	m_modelClass = [[ModelClass alloc] init];
	
	m_appDelegate.isBanerShowed = YES;
	
	[super viewDidLoad];
	NSLog(@"%@",[m_modelClass isSendingEmail]);
	if ([[[m_modelClass getSavedFromFile:@"email.plist"] objectForKey:@"status"] isEqual:@"code"])
	{
		UIAlertView *notValidEmailAlert = [[[UIAlertView alloc] initWithTitle:nil
																	 message:[NSString stringWithFormat:@"You have already sent: %@", [[m_modelClass getSavedFromFile:@"email.plist"] objectForKey:@"email"]]
																	delegate:self
														   cancelButtonTitle:@"Ok"
														   otherButtonTitles:nil] autorelease];
		[notValidEmailAlert show];
	} 

	NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject];
	NSString *workSpacePath = [documentDirectory stringByAppendingPathComponent:@"baner3.png"];
	
	[m_adImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]]];
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if ([[[m_modelClass getSavedFromFile:@"email.plist"] objectForKey:@"status"] isEqual:@"em"])
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.view endEditing:YES];
}

- (IBAction) submitClicked
{
	if ( [m_modelClass connectedToNetwork] )
	{
		if ( [m_modelClass validateEmail:m_mailTextField.text] )
		{
			[m_modelClass createSendingEmailPlist:m_mailTextField.text];
			
			[m_mailTextField resignFirstResponder];

			VCCode *vc = [[[VCCode alloc] initWithNibName:@"VCCode" bundle:nil] autorelease];
//			[self.navigationController pushViewController:[VCCode alloc] animated:YES];
			[self.navigationController pushViewController:vc animated:YES];
			
			NSURL *url = [NSURL URLWithString:@"http://ax-admin.athleanx.com/app-handler.php"];
			ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
			[request setRequestMethod:@"POST"];
			
			[request addPostValue:m_mailTextField.text forKey:@"email"];
			[request addPostValue:@"PAID" forKey:@"type"];
			[request setDelegate:self];
			[request startAsynchronous];

			[m_modelClass saveData:@"Yes" toArchive:@"dontShowEmail"];
			
#if 1
			int myPTS = [m_modelClass getPTS] + 6;
			[m_modelClass setPTS:myPTS];
#endif
		}
		else
		{
			UIAlertView *notValidEmailAlert = [[[UIAlertView alloc] initWithTitle:nil
																		  message:@"Not valid email"
																		 delegate:nil
																cancelButtonTitle:@"Ok"
																otherButtonTitles:nil] autorelease];
			[notValidEmailAlert show];
		}
	}
	else
	{
		UIAlertView *notValidEmailAlert = [[[UIAlertView alloc] initWithTitle:nil
																	  message:@"No internet connection"
																	 delegate:nil
															cancelButtonTitle:@"Ok"
															otherButtonTitles:nil] autorelease];
		[notValidEmailAlert show];
	}
}

- (IBAction) notNowClicked:(id)sender
{
	UIButton *button = (UIButton *)sender;
	if (button.tag == 1)
	{
		[m_modelClass saveData:@"Yes" toArchive:@"dontShowEmail"];
	}
	
	m_appDelegate.isSixPack = NO;
	
	VCShuffleWorkout *vc = [VCShuffleWorkout instance];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if ([alertView.message isEqual:@"Please check your email now for your activation code!  Enter it here when you have it!"])
	{
		[self.navigationController pushViewController:[VCCode alloc] animated:YES];
	}
	else
	{
		[self back];
	}
}

- (IBAction) back
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) adAction
{
	if ([m_modelClass connectedToNetwork])
	{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:m_appDelegate.baner3URL]];
	}
	else
	{
		UIAlertView *notValidEmailAlert = [[UIAlertView alloc] initWithTitle:nil message:@"No internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[notValidEmailAlert show];
		[notValidEmailAlert release];
	}
}

@end
