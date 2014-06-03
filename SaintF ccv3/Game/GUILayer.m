//
//  GUILayer.m
//  SaintF
//
//  Created by Alexey Semenov on 29/04/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "GUILayer.h"
#import "Hero+HeroMove.h"
#import "Hero+HeroCast.h"



static GUILayer* _sharedGUILayer;

@interface GUILayer() {
    CCNodeColor* progressBar;
}

@end


@implementation GUILayer

const float progressBarWidth = 150.0f;

-(id)init {
    if(self = [super init])
    {
        CGSize size = [CCDirector sharedDirector].viewSize;
        self.userInteractionEnabled = TRUE;
        self.contentSize = size;
        [self buildControls];
        [self buildProgressBar];
    }
    return self;
}


-(void)showProgressBar:(float)percentage {
    progressBar.visible = true;
    progressBar.contentSize = CGSizeMake(progressBarWidth * percentage, progressBar.contentSize.height);
}

-(void) hideProgressBar {
    progressBar.visible = false;
}


-(void) buildControls {
    CCButton* blessBtn = [CCButton buttonWithTitle:@"Bless"];
    
    [blessBtn setColor:[CCColor colorWithRed:1.0f green:0.0f blue:0.0f] ];
    blessBtn.position = ccp(400, 50);
    blessBtn.block = ^(id sender){
        [[Hero sharedHero] startBless];
    };
    blessBtn.exclusiveTouch = false;
    [self addChild:blessBtn];
}

-(void) buildProgressBar {
    progressBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.5f green:0.0f blue:0.5f alpha:1.0f]];
    progressBar.contentSize = CGSizeMake(progressBarWidth, 10);
    progressBar.position = ccp(300, 30);
    [self addChild:progressBar];
    [self hideProgressBar];
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

+(GUILayer*) sharedGUILayer {
    if(!_sharedGUILayer)
    {
        _sharedGUILayer = [[GUILayer alloc] init];
    }
    return _sharedGUILayer;
}

@end
