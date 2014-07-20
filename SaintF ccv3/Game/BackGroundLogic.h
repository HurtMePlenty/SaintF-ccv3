//
//  BackGroundLogic.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 03/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

typedef enum {
    bush,
    klen,
    oak,
    platan,
    yasen
} BackgroundObjects;

@interface BackGroundLogic : NSObject

-(void) scroll:(float)dx;
-(void) buildInitialBackground;

@end
