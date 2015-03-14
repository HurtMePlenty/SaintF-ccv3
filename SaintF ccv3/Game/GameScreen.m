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

static GameScreen* lastGameScreen;

@interface GameScreen() {
    GameLogic* sharedGameLogic;
}
@end

@implementation GameScreen

-(id)init{
    if(self = [super init])
    {
        [self loadLayers];
        [Level buildLevel];
        
        sharedGameLogic = [GameLogic sharedGameLogic];
    }
    return self;
}

-(void) loadLayers {
    [self addChild:[BackgroundLayer sharedBGLayer] z:-1];
    [self addChild:[GUILayer sharedGUILayer] z:1];
    CGRect gameLayerRect = [BackgroundLayer gameLayerRect]; // main game layer should be bounded to background (should fit paper)
    
    CCNodeColor* stencil = [CCNodeColor nodeWithColor:[CCColor blackColor] width:gameLayerRect.size.width height:gameLayerRect.size.height];
    CCClippingNode* clippingNode = [CCClippingNode clippingNodeWithStencil:stencil];
    
    [MainGameLayer sharedGameLayer].scale = 0.75f;
    [clippingNode addChild: [MainGameLayer sharedGameLayer]];
    clippingNode.position = gameLayerRect.origin;
    [self addChild:clippingNode];
}


+(CCScene*) scene {
    if(lastGameScreen){
        [lastGameScreen removeAllChildren];
    }
    
    CCScene* gameScene = [CCScene node];
    GameScreen* gameScreen = [GameScreen node];
    lastGameScreen = gameScreen;
    [gameScene addChild:gameScreen];
    return gameScene;
}

-(void)update:(CCTime)delta {
    [sharedGameLogic update:delta];
}

@end
