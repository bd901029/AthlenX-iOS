//
//  VCSetMusic.h
//  AthleanX
//
//  Created by Dmitriy on 09.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AthleanXAppDelegate;

@interface VCSetMusic : UIViewController {
	IBOutlet UIButton *btn1;
	IBOutlet UIButton *btn2;
	IBOutlet UIButton *btn3;
	IBOutlet UIButton *btn4;
	
	AthleanXAppDelegate *app;
	
	NSArray *startArray;
}

- (id)initWithArray:(NSArray *)arr;
- (IBAction) back;
- (IBAction) noMusic;
- (IBAction) libraryMusic;
- (IBAction) start;
- (IBAction) playlistMus;
- (IBAction) albomsMus;
@end
