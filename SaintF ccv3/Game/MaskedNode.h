//
//  MaskedNode.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 23/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

@protocol MaskedNode <NSObject>

-(CCSprite*) mask;
-(CGPoint) position;

@end
