//
//  MusicPlayer.m
//  SaintF ccv3
//
//  Created by Alexey Semenov on 23/12/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "GameMusicPlayer.h"
#import "cocos2d.h"


@implementation GameMusicPlayer
static OALSimpleAudio *audio;
static bool bgMuted;

+ (void) initialize {
    audio = [OALSimpleAudio sharedInstance];
    [audio preloadBg: @"bgmusic.mp3"];
}

+(void) playBackgroundMusic {
    [audio playBgWithLoop: YES];
    bgMuted = false;
}

+(void) muteBackgroundMusic {
    audio.bgMuted = true;
    bgMuted = true;
}

+(void) unmuteBackgroundMusic {
    audio.bgMuted = false;
    bgMuted = false;
}

+(bool) isBgMuted {
    return bgMuted;
}

@end
