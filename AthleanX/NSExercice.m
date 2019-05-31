//
//  NSExercice.m
//  AthleanX
//
//  Created by Dmitriy on 22.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSExercice.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSExercice
	
@synthesize exerciceId, pts, durationTime, locked, exerciseName, equipmentSound, exerciseNameSound, sampleVideoPath, description, anatomyCode, side, x2;

- (void) playExName{	  
//	NSLog(@"soundName - %@",exerciseNameSaund);	
//	NSString* path = [[NSBundle mainBundle] pathForResource:exerciseNameSaund ofType:@"wav"];
//	AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:NULL];	
//	//[player setDelegate:self];
//	[player setVolume:1.0f];
//	[player prepareToPlay];	
//	[player play];	
}

//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{	
//	//[player release];	
//	//NSLog(@"relised");
//}

- (void)dealloc
{	
	[super dealloc];
}



@end
