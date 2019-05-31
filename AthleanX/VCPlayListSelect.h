//
//  VCPlayListSelect.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 05.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AthleanXAppDelegate;

@interface VCPlayListSelect : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *TableNiew;
	AthleanXAppDelegate *app;
	NSArray *array;
}

+ (VCPlayListSelect *) instance;

- (IBAction) back;

@end
