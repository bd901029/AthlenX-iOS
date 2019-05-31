//
//  VCMealPlan.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VCMealPlan : UIViewController {
	
}

+ (VCMealPlan *) instance;

- (IBAction) back;
- (IBAction) shuffleMeal;
- (IBAction) sixPackMealPlan;
- (IBAction) groceryList;

@end
