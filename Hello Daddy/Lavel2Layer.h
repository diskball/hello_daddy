//
//  Lavel2Layer.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HudLayer.h"
#import "LivesLayer.h"
#import "Consts.h"

// Lavel2Layer
@interface Lavel2Layer : CCLayerColor
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
    CCSprite *_movingSpring;
    bool _pauseScreenUp;
    CCLayer *pauseLayer;
    CCSprite *_pauseScreen;
    CCMenu *_pauseScreenMenu;
    CCMenuItem *bombItem;
    CCMenuItem *superShotItem;
    
}

// returns a CCScene that contains the Lavel2Layer as the only child
+(CCScene *) scene;
@property (nonatomic, retain) HudLayer *hud;
@property (nonatomic, assign) LivesLayer *lives;
@property (nonatomic, retain) CCAction *walkAction;
//pause
@property (nonatomic, assign) CCSprite *_movingSpring;
@property (nonatomic, assign) CCLayer *pauseLayer;
@property (nonatomic, assign) CCSprite *_pauseScreen;
@property (nonatomic, assign) CCMenu *_pauseScreenMenu;
@property (nonatomic, assign) CCMenuItem *bombItem;
@property (nonatomic, assign) CCMenuItem *superShotItem;

@end