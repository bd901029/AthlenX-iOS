//
//  ExManager.h
//  AthleanX
//
//  Created by Cai DaRong on 1/5/13.
//
//

#import <Foundation/Foundation.h>
#import "Sqlite.h"

#define EQUIPMENT_COUNT_MAX		5

typedef enum _PurchaseType {
	PurchaseGroup1 = 0,
	PurchaseGroup2,
	PurchaseFullVersion
} PurchaseType ;

@interface ExManager : NSObject
{
	NSString *m_path;
	Sqlite *m_database;
	
	NSMutableArray *m_arySelectedEquipment;
}

@property (nonatomic, retain) NSMutableArray *arySelectedEquipment;

+ (id) sharedExManager;
+ (NSMutableArray *) allEquipmentName;

- (void) createEditableDatabase;

- (void) saveEquipment;
- (void) setEquipment:(NSMutableArray *)aryEquipment;

- (BOOL) isFreeWithName:(NSString *)exName;
- (BOOL) isFreeWithNo:(int)exNo;
- (void) setStateWithName:(NSString *)exName state:(BOOL)free;
- (void) setFreeWithID:(int)exID state:(BOOL)free;

- (int) pointWithName:(NSString *)exName;

- (NSString *) equipWithName:(NSString *)exName;

- (void) purchaseWithType:(PurchaseType)type;

@end
