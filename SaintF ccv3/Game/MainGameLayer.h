//
//  MainGameLayer.h
//  SaintF
//
//  Created by Eliphas on 23.04.14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainGameLayer : CCNode {
    
}
@property (nonatomic) CCSpriteBatchNode* commonBatch;

-(CGSize) size;
-(void) restartLevel;
+(MainGameLayer*) sharedGameLayer;
+(CCSpriteBatchNode*) commonBatch;
+(CGSize) size;


@end
