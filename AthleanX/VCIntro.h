//
//  VCIntro.h
//  AthleanX
//
//  Created by Evgeny Kalashnikov on 11.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VCIntro : UIViewController <MPMediaPickerControllerDelegate>
{
//	MPMoviePlayerController *player;
	
	IBOutlet UIImageView *m_ivDefault;
	UIView *m_vBkgnd;
}

+ (id) instance;

@end
