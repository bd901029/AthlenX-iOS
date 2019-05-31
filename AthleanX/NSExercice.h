//
//  NSExercice.h
//  AthleanX
//
//  Created by Dmitriy on 22.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NSExercice : NSObject <AVAudioPlayerDelegate>{
	
	int exerciceId;
	int durationTime;
	int pts;
	
	NSString *locked;
	NSString *exerciseName;	
	NSString *equipmentSound;	
	NSString *exerciseNameSound;
	//NSString *exerciseNameSaund60;
	NSString *sampleVideoPath;
	NSString *description;  
	NSString *anatomyCode;
	NSString *side;
	NSString *x2;
	
}

@property(nonatomic,readwrite)int exerciceId;
@property(nonatomic,readwrite)int durationTime;
@property(nonatomic,readwrite)int pts;
@property(nonatomic,retain)NSString *locked;
@property(nonatomic,retain)NSString *side;
@property(nonatomic,retain)NSString *x2;
@property(nonatomic,retain)NSString *exerciseName;
@property(nonatomic,retain)NSString *equipmentSound;
@property(nonatomic,retain)NSString *exerciseNameSound;
//@property(nonatomic,retain)NSString *exerciseNameSaund60;
@property(nonatomic,retain)NSString *sampleVideoPath;
@property(nonatomic,retain)NSString *description;
@property(nonatomic,retain)NSString *anatomyCode;

- (void) playExName;

@end
