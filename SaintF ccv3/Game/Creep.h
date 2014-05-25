//
//  Creep.h
//  SaintF
//
//  Created by Alexey Semenov on 02/05/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BGObjectInfo.h"
#import "FlowingAnimation.h"

typedef enum {
    raven,
    paulin
} creepTypes;

@interface Creep : CCNode {
    
}

@property (nonatomic) bool isDead;

-(CGRect) hitBox;
-(CGSize) size;
-(void)startMoving:(MoveDirection)direction;
-(void) spawnAtPosition: (CGPoint)position;
-(id) initWithType: (creepTypes) type;
-(void) move: (CGPoint) point;

+(Creep*) spawnCreepWithType: (creepTypes) type position: (CGPoint)position;

@end
