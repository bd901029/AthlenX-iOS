//
//  VCTopTips.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 02.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ModelClass;

@interface VCTopTips : UIViewController {
	IBOutlet UIWebView *tipsView;
	IBOutlet UIButton *prevBtn;
	IBOutlet UIButton *nextBtn;
	IBOutlet UILabel *tipName;
	ModelClass *mc;
	
	NSArray *tipArray;
	NSInteger currentTip;
}

+ (VCTopTips *) instance;

- (IBAction) back;

- (IBAction) next;
- (IBAction) prev;

@end
