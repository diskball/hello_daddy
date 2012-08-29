//
//  Monster.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"

@interface Monster : CCSprite {
    int _curHp;
    int _minMoveDuration;
    int _maxMoveDuration;
    int _points;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int minMoveDuration;
@property (nonatomic, assign) int maxMoveDuration;
@property (nonatomic, assign) int points;

@end

@interface WeakAndFastMonster : Monster {
}
+(id)monster;
@end

@interface StrongAndSlowMonster : Monster {
}
+(id)monster;
@end

@interface Virus1 : Monster {
}
+(id)monster;
@end

@interface FirstBoss : Monster {
}
+(id)monster;
@end