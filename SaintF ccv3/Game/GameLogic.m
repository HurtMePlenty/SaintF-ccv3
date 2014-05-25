//
//  GameLogic.m
//  SaintF
//
//  Created by Alexey Semenov on 03/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "GameLogic.h"
#import "cocos2d.h"
#import "BGObjectInfo.h"
#import "MainGameLayer.h"
#import "Creep.h"

static GameLogic* _sharedGameLogic;

@interface GameLogic() {
    NSMutableDictionary* bgResources;
    NSMutableArray* bgObjects;
    NSMutableArray* creeps;
    float requiredScroll;

    
    float lastGenAttemptDist;
    CGSize winSize;
}

@end

@implementation GameLogic
@synthesize scrollSpeed; //should be set from hero

-(id)init {
    if(self = [super init]) {
        winSize = [[CCDirector sharedDirector] viewSize];
        [self buildObjectResourceDict];
    }
    return self;
}


-(void) buildInitialBackground {
    for(int i = 0; i < 5; i++)
    {
        [self tryToGenerateNewObj];
        [self scrollBackgroundFor:90];
        [self executeScrolling:90];
    }
}

-(void)update:(CCTime)delta {
    [self executeScrolling:scrollSpeed * delta];
}

-(void) scrollBackgroundFor:(float)length {
    requiredScroll += length;
}

-(void) executeScrolling:(float)dx {
    if(fabsf(requiredScroll) - dx < 0) //do not scroll if requiredScroll < scroll speed
    {
        return;
    }
    
    if (requiredScroll > 0) { //if we go right, bg goes left^^
        dx = -dx;
    }
    requiredScroll += dx;
    
    for(int i = 0; i < bgObjects.count; i++){
        CCSprite* bgObj = [bgObjects objectAtIndex:i];
        bgObj.position = ccpAdd(bgObj.position, ccp(dx, 0));
    }
    
    [self removeDeadCreeps];
    
    for(int i = 0; i < creeps.count; i++) {
        Creep* creep = [creeps objectAtIndex:i];
        [creep move:ccpAdd(creep.position, ccp(dx,0))];
    }
    
    [self tryToGenerateNewObj];
    
}

-(void) tryToGenerateNewObj {
    CCSprite* lastObject = [bgObjects lastObject];
    float distFromLast;
    
    if(lastObject){
        distFromLast = winSize.width - lastObject.position.x;
    }
    else {
        distFromLast = 3000; //hardcoded for nil object. should be divided by 30 :)
    }
    
    if([self shouldGenerateNewObj:distFromLast])
    {
        [self generateNewObj];
        //we created new bgObject, try to spawn creep
        int chanceToGen = arc4random() % 2;
        if(chanceToGen == 0) {
            [self generateNewCreep];
        }
    }
}

-(bool) shouldGenerateNewObj:(float)distFromLast {
    if(distFromLast < 150) //if distance from last generated object is less than...
    {
        return false;
    }
    
    bool isReadyNextAttempt = distFromLast - lastGenAttemptDist > 30; //how often do we proc gen attempt
    if (!isReadyNextAttempt) {
        return false;
    }
    
    
    int addChance = distFromLast / 250;
    int chanceToGen = arc4random() % 9;
    chanceToGen += addChance * 2;
    if(chanceToGen > 5) {
        lastGenAttemptDist = 0;
        return true;
    }
    lastGenAttemptDist = distFromLast; //we tried to gen, but random failed. Save last attempt dist
    return false;
    
}

-(void) generateNewObj {
    int type = arc4random() % 5;
    
    CCSprite* newObj;
    
    /*for(int i = 0; i< bgObjects.count; i++){
        CCSprite* bgObj = [bgObjects objectAtIndex:i];
        if(bgObj.tag == type && !bgObj.visible) //for now it will always be a new object. Never use cache, but we save history instead:)
        {
            newObj = bgObj;
        }
    }*/
    if(!newObj){
        BGObjectInfo* info = [bgResources objectForKey:[NSNumber numberWithInt:type]];
        NSString* objFileName = info.fileName;
        newObj = [CCSprite spriteWithImageNamed:objFileName];
        //newObj.name = type;
        
        //[self addChild:newObj];
        [[[MainGameLayer sharedGameLayer] commonBatch] addChild:newObj z:-1];
        
        [bgObjects addObject:newObj];
    }
    newObj.position = ccp(winSize.width + newObj.contentSize.width / 2, newObj.contentSize.height / 2);
    newObj.visible = true;
}

-(void) generateNewCreep {
    CCLOG(@"Bird spawned");
    Creep* creep = [Creep spawnCreepWithType:paulin position:ccp(winSize.width, winSize.height * 0.7)];
    [creeps addObject:creep];
}

-(void) removeDeadCreeps {
    for(int i = 0; i < creeps.count; i++) {
        Creep* creep = [creeps objectAtIndex:i];
        if(creep.isDead){
            [creeps removeObject:creep];
            i--;
        }
    }
}

-(void) buildObjectResourceDict {
    bgResources = [[NSMutableDictionary alloc] init];
    
    BGObjectInfo* bushInfo = [BGObjectInfo BgObjWithFileName:@"bush.png"];
    BGObjectInfo* klenInfo = [BGObjectInfo BgObjWithFileName:@"klen.png"];
    BGObjectInfo* oakInfo = [BGObjectInfo BgObjWithFileName:@"oak.png"];
    BGObjectInfo* platanInfo = [BGObjectInfo BgObjWithFileName:@"platan.png"];
    BGObjectInfo* yasenInfo = [BGObjectInfo BgObjWithFileName:@"yasen.png"];
    
    
    [bgResources setObject:bushInfo forKey:[NSNumber numberWithInt: bush]];
    [bgResources setObject:klenInfo forKey:[NSNumber numberWithInt:klen]];
    [bgResources setObject:oakInfo forKey:[NSNumber numberWithInt:oak]];
    [bgResources setObject:platanInfo forKey:[NSNumber numberWithInt:platan]];
    [bgResources setObject:yasenInfo forKey:[NSNumber numberWithInt:yasen]];
    bgObjects = [[NSMutableArray alloc] init];
    creeps = [[NSMutableArray alloc]init];
}

+(GameLogic*) sharedGameLogic {
    if(!_sharedGameLogic)
    {
        _sharedGameLogic = [[GameLogic alloc] init];
    }
    return _sharedGameLogic;
}


@end
