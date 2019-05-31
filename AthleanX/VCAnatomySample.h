//
//  VCAnatomySample.h
//  AthleanX
//
//  Created by Dmitriy on 29.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelClass.h"
#import <MediaPlayer/MediaPlayer.h>


@class MoviePlayer;

@interface VCAnatomySample : UIViewController <MPMediaPickerControllerDelegate> {
	
	NSURL *movieURL;	
	MPMoviePlayerController *player;
	NSString *anatomyCode;
}

@property (nonatomic, retain) NSURL *movieURL;

- (id)initWithCode:(NSString *)code;
- (IBAction) back;

@end
