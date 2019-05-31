//
//  NSTraining.h
//  AthleanX
//
//  Created by Dmitriy on 22.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSExercice.h"
#import "ModelClass.h"

@class NSExercice;
@class ModelClass;

@interface NSTraining : NSObject
{
	ModelClass *m_modelClass;
	
	int m_currentExerciseNumber;
	int m_exCount;
		
	NSArray *m_array;
	NSMutableArray *m_aryExercise;
	
	NSMutableArray *m_aryEquipment;
	
	NSMutableArray *m_aryNames;
	NSMutableArray *m_aryTimes;
	NSMutableArray *m_aryId;
	NSMutableArray *m_aryAnatomyCode;
	
	NSExercice *m_aryCurrentEx;
}

- (NSString *) second2minut:(float)time;
-(void) addExercice:(NSExercice *)exerccice;
-(void) nextExercice;
-(void) previosExercice;

- (int)currentExNumber;

- (id)initWithArray:(NSArray *)arr;
- (void) load;

- (int) m_exCount;

-(NSArray *) getM_aryId;
-(NSArray *) getNameArr;
-(NSArray *) getTimeArr;
-(NSArray *) getM_aryAnatomyCode;

-(NSExercice *)getM_aryCurrentEx;
-(NSString *) getCurrentExNameSaund;
-(NSString *) getCurrentExName;
-(NSString *) getCurrentExEquipment;
-(int) getCurrentExDuration;
-(NSString *) getCurrentExVideo;
-(NSString *) getCurrentExDescription;

-(NSArray *) getEquipment;

-(int) getTrainingDuration;

@end
