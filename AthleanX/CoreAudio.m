//
//  CoreAudio.m
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 03.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreAudio.h"
#import "ModelClass.h"

@implementation CoreAudio

- (id) init
{
	self = [super init];
	if (self) {
		mPlayer = [MPMusicPlayerController iPodMusicPlayer];
		mc = [[ModelClass alloc] init];
		
		memQuery = [[MPMediaQuery alloc] init];
		
		memQuery = [[self getAudioQuery] copy];
		
		if ( [self getAudioType] != 4 && [self getAudioType] != 0 )
		{
			if ( ![memQuery isKindOfClass:[NSNull class]] )
			{
				if (memQuery != nil)
				{
					[self setAudioQuery:memQuery];
				}
				else
				{
					[self saveAudioType:4];
				}
			}
			else
			{
				[self saveAudioType:4];
			}
		}
		
		currentPlay = 0;
	}
	
	return self;
}

- (void) setAudioQuery:(MPMediaQuery *)query
{
	[mPlayer setQueueWithQuery:[query copy]];
	
	[self saveAudioQuery:[query copy]];
	memQuery = [query copy];
}

- (void) setAudioQueryCollections:(MPMediaItemCollection *)query
{
	[mPlayer setQueueWithItemCollection:query];
}

- (void) setVolume:(float)volume
{
	[mPlayer setVolume:volume];
}

- (void) prepareToPlay
{
	if ([self getAudioType] != 4 && [self getAudioType] != 0)
	{
		if (![memQuery isKindOfClass:[NSNull class]])
		{
			if (memQuery != nil)
			{
				[self setAudioQuery:memQuery];
			}
			else
			{
				[self saveAudioType:4];
			}
		}
		else
		{
			[self saveAudioType:4];
		}
	}
	
	if ([self getAudioType] != 4 && [self getAudioType] != 0)
	{
		if (![memQuery isKindOfClass:[NSNull class]])
		{
			if (memQuery != nil)
			{
				[self setAudioQuery:memQuery];
			}
			else
			{
				[self saveAudioType:4];
			}
		}
		else
		{
			[self saveAudioType:4];
		}
	}
}

- (void) play
{
	if (!TARGET_IPHONE_SIMULATOR)
	{
		if ([self getAudioType] != 4 && [self getAudioType] != 0)
		{
			[mPlayer play];
		}
	}
}


- (void) pause
{
	if (!TARGET_IPHONE_SIMULATOR)
	{
		[mPlayer pause];
	}
}


- (void) stop
{
	if (!TARGET_IPHONE_SIMULATOR)
	{
		[mPlayer stop];
	}
}


- (void) next
{
	[mPlayer skipToNextItem];
}


- (void) prev
{
	[mPlayer skipToPreviousItem];
}

- (bool) isPlaying
{
	if ([[MPMusicPlayerController iPodMusicPlayer] playbackState] == MPMusicPlaybackStatePlaying)
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

- (NSString *) getPlayingName
{
	MPMediaItem *it = [mPlayer nowPlayingItem];
	return [it valueForProperty:MPMediaItemPropertyTitle];
}

- (NSString *) getPlayingArtistName
{
	MPMediaItem *it = [mPlayer nowPlayingItem];
	return [it valueForProperty:MPMediaItemPropertyArtist];
}

//- (MPMediaQuery *) getPlayLists
//{
//
//}


- (NSArray *) getPlayListsName {
	
	NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
	
	MPMediaQuery *playlistsQuery1 = [MPMediaQuery playlistsQuery];
	NSArray *albums = [playlistsQuery1 collections];
	
	for (MPMediaItemCollection *album in albums) {
		[array addObject:[album valueForProperty:MPMediaPlaylistPropertyName]];
	}
	return array;
}


//- (MPMediaQuery *) getAlbons {
//
//
//}

- (NSArray *) getAlbomsName {
	NSMutableArray *albNameArr = [[[NSMutableArray alloc] init] autorelease];
	
	MPMediaQuery *playlistsQuery1 = [MPMediaQuery albumsQuery];
	NSArray *albums = [playlistsQuery1 collections];
	
	for (MPMediaItemCollection *album in albums)
	{
		MPMediaItem *representativeItem = [album representativeItem];
		NSString *artistName = [representativeItem valueForProperty: MPMediaItemPropertyArtist];
		NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
		MPMediaItemArtwork *image = [representativeItem valueForProperty:MPMediaItemPropertyArtwork];
		if ([image imageWithSize:CGSizeMake(60, 60)])
		{
			[albNameArr addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[artistName isKindOfClass:[NSString class]]?artistName:@"",[albumName isKindOfClass:[NSString class]]?albumName:@"",image, nil] forKeys:[NSArray arrayWithObjects:@"artist",@"albom",@"image", nil]]];
		}
		else
		{
			[albNameArr addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[artistName isKindOfClass:[NSString class]]?artistName:@"",[albumName isKindOfClass:[NSString class]]?albumName:@"",[NSNull null], nil] forKeys:[NSArray arrayWithObjects:@"artist",@"albom",@"image", nil]]];
		}
		
	}
	
	return albNameArr;
}

- (float)getCurrentVolume
{
	return mPlayer.volume;
}

- (void)saveAudioQuery:(MPMediaQuery *)query
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[query copy]];
	
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"audioQuery"];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (MPMediaQuery *)getAudioQuery
{
	NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"audioQuery"];
	
	if ( data2 )
		return [NSKeyedUnarchiver unarchiveObjectWithData:data2];
	
	return nil;
}

- (void)saveAudioType:(NSInteger)type
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInteger:type]];
	
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"audioType"];
	
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger)getAudioType
{
	NSData *data2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"audioType"];
	
	return [[NSKeyedUnarchiver unarchiveObjectWithData:data2] integerValue];
}

- (void) volumeTurnUp
{
	volumePerTurn = mPlayer.volume;
	mPlayer.volume = 0;
	[self play];
	upTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(upTik) userInfo:nil repeats:YES];
}

- (void) upTik
{
	volumeInTurn = volumeInTurn + 0.1;
	[mPlayer setVolume:volumeInTurn];
	if (mPlayer.volume >= volumePerTurn) {
		mPlayer.volume = volumePerTurn;
		[upTimer invalidate];
		upTimer = nil;
		volumeInTurn = 0;
	}
}

- (void) volumeTurnDown
{
	volumePerTurn = mPlayer.volume;
	downTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(downTik) userInfo:nil repeats:YES];
	volumeInTurn = mPlayer.volume;
}

- (void) downTik
{
	volumeInTurn = volumeInTurn - 0.1;
	[mPlayer setVolume:volumeInTurn];
	if (mPlayer.volume <= 0)
	{
		[downTimer invalidate];
		downTimer = nil;
		[self pause];
		[self performSelector:@selector(volumeRestore) withObject:self afterDelay:0.4];
	}
}

- (void) volumeRestore
{
	mPlayer.volume = volumePerTurn;
}

@end
