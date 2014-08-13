//
//  BackgroundLayer.m
//  SaintF
//
//  Created by Alexey Semenov on 29/04/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "BackgroundLayer.h"
#import "BGObjectInfo.h"
#import "Creep.h"
#import "MainGameLayer.h"

static BackgroundLayer* _sharedBGLayer;

@interface BackgroundLayer(){
    NSMutableDictionary* bgResources;
    NSMutableArray* bgObjects;
    
    float lastGenAttemptDist;
    
    CGRect gameLayerRect;
    
}

@end

@implementation BackgroundLayer

-(id)init {
    if(self = [super init]) {
        CGSize winSize = [[CCDirector sharedDirector] viewSize];
        
        CCSprite* wood = [CCSprite spriteWithImageNamed:@"wood.png"];
        wood.position = CGPointMake(wood.contentSize.width / 2, wood.contentSize.height / 2);
        [self addChild:wood];
        
        CCSprite* paper = [CCSprite spriteWithImageNamed:@"paper.png"];
        float offsetY = winSize.height - paper.contentSize.height; //paper should be bounded to the top of hte screen
        
        //set game layer rect
        float zeroX = paper.contentSize.width * 0.05f;
        float zeroY = offsetY + paper.contentSize.height * 0.1f; //take 10% of full height as zero point
        float width = paper.contentSize.width - paper.contentSize.width * 0.1f;
        float height = paper.contentSize.height - paper.contentSize.height * 0.1f;
        gameLayerRect = CGRectMake(zeroX, zeroY, width, height);
        
        paper.position = CGPointMake(paper.contentSize.width / 2, paper.contentSize.height / 2 + offsetY);
        [self addChild:paper];
    }
    return self;
}

+(CGRect) gameLayerRect {
    return _sharedBGLayer->gameLayerRect;
}

+(BackgroundLayer*) sharedBGLayer {
    if(!_sharedBGLayer)
    {
        _sharedBGLayer = [[BackgroundLayer alloc] init];
    }
    return _sharedBGLayer;
}

@end
