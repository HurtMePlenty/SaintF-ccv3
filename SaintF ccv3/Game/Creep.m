//
//  Creep.m
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "Creep.h"
#import "MainGameLayer.h"

@interface Creep() {
    bool wasShown; //was shown on screen at least once. Need to check before remove
    creepTypes creepType;
    FlowingAnimation* moveAnimation;
    
    CCSprite* creepSprite;
    CCSpriteFrame* standFrame;
    bool isMoving;
    float speed;
    MoveDirection currentDirection;
    
    MainGameLayer* __weak mainGameLayer;
    
    float moveAnimationDelay;
    float moveAnimationShift;
    
    float maxMoveHeight;
    float minMoveHeight;
    
    CGSize size;
    CGSize winSize;
}

@end

@implementation Creep
@synthesize isDead;
-(id) initWithType: (creepTypes) type {
    if(self = [super init])
    {
        creepType = type;
        mainGameLayer = [MainGameLayer sharedGameLayer];
        speed = 2.5f;
        
        moveAnimationDelay = 0.5f;
        winSize = [CCDirector sharedDirector].viewSize;
        maxMoveHeight = winSize.height * 0.8;
        minMoveHeight = winSize.height * 0.5;
        
        
        
        [self loadContent];
        [self buildAnimation];
    }
    return self;
}

-(void) spawnAtPosition: (CGPoint)position {
    [mainGameLayer addChild:self];
    CCSpriteBatchNode* commonBatch = [mainGameLayer commonBatch];
    [commonBatch addChild:creepSprite z:1];
    self.position = creepSprite.position = position;
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

-(bool) checkIfShouldRemove {
    if(!CGRectIntersectsRect(mainGameLayer.boundingBox, self.hitBox))
    {
        if(wasShown){
            [self remove];
            return true;
        }
    } else {
        wasShown = true;
    }
    return false;
}

-(void) move: (CGPoint) point {
    creepSprite.position = self.position = point;
}

-(void) animateStand {
    //not moving
}

-(void) loadContent {
    creepSprite = [CCSprite node];
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    switch (creepType) {
        case paulin:
            standFrame = [frameCache spriteFrameByName:@"paulin0.png"];
            break;
            
        default:
            break;
    }
    
    [creepSprite setSpriteFrame:standFrame];
}

-(void) buildAnimation {
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
    
    
    void (^callback)(CGPoint) = ^(CGPoint shift){
        [self animationMoveCallback:shift];
    };
    moveAnimation = [[FlowingAnimation alloc] initWithFrames:moveFrames delay:moveAnimationDelay callBack:callback];
    [creepSprite addChild:moveAnimation];
    
    
    //1st frame size is the size of our creep.
    CCSpriteFrame* firstFrame = [moveFrames firstObject];
    size = firstFrame.rect.size;
}

-(CGSize) size
{
    return size;
}

-(CGRect) hitBox {
    float x = - size.width / 2;
    float y = - size.height / 2;
    CGRect collisionRect = CGRectMake(x, y, size.width, size.height);
    return CGRectApplyAffineTransform(collisionRect, [self nodeToParentTransform]);
}

-(void) remove {
    [moveAnimation stopAnimation];
    [creepSprite removeFromParent];
    [self removeFromParent];
    isDead = true;
}

-(void)update:(CCTime)delta {
    /*if(!isMoving){
     return;
     }
     float dx = speed;
     if(currentDirection == LEFT)
     {
     dx = -dx;
     }
     
     self.position = ccpAdd(self.position, ccp(dx, 0));
     creepSprite.position = self.position;
     
     if(!CGRectIntersectsRect(self.hitBox, mainGameLayer.boundingBox)){
     if(wasShown){
     [self remove];
     }
     } else {
     wasShown = true;
     }*/
}

+(Creep*) spawnCreepWithType: (creepTypes)type position: (CGPoint)position {
    Creep* creep = [[Creep alloc] initWithType:type];
    [creep spawnAtPosition:position];
    [creep startMoving:LEFT];
    return creep;
}

@end
