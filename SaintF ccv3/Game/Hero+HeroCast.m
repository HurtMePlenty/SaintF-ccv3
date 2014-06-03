//
//  Hero+HeroCast.m
//  SaintF ccv3
//
//  Created by Alexey Semenov on 26/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "Hero+HeroCast.h"
#import "Hero+HeroMove.h"
#import "GUILayer.h"
@implementation Hero (HeroCast)

const int lastBlessFrameIndex = 5;
const int waitBlessFrameIndex = 3;
const float blessAnimationDelay = 0.3f;
const float blessChannelingTime = 2.0f;
float blessChannelTimeElapsed = 0.0f;

bool blessChanneling = false;

-(void) buildBlessAnimations {
    
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSpriteFrame* frame1 = [frameCache spriteFrameByName:@"turn1.png"];
    CCSpriteFrame* frame2 = [frameCache spriteFrameByName:@"turn2.png"];
    CCSpriteFrame* frame3 = [frameCache spriteFrameByName:@"turn3.png"];
    CCSpriteFrame* frame4 = [frameCache spriteFrameByName:@"bless1.png"];
    CCSpriteFrame* frame5 = [frameCache spriteFrameByName:@"bless2.png"];
    CCSpriteFrame* frame6 = [frameCache spriteFrameByName:@"bless3.png"];
    
    
    NSArray* moveFrames = [NSArray arrayWithObjects:frame1, frame2, frame3, frame4, frame5, frame6, nil];
    
    void (^callback)(CGPoint, int) = ^(CGPoint shift, int showingIndex){
        [self animationBlessCallback:showingIndex];
    };
    
    void (^updateHanlder)(CCTime) = ^(CCTime delay) {
        [self updateCast:delay];
    };
    [updateHandlers addObject:updateHanlder];
    
    blessAnimation = [[FlowingAnimation alloc] initWithFrames:moveFrames delay:blessAnimationDelay callBack:callback];
    [heroSprite addChild:blessAnimation];
}

-(void) animationBlessCallback:(int)showingIndex {
    if(showingIndex == waitBlessFrameIndex){
        if(!blessChanneling)
        {
            CCLOG(@"Bless channeling time is smaller than the animation time");
            return;
        }
        [blessAnimation pauseAnimation];
        //[self scheduleOnce:@selector(animationChannelingComplete) delay:blessChannelingTime];
    }
    
    if(showingIndex == lastBlessFrameIndex){
        [self stopBless];
        [self castCompleted];
    }
}

-(void) animationChannelingComplete {
    [blessAnimation resumeAnimation];
}

-(void) castCompleted {
    
}

-(void) startBless {
    [heroSprite setTextureRect:CGRectZero];
    blessChanneling = true;
    [blessAnimation startAnimation];
}

-(void) stopBless {
    [self stopAllAndRestoreHero];
}

-(void) updateCast:(CCTime) delta {
    if(blessChanneling){
        [[GUILayer sharedGUILayer] showProgressBar:blessChannelTimeElapsed / blessChannelingTime];
        blessChannelTimeElapsed += delta;
        
        if(blessChannelTimeElapsed > blessChannelingTime){
            blessChannelTimeElapsed = 0.0f;
            [[GUILayer sharedGUILayer] hideProgressBar];
            [blessAnimation resumeAnimation]; //resume if animation was paused cause of channaling time
            blessChanneling = false;
        }
    }
}

@end
