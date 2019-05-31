//
//  CoreAudio.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 03.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPMediaQuery.h>

#import <MediaPlayer/MediaPlayer.h>

@class ModelClass;

@interface CoreAudio : NSObject {
	MPMusicPlayerController *mPlayer;
	MPMediaQuery *memQuery;
	ModelClass *mc;
	NSInteger currentPlay;
	CGFloat volumePerTurn;
	CGFloat volumeInTurn;
	NSTimer *upTimer;
	NSTimer *downTimer;
}

- (void) setAudioQuery:(MPMediaQuery *)query;
- (void) setAudioQueryCollections:(MPMediaItemCollection *)query;
- (void) setVolume:(float)volume;
- (void) prepareToPlay;
- (void) play;
- (void) pause;
- (void) stop;
- (void) next;
- (void) prev;
- (bool) isPlaying;
- (NSString *) getPlayingName;
- (NSString *) getPlayingArtistName;
//- (MPMediaQuery *) getPlayLists;
- (NSArray *) getPlayListsName;
//- (MPMediaQuery *) getAlbons;
- (NSArray *) getAlbomsName;
- (float) getCurrentVolume;
- (void) saveAudioQuery:(MPMediaQuery *)query;
- (MPMediaQuery *) getAudioQuery;
- (void) saveAudioType:(NSInteger)type;
- (NSInteger) getAudioType;
- (void) volumeTurnUp;
- (void) volumeTurnDown;
- (void) volumeRestore;

@end
