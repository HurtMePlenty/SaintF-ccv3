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
    
    
    CGRect gameLayerRect = [BackgroundLayer gameLayerRect]; // main game layer should be bounded to backround (should fit paper)
 
  
    CCDrawNode* stencil = [CCDrawNode node];
    //[stencil drawDot:ccp(10, 10) radius:100 color:[CCColor blackColor]];
    //[stencil drawDot:ccp(10,10) radius:50 color:[CCColor colorWithWhite:1.0f alpha:1.0f]];
    [stencil drawSegmentFrom:ccp(0,0) to:ccp(100,100) radius:100 color:[CCColor greenColor]];
    //stencil.contentSizeType = CCSizeTypeNormalized;
    CCClippingNode* clippingNode = [CCClippingNode clippingNodeWithStencil:stencil];
    clippingNode.alphaThreshold = 0.5;
    [self addChild:clippingNode];
    
    CCNodeColor* colorNode = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:1]];
    [clippingNode addChild:colorNode];
    //[clippingNode addChild:[MainGameLayer sharedGameLayer] z:0];
    clippingNode.position = gameLayerRect.origin;
    //[MainGameLayer sharedGameLayer].position = gameLayerRect.origin;
    
    
    [self addChild:[GUILayer sharedGUILayer] z:1];

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
