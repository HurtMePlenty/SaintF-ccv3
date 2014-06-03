//
//  FlowingAnimation.h
//  SaintF
//
//  Created by Alexey Semenov on 03/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    LEFT,
    RIGHT
} MoveDirection;

@interface FlowingAnimation : CCSprite

-(id)initWithFrames: (NSArray*)frames delay:(float)delay callBack:(void(^)(CGPoint, int))delegate;
-(void) startAnimation;
-(void) startAnimationWithShift: (CGPoint)shift;
-(void) setShift: (CGPoint) shift;
-(void) stopAnimation;
-(void) pauseAnimation;
-(void) resumeAnimation;

@end
