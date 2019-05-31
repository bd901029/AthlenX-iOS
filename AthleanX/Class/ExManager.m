//
//  ExManager.m
//  AthleanX
//
//  Created by Cai DaRong on 1/5/13.
//
//

#import "ExManager.h"

ExManager *g_exManager = nil;

@implementation ExManager

@synthesize arySelectedEquipment = m_arySelectedEquipment;

+ (id) sharedExManager
{
	if ( !g_exManager )
		g_exManager = [[ExManager alloc] init];
	
	return g_exManager;
}

+ (NSMutableArray *) allEquipmentName
{
	return [NSMutableArray arrayWithObjects:@"No Equipment",
			@"Tennis Ball",
			@"Chinup or Hanging Bar",
			@"Resistance Band",
			@"Physioball", nil];
}

- (id) init
{
	if ( self = [super init] )
	{
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		m_path = [documentsDirectory stringByAppendingPathComponent:@"exState.db"];
		
		[self createEditableDatabase];
		
		m_database = [[Sqlite alloc] init];
		[m_database open:m_path];
		
		[self loadEquipment];
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

- (void) createEditableDatabase
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if ( ![fileManager fileExistsAtPath:m_path] )
	{
		NSError *error = nil;
		NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"exState.db"];
		[fileManager copyItemAtPath:resourcePath toPath:m_path error:&error];
		
		if ( error )
			NSLog(@"create database error : %@", error);
	}
}

- (void) loadEquipment
{
	NSUserDefaults *appSetting = [NSUserDefaults standardUserDefaults];
	m_arySelectedEquipment = [[NSMutableArray alloc] init];
	for (int i = 0; i < EQUIPMENT_COUNT_MAX; i++)
	{
		NSString *key = [NSString stringWithFormat:@"Equipment %d", i];
		NSString *equipment = [appSetting stringForKey:key];
		
		if ( equipment && ![equipment isEqualToString:@""] )
		{
			[m_arySelectedEquipment addObject:equipment];
		}
	}
}

- (void) saveEquipment
{
	NSUserDefaults *appSetting = [NSUserDefaults standardUserDefaults];
	for (int i = 0; i < EQUIPMENT_COUNT_MAX; i++)
	{
		NSString *key = [NSString stringWithFormat:@"Equipment %d", i];
		if ( i < m_arySelectedEquipment.count )
		{
			[appSetting setValue:[m_arySelectedEquipment objectAtIndex:i] forKey:key];
		}
		else
		{
			[appSetting setValue:@"" forKey:key];
		}
	}
	
	[appSetting synchronize];
}

- (void) setEquipment:(NSMutableArray *)aryEquipment
{
	if ( m_arySelectedEquipment )
		[m_arySelectedEquipment release];
	
	m_arySelectedEquipment = [[NSMutableArray alloc] initWithArray:aryEquipment];
	
	[self saveEquipment];
}

- (BOOL) isFreeWithName:(NSString *)exName
{
	exName = [exName stringByReplacingOccurrencesOfString:@"\"" withString:@"+"];
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM exState WHERE NAME LIKE '%@%@%@';", @"%", exName, @"%"];
	NSString *result = [[[m_database executeQuery:query] lastObject] objectForKey:@"STATUS"];
	if ( [result isEqualToString:@"FREE"] )
		return YES;
	
	return NO;
}

- (BOOL) isFreeWithNo:(int)exNo
{
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM exState WHERE rowid='%d';", exNo];
	NSString *result = [[[m_database executeQuery:query] lastObject] objectForKey:@"STATUS"];
	if ( [result isEqualToString:@"FREE"] )
	{
		return YES;
	}
	
	return NO;
}

- (void) setStateWithName:(NSString *)exName state:(BOOL)free
{
	exName = [exName stringByReplacingOccurrencesOfString:@"\"" withString:@"+"];
	NSString *query = [NSString stringWithFormat:@"UPDATE exState SET STATUS='%@' FROM \"exState\" WHERE NAME LIKE '%@%@%@';", free ? @"FREE" : @"PAID", @"%", exName, @"%"];
	[m_database executeQuery:query];
}

- (void) setFreeWithID:(int)exID state:(BOOL)free
{
	NSString *query = [NSString stringWithFormat:@"UPDATE exState SET STATUS='%@' WHERE ID=%d;", free ? @"FREE" : @"PAID", exID];
	[m_database executeQuery:query];
}

- (int) pointWithName:(NSString *)exName
{
	exName = [exName stringByReplacingOccurrencesOfString:@"\"" withString:@"+"];
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM exState WHERE NAME LIKE '%@%@%@';", @"%", exName, @"%"];
	NSNumber *result = [[[m_database executeQuery:query] lastObject] objectForKey:@"POINTS"];
	return [result integerValue];
}

- (NSString *) equipWithName:(NSString *)exName
{
	exName = [exName stringByReplacingOccurrencesOfString:@"\"" withString:@"+"];
	NSString *query = [NSString stringWithFormat:@"SELECT * FROM exState WHERE NAME LIKE '%@%@%@';", @"%", exName, @"%"];
	NSString *result = [[[m_database executeQuery:query] lastObject] objectForKey:@"EQUIPMENT"];
	return result;
}

- (void) purchaseWithType:(PurchaseType)type
{
	switch (type)
	{
		case PurchaseGroup1:
		{
			NSString *query = [NSString stringWithFormat:@"UPDATE \"exState\" SET \"STATUS\"='FREE' WHERE \"GROUP\"='1';"];
			[m_database executeQuery:query];
			break;
		}
		case PurchaseGroup2:
		{
			NSString *query = [NSString stringWithFormat:@"UPDATE \"exState\" SET \"STATUS\"='FREE' WHERE \"GROUP\"='2';"];
			[m_database executeQuery:query];
			break;
		}
		case PurchaseFullVersion:
		{
			NSString *query = [NSString stringWithFormat:@"UPDATE \"exState\" SET \"STATUS\"='FREE';"];
			[m_database executeQuery:query];
			
			break;
		}
		default:
			break;
	}
}

@end
