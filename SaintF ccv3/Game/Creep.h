//
//  Creep.h
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGObjectInfo.h"
#import "FlowingAnimation.h"

typedef enum {
    raven,
    paulin
} creepTypes;

@interface Creep : CCNode {
    creepTypes creepType;
    FlowingAnimation* moveAnimation;
    CCSpriteFrame* standFrame;
    bool isMoving;
    float speed;
    MoveDirection currentDirection;
    CCSprite* creepSprite;
    float moveAnimationDelay;
    float moveAnimationShift;
    float maxMoveHeight;
    float minMoveHeight;

}

-(void) move: (CGPoint) point;
-(bool) checkIfShouldRemove;
-(void) receiveBless;

+(Creep*) spawnCreepWithType: (creepTypes) type position: (CGPoint)position;

@end
