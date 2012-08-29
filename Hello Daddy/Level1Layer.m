//
//  Level1Layer.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/28/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//
// Import the interfaces
#import "Level1Layer.h"
#import "SimpleAudioEngine.h"
#import "GameOverClass.h"
#import "Lavel2Layer.h"
#import "Monster.h"
#import "AppDelegate.h"
#import "LeaderBoard.h"
#import "PowerUp.h"

// HelloWorldLayer implementation
@implementation Level1Layer
@synthesize walkAction = _walkAction;
@synthesize hud = _hud;
@synthesize lives = _lives;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Level1Layer *layer = [Level1Layer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
    //add hud layer
    HudLayer *hud = [HudLayer node];    
    [scene addChild: hud];
    
    layer.hud = hud;
    
    //add lives layer
    LivesLayer *lives = [LivesLayer node];    
    [scene addChild: lives];
    
    layer.lives = lives;
    
	// return the scene
	return scene;
}
-(void)spriteMoveFinished:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    if (sprite.tag == 1) { // target
        appDelegate.lives--;
        if (appDelegate.lives>0) {
            [_lives livesChanged:appDelegate.lives];
        }else {
            [_targets removeObject:sprite];
            GameOverScene *gameOverScene = [GameOverScene node];
            NSString *labelText=[NSString stringWithFormat:@"Hello Daddy...!!! \nShake your iphone to make it sleep. \nScore: %i",appDelegate.score];
            appDelegate.secondTime=FALSE;
            [gameOverScene.layer.label setString:labelText];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        
    } else if (sprite.tag == 2) { // projectile
        [_projectiles removeObject:sprite];
    }
}

-(void)addPowerUp{
    PowerUp *powerUp = nil;
    
    powerUp = [StarPowerUp star];
    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = powerUp.contentSize.height/2;
    int maxY = winSize.height - powerUp.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    powerUp.position = ccp(winSize.width + (powerUp.contentSize.width/2), actualY);
    [self addChild:powerUp];
    
    // Determine speed of the target
    int minDuration = powerUp.minMoveDuration; //2.0;
    int maxDuration = powerUp.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration
                                        position:ccp(-powerUp.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [powerUp runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    powerUp.tag = 10;
    [_targets addObject:powerUp];
}

-(void)addTarget {
    
    //CCSprite *target = [CCSprite spriteWithFile:@"Target.png" rect:CGRectMake(0, 0, 27, 40)]; 
    Monster *target = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
     @"sperm_default.plist"];
    CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                      batchNodeWithFile:@"sperm_default.png"];
    [self addChild:spriteSheet];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 0; i <= 2; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"sp%d.png", i]]];
    }
    
    CCAnimation *walkAnim = [CCAnimation 
                             animationWithFrames:walkAnimFrames delay:0.1f];
    
    target = [WeakAndFastMonster monster];
    
    self.walkAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    [target runAction:_walkAction];
    
    // Determine where to spawn the target along the Y axis
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = target.contentSize.height/2;
    int maxY = winSize.height - target.contentSize.height/2;
    int rangeY = maxY - minY;
    int actualY = (arc4random() % rangeY) + minY;
    
    // Create the target slightly off-screen along the right edge,
    // and along a random position along the Y axis as calculated above
    target.position = ccp(winSize.width + (target.contentSize.width/2), actualY);
    [self addChild:target];
    
    // Determine speed of the target
    int minDuration = target.minMoveDuration; //2.0;
    int maxDuration = target.maxMoveDuration; //4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;
    
    // Create the actions
    id actionMove = [CCMoveTo actionWithDuration:actualDuration 
                                        position:ccp(-target.contentSize.width/2, actualY)];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self 
                                             selector:@selector(spriteMoveFinished:)];
    [target runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
    target.tag = 1;
    [_targets addObject:target];
}
-(void)gameLogic:(ccTime)dt {
    [self addTarget];
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[SimpleAudioEngine sharedEngine] playEffect:@"scifi003.mp3"];
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"condom.png" 
                                               rect:CGRectMake(0, 0, 68, 20)];
    projectile.position = ccp(20, winSize.height/2);
    
    // Determine offset of location to projectile
    int offX = location.x - projectile.position.x;
    int offY = location.y - projectile.position.y;
    
    // Bail out if we are shooting down or backwards
    if (offX <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    // Determine where we wish to shoot the projectile to
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offY / (float) offX;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far we're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                           nil]];
    projectile.tag = 2;
    [_projectiles addObject:projectile];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.score--;
}
- (void)update:(ccTime)dt {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [_hud numCollectedChanged:appDelegate.score];
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        CGRect projectileRect = CGRectMake(
                                           projectile.position.x - (projectile.contentSize.width/2), 
                                           projectile.position.y - (projectile.contentSize.height/2), 
                                           projectile.contentSize.width, 
                                           projectile.contentSize.height);
        BOOL monsterHit = FALSE;
        NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *target in _targets) {
            CGRect targetRect = CGRectMake(
                                           target.position.x - (target.contentSize.width/2), 
                                           target.position.y - (target.contentSize.height/2), 
                                           target.contentSize.width, 
                                           target.contentSize.height);
            
            if (CGRectIntersectsRect(projectileRect, targetRect)) {
                monsterHit = TRUE;
                if (target.tag!=10) {
                    Monster *monster = (Monster *)target;
                    monster.hp--;
                    if (monster.hp <= 0) {
                        
                        [targetsToDelete addObject:target];
                        //[[SimpleAudioEngine sharedEngine] playEffect:@"scream.wav"];
                        appDelegate.score=appDelegate.score+monster.points;
                        [_hud numCollectedChanged:appDelegate.score];
                        NSLog(@"Monster points: %i",monster.points);
                        [[SimpleAudioEngine sharedEngine] playEffect:@"blast.mp3"];
                    }
                    break;
                }else{
                    PowerUp *powerUp = (PowerUp *)target;
                    powerUp.hp--;
                    if (powerUp.hp<=0) {
                        [targetsToDelete addObject:target];
                        appDelegate.score=appDelegate.score+powerUp.points;
                        [_hud numCollectedChanged:appDelegate.score];
                        if ([powerUp.name isEqualToString:@"Heart"]) {
                            if (appDelegate.lives<5) {
                                appDelegate.lives++;
                                [_lives livesChanged:appDelegate.lives];
                            }
                            [[SimpleAudioEngine sharedEngine] playEffect:@"liveUpSound.mp3"];
                        }else if ([powerUp.name isEqualToString:@"Star"]){
                            [[SimpleAudioEngine sharedEngine] playEffect:@"starSound.mp3"];
                        }
                        NSLog(@"Power Up collected");
                    }
                    break;
                }
                		
            }						
        }
        
        for (CCSprite *target in targetsToDelete) {
            [_targets removeObject:target];
            [self removeChild:target cleanup:YES];
            _projectilesDestroyed++;
            if (_projectilesDestroyed == 51) {
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                [[SimpleAudioEngine sharedEngine] playEffect:@"orgasm.mp3"];
                [self performSelector:@selector(startLevel)
                           withObject:nil afterDelay:3.0f];
            }
        }
        
        if (targetsToDelete.count > 0 || monsterHit) {
            [projectilesToDelete addObject:projectile];
        }
        [targetsToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}
-(void)startLevel{
    CCScene *level2Scene = [Lavel2Layer scene];
    _projectilesDestroyed = 0;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.5 scene:level2Scene]];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //preload music and sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"orgasm.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"peter_gunn.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"scifi003.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"liveUpSound.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"starSound.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"blast.mp3"];
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
        
        //init bg picture
		CCSprite* background = [CCSprite spriteWithFile:@"bg2.png"];
        background.tag = 1;
        background.anchorPoint = CGPointMake(0, 0);
        [self addChild:background];
        
		
        // Get the dimensions of the window for calculation purposes
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		// Add the player to the middle of the screen along the y-axis, 
		// and as close to the left side edge as we can get
		// Remember that position is based on the anchor point, and by default the anchor
		// point is the middle of the object.
		CCSprite *player = [CCSprite spriteWithFile:@"condom.png" rect:CGRectMake(0, 0, 68, 40)];
		player.position = ccp(player.contentSize.width/2, winSize.height/2);
		[self addChild:player];
		
        if (appDelegate.secondTime) {
            // Call game logic about every second
            [self schedule:@selector(gameLogic:) interval:0.5];
        }else{
            // Call game logic about every second
            [self schedule:@selector(gameLogic:) interval:1.0];
        }
		
		[self schedule:@selector(update:)];
		
		// Start up the background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"peter_gunn.mp3" loop:YES];
        [self performSelector:@selector(addPowerUp) withObject:nil
                   afterDelay:5];
		
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    // don't forget to call "super dealloc"
	[super dealloc];
	[_targets release];
    _targets = nil;
    [_projectiles release];
    _projectiles = nil;
    [_walkAction release];
    _walkAction=nil;
    [_hud release];
    _hud=nil;
}
@end