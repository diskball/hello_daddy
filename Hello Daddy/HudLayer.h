//
//  HudLayer.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/15/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"
@interface HudLayer : CCLayer
{   
    CCLabelTTF *label;
}

@property (nonatomic,assign) CCLabelTTF *label;
- (void)numCollectedChanged:(int)numCollected;

@end
