//
//  Creep.m
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "Creep.h"
#import "Creep+CreepMove.h"
#import "MainGameLayer.h"

@interface Creep() {
    bool wasShown; //was shown on screen at least once. Need to check before remove
    MainGameLayer* __weak mainGameLayer;
}

@end

@implementation Creep
@synthesize isDead;
-(id) initWithType: (creepTypes) type {
    if(self = [super init])
    {
        creepType = type;
        mainGameLayer = [MainGameLayer sharedGameLayer];
        winSize = [CCDirector sharedDirector].viewSize;
        [self loadContent];
        [self performSelector:@selector(buildMoveAnimations)];
    }
    return self;
}

-(void) spawnAtPosition: (CGPoint)position {
    [mainGameLayer addChild:self];
    CCSpriteBatchNode* commonBatch = [mainGameLayer commonBatch];
    [commonBatch addChild:creepSprite z:1];
    self.position = creepSprite.position = position;
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

}

+(Creep*) spawnCreepWithType: (creepTypes)type position: (CGPoint)position {
    Creep* creep = [[Creep alloc] initWithType:type];
    [creep spawnAtPosition:position];
    [creep startMoving:LEFT];
    return creep;
}

@end
