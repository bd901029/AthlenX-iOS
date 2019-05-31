//
//  VCShuffleMeal.h
//  AthleanX
//
//  Created by Dmitriy on 06.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VCShuffleMeal : UIViewController {
	
}

+ (VCShuffleMeal *) instance;

- (IBAction) back;
- (IBAction) shuffleBreakfast;
- (IBAction) shuffleLunch;
- (IBAction) shuffleDinner;
- (IBAction) shuffleSnack;

@end
