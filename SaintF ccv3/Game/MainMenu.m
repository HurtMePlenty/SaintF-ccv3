//
//  MyCocos2DClass.m
//  SaintF
//
//  Created by Eliphas on 22.04.14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "MainMenu.h"
#import "GameScreen.h"

@interface MainMenu(){
    CGSize screenSize;
}
@end

@implementation MainMenu

- (id)init {
    if(self = [super init])
    {
        self.color = [CCColor colorWithRed:220 green:220 blue:255];
        self.opacity = 255;
        screenSize = [[CCDirector sharedDirector] viewSize];
        [self createMenu];
    }
    return self;
}

+(CCScene*) scene {
    CCScene* menuScene = [CCScene node];
    MainMenu* menuLayer = [MainMenu node];
    [menuScene addChild:menuLayer];
    return menuScene;
}

-(void) createMenu {
    CCButton* playBtn = [CCButton buttonWithTitle:@"play"];
    playBtn.block = ^(id sender) {
        [self playGameHandler:sender];
    };
    [self addChild:playBtn];
    playBtn.position = ccp(300,300);
                    
    
    
}

-(void) playGameHandler:(id)sender {
    CCLOG(@"play click");
    [[CCDirector sharedDirector] replaceScene: [GameScreen scene]];
}

@end
