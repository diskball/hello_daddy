//
//  BonusLevel.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 8/23/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"
#import "HudLayer.h"
#import "LivesLayer.h"

@interface BonusLevel : CCLayerColor{
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    int _projectilesDestroyed;
    CCSprite *_player;
    CCSprite *_nextProjectile;
    CCAction *_walkAction;
    HudLayer *_hud;
    LivesLayer *_lives;
    int starCounter;
    
}

// returns a CCScene that contains the Lavel2Layer as the only child
+(CCScene *) scene;
@property (nonatomic, retain) HudLayer *hud;
@property (nonatomic, retain) LivesLayer *lives;
@property (nonatomic, retain) CCAction *walkAction;
@end