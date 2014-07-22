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

@interface BGObject(){
    CCSprite* bgObjectSprite;
     MainGameLayer* __weak mainGameLayer;
}

@end


@implementation BGObject

- (id)init
{
    self = [super init];
    if (self) {
        mainGameLayer = [MainGameLayer sharedGameLayer];
    }
    return self;
}

-(void) buildWithInfo: (BGObjectInfo*) bgObjectInfo {
 
}

-(void) spawnAtPosition: (CGPoint)position {
    [mainGameLayer addChild:self];
    CCSpriteBatchNode* commonBatch = [mainGameLayer commonBatch];
    [commonBatch addChild:bgObjectSprite z:1];
    self.position = bgObjectSprite.position = position;
}





@end
