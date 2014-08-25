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
#import "NodeUtils.h"



static Hero* _sharedHero;

@interface Hero(){
    
}

@end


@implementation Hero

-(id)init{
    if(self = [super init])
    {
        updateHandlers = [[NSMutableArray alloc] init];
        winWidth = [MainGameLayer size].width;
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
    self.contentSize = heroStands.rect.size;
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

-(CGRect) boundingBox {
    return centeredBoundingBox(self);
}

-(void)update:(CCTime)delta {
    for(int i = 0; i < updateHandlers.count; i++) {
        void (^handler)(CCTime) = [updateHandlers objectAtIndex:i];
        handler(delta);
    }
}

-(CCSprite*) mask {
    CCSprite* mask;
    if(isMoving) {
        CCSpriteFrame* moveFrame = [moveFrames objectAtIndex:currentMoveFrameIndex];
        mask = [CCSprite spriteWithSpriteFrame:moveFrame];
    } else {
        mask = [CCSprite spriteWithImageNamed:@"turn1_mask.png"];
    }
    
    if(currentDirection == LEFT)
    {
        mask.rotationalSkewY = 180;
    };
    return mask;
}

+(Hero*) sharedHero {
    if(!_sharedHero)
    {
        _sharedHero = [[Hero alloc] init];
    }
    return _sharedHero;
}

+(CCSprite*)heroMask {
    return [[Hero sharedHero] mask];
}

@end
