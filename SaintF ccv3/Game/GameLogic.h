//
//  GameLogic.h
//  SaintF
//
//  Created by Alexey Semenov on 03/05/14.
//  Copyright (c) 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface GameLogic : NSObject

@property (nonatomic) float scrollSpeed;

-(void) scrollBackgroundFor:(float)length;
-(void) buildInitialBackground;
-(void)update:(CCTime)delta;

+(GameLogic*) sharedGameLogic;

@end
