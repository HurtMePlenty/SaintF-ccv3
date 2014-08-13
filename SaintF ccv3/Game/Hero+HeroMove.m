//
//  Hero+HeroMove.m
//  SaintF ccv3
//
//  Created by Alexey Semenov on 26/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Hero+HeroMove.h"
#import "Hero+HeroCast.h"
#import "GameLogic.h"


@implementation Hero (HeroMove)

float const moveAnimationShift = 10.0f; // shift to 2nd frame of animation
float const moveAnimationDelay = 0.5f;
float scrollDistPerStep; //range we move per 1 animation
bool shouldStopMoving; //when we stop touch

-(void) buildMoveAnimations {
    
    scrollDistPerStep = moveAnimationShift;
    
    [GameLogic sharedGameLogic].scrollSpeed = scrollDistPerStep / moveAnimationDelay;
    
    
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSpriteFrame* frame1 = [frameCache spriteFrameByName:@"move_new1.png"];
    CCSpriteFrame* frame2 = [frameCache spriteFrameByName:@"move_new2.png"];
    moveFrames = [NSArray arrayWithObjects:frame1, frame2, nil];
    
    void (^callback)(CGPoint, int) = ^(CGPoint shift, int showingIndex){
        [self animationMoveCallback:shift index:showingIndex];
    };
    
    
    moveAnimation = [[FlowingAnimation alloc] initWithFrames:moveFrames delay:moveAnimationDelay callBack:callback];
    [heroSprite addChild:moveAnimation];
}

-(void)startMoving:(MoveDirection)direction {
    if(isMoving){
        return;
    }
    [self stopBless];
    
    float scrollShift = scrollDistPerStep;
    currentDirection = direction;
    if(direction == LEFT ) {
        heroSprite.rotationalSkewY = 180;
        scrollShift = -scrollShift;
    }
    else {
        heroSprite.rotationalSkewY = 0;
    }
    
    [heroSprite setTextureRect:CGRectZero];
    float allowedShiftX = [self getShiftForDirection:direction];
    currentMoveFrameIndex = 0;
    [moveAnimation startAnimationWithShift:ccp(allowedShiftX, 0.0f)];
    //if(allowedShiftX == 0.0f){
        [[GameLogic sharedGameLogic] scrollBackgroundFor:scrollShift]; //start scrolling after starting animation
    //}
    isMoving = true;
    shouldStopMoving = false;
}

-(float) getShiftForDirection: (MoveDirection) direction {
    float distanceAllowed;
    if (direction == RIGHT) {
        distanceAllowed = [self getRightBorder] - self.position.x;
    }
    else {
        distanceAllowed = self.position.x - [self getLeftBorder];
    }
    if (moveAnimationShift < distanceAllowed) {
        return moveAnimationShift;
    }
    else {
        return distanceAllowed;
    }
}

-(void) animationMoveCallback: (CGPoint)shift index:(int)showingIndex {
    currentMoveFrameIndex = showingIndex;
    float moveDx = shift.x;
    float scrollShift = scrollDistPerStep;
    if(currentDirection == LEFT)
    {
        moveDx = -moveDx;
        scrollShift = -scrollShift;
    }
    
    CGPoint moveTo = ccpAdd(self.position, ccp(moveDx, shift.y));
    [self move:moveTo];
    if(shouldStopMoving)
    {
        [self stopAllAndRestoreHero];
    }else {
        //first we move, then calculate next possible shift
        float allowedShiftX = [self getShiftForDirection:currentDirection];
        [moveAnimation setShift:ccp(allowedShiftX, 0.0f)];
        //if(allowedShiftX == 0.0f){
            [[GameLogic sharedGameLogic] scrollBackgroundFor: scrollShift]; //start new animation circle and scroll
            
        //}
        CCLOG(@"next shift allowedShiftX = %f", allowedShiftX);
    }
}

-(void)stopMoving {
    shouldStopMoving = true;
}

-(void) move: (CGPoint) point {
    heroSprite.position = self.position = point;
}


-(float) getRightBorder {
    return winWidth / 2.5;
}

-(float) getLeftBorder {
    return winWidth / 5;
}





@end
