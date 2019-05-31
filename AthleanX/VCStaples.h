//
//  VCStaples.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 02.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCStaples : UIViewController {
	IBOutlet UIWebView *stablesWebView;
}

+ (VCStaples *) instance;

- (IBAction) back;
- (IBAction) tips;

@end
