//
//  DBMealPlan.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 26.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sqlite;

@interface MealPlanManager : NSObject {
	Sqlite *m_dataBase;
}

- (void)createEditableCopyOfDatabaseIfNeeded;
- (NSString *) getDayInHTML:(NSInteger)dayNo;
- (NSString *) getBreakfastForDay:(NSInteger)dayNo;
- (NSString *) getLunchForDay:(NSInteger)dayNo;
- (NSString *) getDinnerForDay:(NSInteger)dayNo;
- (NSString *) getSnackForDay:(NSInteger)dayNo snackId:(NSInteger)snId;

- (NSString *) getWeekInHTML:(NSInteger)weekNo;
- (NSInteger) getDaysCount;
- (NSArray *) getBreakfastList;
- (NSArray *) getLunchList;
- (NSArray *) getDinnerList;
- (NSArray *) getSnackList:(NSInteger)snId;

@end
