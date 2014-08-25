//
//  BGObject.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 22/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "cocos2d.h"
#import "CCNode.h"
#import "BGObjectInfo.h"

@interface BGObject : CCNode

@property bool isDead;

-(void) remove;
-(void) moveBy: (CGPoint) point;
-(CGSize) size;

+(BGObject*) spawnBGObjectWithInfo:(BGObjectInfo *)info AtPoint:(CGPoint)point;
+(BGObject*) spawnBGObjectWithInfo:(BGObjectInfo *)info AtX:(float)x;
@end
