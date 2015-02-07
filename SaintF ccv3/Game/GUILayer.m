//
//  GUILayer.m
//  SaintF
//
//  Created by Alexey Semenov on 29/04/14.
//  Copyright 2014 Eliphas. All rights reserved.
//

#import "GUILayer.h"
#import "Hero+HeroMove.h"
#import "Hero+HeroCast.h"
#import "GameMusicPlayer.h"
#import "Constants.h"
#import "GameLogic.h"


static GUILayer* _sharedGUILayer;

@interface GUILayer() {
    //CCNodeColor* progressBar;
    CCButton* blessBtn;
    CCLabelTTF* scoreLabel;
    
    CCSprite* manaBar;
    CCTime fullBarTimeLimit;
    NSString* scoreText;
    int score;
    
    //manabar
    CCSprite* manaPiece;
    CCSprite* manaSample;
    float manaBarSize; //without left/right borders
    float manaBarLRBorder; //left/right border. Just try to find out the correct amount of pixels xD
    float manaSampleSize;
    float manaSampleInitScale;
}

@end


@implementation GUILayer

const float progressBarWidth = 150.0f;



-(id)init {
    if(self = [super init])
    {
        fullBarTimeLimit = GAME_TIME_MAX;
        CGSize size = [CCDirector sharedDirector].viewSize;
        self.userInteractionEnabled = TRUE;
        self.contentSize = size;
        score = 0;
        [self buildControls];
        [self setScoreText];
        
        
        //[self buildProgressBar];
    }
    return self;
}

/*
 -(void)showProgressBar:(float)percentage {
 progressBar.visible = true;
 progressBar.contentSize = CGSizeMake(progressBarWidth * percentage, progressBar.contentSize.height);
 }
 
 -(void) hideProgressBar {
 progressBar.visible = false;
 }*/


-(void) buildControls {
    blessBtn = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:@"bird_button_passive.png"]];
    __weak CCButton* blessBtnWeak = blessBtn;
    blessBtn.scale = 0.5;
    [blessBtn setColor:[CCColor colorWithRed:1.0f green:0.0f blue:0.0f] ];
    blessBtn.position = ccp(self.contentSize.width - 75, 40);
    blessBtn.block = ^(id sender){
        [blessBtnWeak setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"bird_button_active.png"] forState: CCControlStateNormal];
        [[Hero sharedHero] startBless];
    };
    blessBtn.exclusiveTouch = false;
    [self addChild:blessBtn];
    
    
    CCButton* muteMusic = [CCButton buttonWithTitle:@"Mute music"];
    muteMusic.position = ccp(150, 40);
    __weak CCButton* muteMusicWeak = muteMusic;
    
    muteMusic.block = ^(id sender){
        if([GameMusicPlayer isBgMuted]){
            [GameMusicPlayer unmuteBackgroundMusic];
            muteMusicWeak.title = @"Mute music";
        } else {
            [GameMusicPlayer muteBackgroundMusic];
            muteMusicWeak.title = @"Unmute music";
        }
    };
    [self addChild: muteMusic];
    
    scoreLabel = [CCLabelTTF labelWithString:@"Score will be set later" fontName:@"Helvetica" fontSize:14];
    scoreLabel.position = ccp(self.contentSize.width - 150, 40);
    [self addChild: scoreLabel];
    
    
    //Mana bar
    manaBarLRBorder = 7.0f;
    manaBar = [CCSprite spriteWithImageNamed:@"tube_empty.png"];
    manaBar.position = ccp(self.contentSize.width / 2, 15);
    [self addChild: manaBar];
    manaBarSize = manaBar.contentSize.width - manaBarLRBorder * 2;
    
    manaSample = [CCSprite spriteWithImageNamed:@"mana_sample.png"];
    manaSample.zOrder = -1;
    manaSampleInitScale = 5.0f;
    manaSample.scaleX = manaSampleInitScale;
    manaSampleSize = manaSample.boundingBox.size.width;
    [manaBar addChild: manaSample];
    
    manaPiece = [CCSprite spriteWithImageNamed:@"mana_piece.png"];
    manaPiece.zOrder = -1;
    [manaBar addChild:manaPiece];
    
    [self updateGameTimeLeft:fullBarTimeLimit];
}

-(void) blessStopped {
    [blessBtn setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"bird_button_passive.png"] forState: CCControlStateNormal];
}

/*-(void) buildProgressBar {
 progressBar = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.5f green:0.0f blue:0.5f alpha:1.0f]];
 progressBar.contentSize = CGSizeMake(progressBarWidth, 10);
 progressBar.position = ccp(300, 30);
 [self addChild:progressBar];
 [self hideProgressBar];
 }*/

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    if([GameLogic sharedGameLogic].isGameOver){
        return;
    }
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    float fullWidth = [[CCDirector sharedDirector] viewSize].width;
    MoveDirection direction;
    if(location.x < fullWidth / 2)
    {
        direction = LEFT;
    }
    else {
        direction = RIGHT;
    }
    [[Hero sharedHero] startMoving:direction];
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [[Hero sharedHero] stopMoving];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
}

-(void) touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
}

-(void) addScore {
    score++;
    [self setScoreText];
}

-(void) setScoreText {
    scoreText = [NSString stringWithFormat:@"Score: %d", score];
    [scoreLabel setString: scoreText];
}

-(void) updateGameTimeLeft: (CCTime)time {
    //manaPiece - is solid part of or bar and can be scaled to produce long bar
    //manaSample - is part with blur
    
    float y = manaSampleSize;
    
    float x = manaBarSize - y;
    float fullManaPieceScale = x / manaPiece.contentSize.width;
    //float minRatioForManaPiece = blurPartWidth / manaBarSize;
    
    float timeLeftRatio = time / fullBarTimeLimit;
    if(timeLeftRatio >= 1){
        timeLeftRatio = 1;
        
    }
    
    float mult = 1 - timeLeftRatio;
    float xScale = fullManaPieceScale * ((x - mult * x - mult * y) / x);
    if(xScale <= 0){
        xScale = 0;
        float yScale = timeLeftRatio / ( y / (x + y));
        if(yScale <= 0){
            yScale = 0;
        }
        manaSample.scaleX = yScale * manaSampleInitScale;
    }
    manaPiece.scaleX = xScale;
    
    float realSolidWidth = manaPiece.boundingBox.size.width;
    manaPiece.position = ccp(realSolidWidth / 2 + manaBarLRBorder, manaPiece.contentSize.height / 2 + 2);
    manaSample.position = ccp(manaSample.boundingBox.size.width / 2 + realSolidWidth + manaBarLRBorder - 2, manaSample.contentSize.height / 2 + 2);
    //we need to add 2 points to height cuz of bad manabar pic. It has like 4 free px at the bottom
}

-(void) gameOver {
    blessBtn.enabled = false;
    [blessBtn setBackgroundOpacity:1.0f forState:CCControlStateDisabled];
    
    CCLabelTTF* gameOverLabel = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Helvetica" fontSize:24];
    //[gameOverLabel setColor:[CCColor colorWithWhite:0 alpha:1]];
    gameOverLabel.position = ccp(self.contentSize.width / 2, self.contentSize.height / 2 + 50);
    [self addChild: gameOverLabel];

    //todo add button for replay and label with score
}


+(GUILayer*) sharedGUILayer {
    if(!_sharedGUILayer)
    {
        _sharedGUILayer = [[GUILayer alloc] init];
    }
    return _sharedGUILayer;
}

@end
