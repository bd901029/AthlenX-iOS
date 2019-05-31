//
//  AthleanXAppDelegate.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CoreAudio;

@interface AthleanXAppDelegate : NSObject <UIApplicationDelegate>
{
	NSInteger curentDay;
	NSInteger curentWeek;
	NSString *shuffleType;
	int curentDate;
	int curTrainDayNumber;
	
	BOOL isSixPack;
	
	CoreAudio *m_coreAudio;
	BOOL isDoWorkout;
	BOOL isPlayBagMusic;
	BOOL isAudioSession;
	
	BOOL isBanerShowed;
	
	BOOL isActiveShuffle;
	NSMutableArray *tempTrArray;
	
	
	NSString *baner1URL;   
	NSString *baner2URL;   
	NSString *baner3URL;
	
	int m_freeCredit;
	
	NSUInteger m_orientationMask;
	
	BOOL m_bIsCanceledSync;
	
	BOOL m_bIsShownLockedMealPlan;
	BOOL m_bIsShownLockedEquip;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, retain) NSString *baner1URL;
@property (nonatomic, retain) NSString *baner2URL;
@property (nonatomic, retain) NSString *baner3URL;
@property (nonatomic, retain) NSString *shuffleType;
@property (nonatomic, readwrite) NSInteger curentDay;
@property (nonatomic, readwrite) NSInteger curentWeek;
@property (nonatomic, readwrite) int curentDate;
@property (nonatomic, readwrite) int curTrainDayNumber;
@property (nonatomic, readwrite) BOOL isSixPack;
@property (nonatomic, readwrite) BOOL isBanerShowed;
@property (nonatomic, retain) IBOutlet CoreAudio *m_coreAudio;
@property (nonatomic, readwrite) BOOL isDoWorkout;
@property (nonatomic, readwrite) BOOL isPlayBagMusic;
@property (nonatomic, readwrite) BOOL isAudioSession;
@property (nonatomic, readwrite) BOOL isActiveShuffle;
@property (nonatomic, retain)  NSMutableArray *tempTrArray;

@property (nonatomic, readwrite) int freeCredit;
@property (nonatomic, readwrite) NSUInteger orientationMask;

@property (nonatomic, readwrite) BOOL bIsCanceledSync;
@property (nonatomic, readwrite) BOOL bIsShownLockedMealPlan;
@property (nonatomic, readwrite) BOOL bIsShownLockedEquipment;

+ (id) sharedDelegate;

- (void) saveFreeCreditCount;

@end
