//
//  MyCocos2DClass.m
//  SaintF
//
//  Created by Eliphas on 22.04.14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "MainMenu.h"
#import "GameScreen.h"
#import "GameMusicPlayer.h"

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
    
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    
    CCSprite* wood = [CCSprite spriteWithImageNamed:@"wood.png"];
    wood.position = CGPointMake(wood.contentSize.width / 2, wood.contentSize.height / 2);
    [self addChild:wood];
    
    CCSprite* paper = [CCSprite spriteWithImageNamed:@"paper.png"];
    float offsetY = winSize.height - paper.contentSize.height; //paper should be bounded to the top of hte screen
    
    paper.position = CGPointMake(paper.contentSize.width / 2, paper.contentSize.height / 2 + offsetY);
    [self addChild:paper];
    
    CCSprite* mainArt = [CCSprite spriteWithImageNamed:@"startPicture.png"];
    mainArt.position = ccp(mainArt.contentSize.width / 2 + 160, mainArt.contentSize.height / 2 + 120);
    [self addChild:mainArt];
    
    CCSprite* artLabel = [CCSprite spriteWithImageNamed:@"startLabel.png"];
    artLabel.position = ccp(artLabel.contentSize.width / 2 + 110, artLabel.contentSize.height / 2 + 110);
    [self addChild:artLabel];
    
    
    CCButton* playBtn = [CCButton buttonWithTitle:@"Play"fontName:@"Helvetica" fontSize:36];
    playBtn.color = [CCColor blackColor];
    [playBtn setLabelColor:[CCColor blackColor] forState: CCControlStateHighlighted];
    playBtn.block = ^(id sender) {
        [self playGameHandler:sender];
    };
    [self addChild:playBtn];
    playBtn.position = ccp(winSize.width / 2 + 100, paper.contentSize.height / 2 + offsetY);
}

-(void) playGameHandler:(id)sender {
    CCLOG(@"play click");
    [GameMusicPlayer playBackgroundMusic];
    [[CCDirector sharedDirector] replaceScene: [GameScreen scene]];
}

@end
