//
//  PowerUp.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 8/22/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "PowerUp.h"
#import "Consts.h"

@implementation PowerUp

@synthesize hp = _curHp;
@synthesize name = _name;
@synthesize minMoveDuration = _minMoveDuration;
@synthesize maxMoveDuration = _maxMoveDuration;
@synthesize points=_points;

@end

@implementation HeartPowerUp

+ (id)heart {
    
    HeartPowerUp *heart = nil;
    if ((heart = [[[super alloc] initWithFile:HeartPowerUpImage] autorelease])) {
        heart.hp = 1;
        heart.name = @"Heart";
        heart.minMoveDuration = 6;
        heart.maxMoveDuration = 12;
        heart.points=0;
    }
    return heart;
    
}

@end

@implementation StarPowerUp

+ (id)star {
    
    StarPowerUp *star = nil;
    if ((star = [[[super alloc] initWithFile:StarPowerUpImage] autorelease])) {
        star.hp = 1;
        star.name = @"Star";
        star.minMoveDuration = 6;
        star.maxMoveDuration = 12;
        star.points=300;
    }
    return star;
    
}

@end
@implementation SuperShot

+ (id)SuperShot {
    
    SuperShot *superShot = nil;
    if ((superShot = [[[super alloc] initWithFile:SuperShotPowerUpImage] autorelease])) {
        superShot.hp = 1;
        superShot.name = @"superShot";
        superShot.minMoveDuration = 6;
        superShot.maxMoveDuration = 8;
        superShot.points=300;
    }
    return superShot;
    
}

@end