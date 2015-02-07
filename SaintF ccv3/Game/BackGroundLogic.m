//
//  BackGroundLogic.m
//  SaintF ccv3
//
//  Created by Alexey Semenov on 03/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "BackGroundLogic.h"
#import "MainGameLayer.h"
#import "BGObjectInfo.h"
#import "BGObject.h"

@interface BackGroundLogic()
{
    NSMutableArray* frontLineObjects;
    NSMutableDictionary* frontLineResources;
    
    NSMutableArray* backStageObjects;
    NSMutableDictionary* backStageResources;
    
    CGSize winSize;
}
@end

@implementation BackGroundLogic

-(id) init {
    if(self = [super init]){
        winSize = [MainGameLayer size];
        [self buildObjectResourceDict];
        [self buildBackStageResourceDict];
    }
    return self;
}

-(void) buildInitialBackground {
    for(int i = 0; i < 20; i++)
    {
        [self tryToGenerateBackStage];
        [self tryToGenerateNewObj];
        [self scroll: -45];
    }
}

-(bool) scroll:(float)dx {
    for(int i = 0; i < frontLineObjects.count; i++){
        BGObject* bgObj = [frontLineObjects objectAtIndex:i];
        if(!bgObj.isDead) {
            [bgObj moveBy:ccp(dx, 0)];
        }
    }
    
    for(int i = 0; i < backStageObjects.count; i++){
        BGObject* bgObj = [backStageObjects objectAtIndex:i];
        if(!bgObj.isDead){
            [bgObj moveBy:ccp(dx, 0)];
        }
    }
    
    [self tryToGenerateBackStage];
    return [self tryToGenerateNewObj];
}

-(void) tryToGenerateBackStage {
    CCSprite* lastObject = [backStageObjects lastObject];
    float rightBorder;
    if(!lastObject) {
        rightBorder = -300.0f; //hardcoded initial pos for 1st backStage object
    } else {
        rightBorder = lastObject.position.x + lastObject.contentSize.width / 2;
    }
    
    
    if(rightBorder < winSize.width + 500) { //hardcoded right border of screen, where backStage spawns
        int i = arc4random() % 11;
        BGObjectInfo* backStageObjectInfo = [backStageResources objectForKey:[NSNumber numberWithInt:i]];
        BGObject* backStageObject = [BGObject spawnBGObjectWithInfo:backStageObjectInfo AtX:(rightBorder)];
        [backStageObject moveBy:CGPointMake(backStageObject.size.width / 2, 0)]; //stick left border of new obj with right border of new obj
        [backStageObjects addObject:backStageObject];
    }
}

-(bool) tryToGenerateNewObj {
    CCSprite* lastObject = [frontLineObjects lastObject];
    float rightBorder;
    if(lastObject){
        rightBorder = lastObject.position.x + lastObject.contentSize.width / 2;
    } else {
        rightBorder = -300.0f;
    }
    
    if(rightBorder < winSize.width + 500) {
        float distFromPrevious = arc4random() % 4 + 1;
        distFromPrevious = distFromPrevious * 40 + 50;
        
        int type = arc4random() % 5;
        BGObjectInfo* info = [frontLineResources objectForKey:[NSNumber numberWithInt:type]];
        
        //CGPoint spawnPoint = ccp(winSize.width, 0);
        
        BGObject*  newObj = [BGObject spawnBGObjectWithInfo:info AtX: rightBorder + distFromPrevious];
        [frontLineObjects addObject:newObj];
        return true;
    }
    
    return false;
}



-(void) buildObjectResourceDict {
    frontLineResources = [[NSMutableDictionary alloc] init];
    frontLineObjects = [[NSMutableArray alloc] init];
    
    BGObjectInfo* bushInfo = [BGObjectInfo BgObjWithFileName:@"bush.png"];
    BGObjectInfo* klenInfo = [BGObjectInfo BgObjWithFileName:@"klen.png"];
    BGObjectInfo* oakInfo = [BGObjectInfo BgObjWithFileName:@"oak.png"];
    BGObjectInfo* platanInfo = [BGObjectInfo BgObjWithFileName:@"platan.png"];
    BGObjectInfo* yasenInfo = [BGObjectInfo BgObjWithFileName:@"yasen.png"];
    
    
    [frontLineResources setObject:bushInfo forKey:[NSNumber numberWithInt: bush]];
    [frontLineResources setObject:klenInfo forKey:[NSNumber numberWithInt:klen]];
    [frontLineResources setObject:oakInfo forKey:[NSNumber numberWithInt:oak]];
    [frontLineResources setObject:platanInfo forKey:[NSNumber numberWithInt:platan]];
    [frontLineResources setObject:yasenInfo forKey:[NSNumber numberWithInt:yasen]];
}

-(void) buildBackStageResourceDict {
    backStageResources = [[NSMutableDictionary alloc] init];
    backStageObjects = [[NSMutableArray alloc] init];
    for(int i = 0; i < 11; i++){
        NSString *fileName = [NSString stringWithFormat:@"bs%02i.png", i + 1]; //or rename files to start with 0?
        BGObjectInfo* backStageObjectInfo = [BGObjectInfo BgObjWithFileName:fileName];
        [backStageResources setObject:backStageObjectInfo forKey:[NSNumber numberWithInt:i]];
    }
}

-(void) restartLevel {
    [frontLineObjects removeAllObjects];
    [backStageObjects removeAllObjects];
}

@end
