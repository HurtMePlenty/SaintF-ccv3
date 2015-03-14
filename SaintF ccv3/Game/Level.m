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
#import "Hero+HeroMove.h"
#import "GameLogic.h"
#import "MainMenu.h"
#import "BackGroundLogic.h"


@implementation Level

+(void) buildLevel {
    [[MainGameLayer sharedGameLayer] restartLevel];
    Hero* hero = [Hero sharedHero];
    [hero restartLevel];
    CGSize heroSize = hero.contentSize;
    float spawnX = heroSize.width / 2 + [hero leftBorder];
    float spawnY = heroSize.height / 2;
    CGPoint spawnPosition = ccp(spawnX, spawnY + BASE_LINE_HEIGHT);
    [hero spawnAtPosition:spawnPosition];
    
    [self buildBackground];
}

+(void) buildBackground {
    [[GameLogic sharedGameLogic] startLevel];
}


@end
