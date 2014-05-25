//
//  GUILayer.m
//  SaintF
//
//  Created by Alexey Semenov on 29/04/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "GUILayer.h"
#import "Hero.h"


static GUILayer* _sharedGUILayer;

@interface GUILayer() {
    
}

@end


@implementation GUILayer

-(id)init {
    if(self = [super init])
    {
        CGSize size = [CCDirector sharedDirector].viewSize;
        self.userInteractionEnabled = TRUE;
        self.contentSize = size;
    }
    return self;
}

-(void) buildControls {
    
    
    /*CCMenuItem blessBtn = [CCMenuItemSprite itemWithNormalSprite:<#(CCNode<CCRGBAProtocol> *)#> selectedSprite:<#(CCNode<CCRGBAProtocol> *)#> target:<#(id)#> selector:<#(SEL)#>]
    
    CCMenuItem *starMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(starButtonTapped:)];
    starMenuItem.position = ccp(60, 60);
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];*/
}

+(GUILayer*) sharedGUILayer {
    if(!_sharedGUILayer)
    {
        _sharedGUILayer = [[GUILayer alloc] init];
    }
    return _sharedGUILayer;
}



- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    float fullWidth = [[CCDirector sharedDirector] viewSize].width;
    MoveDirection direction;
    if(location.x < fullWidth / 2)
    {
        direction = LEFT;
    }
    else {
        direction = RIGHT;
    }
    [[Hero sharedHero] startMoving:direction];
    
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [[Hero sharedHero] stopMoving];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
}

@end
