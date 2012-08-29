//
//  HelloWorldLayer.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright Iteam 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayerColor
{
    CCLabelTTF *_label;

    BOOL _moving;
}
@property (nonatomic, assign) CCLabelTTF *label;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;


@end
