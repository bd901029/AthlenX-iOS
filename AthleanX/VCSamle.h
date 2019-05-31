//
//  VCSamle.h
//  AthleanX
//
//  Created by Dmitriy on 12.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSExercice.h"
#import "ModelClass.h"
#import <MediaPlayer/MediaPlayer.h>

@class MoviePlayer;

@interface VCSamle : UIViewController <MPMediaPickerControllerDelegate> {
	NSURL *movieURL;	
	MPMoviePlayerController *player; 
	IBOutlet UILabel *exerciceName;
	IBOutlet UITextView *exerciceDescription;	
	IBOutlet UIActivityIndicatorView *load;
	
	int initById;
	NSExercice *currentEx;
	ModelClass *mc;
	
}

@property (nonatomic, retain) NSURL *movieURL;

- (IBAction) back;
- (id)initExerciceId:(int)exId;
- (void) moviePlayBackDidFinish:(NSNotification*)notification;

@end
