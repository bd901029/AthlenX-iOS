//
//  VCDisclamer.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 18.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCDisclamer : UIViewController {
	
}

+ (VCDisclamer *) instance;

- (IBAction) close;
- (IBAction) dontShow;

@end
