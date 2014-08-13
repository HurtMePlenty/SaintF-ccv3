//
//  Hero.h
//  SaintF
//
//  Created by Eliphas on 23.04.14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FlowingAnimation.h"
#import "MaskedNode.h"


@interface Hero : CCNode <MaskedNode> {
    CCSprite* heroSprite;
    CCSpriteFrame* heroStands;
    
    NSMutableArray* updateHandlers;
    
    bool isMoving;
    FlowingAnimation* moveAnimation;
    MoveDirection currentDirection;
    NSArray* moveFrames;
    int currentMoveFrameIndex;
    float winWidth;
    
    bool isCasting;
    FlowingAnimation* blessAnimation;
}


-(void) spawnAtPosition:(CGPoint)position;

-(void) stopAllAndRestoreHero;

+(Hero*) sharedHero;
+(CCSprite*) heroMask;

@end
