//
//  Level1Layer.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/28/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HudLayer.h"
#import "LivesLayer.h"
// HelloWorldLayer
@interface Level1Layer : CCLayerColor
{
    NSMutableArray *_targets;
    NSMutableArray *_projectiles;
    int _projectilesDestroyed;
    CCAction *_walkAction;
    HudLayer *_hud;
    LivesLayer *_lives;
   
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) HudLayer *hud;
@property (nonatomic, retain) LivesLayer *lives;




@end

