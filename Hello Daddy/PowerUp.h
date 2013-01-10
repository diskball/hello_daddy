//
//  PowerUp.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 8/22/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"

@interface PowerUp : CCSprite{
    
    NSString *_name;
    int _curHp;
    int _minMoveDuration;
    int _maxMoveDuration;
    int _points;
}
@property (nonatomic, assign) int hp;
@property(nonatomic,assign) NSString *name;
@property(nonatomic,assign) int minMoveDuration;
@property(nonatomic,assign) int maxMoveDuration;
@property(nonatomic,assign) int points;

@end

@interface HeartPowerUp : PowerUp {
}
+(id)heart;

@end

@interface StarPowerUp : PowerUp {
}
+(id)star;
@end

@interface SuperShot : PowerUp {
}
+(id)SuperShot;

@end

