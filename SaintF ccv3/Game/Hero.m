//
//  Hero.m
//  SaintF
//
//  Created by Eliphas on 23.04.14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Hero.h"
#import "MainGameLayer.h"
#import "BackgroundLayer.h"
#import "GameLogic.h"



static Hero* _sharedHero;

@interface Hero(){
    
}

@end


@implementation Hero

-(id)init{
    if(self = [super init])
    {
        updateHandlers = [[NSMutableArray alloc] init];
        winWidth = [[CCDirector sharedDirector] viewSize].width;
        [self loadContent];
        
        [self performSelector:@selector(buildMoveAnimations)];
        [self performSelector:@selector(buildBlessAnimations)];
    }
    return self;
}

-(void)loadContent {
    heroSprite = [CCSprite node];
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    heroStands = [frameCache spriteFrameByName:@"turn1.png"];
    [heroSprite setSpriteFrame:heroStands];
}

-(void) spawnAtPosition:(CGPoint)position {
    MainGameLayer* mainGameLayer = [MainGameLayer sharedGameLayer];
    [mainGameLayer addChild:self];
    CCSpriteBatchNode* commonBatch = [mainGameLayer commonBatch];
    [commonBatch addChild:heroSprite];
    self.position = heroSprite.position = position;
}

-(void) stopAllAndRestoreHero {
    isMoving = false;
    isCasting = false;
    [blessAnimation stopAnimation];
    [moveAnimation stopAnimation];
    [heroSprite setTextureRect:[heroStands rect]];
}

-(CGSize) size
{
    return [heroSprite contentSize];
}

-(void)update:(CCTime)delta {
    for(int i = 0; i < updateHandlers.count; i++) {
        void (^handler)(CCTime) = [updateHandlers objectAtIndex:i];
        handler(delta);
    }
}

+(Hero*) sharedHero {
    if(!_sharedHero)
    {
        _sharedHero = [[Hero alloc] init];
    }
    return _sharedHero;
}

@end
