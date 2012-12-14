//
//  LivesLayer.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/15/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"

@interface LivesLayer : CCLayer{
    CCSprite *lives;
    CCTexture2D *tex1;
    CCTexture2D *tex2;
    CCTexture2D *tex3;
    CCTexture2D *tex4;
    CCTexture2D *tex5;
}

@property (nonatomic,assign) CCSprite *lives;

@property (nonatomic,assign) CCTexture2D *tex1;
@property (nonatomic,assign) CCTexture2D *tex2;
@property (nonatomic,assign) CCTexture2D *tex3;
@property (nonatomic,assign) CCTexture2D *tex4;
@property (nonatomic,assign) CCTexture2D *tex5;


- (void)livesChanged:(int)livesRemaining;

@end
