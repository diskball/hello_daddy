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
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) HudLayer *hud;
@property (nonatomic , retain) LivesLayer *lives;
@end