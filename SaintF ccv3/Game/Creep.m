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
#import "NodeUtils.h"
#import "GameLogic.h"

@interface Creep() {
    bool wasShown; //was shown on screen at least once. Need to check before remove
    MainGameLayer* __weak mainGameLayer;
}

@end

@implementation Creep
-(id) initWithType: (creepTypes) type {
    if(self = [super init])
    {
        creepType = type;
        mainGameLayer = [MainGameLayer sharedGameLayer];
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
    if(!CGRectIntersectsRect(mainGameLayer.boundingBox, self.boundingBox))
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
    creepSprite.cascadeOpacityEnabled = true;
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


-(CGRect) boundingBox {
    return centeredBoundingBox(self);
}

-(void) receiveBless {
    [moveAnimation pauseAnimation];
    CCActionFadeOut* fadeOut = [CCActionFadeOut actionWithDuration:1.0f];
    CCActionCallBlock* callback = [CCActionCallBlock actionWithBlock: ^(void){
        [self remove];
    }];
    
    CCActionSequence *sequence = [CCActionSequence actions:fadeOut, callback, nil];
    [creepSprite runAction: sequence];
}

-(void) remove {
    [moveAnimation stopAnimation];
    [creepSprite removeFromParent];
    [self removeFromParent];
    [[GameLogic sharedGameLogic] removeCreep:self];
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
