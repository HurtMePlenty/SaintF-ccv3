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



@interface Hero : CCNode {
    CCSprite* heroSprite;
    CCSpriteFrame* heroStands;
    
    NSMutableArray* updateHandlers;
    
    bool isMoving;
    FlowingAnimation* moveAnimation;
    MoveDirection currentDirection;
    float winWidth;
    
    bool isCasting;
    FlowingAnimation* blessAnimation;
}


-(void) spawnAtPosition:(CGPoint)position;
-(CGSize) size;
-(void) stopAllAndRestoreHero;

+(Hero*) sharedHero;

@end
