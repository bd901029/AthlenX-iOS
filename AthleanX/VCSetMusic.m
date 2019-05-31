//
//  VCSetMusic.m
//  AthleanX
//
//  Created by Dmitriy on 09.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCSetMusic.h"
#import "ModelClass.h"
#import "AthleanXAppDelegate.h"
#import "CoreAudio.h"
#import "VCAlbumSelect.h"
#import "VCDoWorkout.h"
#import "VCPlayListSelect.h"

@implementation VCSetMusic

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
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (id)initWithArray:(NSArray *)arr {
	self = [super initWithNibName:NIB_NAME(@"VCSetMusic") bundle:nil];
	if (self) {
		startArray = [[NSArray alloc] initWithArray:arr];
	}
	return self;
}

- (void)viewDidLoad
{
	app = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	if (![app.m_coreAudio getAudioType]) {
		[app.m_coreAudio saveAudioType:4];
	}
	[btn1 setBackgroundImage:[UIImage imageNamed:@"playListBTN.png"] forState:UIControlStateNormal];
	[btn2 setBackgroundImage:[UIImage imageNamed:@"albumBTN.png"] forState:UIControlStateNormal];
	[btn3 setBackgroundImage:[UIImage imageNamed:@"libraryBTN.png"] forState:UIControlStateNormal];
	[btn4 setBackgroundImage:[UIImage imageNamed:@"noMusicBTN.png"] forState:UIControlStateNormal];
	NSLog(@"type %i",[app.m_coreAudio getAudioType]);
	switch ([app.m_coreAudio getAudioType]) {
		case 1:
			[btn1 setBackgroundImage:[UIImage imageNamed:@"playListBTNSel.png"] forState:UIControlStateNormal];
			break;
		case 2:
			[btn2 setBackgroundImage:[UIImage imageNamed:@"albumBTNSel.png"] forState:UIControlStateNormal];
			break;
		case 3:
			[btn3 setBackgroundImage:[UIImage imageNamed:@"libraryBTNSel.png"] forState:UIControlStateNormal];
			break;
		case 4:
			[btn4 setBackgroundImage:[UIImage imageNamed:@"noMusicBTNSel.png"] forState:UIControlStateNormal];
			break;
	}
}

- (void)noMusic {
	[app.m_coreAudio setAudioQuery:nil];
	[app.m_coreAudio saveAudioType:4];
	[self viewWillAppear:YES];
}

- (void)libraryMusic {
	MPMediaQuery *everything = [[MPMediaQuery alloc] init];
//	NSArray *itemsFromGenericQuery = [everything items];
	
	[app.m_coreAudio setAudioQuery:everything];
	[app.m_coreAudio saveAudioType:3];
	[self viewWillAppear:YES];
}

- (void)start {
	
	app.isDoWorkout = YES;
	app.isPlayBagMusic = YES;
	app.isAudioSession = YES;
	VCDoWorkout *vc = [[[VCDoWorkout alloc] initWithArray:startArray] autorelease];
	[self.navigationController pushViewController:vc animated:YES];
}


- (void)playlistMus {
	VCPlayListSelect *vc = [VCPlayListSelect instance];
//	[self presentViewController:vc animated:YES completion:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)albomsMus {
	VCAlbumSelect *vc = [VCAlbumSelect instance];
//	[self presentViewController:vc animated:YES completion:nil];
	[self.navigationController pushViewController:vc animated:YES];
}


- (IBAction) back{ 
	[self.navigationController popViewControllerAnimated:YES];
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

@end
