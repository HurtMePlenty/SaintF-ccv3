//
//  MusicPlayer.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 23/12/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameMusicPlayer : NSObject

+(void) playBackgroundMusic;
+(void) muteBackgroundMusic;
+(void) unmuteBackgroundMusic;
+(bool) isBgMuted;

@end
