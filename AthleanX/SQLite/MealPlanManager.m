//
//  DBMealPlan.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MealPlanManager.h"
#import "Sqlite.h"

#import "HTMLParser.h"
#import "HTMLNode.h"

@implementation MealPlanManager

- (id)init
{
	self = [super init];
	if (self) {
		[self createEditableCopyOfDatabaseIfNeeded];
		NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
		NSString *Fpath = [documentsDirectory1 stringByAppendingPathComponent:@"ax.sqlite"];

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
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"ax.sqlite"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	success = [fileManager fileExistsAtPath:writableDBPath];
	if (success)
		return;
	
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ax.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if ( !success )
	{
		NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) stripDoubleSpaceFrom:(NSString *)str
{
	if ( str == nil )
		return nil;
	
	while ([str rangeOfString:@"  "].location != NSNotFound)
	{
		str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	}
	
	[str stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@""]];
	
	return str;
}

- (NSString *) getDayInHTML:(NSInteger)dayNo
{
	NSString *pach = [[NSBundle mainBundle] pathForResource:@"dayCSS" ofType:@"html"];
	NSString *css = [NSString stringWithContentsOfFile:pach encoding:NSUTF8StringEncoding error:nil];
	
	NSDictionary *dayDataDict = [[m_dataBase executeQuery:[NSString stringWithFormat:@"select * from MealDay where id = %i", dayNo]] lastObject];
	NSString *dayData = [dayDataDict objectForKey:@"Day"];
	NSString *str = [[NSString stringWithFormat:css, dayData] stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
	return [[str stringByReplacingOccurrencesOfString:@"%" withString:@"%"] stringByReplacingOccurrencesOfString:@"¬Ω" withString:@"0,5"];
}

- (NSInteger) getDaysCount
{
	return [[[[m_dataBase executeQuery:@"select count(*) from MealDay;"] lastObject] objectForKey:@"count(*)"] integerValue];
}

- (NSString *) getBreakfastForDay:(NSInteger)dayNo
{
	NSString *mealPlanWithHtml = [self stripDoubleSpaceFrom:[[[m_dataBase executeQuery:[NSString stringWithFormat:@"SELECT Breakfast FROM \"6Pack\" WHERE day = %i;",dayNo]] lastObject] objectForKey:@"Breakfast"]];
	mealPlanWithHtml = [mealPlanWithHtml stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
	mealPlanWithHtml = [[mealPlanWithHtml stringByReplacingOccurrencesOfString:@"%" withString:@"%"] stringByReplacingOccurrencesOfString:@"¬Ω" withString:@"0,5"];
	
	HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:mealPlanWithHtml error:nil];
	HTMLNode *htmlBody = [htmlParser body];
	
	NSString *result = @"";
	for ( HTMLNode *node in htmlBody.children )
	{
		if ( [node.className isEqualToString:@"p2"] )
		{
			NSString *content = node.allContents;
			
			result = [NSString stringWithFormat:@"%@\n%@", result, content];
		}
	}
	
	return result;
}

- (NSString *) getLunchForDay:(NSInteger)dayNo
{
	NSString *mealPlanWithHtml = [self stripDoubleSpaceFrom:[[[m_dataBase executeQuery:[NSString stringWithFormat:@"SELECT Lunch FROM \"6Pack\" WHERE day = %i;",dayNo]] lastObject] objectForKey:@"Lunch"]];
	mealPlanWithHtml = [mealPlanWithHtml stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
	mealPlanWithHtml = [[mealPlanWithHtml stringByReplacingOccurrencesOfString:@"%" withString:@"%"] stringByReplacingOccurrencesOfString:@"¬Ω" withString:@"0,5"];
	
	HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:mealPlanWithHtml error:nil];
	HTMLNode *htmlBody = [htmlParser body];
	
	NSString *result = @"";
	for ( HTMLNode *node in htmlBody.children )
	{
		if ( [node.className isEqualToString:@"p2"] )
		{
			NSString *content = node.allContents;
			
			result = [NSString stringWithFormat:@"%@\n%@", result, content];
		}
	}
	
	return result;
}

- (NSString *)getDinnerForDay:(NSInteger)dayNo
{
	NSString *mealPlanWithHtml = [self stripDoubleSpaceFrom:[[[m_dataBase executeQuery:[NSString stringWithFormat:@"SELECT Dinner FROM \"6Pack\" WHERE day = %i;",dayNo]] lastObject] objectForKey:@"Dinner"]];
	mealPlanWithHtml = [mealPlanWithHtml stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
	mealPlanWithHtml = [[mealPlanWithHtml stringByReplacingOccurrencesOfString:@"%" withString:@"%"] stringByReplacingOccurrencesOfString:@"¬Ω" withString:@"0,5"];
	
	HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:mealPlanWithHtml error:nil];
	HTMLNode *htmlBody = [htmlParser body];
	
	NSString *result = @"";
	for ( HTMLNode *node in htmlBody.children )
	{
		if ( [node.className isEqualToString:@"p2"] )
		{
			NSString *content = node.allContents;
			
			result = [NSString stringWithFormat:@"%@\n%@", result, content];
		}
	}
	
	return result;
}

- (NSString *) getSnackForDay:(NSInteger)dayNo snackId:(NSInteger)snId
{
	NSString *key = [NSString stringWithFormat:@"Snack%d", snId];
	NSString *query = [NSString stringWithFormat:@"SELECT %@ FROM \"6Pack\" WHERE day = %i;", key, dayNo];
	NSString *mealPlanWithHtml = [self stripDoubleSpaceFrom:[[[m_dataBase executeQuery:query] lastObject] objectForKey:key]];
	mealPlanWithHtml = [mealPlanWithHtml stringByReplacingOccurrencesOfString:@"‚Äô" withString:@"'"];
	mealPlanWithHtml = [[mealPlanWithHtml stringByReplacingOccurrencesOfString:@"%" withString:@"%"] stringByReplacingOccurrencesOfString:@"¬Ω" withString:@"0,5"];
	
	HTMLParser *htmlParser = [[HTMLParser alloc] initWithString:mealPlanWithHtml error:nil];
	HTMLNode *htmlBody = [htmlParser body];
	
	NSString *result = @"";
	for ( HTMLNode *node in htmlBody.children )
	{
		if ( [node.className isEqualToString:@"p2"] )
		{
			NSString *content = node.allContents;
			
			result = [NSString stringWithFormat:@"%@\n%@", result, content];
		}
	}
	
	return result;
}

- (NSString *)getWeekInHTML:(NSInteger)weekNo {
	return [self stripDoubleSpaceFrom:[[[m_dataBase executeQuery:[NSString stringWithFormat:@"SELECT Text FROM GroceryList WHERE week = %i;",weekNo]] lastObject] objectForKey:@"Text"]];
}

- (NSArray *)getBreakfastList
{
	return [m_dataBase executeQuery:@"SELECT Breakfast FROM \"6Pack\";"];
}

- (NSArray *)getLunchList
{
	return [m_dataBase executeQuery:@"SELECT Lunch FROM \"6Pack\";"];
}

- (NSArray *)getDinnerList
{
	return [m_dataBase executeQuery:@"SELECT Dinner FROM \"6Pack\";"];
}

- (NSArray *)getSnackList:(NSInteger)snId
{
	switch (snId)
	{
		case 1:
			return [m_dataBase executeQuery:@"SELECT \"Snack1\" FROM \"6Pack\";"];
		case 2:
			return [m_dataBase executeQuery:@"SELECT \"Snack2\" FROM \"6Pack\";"];
		case 3:
			return [m_dataBase executeQuery:@"SELECT \"Snack3\" FROM \"6Pack\";"];
	}
	return nil;
}

@end
