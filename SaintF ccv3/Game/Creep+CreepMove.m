//
//  Creep+CreepMove.m
//  SaintF ccv3
//
//  Created by Alexey Semenov on 04/06/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Creep+CreepMove.h"

@implementation Creep (CreepMove)

-(void) buildMoveAnimations {
    speed = 1.5f;
    moveAnimationDelay = 0.4f;
    maxMoveHeight = winSize.height * 0.8;
    minMoveHeight = winSize.height * 0.5;
    
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSArray* moveFrames;
    switch (creepType) {
        case paulin:
        {
            CCSpriteFrame* frame1 = [frameCache spriteFrameByName:@"paulin0.png"];
            CCSpriteFrame* frame2 = [frameCache spriteFrameByName:@"paulin1.png"];
            moveFrames = [NSArray arrayWithObjects:frame1, frame2, nil];
        }
            break;
            
        default:
            [NSException exceptionWithName:@"WrongCreepType" reason:@"WrongCreepType" userInfo:nil];
    }
    
    
    void (^callback)(CGPoint, int) = ^(CGPoint shift, int showingIndex){
        [self animationMoveCallback:shift];
    };
    moveAnimation = [[FlowingAnimation alloc] initWithFrames:moveFrames delay:moveAnimationDelay callBack:callback];
    [creepSprite addChild:moveAnimation];
    
    
    //1st frame size is the size of our creep.
    CCSpriteFrame* firstFrame = [moveFrames firstObject];
    size = firstFrame.rect.size;
}

-(void)startMoving:(MoveDirection)direction {
    if(isMoving) {
        return;
    }
    isMoving = true;
    currentDirection = direction;
    if(direction == RIGHT ) { //bird looks to left by default
        creepSprite.rotationalSkewY = 180;
    }
    else {
        creepSprite.rotationalSkewY = 0;
    }
    creepSprite.textureRect = CGRectZero;
    
    CGPoint shift = [self getNextMoveShift];
    
    [moveAnimation startAnimationWithShift:shift];
}

-(CGPoint) getNextMoveShift {
    
    float dx = 10.0f + (arc4random() % 4) * 5;
    dx = -dx; //always move left
    float dy = 5.0f + (arc4random() % 3) * 5;
    
    if(arc4random() % 2 == 1) {
        dy = -dy;
    }
    
    float probableY = self.position.y + dy;
    if(probableY > maxMoveHeight || probableY < minMoveHeight){
        dy = -dy;
    }
    
    return ccp(dx, dy);
}


-(void) animationMoveCallback:(CGPoint) shift {
    [self move:ccpAdd(self.position, shift)];
    if([self checkIfShouldRemove]){
        return;
    }
    CGPoint nextShift = [self getNextMoveShift];
    [moveAnimation setShift:nextShift];
}


@end
