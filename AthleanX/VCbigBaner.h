//
//  VCbigBaner.h
//  AthleanX
//
//  Created by Dmitriy on 31.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"

@class AthleanXAppDelegate;


@interface VCbigBaner : UIViewController{
	AthleanXAppDelegate *app;
	ModelClass *mc;
	
	IBOutlet UIImageView *adImage;
	
}

+ (id) instance;

@end
