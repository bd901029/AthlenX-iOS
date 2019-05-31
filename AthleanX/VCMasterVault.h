//
//  VCMasterVault.h
//  AthleanX
//
//  Created by Dmitriy on 23.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"


@interface VCMasterVault : UIViewController <UIActionSheetDelegate>
{
	IBOutlet UILabel *m_remainingPointsLabel;
	ModelClass *m_modelClass;	
	NSMutableDictionary *m_masterVaultDict;
	NSMutableArray *m_aryMasterVault;
	int m_selectedRowIndex;
	IBOutlet UITableView *m_masterVaultTableView;
}

+ (VCMasterVault *) instance;

- (IBAction) back;
- (IBAction) upgrade;

@end
