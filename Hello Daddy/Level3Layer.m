//
//  Level3Layer.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/11/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

// Import the interfaces
#import "Level3Layer.h"
#import "SimpleAudioEngine.h"
#import "GameOverClass.h"
#import "Monster.h"
#import "AppDelegate.h"
#import "Level4Layer.h"
#import "PowerUp.h"

// HelloWorldLayer implementation
@implementation Level3Layer
@synthesize walkAction = _walkAction;
@synthesize hud = _hud;
@synthesize lives = _lives;
@synthesize pauseLayer;
@synthesize _pauseScreen;
@synthesize _pauseScreenMenu;
@synthesize bombItem;
@synthesize superShotItem;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Level3Layer *layer = [Level3Layer node];
	
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
    if (sprite.tag == 1 || sprite.tag == 3) { // target
        appDelegate.lives--;
        if (appDelegate.lives>0) {
            [_lives livesChanged:appDelegate.lives];
        }else if (appDelegate.lives==0){
            [_targets removeObject:sprite];
            GameOverScene *gameOverScene = [GameOverScene node];
            NSString *labelText=[NSString stringWithFormat:LoseMessage,appDelegate.score];
            appDelegate.secondTime=FALSE;
            [gameOverScene.layer.label setString:labelText];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }

    } else if (sprite.tag == 2 || sprite.tag==20 || sprite.tag==10) { // projectile
        [_projectiles removeObject:sprite];
    }
}
-(void)addPowerUpSuper{
    PowerUp *powerUp = nil;
    
    powerUp = [SuperShot SuperShot];
    
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
-(void)addPowerUp{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    PowerUp *powerUp = nil;
    if (appDelegate.secondTime) {
        powerUp = [HeartPowerUp heart];
    }else{
        int random=(arc4random() % 10);
        if ( random == 0) {
            powerUp = [HeartPowerUp heart];
        }else{
            powerUp = [StarPowerUp star];
        }

    }
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
 AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Monster *target = nil;
    if ((arc4random() % 2) == 0) {
        if ((arc4random() % 2) == 0) {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
            EnemySpermPlist];
            CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                              batchNodeWithFile:EnemySpermDefault];
            [self addChild:spriteSheet];
            NSMutableArray *walkAnimFrames = [NSMutableArray array];
            for(int i = 0; i <= 2; ++i) {
                [walkAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:EnemySpermFrames, i]]];
            }
            
            CCAnimation *walkAnim = [CCAnimation 
                                     animationWithFrames:walkAnimFrames delay:0.1f];
            
            target = [WeakAndFastMonster monster];
            //making targets a little quicker
            if (appDelegate.secondTime) {
                target.minMoveDuration=5;
                target.maxMoveDuration=7;
            }else{
                target.minMoveDuration=5;
                target.maxMoveDuration=11;
            }
            
            
            self.walkAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
            [target runAction:_walkAction];
        } else {
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
            FatEnemySpermPlist];
            CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
                                              batchNodeWithFile:FatEnemySpermDefault];
            [self addChild:spriteSheet];
            NSMutableArray *walkAnimFrames = [NSMutableArray array];
            for(int i = 0; i <= 2; ++i) {
                [walkAnimFrames addObject:
                 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
                  [NSString stringWithFormat:FatEnemySpermFrames, i]]];
            }
            
            CCAnimation *walkAnim = [CCAnimation 
                                     animationWithFrames:walkAnimFrames delay:0.1f];
            
            target = [StrongAndSlowMonster monster];
            //making targets a little quicker
            if (appDelegate.secondTime) {
                target.minMoveDuration=7;
                target.maxMoveDuration=9;
            }else{
                target.minMoveDuration=7;
                target.maxMoveDuration=13;
            }
            
            
            self.walkAction = [CCRepeatForever actionWithAction:
                               [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
            [target runAction:_walkAction];
            
        }
        target.tag = 1;
    }else {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
         EnemyVirusPlist];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode
                                          batchNodeWithFile:EnemyVirusDefault];
        [self addChild:spriteSheet];
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [walkAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:EnemyVirusFrames, i]]];
        }
        
        CCAnimation *walkAnim = [CCAnimation
                                 animationWithFrames:walkAnimFrames delay:1.5f];
        target = [Virus1 monster];
        
        if (appDelegate.secondTime) {
            target.minMoveDuration=8;
            target.maxMoveDuration=11;
        }
        
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
        [target runAction:_walkAction];
        target.tag = 3;
    }
        
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
    
    [_targets addObject:target];
}
-(void)gameLogic:(ccTime)dt {
    [self addTarget];
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.superShot) {
        UITouch *touch = [touches anyObject];
        [self performSelector:@selector(longTap:) withObject:touch afterDelay:0.8];
    }
}
-(void) longTap:(UITouch *)touch
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [[SimpleAudioEngine sharedEngine] playEffect:SuperShotEffect];
    //[[SimpleAudioEngine sharedEngine] playEffect:CondomFired];
    int i=0;
    float spray=0.0;
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    if (winSize.width==1024) {
        while (i<20) {
            // Choose one of the touches to work with
            CGPoint location = [touch locationInView:[touch view]];
            location.x=spray;
            NSLog(@"%f", location.x);
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            // Set up initial location of projectile
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CCSprite *projectile;
            if (winSize.width==1024) {
                projectile = [CCSprite spriteWithFile:PlayerImageIpad
                                                 rect:CGRectMake(0, 0, 70, 48)];
            }else{
                projectile = [CCSprite spriteWithFile:PlayerImage
                                                 rect:CGRectMake(0, 0, 68, 20)];
            }
            
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
            float velocity;
            if(winSize.width==1024){
                velocity = 1024/1; // 480pixels/1sec
            }else{
                velocity = 480/1; // 480pixels/1sec
            }
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
            spray=spray+38.4;
            i++;
        }
    }else{
        while (i<10) {
            // Choose one of the touches to work with
            CGPoint location = [touch locationInView:[touch view]];
            location.x=spray;
            NSLog(@"%f", location.x);
            location = [[CCDirector sharedDirector] convertToGL:location];
            
            // Set up initial location of projectile
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CCSprite *projectile;
            if (winSize.width==1024) {
                projectile = [CCSprite spriteWithFile:PlayerImageIpad
                                                 rect:CGRectMake(0, 0, 70, 48)];
            }else{
                projectile = [CCSprite spriteWithFile:PlayerImage
                                                 rect:CGRectMake(0, 0, 68, 20)];
            }
            
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
            float velocity;
            if(winSize.width==1024){
                velocity = 1024/1; // 480pixels/1sec
            }else{
                velocity = 480/1; // 480pixels/1sec
            }
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
            spray=spray+32.0;
            i++;
        }
    }
    if (appDelegate.superShot) {
        [self performSelector:@selector(longTap:) withObject:touch afterDelay:0.5];
    }
    appDelegate.superShot=FALSE;
    superShotItem.visible=FALSE;
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[SimpleAudioEngine sharedEngine] playEffect:CondomFired];
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile;
    if (winSize.width==1024) {
        projectile = [CCSprite spriteWithFile:PlayerImageIpad
                                         rect:CGRectMake(0, 0, 70, 48)];
    }else{
        projectile = [CCSprite spriteWithFile:PlayerImage
                                         rect:CGRectMake(0, 0, 68, 20)];
    }
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
    float velocity;
    if(winSize.width==1024){
        velocity = 1024/1; // 480pixels/1sec
    }else{
        velocity = 480/1; // 480pixels/1sec
    }
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
                if (projectile.tag==20 && target.tag==1) {
                    Monster *monster = (Monster *)target;
                    monster.hp=monster.hp-10;
                    [targetsToDelete addObject:target];
                    //[[SimpleAudioEngine sharedEngine] playEffect:@"scream.wav"];
                    appDelegate.score=appDelegate.score+monster.points;
                    [_hud numCollectedChanged:appDelegate.score];
                    NSLog(@"Monster points: %i",monster.points);
                    [[SimpleAudioEngine sharedEngine] playEffect:KillEffect];
                    break;
                }
                else if (target.tag!=10 && projectile.tag!=20) {
                    Monster *monster = (Monster *)target;
                    monster.hp--;
                    if (monster.hp <= 0) {
                        [targetsToDelete addObject:target];
                        [[SimpleAudioEngine sharedEngine] playEffect:KillEffect];
                        appDelegate.score=appDelegate.score+monster.points;
                        [_hud numCollectedChanged:appDelegate.score];
                        NSLog(@"Monster points: %i",monster.points);
                    }
                    break;
                }else if(target.tag==10){
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
                            [[SimpleAudioEngine sharedEngine] playEffect:HeartEffect];
                        }else if ([powerUp.name isEqualToString:@"Star"]){
                            [[SimpleAudioEngine sharedEngine] playEffect:BonusEffect];
                            
                        }else if ([powerUp.name isEqualToString:@"superShot"]){
                            [[SimpleAudioEngine sharedEngine] playEffect:BonusEffect];
                            appDelegate.superShot=TRUE;
                            superShotItem.visible=TRUE;
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
            if (_projectilesDestroyed == Level3Kills) {
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
                [[SimpleAudioEngine sharedEngine] playEffect:LoadingEffect];
                [self performSelector:@selector(startLevel)
                           withObject:nil afterDelay:1.0f];
               
            }
        }
        
        if (targetsToDelete.count > 0 || monsterHit) {
            if (projectile.tag!=20) {
                [projectilesToDelete addObject:projectile];
            }

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
    CCScene *Level4Scene = [Level4Layer scene];
    _projectilesDestroyed = 0;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.5 scene:Level4Scene]];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //preload music and sound effects
        [[SimpleAudioEngine sharedEngine] preloadEffect:LoadingEffect];
        if (appDelegate.secondTime) {
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:Level3MusicSec];
        }else{
            [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:Level3Music];
        }        
        [[SimpleAudioEngine sharedEngine] preloadEffect:CondomFired];
        [[SimpleAudioEngine sharedEngine] preloadEffect:SuperShotEffect];
         [[SimpleAudioEngine sharedEngine] preloadEffect:KillEffect];
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
        
                
		
        // Get the dimensions of the window for calculation purposes
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* background;
        if (winSize.width==568) {
            //init bg picture
            if (appDelegate.secondTime) {
                background = [CCSprite spriteWithFile:Level7BackgroundIphone5];
            }else{
                background = [CCSprite spriteWithFile:Level3BackgroundIphone5];
            }
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            _player = [[CCSprite spriteWithFile:PlayerImage] retain];
            
        }else if(winSize.width==1024){
            //init bg picture
            if (appDelegate.secondTime) {
                background = [CCSprite spriteWithFile:Level7BackgroundIpad];
            }else{
                background = [CCSprite spriteWithFile:Level3BackgroundIpad];
            }
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            _player = [[CCSprite spriteWithFile:PlayerImageIpad] retain];
            
        }else{
            //init bg picture
            if (appDelegate.secondTime) {
                background = [CCSprite spriteWithFile:Level7Background];
            }else{
                background = [CCSprite spriteWithFile:Level3Background];
            }
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            _player = [[CCSprite spriteWithFile:PlayerImage] retain];
        }

		
		// Add the player to the middle of the screen along the y-axis, 
		// and as close to the left side edge as we can get
		// Remember that position is based on the anchor point, and by default the anchor
		// point is the middle of the object.
        
        
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        [self addChild:_player];
		
		if (appDelegate.secondTime) {
            // Call game logic about every second
            [self schedule:@selector(gameLogic:) interval:0.8];
            [self schedule:@selector(addPowerUp) interval:8.0];
            [self schedule:@selector(addPowerUpSuper) interval:10.0];
            // Start up the background music
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:Level3MusicSec loop:YES];
        }else{
            // Call game logic about every second
            [self schedule:@selector(gameLogic:) interval:1.0];
            [self schedule:@selector(addPowerUp) interval:10.0];
            [self schedule:@selector(addPowerUpSuper) interval:12.0];
            // Start up the background music
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:Level3Music loop:YES];
        }
		[self schedule:@selector(update:)];
        
        //pause menu
        _pauseScreenUp=FALSE;
        CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                     itemFromNormalImage:PauseButton selectedImage:PauseButton
                                     target:self selector:@selector(pauseGame) ];
        
        pauseMenuItem.position = ccp(16, 16);
        
        bombItem = [CCMenuItemImage
                    itemFromNormalImage:BombButton selectedImage:BombButton
                    target:self selector:@selector(fireBomb) ];
        
        bombItem.position = ccp((winSize.width/2)-30, winSize.height-15);
        
        superShotItem = [CCMenuItemImage
                         itemFromNormalImage:SuperShotPowerUpImage selectedImage:SuperShotPowerUpImage
                         target:self selector:nil ];
        
        superShotItem.position = ccp((winSize.width/2)+20, winSize.height-15);
        if (appDelegate.superShot) {
            superShotItem.visible=TRUE;
        }else{
            superShotItem.visible=FALSE;
        }
        
        
        CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem,bombItem,superShotItem, nil];
        pauseMenu.position = CGPointZero;
        [self addChild:pauseMenu z:2];
        
	}
	return self;
}
-(void)pauseGame{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if(_pauseScreenUp ==FALSE)
    {
        appDelegate.paused=TRUE;
        _pauseScreenUp=TRUE;
        //if you have music uncomment the line bellow
        //[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [[CCDirector sharedDirector] pause];
        CGSize s = [[CCDirector sharedDirector] winSize];
        pauseLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
        pauseLayer.position = CGPointZero;
        [self addChild: pauseLayer z:8];
        if (s.width==568) {
            
            _pauseScreen =[CCSprite spriteWithFile:PauseMenuBackgroundIphone5];
            _pauseScreen.position= ccp(s.width/2,s.height/2);
            [self addChild:_pauseScreen z:8];
            
            
            CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                          itemFromNormalImage:PauseResumeButton selectedImage:PauseResumeButton
                                          target:self selector:@selector(ResumeButtonTapped:)];
            ResumeMenuItem.position = ccp(230, 285);
            _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, nil];
            _pauseScreenMenu.position = ccp(0,0);
            [self addChild:_pauseScreenMenu z:10];
            
        }else if(s.width==1024){
            
            _pauseScreen =[CCSprite spriteWithFile:PauseMenuBackgroundIpad];
            _pauseScreen.position= ccp(s.width/2,s.height/2);
            [self addChild:_pauseScreen z:8];
            
            
            CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                          itemFromNormalImage:PauseResumeButton selectedImage:PauseResumeButton
                                          target:self selector:@selector(ResumeButtonTapped:)];
            ResumeMenuItem.position = ccp(400, 650);
            
            _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, nil];
            _pauseScreenMenu.position = ccp(0,0);
            [self addChild:_pauseScreenMenu z:10];
            
        }else{
            
            _pauseScreen =[CCSprite spriteWithFile:PauseMenuBackground];
            _pauseScreen.position= ccp(s.width/2,s.height/2);
            [self addChild:_pauseScreen z:8];
            
            
            CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                          itemFromNormalImage:PauseResumeButton selectedImage:PauseResumeButton
                                          target:self selector:@selector(ResumeButtonTapped:)];
            ResumeMenuItem.position = ccp(170, 270);
            _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, nil];
            _pauseScreenMenu.position = ccp(0,0);
            [self addChild:_pauseScreenMenu z:10];
            
        }
        _pauseScreenMenu.opacity=0;
        
    }
    
}
-(void)fireBomb{
    bombItem.visible=NO;
    
    [[SimpleAudioEngine sharedEngine] playEffect:BombSpraySound];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Determine the length of how far we're shooting
    float velocity;
    float realMoveDuration;
    CGPoint realDest;
    CCSprite *projectile;
    if(winSize.width==1024){
        velocity = 1024/1; // 480pixels/1sec
        projectile = [CCSprite spriteWithFile:BombSprayImageIpad
                                         rect:CGRectMake(0, 0, 20, 768)];
        projectile.position = ccp(20, winSize.height/2);
        
        // Ok to add now - we've double checked position
        [self addChild:projectile];
        
        // Determine where we wish to shoot the projectile to
        
        realDest = ccp(winSize.width, winSize.height/2);
        realMoveDuration = 1024/velocity;
        
    }else{
        velocity = 480/1; // 480pixels/1sec
        projectile = [CCSprite spriteWithFile:BombSprayImage
                                         rect:CGRectMake(0, 0, 10, 320)];
        projectile.position = ccp(20, winSize.height/2);
        
        // Ok to add now - we've double checked position
        [self addChild:projectile];
        
        // Determine where we wish to shoot the projectile to
        
        realDest = ccp(winSize.width, winSize.height/2);
        realMoveDuration = 480/velocity;
        
    }
    
    
    // Move projectile to actual endpoint
    [projectile runAction:[CCSequence actions:
                           [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
                           [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)],
                           nil]];
    projectile.tag = 20;
    [_projectiles addObject:projectile];
    
}

-(void)ResumeButtonTapped:(id)sender{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.paused=FALSE;
    [self removeChild:_pauseScreen cleanup:YES];
    [self removeChild:_pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    _pauseScreenUp=FALSE;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // don't forget to call "super dealloc"
	[super dealloc];
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_targets release];
    _targets = nil;
    [_projectiles release];
    _projectiles = nil;
    [_player release];
    _player = nil;
    [_walkAction release];
    _walkAction=nil;
    [_hud release];
    _hud=nil;
    }
@end
