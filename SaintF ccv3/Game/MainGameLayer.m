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

-(CGSize) size {
    return [MainGameLayer size];
}

- (void) setOpacity:(CGFloat)opacity
{
    [super setOpacity:opacity];
    for(CCNode* child in [self children]) {
        [self setNodeOpacityWithChilds:child opacity:opacity];
    }
    
    for(CCNode* child in [commonBatch children]) {
        [self setNodeOpacityWithChilds:child opacity:opacity];
    }
}

-(void) setNodeOpacityWithChilds:(CCNode*)node opacity:(CGFloat)opacity {
    [node setOpacity:opacity];
    for(CCNode* child in [node children]){
        [self setNodeOpacityWithChilds:child opacity:opacity];
    }
}

-(void) restartLevel {
    self.opacity = 1.0f;
    [self removeAllChildren];
    [self addChild: commonBatch]; //do not remove it :)
    [self.commonBatch removeAllChildren];
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
