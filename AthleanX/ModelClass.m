//
//  ModelClass.m
//  MyLADiet
//
//  Created by Stableflow on 20.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModelClass.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <CommonCrypto/CommonDigest.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaQuery.h>

#import "NSExercice.h"
#import "NSTraining.h"
#import "ExManager.h"
#import "MKStoreManager.h"

@implementation ModelClass

@synthesize firstOpen;

- (id) init
{
	self = [super init];
	if (self)
	{
		[self createEditableCopyOfDatabaseIfNeeded];
		
		NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
		NSString *Fpath = [documentsDirectory1 stringByAppendingPathComponent:@"ex_db.db"];
		
		m_dataBase = [[Sqlite alloc] init];
		[m_dataBase open:Fpath];
	}
	return self;
}

- (void) createEditableCopyOfDatabaseIfNeeded
{
	BOOL success;
	NSError *error;
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ex_db.db"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) return;
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ex_db.db"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void) dealloc
{
	[super dealloc];
}

- (void) setFreeById:(int)rowId
{
#if 0
	NSLog(@"res - %@",[db executeQuery:[NSString stringWithFormat:@"UPDATE ex SET LOCKED = 'FREE' WHERE id = %i",rowId]]);
#else
	[m_dataBase executeQuery:[NSString stringWithFormat:@"UPDATE ex SET LOCKED = 'FREE' WHERE id = %i", rowId]];
#endif
}

- (NSArray *) getAllTips
{
	return [m_dataBase executeQuery:@"select * from tips order by id"];
}

- (NSArray *) getTipsById:(int)tipId
{
	return [m_dataBase executeQuery:[NSString stringWithFormat:@"select * from tips where id = %i",tipId]];
}

- (NSArray *) getRowById:(int)rowId
{
	return [m_dataBase executeQuery:[NSString stringWithFormat:@"select * from ex where id = %i",rowId]];
}

- (NSArray *) getAllEx
{
	return [m_dataBase executeQuery:@"SELECT * from ex ORDER BY id"];
}

- (NSArray *) getAllDays
{
	return [m_dataBase executeQuery:@"select * from days order by id"];	
}

- (NSArray *) getDayByID:(int)dayID
{
	return [m_dataBase executeQuery:[NSString stringWithFormat:@"select * from days where id = %i order by id", dayID]];	
}

- (void) resetAllDays
{
	[m_dataBase executeQuery:@"UPDATE days SET passed = '0' "];
}

- (int) getCurrentTrDay
{
	NSString *query = @"SELECT * FROM days WHERE (passed = 0 AND training_Namber != 0) ORDER BY id LIMIT 1";
	
	NSArray *arr = [m_dataBase executeQuery:query];
	int currentTrDay = [[[arr objectAtIndex:0] valueForKey:@"id"] intValue];

	return currentTrDay;
}

- (void) fixDB
{
#if 0
	NSArray *fixArray = [[NSArray alloc] initWithArray:[db executeQuery:@"select sound60 from ex WHERE id = \"10\" "]];
	NSLog(@"res - %@",[db executeQuery:@"UPDATE ex SET SOUND60 = \"EN10_HangingXRaises60\" WHERE id = \"10\" "]);
#else
	[m_dataBase executeQuery:@"SELECT sound60 FROM ex WHERE id = \"10\" "];
	[m_dataBase executeQuery:@"UPDATE ex SET SOUND60 = \"EN10_HangingXRaises60\" WHERE id = \"10\" "];
#endif
}

- (void) setPassedDayByID:(int) dayID
{
	/// check IAP
	[m_dataBase executeQuery:[NSString stringWithFormat:@"UPDATE days SET passed = 1 WHERE id = %i ", dayID]];
}

- (void) setPassedDayByIDTr:(int)dayID
{
	[m_dataBase executeQuery:[NSString stringWithFormat:@"UPDATE days SET passed = 1 WHERE training_Namber = %i ", dayID]];
}

- (NSDictionary *) getAxByLevel:(int)lvl andCategory:(NSString *)category
{
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	NSArray *arr = [[NSArray alloc] initWithArray:[m_dataBase executeQuery:[NSString stringWithFormat:@"select * from ex WHERE ((\"30 Seconds\" = %i OR \"60 Seconds\" = %i) AND \"%@\" = 1) ORDER BY RANDOM() LIMIT 1",lvl, lvl, category]]];
	
	[dict setValue:[[arr objectAtIndex:0] valueForKey:@"ID"] forKey:@"ex"];
	
	if ([[[arr objectAtIndex:0] valueForKey:@"30 Seconds"] intValue] == lvl)
	{
		[dict setValue:@"30" forKey:@"time"];
	}
	else
	{
		[dict setValue:@"60" forKey:@"time"];
	}
	
	[arr release];
	return dict;
}

- (NSDictionary *) getAxByLevel:(int)lvl andCategory:(NSString *)category noDublicateInArr:(NSArray *)arrDbl
{
#if 1
	NSMutableString *excludeIdStr = [[NSMutableString alloc] init];
	for (NSMutableDictionary *tempDict in arrDbl)
	{
		if ( [tempDict valueForKey:@"ex"] )
			excludeIdStr = [NSMutableString stringWithFormat:@"%@ AND ID!=%@", excludeIdStr, [tempDict valueForKey:@"ex"]];
	}

	ExManager *exManager = [ExManager sharedExManager];
	NSString *includeEquipment = @"";
	for (NSString *equipment in exManager.arySelectedEquipment)
	{
		if ( [includeEquipment isEqualToString:@""] )
			includeEquipment = [NSString stringWithFormat:@"EQUIPMENT=\"%@\"", equipment];
		else
			includeEquipment = [NSString stringWithFormat:@"%@ OR EQUIPMENT=\"%@\"", includeEquipment, equipment];
	}
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM ex WHERE ((\"30 Seconds\" = %i OR \"60 Seconds\" = %i) AND \"%@\" = 1 %@ AND (%@) ) ORDER BY RANDOM() LIMIT 1", lvl, lvl, category, excludeIdStr, includeEquipment];
	if ( [includeEquipment isEqualToString:@""] )
		query = [NSString stringWithFormat:@"SELECT * FROM ex WHERE ((\"30 Seconds\" = %i OR \"60 Seconds\" = %i) AND \"%@\" = 1 %@ ) ORDER BY RANDOM() LIMIT 1", lvl, lvl, category, excludeIdStr];
	NSArray *arr = [m_dataBase executeQuery:query];
	if ( !arr || arr.count == 0 )
		return nil;
#else
	ExManager *exManager = [ExManager sharedExManager];
	NSString *includeEquipment = @"";
	for (NSString *equipment in exManager.arySelectedEquipment)
	{
		if ( [includeEquipment isEqualToString:@""] )
			includeEquipment = [NSString stringWithFormat:@"EQUIPMENT=\"%@\"", equipment];
		else
			includeEquipment = [NSString stringWithFormat:@"%@ OR EQUIPMENT=\"%@\"", includeEquipment, equipment];
	}
	
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM ex WHERE ((\"30 Seconds\" = %i OR \"60 Seconds\" = %i) AND \"%@\" = 1 AND (%@) ) ORDER BY RANDOM() LIMIT 1", lvl, lvl, category, includeEquipment];
	if ( [includeEquipment isEqualToString:@""] )
		query = [NSString stringWithFormat:@"SELECT * FROM ex WHERE ((\"30 Seconds\" = %i OR \"60 Seconds\" = %i) AND \"%@\" = 1) ORDER BY RANDOM() LIMIT 1", lvl, lvl, category];
	NSArray *arr = [m_dataBase executeQuery:query];
	if ( !arr || arr.count == 0 )
		return nil;
#endif
	
	[dict setValue:[[arr objectAtIndex:0] valueForKey:@"ID"] forKey:@"ex"];
	
	if ([[[arr objectAtIndex:0] valueForKey:@"30 Seconds"] intValue] == lvl)
	{
		[dict setValue:@"30" forKey:@"time"];
	}
	else
	{
		[dict setValue:@"60" forKey:@"time"];
	}
	
	[arr release];
	return dict;
}

- (NSDictionary *) axWithLevel:(int)level andCategory:(NSString *)category noDublicateInArr:(NSMutableArray *)array
{
	ExManager *exManager = [ExManager sharedExManager];
	BOOL bFound = NO;
	int loopCount = 0;
	while ( !bFound && loopCount < 1000 )
//	while ( !bFound )
	{
		loopCount++;
		
		NSDictionary *dict = [self getAxByLevel:level andCategory:category noDublicateInArr:array];
		if ( !dict )
			continue;
		
		int exID = [[dict valueForKey:@"ex"] intValue];
		if ( exID == 86 && array.count == 0 )
			continue;
		
		if ( [exManager isFreeWithNo:exID] )
		{
			return [NSDictionary dictionaryWithDictionary:dict];
			bFound = YES;
		}
	}

#if 0
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM ex WHERE \"%@\"=1;",
					   category];
	NSMutableArray *aryTemp = [NSMutableArray arrayWithArray:[m_dataBase executeQuery:query]];
	for (NSDictionary *dict in aryTemp)
	{
		int exID = [[dict valueForKey:@"ID"] intValue];
		if ( [exManager isFreeWithNo:exID] )
			return dict;
	}
#endif
	
	NSLog(@"Cannot find ax with level");
	return nil;
}

- (NSArray *) generateTraningForBasic
{
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
	NSDictionary *rest45sec = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1", @"ex", @"45", @"time", nil];
	
#if 0
	BOOL typeBool = arc4random() % 2;
	if ( typeBool )
	{
		[self addResultToArray:arr dict:[self getAxByLevel:1 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:1 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self getAxByLevel:1 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self getAxByLevel:1 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self getAxByLevel:1 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#else
	BOOL typeBool = arc4random() % 2;
	if ( typeBool )
	{
		[self addResultToArray:arr dict:[self axWithLevel:1 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:1 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self axWithLevel:1 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self axWithLevel:1 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest45sec];
        [self addResultToArray:arr dict:[self axWithLevel:1 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#endif
	
	[rest45sec release];
	
	if ( arr.count == 2 )
		return nil;
	return arr;
}

- (NSArray *) generateTraningForNext
{
	NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
	NSDictionary *rest30sec = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1", @"ex", @"30", @"time", nil];
	
#if 0
	BOOL typeBool = arc4random() % 2;
	if (typeBool)
	{
		[self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:1 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#else
	BOOL typeBool = arc4random() % 2;
	if (typeBool)
	{
		[self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:1 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#endif
	
	[rest30sec release];
	
	if ( arr.count == 2 )
		return nil;
	
	return arr;
}

- (NSArray *) generateTraningForMax
{
	NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
	NSDictionary *rest30sec = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1", @"ex", @"30", @"time", nil];
	
#if 0
	BOOL typeBool = arc4random() % 2;
	if (typeBool)
	{
		[self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#else
	int typeBool = arc4random() % 3;
	if (typeBool == 0)
	{
		[self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else if ( typeBool == 1 )
	{
		[self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
		[self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:2 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#endif
	
	[rest30sec release];
	
	if ( arr.count == 2 )
		return nil;
	
	return arr;
}

- (NSArray *) generateTraningForXTreme
{
	NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
	NSDictionary *rest30sec = [[NSDictionary alloc] initWithObjectsAndKeys:@"-1", @"ex", @"30", @"time", nil];
	
#if 0
	BOOL typeBool = arc4random() % 2;
	if (typeBool)
	{
		[self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self getAxByLevel:4 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#else
	int typeBool = arc4random() % 3;
	if (typeBool == 0)
	{
		[self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
	else
	{
		[self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_L" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_BUR" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_M" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:rest30sec];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_O" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:3 andCategory:@"CATEGORY_T" noDublicateInArr:arr]];
        [self addResultToArray:arr dict:[self axWithLevel:4 andCategory:@"CATEGORY_TDR" noDublicateInArr:arr]];
	}
#endif
	
	[rest30sec release];
	
	if ( arr.count == 1 )
		return nil;
	
	return arr;
}

- (BOOL) addResultToArray:(NSMutableArray *)array dict:(NSDictionary *)dict
{
	if ( !dict || !array )
	{
		return NO;
	}

	if ( array.count > 0 )
	{
		int lastValue = [[array.lastObject valueForKey:@"ex"] intValue];
		int curValue = [[dict valueForKey:@"ex"] intValue];
		if ( lastValue == curValue && lastValue == -1 )
		{
			return NO;
		}
	}
	else
	{
		int curValue = [[dict valueForKey:@"ex"] intValue];
		if ( curValue == -1 )
		{
			return NO;
		}
	}
	
	[array addObject:dict];
	
	return YES;
}

- (NSExercice *) getExercice30ById:(int)exerciceId
{
	NSExercice *curEx = [[[NSExercice alloc] init] autorelease];
	NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[[self getRowById:exerciceId] objectAtIndex:0]];
	
	curEx.exerciseName	= [dict valueForKey:@"NAME"];
	curEx.exerciceId	= [[dict valueForKey:@"ID"] intValue];
	curEx.locked		= [dict valueForKey:@"LOCKED"];
	curEx.pts			= [[dict valueForKey:@"PTS"] intValue];
	
	if ([[dict valueForKey:@"VIDEO"] length] == 1)
	{
		curEx.sampleVideoPath = [NSString stringWithFormat:@"0%@",[dict valueForKey:@"VIDEO"]];
	}
	else
	{
		curEx.sampleVideoPath = [dict valueForKey:@"VIDEO"];
	}
	curEx.exerciseNameSound = [dict valueForKey:@"SOUND30"];
	curEx.durationTime = 30;
	curEx.anatomyCode = [dict valueForKey:@"ANATOMY LISTING CODE"];
	
	curEx.equipmentSound = [dict valueForKey:@"EQUIPMENT"];
	if ( [curEx.equipmentSound isEqualToString:@"NO EQUIPMENT"] )
		NSLog(@"dog = %d", curEx.exerciceId);
	curEx.side = [dict valueForKey:@"SIDE"];
	curEx.x2 = [dict valueForKey:@"X2"];
	[dict release];
   
	return curEx;
}

- (NSExercice *) getExercice60ById:(int)exerciceId
{
	NSExercice *curEx = [[[NSExercice alloc] init] autorelease]; 
	NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[[self getRowById:exerciceId] objectAtIndex:0]];
	
	curEx.exerciseName = [dict valueForKey:@"NAME"];
	curEx.exerciceId = [[dict valueForKey:@"ID"] intValue];
	curEx.locked = [dict valueForKey:@"LOCKED"];
	curEx.pts = [[dict valueForKey:@"PTS"] intValue];
	if ([[dict valueForKey:@"VIDEO"] length] == 1)
	{
		curEx.sampleVideoPath = [NSString stringWithFormat:@"0%@",[dict valueForKey:@"VIDEO"]];
	}
	else
	{
		curEx.sampleVideoPath = [dict valueForKey:@"VIDEO"];
	}
	curEx.exerciseNameSound = [dict valueForKey:@"SOUND60"];
	curEx.durationTime = 60;	
	curEx.anatomyCode = [dict valueForKey:@"ANATOMY LISTING CODE"];
	
	curEx.equipmentSound = [dict valueForKey:@"EQUIPMENT"];
	if ( [curEx.equipmentSound isEqualToString:@"NO EQUIPMENT"] )
		NSLog(@"dog = %d", curEx.exerciceId);
	curEx.side = [dict valueForKey:@"SIDE"];
	curEx.x2 = [dict valueForKey:@"X2"];
	[dict release];	
	
	return curEx;
}

#if 1
- (NSURL *) sampleVideoURLWithID:(int)exID
{
	NSExercice *ex = [self getExercice30ById:exID];
	NSString *path = [[NSBundle mainBundle] pathForResource:ex.sampleVideoPath ofType:@"mp4"];
	return [NSURL fileURLWithPath:path];
}
#endif

- (NSExercice *) getRestBySec:(int)sec
{
	NSExercice *curEx = [[[NSExercice alloc] init] autorelease]; 
	
	curEx.exerciseName = @"Rest";//[dict valueForKey:@"NAME"];
	curEx.exerciceId = -1;//[[dict valueForKey:@"ID"] intValue];
	curEx.locked = @"FREE";//[dict valueForKey:@"LOCKED"];
	curEx.pts = 0;//[[dict valueForKey:@"PTS"] intValue];
	curEx.sampleVideoPath = nil;
	   
	if (sec == 30)
	{
		curEx.exerciseNameSound = @"10_30SecondsRest";
	}
	if (sec == 45)
	{
		curEx.exerciseNameSound = @"9_45SecondRest";
	}
	
	curEx.durationTime = sec;  
	curEx.anatomyCode = @"";
	
	curEx.equipmentSound = @"NO EQUIPMENT";

	return curEx;
}

- (void) getTr
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"tr" ofType:@"plist"];
	
	NSArray *arr = [[[NSArray alloc] initWithContentsOfFile:path] autorelease];
	NSLog(@"tr - %@",arr);
}

- (NSArray *) getTrainingByDay:(int)dayNumber
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"tr" ofType:@"plist"];	 
	NSArray *arr = [[[NSArray alloc] initWithContentsOfFile:path] autorelease];
	
	if ( 0 < dayNumber && dayNumber < arr.count )
		return [arr objectAtIndex:dayNumber-1];

	return [arr objectAtIndex:3];
}

- (NSDictionary *) getMasteVaultDict
{
	if (![self getSavedFromFile:@"ex.plist"])
	{
		[self createMasterVaultPlist];
	}
	
	return [self getSavedFromFile:@"ex.plist"];
}

- (void) createMasterVaultPlist
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"ex" ofType:@"plist"];
	NSArray *arr = [[[NSArray alloc] initWithContentsOfFile:path] autorelease];
	[self saveDict:[NSDictionary dictionaryWithObject:arr forKey:@"ex"] toFile:@"ex.plist"];
}

- (void) saveMasterVaultDict:(NSDictionary *)dict
{
	[self saveDict:dict toFile:@"ex.plist"];
}

- (NSString *) isSendingEmail
{
	if ([[[self getSavedFromFile:@"email.plist"] objectForKey:@"status"] isEqual:@"em"])
	{
		return [[self getSavedFromFile:@"email.plist"] valueForKey:@"email"];
	}
	
	return @"code";
}

- (void) createSendingEmailPlist:(NSString *)email
{
	NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
	[dict setValue:email forKey:@"email"];  
	[dict setValue:@"em" forKey:@"status"];
	[self saveDict:dict toFile:@"email.plist"];	
}

- (BOOL) createSendingEmailPlistAndVeref:(NSString *)code
{
	if ([code isEqual:@"ATX6PP2012X"])
	{
		NSMutableDictionary *dict = [[[NSMutableDictionary alloc] initWithDictionary:[self getSavedFromFile:@"email.plist"]] autorelease];
		NSLog(@"get Saved %@", dict);
		[dict setValue:@"code" forKey:@"status"];
		[self saveDict:dict toFile:@"email.plist"];
		return YES;
	}
	else
	{
		return NO;
	}
}

- (int) getPTS
{
	if (![self getSavedFromFile:@"PTS.plist"])
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"PTS" ofType:@"plist"];
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
		[self saveDict:dict toFile:@"PTS.plist"];
	}
	
	return [[[[self getSavedFromFile:@"PTS.plist"] valueForKey:@"dict"] valueForKey:@"pts"] intValue];
}

- (void) setPTS:(int)pts
{
	NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:[self getSavedFromFile:@"PTS.plist"]];	
	[[dict valueForKey:@"dict"] setObject:[NSString stringWithFormat:@"%i", pts] forKey:@"pts"];
	[self saveDict:dict toFile:@"PTS.plist"];  
}

- (BOOL) connectedToNetwork
{
	const char *host = "www.google.com";
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
	SCNetworkReachabilityFlags flags;
	BOOL connected = SCNetworkReachabilityGetFlags(reachability, &flags);
	BOOL isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
	CFRelease(reachability);
	return isConnected;
}

- (NSMutableArray *) removeEqual:(NSArray *)arr
{
	NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
	NSMutableArray *copy = [NSMutableArray arrayWithCapacity:0];

	for (int i = 0; i < tempArr.count; i++)
	{
		NSString *itemA = (NSString *)[tempArr objectAtIndex:i];
		BOOL bFound = NO;
		for (int j = 0; j < copy.count; j++)
		{
			NSString *itemB = (NSString *)[copy objectAtIndex:j];
			if ( [itemA.lowercaseString isEqualToString:itemB.lowercaseString] )
			{
				bFound = YES;
				break;
			}
		}
		
		if ( !bFound )
			[copy addObject:itemA];
	}

	return copy;
}

#pragma mark Methods ========== {

- (void) saveDictNew:(NSDictionary *)dict toFile:(NSString *)file
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
	
	NSLog(@"%@",path);
	NSArray *arr = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:arr];

	[mArray addObject:dict];
	NSArray *pathsW = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryW = [pathsW objectAtIndex:0];
	NSString *pathW = [documentsDirectoryW stringByAppendingPathComponent:file];
	[mArray writeToFile:pathW atomically:YES];
	[mArray release];
}

- (void) saveDict:(NSDictionary *)dict toFile:(NSString *)file
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
	
	NSLog(@"%@",path);
	NSArray *arr = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray *mArray = [[NSMutableArray alloc] initWithArray:arr];
	[mArray removeAllObjects];
	[mArray addObject:dict];
	NSArray *pathsW = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectoryW = [pathsW objectAtIndex:0];
	NSString *pathW = [documentsDirectoryW stringByAppendingPathComponent:file];
	[mArray writeToFile:pathW atomically:YES];
	[mArray release];
}

- (NSDictionary *) getSavedFromFile:(NSString *)file
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
	return [[NSArray arrayWithContentsOfFile:path] objectAtIndex:0];
}

- (void) deleteFile:(NSString *)file
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:file];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:path error:NULL];
}

- (NSString *)sha1:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(cStr, strlen(cStr), result);
	NSString *s = [NSString  stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
				   result[0], result[1], result[2], result[3], result[4],
				   result[5], result[6], result[7],
				   result[8], result[9], result[10], result[11], result[12],
				   result[13], result[14], result[15],
				   result[16], result[17], result[18], result[19]];
	
	return s.lowercaseString;
}


- (void) createPlists
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"birds" ofType:@"plist"];	
	NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
		
	NSLog(@"dict --- %@",path);
	NSLog(@"dict >>- %@",str);   
	
	[str release];
}


- (BOOL) validateEmail: (NSString *) candidate
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
	return [emailTest evaluateWithObject:candidate];
}

- (void) startDatePlistCreate
{
	if (![self getSavedFromFile:@"startDate.plist"])
	{
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		[dict setValue:[NSDate date] forKey:@"startDate"];
		
		[self saveDict:dict toFile:@"startDate.plist"];
		
		[dict release];
	}
}

- (int) getCurrentDayNumber
{
	if ([self getSavedFromFile:@"startDate.plist"])
	{
		int currentDayNumber = [self howManyDaysHavePast:[[self getSavedFromFile:@"startDate.plist"] valueForKey:@"startDate"]]+1;
		
		/// check IAP
		MKStoreManager *mkManager = [MKStoreManager sharedManager];
		if ( currentDayNumber > 5 && currentDayNumber <= 21 )
		{
			if ( !mkManager.purchasedGroup1 && !mkManager.purchasedFullVersion )
				currentDayNumber = 5;
		}
		else if ( currentDayNumber > 21 )
		{
			if ( !mkManager.purchasedGroup2 && !mkManager.purchasedFullVersion )
				currentDayNumber = 21;
		}
		
		return currentDayNumber;
	}
	
	return 0;   
}

- (int) howManyDaysHavePast:(NSDate*)lastDate
{
	NSDate *startDate = lastDate;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	unsigned int unitFlags = NSDayCalendarUnit;
	NSDateComponents *components = [gregorian components:unitFlags
												fromDate:startDate
												  toDate:[NSDate date] options:0];
	int days = [components day];
	
	[gregorian release];
	return days;
}

- (NSArray *) getPlaylists
{
	MPMediaQuery *playlistsQuery = [MPMediaQuery playlistsQuery];
	NSArray *playlists = [playlistsQuery collections];
	
	for (MPMediaPlaylist *playlist in playlists)
	{
		NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
	}
	
	return playlists;
}

- (NSArray *) getAlbums
{
	MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
	NSArray *albums = [albumsQuery collections];
	
	NSLog(@">>>name - %@",[[albums objectAtIndex:1] valueForProperty: MPMediaItemPropertyTitle]);  
	return albums;
}

- (NSString *) second2minut:(float)time
{	
	float minutes = floor(time/60);
	float seconds = round(time - minutes * 60);
	if (seconds < 10)
	{
		return [NSString stringWithFormat:@"%0.0f:0%0.0f",minutes, seconds];
	}
	
	return [NSString stringWithFormat:@"%0.0f:%0.0f",minutes, seconds];  
}

#pragma mark ================== }

- (void)saveData:(id)data toArchive:(NSString *)arshive
{
	NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:data];
	
	[[NSUserDefaults standardUserDefaults] setObject:data1 forKey:arshive];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)getDataFromArchive:(NSString *)arshive
{
	NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:arshive];
	
	return [NSKeyedUnarchiver unarchiveObjectWithData:data2];
}

- (NSString *) getEquipmentWithExNo:(int)exNo
{
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM ex WHERE ID=%d", exNo];
	NSArray *arr = [m_dataBase executeQuery:query];
	
	if ( arr.count <= 0 )
		return nil;
	
	NSDictionary *dict = [arr objectAtIndex:0];
	NSString *equipment = [dict objectForKey:@"EQUIPMENT"];
	
	NSLog(@"equipment = %@", equipment);
	
	return equipment;
}

@end