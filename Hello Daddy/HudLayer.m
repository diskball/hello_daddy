//
//  HudLayer.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/15/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "HudLayer.h"

@implementation HudLayer
@synthesize label;

-(id) init
{
    if ((self = [super init])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        label = [CCLabelTTF labelWithString:@"0" dimensions:CGSizeMake(100, 20)
                                  alignment:UITextAlignmentRight fontName:@"Verdana-Bold" 
                                   fontSize:15.0];
        label.color = ccc3(255,255,255);
        int margin = 10;
        label.position = ccp(winSize.width - (label.contentSize.width/2) 
                             - margin, label.contentSize.height/2 + margin);
        [self addChild:label];
    }
    return self;
}

- (void)numCollectedChanged:(int)numCollected {
    if (numCollected>=0) {
         [label setString:[NSString stringWithFormat:@"%d", numCollected]];
    }
}

-(void)dealloc{
    [super dealloc];
}
@end
