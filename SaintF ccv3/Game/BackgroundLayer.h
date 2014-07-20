//
//  BackgroundLayer.h
//  SaintF
//
//  Created by Alexey Semenov on 29/04/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BackgroundLayer : CCNode {
    
}

+(BackgroundLayer*) sharedBGLayer;
+(CGRect) gameLayerRect;


@end
