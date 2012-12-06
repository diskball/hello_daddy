//
//  HelloWorldLayer.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright Iteam 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "GameOverClass.h"
#import "Level1Layer.h"
#import "Monster.h"
#import "Rankings.h"
#import "AppDelegate.h"
// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize label = _label;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        //preload music and sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:LoadingEffect];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:MenuMusic];
        
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        if (winSize.width==568) {
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:MenuBackgroundIphone5];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }else{
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:MenuBackground];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }

        
        
        /* Opening Text
        self.label = [CCLabelTTF labelWithString:@"Welcome! Choose Level!" fontName:@"Arial" fontSize:32];
        _label.color = ccc3(255,255,255);
        _label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_label];
        */
        
        // Standard method to create a button
        CCMenuItem *startGame = [CCMenuItemImage
                                    itemFromNormalImage:StartGameButton selectedImage:StartGameButton
                                 target:self selector:@selector(startGame) ];
        
        startGame.position = ccp(winSize.width/2, winSize.height/2+50);
        
        CCMenuItem *highscores = [CCMenuItemImage
                                 itemFromNormalImage:HighScoresButton selectedImage:HighScoresButton
                                 target:self selector:@selector(showRankings) ];
        
        highscores.position = ccp(winSize.width/2, winSize.height/2-50);
        
        CCMenu *levelMenu = [CCMenu menuWithItems:startGame,highscores, nil];
        levelMenu.position = CGPointZero;
        [self addChild:levelMenu];
        
        /*
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:5],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
                         nil]];
         */
        // Start up the background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:MenuMusic loop:YES];
        
    }	
    return self;
}
-(void)showRankings{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.2 scene:[Rankings scene]]];
}
- (void)startGame{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[SimpleAudioEngine sharedEngine] playEffect:LoadingEffect];
    [self performSelector:@selector(startLevel)
               withObject:nil afterDelay:3.0f];
    appDelegate.lives=5;
}
-(void)startLevel{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.3 scene:[Level1Layer scene]]];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    // don't forget to call "super dealloc"
	
    [super dealloc];
    //[_label release];
    //_label = nil;
}
@end
