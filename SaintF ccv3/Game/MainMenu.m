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
    CCSprite* startLabel;
    bool touched;
}
@end

@implementation MainMenu

- (id)init {
    if(self = [super init])
    {
        self.color = [CCColor colorWithRed:220 green:220 blue:255];
        self.opacity = 255;
        screenSize = [[CCDirector sharedDirector] viewSize];
        self.contentSize = screenSize;
        [self loadResources];
        [self createMenu];
        self.userInteractionEnabled = TRUE;

        
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
    
    CCSprite* mainArt = [CCSprite spriteWithImageNamed:@"start_icon.png"];
    mainArt.position = ccp(mainArt.contentSize.width / 2 + 260, mainArt.contentSize.height / 2 + 120);
    [self addChild:mainArt];
    
    CCSprite* artLabel = [CCSprite spriteWithImageNamed:@"start_francesco_label.png"];
    artLabel.position = ccp(artLabel.contentSize.width / 2 + 310, artLabel.contentSize.height / 2 + 90);
    [self addChild:artLabel];
    
    startLabel = [CCSprite spriteWithImageNamed:@"start_label.png"];
    startLabel.position = ccp(startLabel.contentSize.width / 2 + 100, startLabel.contentSize.height / 2 + 120);
    [self addChild:startLabel];
}

-(void) playGameHandler {
    CCLOG(@"play click");
    [GameMusicPlayer playBackgroundMusic];
    [[CCDirector sharedDirector] replaceScene: [GameScreen scene]];
}

-(void) loadResources {
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"atlas.plist"];
    [frameCache addSpriteFramesWithFile:@"menuAtlas.plist"];
}


- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];

    if (CGRectContainsPoint(startLabel.boundingBox, location)){
        CCLOG(@"HIT");
        touched = true;
        
        CCAction* scaleAction = [CCActionScaleTo actionWithDuration:0.08f scale:1.1f];
        [startLabel runAction:scaleAction];
    }
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    if(touched &&  CGRectContainsPoint(startLabel.boundingBox, location)){
        [self playGameHandler];
    }
    touched = false;
    CCAction* scaleAction = [CCActionScaleTo actionWithDuration:0.08f scale:1.0f];
    [startLabel runAction:scaleAction];
}

@end
