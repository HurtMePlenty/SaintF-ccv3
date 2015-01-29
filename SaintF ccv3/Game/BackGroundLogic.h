//
//  BackGroundLogic.h
//  SaintF ccv3
//
//  Created by Alexey Semenov on 03/07/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import "cocos2d.h"
#import <Foundation/Foundation.h>

static int BASE_LINE_HEIGHT = 20.0f;

typedef enum {
    bush,
    klen,
    oak,
    platan,
    yasen
} BackgroundObjects;

@interface BackGroundLogic : NSObject

-(bool) scroll:(float)dx;
-(void) buildInitialBackground;


@end
