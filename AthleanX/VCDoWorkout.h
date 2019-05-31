//
//  VCDoWorkout.h
//  AthleanX
//
//  Created by Dmitriy on 12.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSTraining.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "SlideToCancelViewController.h"

@class AthleanXAppDelegate;


@interface VCDoWorkout : UIViewController <AVAudioPlayerDelegate, UIActionSheetDelegate, SlideToCancelDelegate, UIAlertViewDelegate>
{
	SlideToCancelViewController *m_slideToCancel;
	
	AthleanXAppDelegate *m_appDelegate;	
	ModelClass *m_modelClass; 
	NSTraining *m_training;
	
	IBOutlet UIView *m_pauseView;
	IBOutlet UILabel *pauseTimeLabel;
	IBOutlet UIView *playerView;
	IBOutlet UILabel *timeLabel;
	IBOutlet UILabel *pauseTimeLable;
	
	IBOutlet UILabel *pauseTimeInLable;
	
	IBOutlet UILabel *currExName;
	IBOutlet UILabel *nextExName;
	
	IBOutlet UILabel *timeRemainingLabel;
	
	IBOutlet UIButton *sampleButton;
	IBOutlet UIButton *muzButton;
	IBOutlet UIButton *lockButton;
	
	
	NSTimer *timer;  
	NSTimer *timerPause;
	NSInteger sec;	
	NSInteger secPause;
	int timeRemaining;
	
	BOOL isPlay;
	
	NSArray *namesArr;
	NSArray *idArray;
	
	NSMutableArray *equipmentArray;
	int currentEquipment;
		
	NSString* pathLeft30;
	NSString* pathLeft15;
	NSString* m_pathLeft10;
	NSString* m_pathPause20;
	NSString* m_pathPause60;
	NSString* m_pathEnd;
	NSString* m_pathEquipment;
	
	AVAudioPlayer* m_playerLeft30;
	AVAudioPlayer* m_playerLeft15;
	AVAudioPlayer* m_playerLeft10;
	AVAudioPlayer* m_playerPause20;
	AVAudioPlayer* m_playerPause60;
	AVAudioPlayer* m_playerEnd;
	
	AVAudioPlayer* m_player1;
	
	AVAudioPlayer* m_playerEquipment;
	
	UIAlertView *m_iapAlertView;
	
	
	IBOutlet UISlider *m_audioVolumeSlider;
	IBOutlet UILabel *m_audioName;
	IBOutlet UILabel *m_audioName2;
	BOOL m_audioIsPaused;
}

+ (VCDoWorkout *) instance;

- (IBAction) stop;
- (IBAction) pauseBtn;
- (void) pauseShow:(BOOL)audioStop;
- (void) pauseHide:(BOOL)audioStop;
- (IBAction) player;
- (void) playSound;
- (NSString *) second2minut:(float)time;

#pragma mark -
#pragma mark - Audio
- (IBAction) playPause;
- (IBAction) playNext;
- (IBAction) playPlav;
- (void) playEquipment;

- (id)initWithArray:(NSArray *)arr;
- (id)initWithTranningId:(int)trID;

- (IBAction) playVideoSample;
- (IBAction) lock;

@end
