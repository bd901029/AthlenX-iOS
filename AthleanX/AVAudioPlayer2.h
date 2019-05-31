#import <AVFoundation/AVAudioPlayer.h>
#include <AudioToolbox/AudioToolbox.h>


#define AudioQueuePropertyID UInt32


@interface AVAudioPlayer2 : AVAudioPlayer
{
	BOOL pausedByInterruption;
}

+ (void) prepare;

- (void) handleInterruptionChangeToState:(AudioQueuePropertyID)inInterruptionState;
- (id) initWithContentsOfURL:(id)url error:(id)err;

- (BOOL) prepareToPlay;
- (BOOL) play;

@end