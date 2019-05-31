//
//  VCShuffleResult.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VCShuffleResult : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
	IBOutlet UILabel *titleName;
	IBOutlet UILabel *redTitle;
	IBOutlet UITextView *eatList;
	IBOutlet UIButton *reshuffle;
	
	NSString *eatNamed;
	
	IBOutlet UITableView *m_tableView;
	NSMutableArray *animArr;
}

+ (VCShuffleResult *) instanceWithName:(NSString *)name;

- (IBAction) back;

- (id)initWithName:(NSString *)name;

- (IBAction) reload;

@end
