//
//  GUILayer.h
//  SaintF
//
//  Created by Alexey Semenov on 29/04/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"


@interface GUILayer : CCNode {
    
}

//-(void) showProgressBar:(float)percentage;
//-(void) hideProgressBar;
+(GUILayer*) sharedGUILayer;
-(void) blessStopped;
-(void) addScore;
-(void) updateGameTimeLeft: (CCTime)time;

@end
