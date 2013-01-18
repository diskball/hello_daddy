//
//  HowToPlay.m
//  Hello Daddy
//
//  Created by George Bafaloukas on 1/14/13.
//
//

#import "HowToPlay.h"
#import "SimpleAudioEngine.h"
#import "HelloWorldLayer.h"
@implementation HowToPlay
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HowToPlay *layer = [HowToPlay node];
	
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
        //[[SimpleAudioEngine sharedEngine] preloadEffect:LoadingEffect];
        //[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:MenuMusic];
        
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        if (winSize.width==568) {
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:HowtoplayBackgroundIphone5];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }else if (winSize.width==1024) {
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:HowtoplayBackgroundIpad];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }
        else{
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:HowtoplayBackground];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }
        CCMenuItem *back = [CCMenuItemImage
                            itemFromNormalImage:MainMenuBackButton selectedImage:MainMenuBackButton
                            target:self selector:@selector(returnToMenu) ];
        
        back.position = ccp(winSize.width-120, 50);
        
        CCMenu *levelMenu = [CCMenu menuWithItems:back, nil];
        levelMenu.position = CGPointZero;
        [self addChild:levelMenu];

        
        
    }
    return self;
}
-(void)returnToMenu{
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.2 scene:[HelloWorldLayer scene]]];
}
-(void) dealloc{
    [super dealloc];
    
}
@end
