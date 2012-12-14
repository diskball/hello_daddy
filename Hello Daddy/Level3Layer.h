//
//  Level3Layer.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/11/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HudLayer.h"
#import "LivesLayer.h"
#import "Consts.h"
// Level3Layer
@interface Level3Layer : CCLayerColor
{
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    int _projectilesDestroyed;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    CCAction *_walkAction;
    HudLayer *_hud;
    LivesLayer *_lives;
    
    //Pause Menu
    //CCSprite *_movingSpring;
    bool _pauseScreenUp;
    CCLayer *pauseLayer;
    CCSprite *_pauseScreen;
    CCMenu *_pauseScreenMenu;
     CCMenuItem *bombItem;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) HudLayer *hud;
@property (nonatomic , assign) LivesLayer *lives;
//pause
//@property (nonatomic, assign) CCSprite *_movingSpring;
@property (nonatomic, assign) CCLayer *pauseLayer;
@property (nonatomic, assign) CCSprite *_pauseScreen;
@property (nonatomic, assign) CCMenu *_pauseScreenMenu;
@property (nonatomic, assign) CCMenuItem *bombItem;
@end