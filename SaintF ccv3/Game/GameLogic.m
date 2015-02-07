//
//  GameLogic.m
//  SaintF
//
//  Created by Alexey Semenov on 03/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "GameLogic.h"
#import "cocos2d.h"
#import "MainGameLayer.h"
#import "Creep.h"
#import "BackGroundLogic.h"
#import "Hero.h"
#import "GUILayer.h"
#import "Constants.h"
#import "Level.h"

static GameLogic* _sharedGameLogic;

@interface GameLogic() {
    NSMutableArray* creeps;
    float requiredScroll;
    
    CCTime gameTimeLeft; // seconds

    
    float lastGenAttemptDist;
    CGSize winSize;
    
    BackGroundLogic* backGroundLogic;
}

@end

@implementation GameLogic
@synthesize scrollSpeed; //should be set from hero
@synthesize isGameOver;

-(id)init {
    if(self = [super init]) {
        winSize = [MainGameLayer size];
        [self buildLogics];
        creeps = [[NSMutableArray alloc] init];
        gameTimeLeft = GAME_TIME_MAX; //seconds
    }
    return self;
}

-(void) buildInitialBackground {
    isGameOver = false;
    [backGroundLogic buildInitialBackground];
}

-(void) buildLogics {
    backGroundLogic = [[BackGroundLogic alloc] init];
}

-(void)update:(CCTime)delta {
    [self executeScrolling:scrollSpeed * delta];
    gameTimeLeft -= delta;
    [[GUILayer sharedGUILayer] updateGameTimeLeft:gameTimeLeft];
    if(gameTimeLeft <= 0){
        isGameOver = true;
        [Level gameOver];
        [[GUILayer sharedGUILayer] gameOver];
    }
}

-(void) scrollBackgroundFor:(float)length {
    CCLOG(@"requested to scroll for %f", length);
    requiredScroll += length;
}

-(void) executeScrolling:(float)dx {
    if(fabsf(requiredScroll) - dx < 0) //do not scroll if requiredScroll < scroll speed
    {
        return;
    }
    
    if (requiredScroll > 0) { //if we go right, bg goes left^^
        dx = -dx;
    }
    
    requiredScroll += dx;
    CCLOG(@"scrolled for %f left: %f", dx, requiredScroll);
    
    bool treeSpawned = [backGroundLogic scroll:dx];
    if (treeSpawned) {
        //we created new bgObject, try to spawn creep
        int chanceToGen = arc4random() % 3;
        if(chanceToGen == 0 || true) {
            [self generateNewCreep];
        }
    }
    
    for(int i = 0; i < creeps.count; i++) {
        Creep* creep = [creeps objectAtIndex:i];
        [creep move:ccpAdd(creep.position, ccp(dx,0))];
    }
}

-(void) generateNewCreep {
    CCLOG(@"Bird spawned");
    Creep* creep = [Creep spawnCreepWithType:paulin position:ccp(winSize.width, winSize.height * 0.7)];
    [creeps addObject:creep];
}

-(bool) shouldGenerateNewObj:(float)distFromLast {
    if(distFromLast < 150) //if distance from last generated object is less than...
    {
        return false;
    }
    
    bool isReadyNextAttempt = distFromLast - lastGenAttemptDist > 30; //how often do we proc gen attempt
    if (!isReadyNextAttempt) {
        return false;
    }
    
    int addChance = distFromLast / 250;
    int chanceToGen = arc4random() % 9;
    chanceToGen += addChance * 2;
    if(chanceToGen > 5) {
        lastGenAttemptDist = 0;
        return true;
    }
    lastGenAttemptDist = distFromLast; //we tried to gen, but random failed. Save last attempt dist
    return false;
}

-(void) blessCompleted {
    for(int i = 0; i < creeps.count; i++) {
        Creep* creep = [creeps objectAtIndex:i];
        CGRect heroRect = [[Hero sharedHero] boundingBox];
        CGRect creepRect = [creep boundingBox];
        float heroX1 = heroRect.origin.x;
        float heroX2 = heroX1 + heroRect.size.width;
        float creepX1 = creepRect.origin.x;
        float creepX2 = creepX1 + creepRect.size.width;
        if(heroX1 < creepX2 && heroX2 > creepX1){
            [creep receiveBless];
            [[GUILayer sharedGUILayer] addScore];
            gameTimeLeft += TIME_PER_BLESS;
        }
    }
}

-(void) removeCreep: (Creep*) creep {
    [creeps removeObject:creep];
}

-(void) restartLevel {
    [creeps removeAllObjects];
    [backGroundLogic restartLevel];
}

+(GameLogic*) sharedGameLogic {
    if(!_sharedGameLogic)
    {
        _sharedGameLogic = [[GameLogic alloc] init];
    }
    return _sharedGameLogic;
}


@end
