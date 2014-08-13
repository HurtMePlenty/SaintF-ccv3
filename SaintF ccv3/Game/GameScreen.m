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
    [self addChild:[BackgroundLayer sharedBGLayer] z:-1];
    [self addChild:[GUILayer sharedGUILayer] z:1];
    CGRect gameLayerRect = [BackgroundLayer gameLayerRect]; // main game layer should be bounded to background (should fit paper)
    
    CCNodeColor* stencil = [CCNodeColor nodeWithColor:[CCColor blackColor] width:gameLayerRect.size.width height:gameLayerRect.size.height];
    CCClippingNode* clippingNode = [CCClippingNode clippingNodeWithStencil:stencil];
    
    [clippingNode addChild: [MainGameLayer sharedGameLayer]];
    clippingNode.position = gameLayerRect.origin;
    [self addChild:clippingNode];
    
    //CCSprite* stencilSprite = [CCSprite spriteWithImageNamed:@"turn1_mask.png"];
    //stencilSprite.position = ccp(stencilSprite.contentSize.width / 2, stencilSprite.contentSize.height / 2);
    
    //CCSprite* stencilSprite2 = [CCSprite spriteWithImageNamed:@"turn1_mask.png"];
    //stencilSprite2.position = ccp(stencilSprite.contentSize.width / 2, stencilSprite.contentSize.height / 2);
    
    //clippingNode.alphaThreshold = 0.999f;
    //CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:1]];
    //[clippingNode addChild:colorNode]
    
    //[clippingNode addChild:colorNode];
    //[clippingNode addChild:[MainGameLayer sharedGameLayer] z:0];
    //clippingNode.position = gameLayerRect.origin;
    //[self addChild:stencilSprite];
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
