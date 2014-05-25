//
//  LevelBuilder.m
//  SaintF
//
//  Created by Alexey Semenov on 27/04/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Level.h"
#import "MainGameLayer.h"
#import "Hero.h"
#import "GameLogic.h"


@implementation Level

+(void) buildLevel {
    Hero* hero = [Hero sharedHero];
    CGSize heroSize = [hero size];
    float spawnX = heroSize.width / 2;
    float spawnY = heroSize.height / 2;
    CGPoint spawnPosition = ccp(spawnX, spawnY);
    [hero spawnAtPosition:spawnPosition];
    
    [self buildBackground];
}

+(void) buildBackground {
    [[GameLogic sharedGameLogic] buildInitialBackground];
}

@end
