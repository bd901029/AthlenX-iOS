#import "AVAudioPlayer2.h"

@class AVAudioSession;

#if TARGET_OS_IPHONE			
//
// MyAudioSessionInterruptionListener
//
// Invoked if the audio session is interrupted (like when the phone rings)
//
void MyAudioSessionInterruptionListener(void *inClientData, UInt32 inInterruptionState)
{
	id streamer = (id)inClientData;
	[streamer handleInterruptionChangeToState:inInterruptionState];
}
#endif

@implementation AVAudioPlayer2

- (void)handleInterruptionChangeToState:(AudioQueuePropertyID)inInterruptionState
{
	if (inInterruptionState == kAudioSessionBeginInterruption)
	{ 
		if ([self isPlaying]) {
			[self pause];
			
			pausedByInterruption = YES; 
		} 
	}
	else if (inInterruptionState == kAudioSessionEndInterruption) 
	{
		AudioSessionSetActive( true );
		
		if ( [super isPaused] && pausedByInterruption ) {
			[self pause]; // this is actually resume
			
			pausedByInterruption = NO; // this is redundant 
		}
	}
}

-(id)initWithContentsOfURL:(id)url error:(id)err
{

	[super initWithContentsOfURL:url error:&err];
	return self;
}

- (BOOL)prepareToPlay
{
#if TARGET_OS_IPHONE
	AudioSessionInitialize (
							NULL,						  // 'NULL' to use the default (main) run loop//хм???
							NULL,						  // 'NULL' to use the default run loop mode
							MyAudioSessionInterruptionListener,  // a reference to your interruption callback
							self					   // data to pass to your interruption listener callback
							);
	UInt32 sessionCategory=0;//kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	//----
	UInt32 shouldDuck = true;
	AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(shouldDuck), &shouldDuck);//ныряем звуком :(((
	//----
	AudioSessionSetActive(true);
#endif
	
	return [super prepareToPlay];
}

- (BOOL) play
{
   /* AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	NSError *err = nil;
	[audioSession setCategory:0 error:&err];
	AudioSessionInitialize (
							NULL,						  // 'NULL' to use the default (main) run loop//хм???
							NULL,						  // 'NULL' to use the default run loop mode
							MyAudioSessionInterruptionListener,  // a reference to your interruption callback
							self					   // data to pass to your interruption listener callback
							);
	UInt32 sessionCategory=0;//kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	//----
	UInt32 shouldDuck = true;
	AudioSessionSetProperty(kAudioSessionProperty_OtherMixableAudioShouldDuck, sizeof(shouldDuck), &shouldDuck);//ныряем звуком :(((
	//----
	AudioSessionSetActive(true);*/
	return [super play];
}

+ (void) prepare
{
//	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//	NSError *err = nil;
//	[audioSession setCategory:0 error:&err];
	
	AudioSessionInitialize (
							NULL,						  // 'NULL' to use the default (main) run loop//хм???
							NULL,						  // 'NULL' to use the default run loop mode
						 NULL,//   MyAudioSessionInterruptionListener,  // a reference to your interruption callback
							self					   // data to pass to your interruption listener callback
							);
	UInt32 sessionCategory=0;//kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	//----
	UInt32 shouldDuck = true;
	AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(shouldDuck), &shouldDuck);//ныряем звуком :(((
	//----
	AudioSessionSetActive(true);
}

@end