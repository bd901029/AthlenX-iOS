//
//  NSTraining.m
//  AthleanX
//
//  Created by Dmitriy on 22.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSTraining.h"
#import "ExManager.h"
#import "AthleanXAppDelegate.h"

@implementation NSTraining


- (id)initWithArray:(NSArray *)arrTmp
{
	self = [super init];
	if (self)
	{
		m_array = [[NSArray alloc] initWithArray:arrTmp];  
	}
	
	return self;
}

- (void) load
{
	m_modelClass = [[ModelClass alloc] init];
	ExManager *exManager = [ExManager sharedExManager];
	
	NSExercice *exTemp = [[NSExercice alloc] init];
	NSExercice *exTemp2 = [[NSExercice alloc] init];
//	exTemp = [m_modelClass getExercice30ById:3];
		  
	m_aryExercise = [[NSMutableArray alloc] init];
	
	m_aryNames = [[NSMutableArray alloc] init];
	m_aryTimes = [[NSMutableArray alloc] init];
	m_aryId = [[NSMutableArray alloc] init];
	m_aryAnatomyCode = [[NSMutableArray alloc] init];
	m_aryEquipment = [[NSMutableArray alloc] init];

	m_exCount = 0;

	AthleanXAppDelegate *delegate = [AthleanXAppDelegate sharedDelegate];
	for (NSDictionary *dict in m_array)
	{
		if ([[dict valueForKey:@"ex"] isEqual:@"-1"])
		{
			exTemp = [m_modelClass getRestBySec:[[dict valueForKey:@"time"] intValue]];
			exTemp2 = [m_modelClass getRestBySec:[[dict valueForKey:@"time"] intValue]];
		}
		else
		{
			/// check IAP - start.
			int exID = [[dict valueForKey:@"ex"] intValue];
			if ( [exManager isFreeWithNo:exID] == NO  && !delegate.isSixPack )
				continue;
			/// check IAP - end.
			
			if ([[dict valueForKey:@"time"] isEqual:@"30"])
			{
				exTemp = [m_modelClass getExercice30ById:[[dict valueForKey:@"ex"] intValue]];
				exTemp2 = [m_modelClass getExercice30ById:[[dict valueForKey:@"ex"] intValue]];
			}
			else if ([[dict valueForKey:@"time"] isEqual:@"60"])
			{
				exTemp = [m_modelClass getExercice60ById:[[dict valueForKey:@"ex"] intValue]];
				exTemp2 = [m_modelClass getExercice60ById:[[dict valueForKey:@"ex"] intValue]];
			}
		}
		
		if ([exTemp.side isEqual:@"2"])
		{
			[m_aryExercise addObject:exTemp];
			[m_aryId addObject:[NSString stringWithFormat:@"%i", exTemp.exerciceId]];
			[m_aryNames addObject:exTemp.exerciseName];
			[m_aryTimes addObject:[NSString stringWithFormat:@"%i", exTemp.durationTime]];
			[m_aryEquipment addObject:exTemp.equipmentSound];
			[m_aryAnatomyCode addObject:exTemp.anatomyCode];
			m_exCount++;
				
			exTemp2.exerciseNameSound = exTemp.x2;
			
			[m_aryExercise addObject:exTemp2];
			
			[m_aryId addObject:[NSString stringWithFormat:@"%i",exTemp2.exerciceId]];
			[m_aryNames addObject:exTemp2.exerciseName];
			[m_aryTimes addObject:[NSString stringWithFormat:@"%i",exTemp2.durationTime]];
			[m_aryEquipment addObject:exTemp2.equipmentSound];
			[m_aryAnatomyCode addObject:exTemp2.anatomyCode];
			m_exCount++;
		}
		else
		{
			[m_aryExercise addObject:exTemp];
			[m_aryId addObject:[NSString stringWithFormat:@"%i",exTemp.exerciceId]];
			[m_aryNames addObject:exTemp.exerciseName];
			[m_aryTimes addObject:[NSString stringWithFormat:@"%i",exTemp.durationTime]];
			[m_aryEquipment addObject:exTemp.equipmentSound];
			[m_aryAnatomyCode addObject:exTemp.anatomyCode];
			m_exCount++;
		}
	}
	
	m_currentExerciseNumber = 0;
	
	m_aryCurrentEx = [[NSExercice alloc] init];
	m_aryCurrentEx = [m_aryExercise objectAtIndex:m_currentExerciseNumber]; 
}

- (int) getTrainingDuration
{
	int dur = 0;
	for (int i = 0; i < [m_aryTimes count]; i++)
	{
		dur += [[m_aryTimes objectAtIndex:i] intValue];
	}
	
	return dur;
}

- (NSArray *) getEquipment
{
#if 1
//	if ( [[AthleanXAppDelegate sharedDelegate] isSixPack] )
//	{
		NSMutableArray *tempArr = [[[NSMutableArray alloc] initWithArray:[m_modelClass removeEqual:m_aryEquipment]] autorelease];
		if ([tempArr count] > 1)
		{
			for (int i = 0; i < [tempArr count]; i++)
			{
				NSString *equipName = [tempArr objectAtIndex:i];
				if ( [equipName.lowercaseString isEqualToString:@"no equipment"] )
				{
					[tempArr removeObjectAtIndex:i];
				}
			}
		}
		
		return tempArr;
//	}
//	else
//	{
//		ExManager *exManager = [ExManager sharedExManager];
//		return exManager.arySelectedEquipment;
//	}
	
	return nil;
	
#else
	ExManager *exManager = [ExManager sharedExManager];
	return exManager.arySelectedEquipment;
#endif
}

- (NSArray *)getM_aryAnatomyCode
{
	return m_aryAnatomyCode;
}

- (NSArray *) getM_aryId
{
	return m_aryId;
}

- (NSArray *)getNameArr
{
	return m_aryNames;
}

- (NSArray *)getTimeArr
{
	return m_aryTimes;
}


- (NSString *) second2minut:(float)time
{	
	float minutes = floor(time/60);
	float seconds = round(time - minutes * 60);
	if (seconds < 10) {
		return [NSString stringWithFormat:@"%0.0f.0%0.0f",minutes, seconds];
	}	
	return [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];  
}

- (int)m_exCount{	
	return m_exCount;
}

- (int)currentExNumber{	
	return m_currentExerciseNumber;
}

-(void) addExercice:(NSExercice *)exerccice{
	
}

-(void) nextExercice{
	m_aryCurrentEx = nil;
	m_currentExerciseNumber++;
	m_aryCurrentEx = [m_aryExercise objectAtIndex:m_currentExerciseNumber];
}

-(void) previosExercice{
	m_aryCurrentEx = nil;
	m_currentExerciseNumber--;
	m_aryCurrentEx = [m_aryExercise objectAtIndex:m_currentExerciseNumber];
}

-(NSString *) getCurrentExNameSaund{	
	if ([m_aryCurrentEx.exerciseNameSound isKindOfClass:[NSNull class]]) {
		m_aryCurrentEx.exerciseNameSound = @"silence";
	}	
	NSLog(@"soundName - %@", m_aryCurrentEx.exerciseNameSound);
	
	return m_aryCurrentEx.exerciseNameSound;
}

-(NSString *) getCurrentExName{	
	return m_aryCurrentEx.exerciseName;
}

-(NSString *) getCurrentExEquipment{
	
	return @"";
}

-(int) getCurrentExDuration{
	return [m_aryCurrentEx durationTime];
}

-(NSString *) getCurrentExVideo{	
	return [m_aryCurrentEx sampleVideoPath];
}

-(NSString *) getCurrentExDescription{	
	return @"no description";
}

-(NSExercice *)getM_aryCurrentEx{
	return m_aryCurrentEx;	
}

- (void)dealloc {
		
	[m_aryCurrentEx release];	
	[m_aryExercise release];
	[super dealloc];
}


@end
