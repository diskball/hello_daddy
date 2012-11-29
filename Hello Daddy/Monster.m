//
//  Monster.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "Monster.h"

@implementation Monster

@synthesize hp = _curHp;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;
@synthesize points=_points;

@end

@implementation WeakAndFastMonster

+ (id)monster {
    
    WeakAndFastMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"sp1.png"] autorelease])) {
        monster.hp = 1;
        monster.minMoveDuration = 6;
        monster.maxMoveDuration = 12;
        monster.points=100;
    }
    return monster;
   
}

@end

@implementation StrongAndSlowMonster

+ (id)monster {
    
    StrongAndSlowMonster *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"fat_headed_sperm_frame.png"] autorelease])) {
        monster.hp = 3;
        monster.minMoveDuration = 8;
        monster.maxMoveDuration = 14;
        monster.points=200;
    }
    return monster;
    
}

@end

@implementation Virus1

+ (id)monster {
    
    Virus1 *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"virus_1.png"] autorelease])) {
        monster.hp = 5;
        monster.minMoveDuration = 8;
        monster.maxMoveDuration = 14;
        monster.points=300;
    }
    return monster;
    
}

@end

@implementation FirstBoss

+ (id)monster {
    
    FirstBoss *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"virus_boss.png"] autorelease])) {
        monster.hp = 30;
        monster.minMoveDuration = 30;
        monster.maxMoveDuration = 35;
        monster.points=1000;
    }
    return monster;
    
}

@end

@implementation BigBoss

+ (id)monster {
    
    BigBoss *monster = nil;
    if ((monster = [[[super alloc] initWithFile:@"boss0.png"] autorelease])) {
        monster.hp = 40;
        monster.minMoveDuration = 30;
        monster.maxMoveDuration = 35;
        monster.points=5000;
    }
    return monster;
    
}

@end