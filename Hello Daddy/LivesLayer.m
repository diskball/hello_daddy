//
//  LivesLayer.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/15/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "LivesLayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
@implementation LivesLayer
@synthesize lives;
@synthesize tex1;
@synthesize tex2;
@synthesize tex3;
@synthesize tex4;
@synthesize tex5;


-(id) init
{
    if ((self = [super init])) {
        //init bg picture
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"scream.wav"];
        self.tex1 = [[CCTextureCache sharedTextureCache] addImage:@"1lives.png"];
        self.tex2 = [[CCTextureCache sharedTextureCache] addImage:@"2lives.png"];
        self.tex3 = [[CCTextureCache sharedTextureCache] addImage:@"3lives.png"];
        self.tex4 = [[CCTextureCache sharedTextureCache] addImage:@"4lives.png"];
        self.tex5 = [[CCTextureCache sharedTextureCache] addImage:@"5lives.png"];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.lives = [CCSprite spriteWithTexture:self.tex5];
        self.lives.tag = 1;
        self.lives.position = ccp(self.lives.contentSize.width/2, winSize.height-15);
        [self livesChanged:appDelegate.lives];
        [self addChild:self.lives];
        
    }
    return self;
}

- (void)livesChanged:(int)livesRemaining{
    if (livesRemaining < 5) {
        [[SimpleAudioEngine sharedEngine] playEffect:@"scream.wav"];
    }
    if (livesRemaining >= 5) {
        self.lives.texture=self.tex5;
    }
    else if (livesRemaining == 4) {
       self.lives.texture=self.tex4;
    }else if (livesRemaining == 3) {
        self.lives.texture=self.tex3;
    }else if (livesRemaining == 2) {
        self.lives.texture=self.tex2;
    }else if (livesRemaining == 1) {
        self.lives.texture=self.tex1;
    }
}
- (void) dealloc
{
    // don't forget to call "super dealloc"
	[super dealloc];
    
    /*
     [self.lives release];
     [self.tex1 release];
     [self.tex2 release];
     [self.tex3 release];
     [self.tex4 release];
     [self.tex5 release];
     */
    
}

@end
