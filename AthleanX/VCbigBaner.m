//
//  VCbigBaner.m
//  AthleanX
//
//  Created by Dmitriy on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SBJson5.h>
#import "VCbigBaner.h"
#import "VCShuffleWorkout.h"
#import "AthleanXAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "XMLReader.h"

@implementation VCbigBaner

+ (id) instance
{
	return [[[VCbigBaner alloc] initWithNibName:NIB_NAME(@"VCbigBaner") bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) viewDidLoad
{
	[super viewDidLoad];
	
	app = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	mc = [[ModelClass alloc] init];
	
	app.isBanerShowed = YES;
	
	if ( [mc connectedToNetwork] )
	{
#if 0
		NSString *workSpacePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"baner1.png"];
		[adImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]]];
#else
#if 0
		ASIFormDataRequest *fetchRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://athleanonline.com/getBanners.php"]];
		[fetchRequest setRequestMethod: @"POST"];
		[fetchRequest setDidFinishSelector: @selector(didGetBannerImage:)];
		[fetchRequest setDelegate:self];
		[fetchRequest startAsynchronous];
#else
		dispatch_async(kBgQueue, ^{
			NSURL *serverURL = [NSURL URLWithString:@"http://athleanonline.com/getBanners.php"];
			NSString *bannerInfo = [NSString stringWithContentsOfURL:serverURL encoding:NSUTF8StringEncoding error:nil];
			
			NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[XMLReader dictionaryForXMLString:bannerInfo error:nil]];
			if ( dict )
			{
				NSString *bannerURL = [dict valueForKeyPath:@"banners.banner1.src"];
				NSData *bannerData = [NSData dataWithContentsOfURL:[NSURL URLWithString:bannerURL]];
				UIImage *bannerImage = [UIImage imageWithData:bannerData];
				adImage.image = bannerImage;
			}
			else
			{
				adImage.hidden = YES;
			}
		});
#endif
#endif
	}
	else
	{
		adImage.hidden = YES;
	}
}

- (void) didGetBannerImage:(ASIHTTPRequest *)request
{
	SBJson5Parser *parser = [[[SBJson5Parser alloc] init] autorelease];
    
    NSDictionary *dict = [parser objectWithString:[request responseString]];
	NSLog(@"server data = %@", dict);
	
	NSString *bannerString = [dict valueForKeyPath:@"banners.banner1.src"];
	NSURL *bannerURL = [NSURL URLWithString:bannerString];
	NSData *bannerData = [NSData dataWithContentsOfURL:bannerURL];
	UIImage *bannerImage = [UIImage imageWithData:bannerData];
	[adImage setImage:bannerImage];
}

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (IBAction) showShuffle
{
	app.isSixPack = NO; 
	
	VCShuffleWorkout *shuffleWork = [VCShuffleWorkout instance];
	[self.navigationController pushViewController:shuffleWork animated:YES];
}


- (IBAction) adAction
{
	if ( [mc connectedToNetwork] )
	{
//		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.baner1URL]];
		
		NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/user/JDCav24"];
//		NSURL *url = [NSURL URLWithString:@"http://athleanonline.com/6pp/wsdl/getBanners.php"];
		if ( ![[UIApplication sharedApplication] openURL:url] )
		{
			NSLog(@"Failed to open %@", url);
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

@end
