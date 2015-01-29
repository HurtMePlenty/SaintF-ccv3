//
//  BGObject.m
//  SaintF ccv3
//
//  Created by Alexey Semenov on 22/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "BGObject.h"
#import "BGObjectInfo.h"
#import "MainGameLayer.h"
#import "Hero.h"
#import "NodeUtils.h"
#import "MaskedNode.h"
#import "BackGroundLogic.h"


@interface BGObject(){
    CCSprite* bgObjectSprite;
    MainGameLayer* __weak mainGameLayer;
    CCSpriteBatchNode* batchNode;
    
    CCClippingNode* bgObjectClipper;
    CCSprite* bgObjectClipperSprite; //do not reyse bgObjectSprite. Don't want to detach/attach it each time
    
    CGSize mainGameLayerSize;
}

@end


@implementation BGObject
@synthesize isDead;

-(id) init
{
    self = [super init];
    if (self) {
        mainGameLayer = [MainGameLayer sharedGameLayer];
        batchNode = [mainGameLayer commonBatch];
        mainGameLayerSize = mainGameLayer.size;
    }
    return self;
}

-(void) buildWithInfo: (BGObjectInfo*) bgObjectInfo {
    bgObjectSprite = [CCSprite spriteWithImageNamed: bgObjectInfo.fileName];
    bgObjectClipperSprite = [CCSprite spriteWithImageNamed: bgObjectInfo.fileName];
    
    bgObjectClipper = [CCClippingNode clippingNode];
    bgObjectClipper.inverted = true;
    bgObjectClipper.alphaThreshold = 0.0f;
    [bgObjectClipper addChild:bgObjectClipperSprite];
    
    self.contentSize = bgObjectSprite.contentSize;
}

-(void) remove {
    [self removeFromParent];
    [bgObjectClipper removeFromParent];
    [bgObjectSprite removeFromParent];
    self.isDead = true;
}

-(void) spawnAtPoint: (CGPoint) point {
    [mainGameLayer addChild:self];
    [batchNode addChild: bgObjectSprite];
    [mainGameLayer addChild:bgObjectClipper];
    [self move:ccp(point.x, point.y + bgObjectSprite.contentSize.height / 2)];
}

-(void) spawnAtX: (float)x {
    [self spawnAtPoint:ccp(x,0)];
}

-(void) move: (CGPoint) position {
    self.position = bgObjectClipper.position = bgObjectSprite.position = position;
}

-(void)update:(CCTime)delta {
    //probably optimize it and use some kind of updateManager
    [self chooseRenderMode];
}

-(void) moveBy: (CGPoint) point {
    [self move: ccpAdd(self.position, point)];
}

-(CGRect) boundingBox {
    return centeredBoundingBox(self);
}

-(CGSize) size {
    return bgObjectSprite.contentSize;
}

-(id<MaskedNode>) intersectsWithObject {
    if(CGRectIntersectsRect(self.boundingBox, [Hero sharedHero].boundingBox)){
        return [Hero sharedHero];
    }
    return nil;
}

-(void) chooseRenderMode {
    id<MaskedNode> maskedNode;
    if((maskedNode = [self intersectsWithObject])){
        bgObjectSprite.visible = false;
        bgObjectClipper.visible = true;
        bgObjectClipper.stencil = [maskedNode mask];
        
        //CGPoint stencilPosition = [self convertToNodeSpace:[self convertToWorldSpace:[maskedNode position]]];
        
        CGPoint stencilPosition = ccpSub([maskedNode position], self.position);
        bgObjectClipper.stencil.position = stencilPosition;
    } else {
        bgObjectSprite.visible = true;
        bgObjectClipper.visible = false;
    }
}

+(BGObject*) spawnBGObjectWithInfo:(BGObjectInfo *)info AtX:(float)x {
    return [BGObject spawnBGObjectWithInfo:info AtPoint:ccp(x, BASE_LINE_HEIGHT)];
}

+(BGObject*) spawnBGObjectWithInfo:(BGObjectInfo *)info AtPoint:(CGPoint)point {
    BGObject* bgObject = [[BGObject alloc] init];
    [bgObject buildWithInfo:info];
    [bgObject spawnAtPoint:point];
    return bgObject;
}

@end