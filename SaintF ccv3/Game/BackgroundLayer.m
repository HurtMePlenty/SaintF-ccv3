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
    
    float winWidth;
    
    float lastGenAttemptDist;
}

@end

@implementation BackgroundLayer

-(id)init {
    if(self = [super init]) {
        self.color = [CCColor colorWithRed:0.9f green:0.9f blue:1.0f];
        self.opacity = 1;
    }
    return self;
}


+(BackgroundLayer*) sharedBGLayer {
    if(!_sharedBGLayer)
    {
        _sharedBGLayer = [[BackgroundLayer alloc] init];
    }
    return _sharedBGLayer;
}

@end
