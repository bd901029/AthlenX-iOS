//
//  VCPlayListSelect.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 05.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VCPlayListSelect.h"
#import "AthleanXAppDelegate.h"
#import "CoreAudio.h"

@implementation VCPlayListSelect

+ (VCPlayListSelect *) instance
{
    return [[[VCPlayListSelect alloc] initWithNibName:NIB_NAME(@"VCPlayListSelect") bundle:nil] autorelease];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
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
	app = (AthleanXAppDelegate *)[UIApplication sharedApplication].delegate;
	array = [[NSArray alloc] initWithArray:[app.m_coreAudio getPlayListsName]];
	[super viewDidLoad];
}

- (void) back
{
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];				 
	} 
	cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowBRG.png"]] autorelease];
	[cell.textLabel setTextColor:[UIColor whiteColor]];
	cell.textLabel.text = [array objectAtIndex:indexPath.row];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MPMediaQuery *playlistsQuery1 = [MPMediaQuery playlistsQuery];
	
	[playlistsQuery1 addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:[array objectAtIndex:indexPath.row] forProperty:MPMediaPlaylistPropertyName comparisonType:MPMediaPredicateComparisonEqualTo]]; 
	;
	[playlistsQuery1 setGroupingType:MPMediaGroupingPlaylist];
	
	[app.m_coreAudio setAudioQuery:playlistsQuery1];
	[app.m_coreAudio saveAudioType:1];
//	[self dismissViewControllerAnimated:YES completion:nil];
	[self.navigationController popViewControllerAnimated:YES];
	
	// [app.ca play];
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
