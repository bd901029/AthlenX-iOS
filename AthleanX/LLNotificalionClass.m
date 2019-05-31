//
//  LLNotificalionClass.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 14.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LLNotificalionClass.h"
#import "ModelClass.h"

@implementation LLNotificalionClass

- (id)init
{
	self = [super init];
	if (self) {
		mc = [[ModelClass alloc] init];
		// Initialization code here.
	}
	
	return self;
}

- (void) show {
	if (![mc getDataFromArchive:@"Notif"]) {
		UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"FREE" message:@"Not FREE" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Get Full",@"Don't show", nil];
		[al show];
		[al release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.google.com/"]];
			break;
		case 2:
			NSLog(@"nnn");
			[mc saveData:@"No" toArchive:@"Notif"];
			break;
	}
}

@end
