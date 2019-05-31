//
//  VCWorkout.h
//  AthleanX
//
//  Created by Dmitriy on 08.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import "NSTraining.h"

@class AthleanXAppDelegate;
@class NSTraining;
@class ModelClass;

#define WorkOutFinishedNotification		@"WorkOutFinishedNotification"

@interface VCWorkout : UIViewController <UIAlertViewDelegate>
{
	IBOutlet UILabel *m_dayNumberLabel;
	IBOutlet UILabel *m_exDurationTime;
	
	IBOutlet UIButton *m_shuffleBtn;
	IBOutlet UITableView *m_traningTableView;
	
	IBOutlet UIButton *m_startBtn;
	IBOutlet UIButton *m_bragBtn;
	IBOutlet UIButton *m_setMusicBtn;
	IBOutlet UIButton *m_closeBtn;
	
	IBOutlet UIActivityIndicatorView *m_progressView;
	
	AthleanXAppDelegate *m_appDelegate;
	
	ModelClass *m_modelClass;
	NSMutableDictionary *m_masterVaultDict;
	NSTraining *m_training;
	
	NSArray *m_aryTimes;
	NSArray *m_aryNames;
	NSArray *m_aryIds;
	NSArray *m_aryAnatomyCode;
	
	NSMutableArray *m_aryShuffleTr;
	
	UIAlertView *m_iapAlertView;
	UIAlertView *m_noTrainToMatchAlert;
	
	BOOL m_bShownDisclamer;
}

+ (VCWorkout *) instance;

- (IBAction) onBackBtnClicked;
- (IBAction) setMusic;
- (IBAction) onStartBtnClicked;

- (IBAction) reshuffle;

- (IBAction) bragBtnClicked:(id)sender;
- (IBAction) closeBtnClicked:(id)sender;

@end
