//
//  ModelClass.h
//  MyLADiet
//
//  Created by Stableflow on 20.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaQuery.h>

#import <MediaPlayer/MediaPlayer.h>

#import "NSExercice.h"
#import "NSTraining.h"

#import "Sqlite.h"

//@class Sqlite;

@class Sqlite;
@class MediaPlayer;
@class NSExercice;

@interface ModelClass : NSObject {
	Sqlite *m_dataBase;
}

@property (nonatomic, retain) NSMutableDictionary *firstOpen;

- (void) saveDictNew:(NSDictionary *)dict toFile:(NSString *)file;
- (BOOL) connectedToNetwork;
- (void) saveDict:(NSDictionary *)dict toFile:(NSString *)file;
- (NSDictionary *) getSavedFromFile:(NSString *)file;
- (void) deleteFile:(NSString *)file;
-(NSString*) sha1:(NSString*)input;
- (void) createPlists;

- (NSArray *) getPlaylists;
- (NSArray *) getAlbums;

- (NSDictionary *) getMasteVaultDict;
- (void) saveMasterVaultDict:(NSDictionary *)dict;
- (void) createMasterVaultPlist;

- (int) getPTS;
- (void) setPTS:(int)pts;

- (NSExercice *) getExercice30ById:(int)exerciceId;
- (NSExercice *) getExercice60ById:(int)exerciceId;

#if 1
- (NSURL *) sampleVideoURLWithID:(int)exID;
#endif

- (void)createEditableCopyOfDatabaseIfNeeded;

- (NSArray *) getRowById:(int)rowId;
- (NSArray *) getAllEx;
- (void) setFreeById:(int)rowId;

- (void) getTr;
- (NSArray *) getTrainingByDay:(int)dayNumber;
- (NSExercice *) getRestBySec:(int)sec;

- (NSArray *) getAllDays;
- (NSArray *) getDayByID:(int)dayID;
- (void) resetAllDays;
- (void) setPassedDayByID:(int)dayID;
- (void) setPassedDayByIDTr:(int)dayID;

- (int) howManyDaysHavePast:(NSDate*)lastDate;
- (int) getCurrentDayNumber;
- (void) startDatePlistCreate;

- (NSString *) second2minut:(float)time;
- (BOOL) validateEmail: (NSString *) candidate;

- (NSString *) isSendingEmail;
- (void) createSendingEmailPlist:(NSString *)email;
- (BOOL) createSendingEmailPlistAndVeref:(NSString *)code;

- (NSDictionary *) getAxByLevel:(int)lvl andCategory:(NSString *)category;
- (NSDictionary *) getAxByLevel:(int)lvl andCategory:(NSString *)category noDublicateInArr:(NSArray *)arr;

- (NSArray *) generateTraningForBasic;
- (NSArray *) generateTraningForNext;
- (NSArray *) generateTraningForMax;
- (NSArray *) generateTraningForXTreme;

- (NSArray *) getAllTips;
- (NSArray *) getTipsById:(int)tipId;

- (NSMutableArray *) removeEqual:(NSArray *)arr;

- (void) saveData:(id)data toArchive:(NSString *)arshive;
- (id) getDataFromArchive:(NSString *)arshive;

- (int) getCurrentTrDay;

- (void) fixDB;

- (NSString *) getEquipmentWithExNo:(int)exNo;

@end
