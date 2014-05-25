//
//  MyCocos2DClass.m
//  SaintF
//
//  Created by Eliphas on 23.04.14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "GameScreen.h"
#import "MainGameLayer.h"
#import "GUILayer.h"
#import "Level.h"
#import "GameLogic.h"
#import "BackgroundLayer.h"

@interface GameScreen() {
    GameLogic* sharedGameLogic;
}
@end

@implementation GameScreen

-(id)init{
    if(self = [super init])
    {
        [self loadResources];
        [self loadLayers];
        [Level buildLevel];
        
        sharedGameLogic = [GameLogic sharedGameLogic];
    }
    return self;
}

-(void) loadLayers {
    [self addChild:[MainGameLayer sharedGameLayer] z:0];
    [self addChild:[GUILayer sharedGUILayer] z:1];
    [self addChild:[BackgroundLayer sharedBGLayer] z:-1];
}

-(void) loadResources {
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"atlas.plist"];
}

+(CCScene*) scene {
    CCScene* menuScene = [CCScene node];
    GameScreen* menuLayer = [GameScreen node];
    [menuScene addChild:menuLayer];
    return menuScene;
}

-(void)update:(CCTime)delta {
    [sharedGameLogic update:delta];
}

@end
