//
//  VCAlbumSelect.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 04.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AthleanXAppDelegate;

@interface VCAlbumSelect : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	IBOutlet UITableView *TableNiew;
	AthleanXAppDelegate *app;
	NSArray *array;
}

+ (VCAlbumSelect *) instance;

- (IBAction) back;

@end
