//
//  MainGameLayer.m
//  SaintF
//
//  Created by Eliphas on 23.04.14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "MainGameLayer.h"
#import "BackgroundLayer.h"


static MainGameLayer* _sharedMainLayer = nil;

@interface MainGameLayer() {
    CGSize gameLayerSize;
}

@end



@implementation MainGameLayer
@synthesize commonBatch;
-(id)init {
    if(self = [super init])
    {
        CGSize size = [[CCDirector sharedDirector] viewSize];
        self.contentSize = size;
        [self createBatches];
        
    }
    return self;
}

-(void) createBatches {
    commonBatch = [CCSpriteBatchNode batchNodeWithFile:@"atlas.png"];
    [self addChild:commonBatch];
}

+(MainGameLayer*) sharedGameLayer {
    if(!_sharedMainLayer)
    {
        _sharedMainLayer = [[MainGameLayer alloc] init];
    }
    return _sharedMainLayer;
}

+(CCSpriteBatchNode*)commonBatch {
    return [_sharedMainLayer commonBatch];
}

+(CGSize) size {
    return [BackgroundLayer gameLayerRect].size;
    
}



@end
