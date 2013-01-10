//
//  BonusLevel.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 8/23/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "BonusLevel.h"
#import "SimpleAudioEngine.h"
#import "GameOverClass.h"
#import "Monster.h"
#import "AppDelegate.h"
#import "Level4Layer.h"
#import "PowerUp.h"

@implementation BonusLevel
@synthesize walkAction = _walkAction;
@synthesize hud = _hud;
@synthesize lives = _lives;
@synthesize pauseLayer;
@synthesize _pauseScreen;
@synthesize _pauseScreenMenu;
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BonusLevel *layer = [BonusLevel node];
	
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
    CCSprite *sprite = (CCSprite *)sender;
    [self removeChild:sprite cleanup:YES];
    [_projectiles removeObject:sprite];
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
    starCounter++;
    if (starCounter==101) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playEffect:LoadingEffect];
        [self performSelector:@selector(startLevel)
                   withObject:nil afterDelay:3.0f];
    }
}
-(void)startLevel{
    CCScene *level4Scene = [Level4Layer scene];
    _projectilesDestroyed = 0;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.5 scene:level4Scene]];
}

-(void)gameLogic:(ccTime)dt {
    // Update Hud layer with score
    [self addPowerUp];
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[SimpleAudioEngine sharedEngine] playEffect:CondomFired];
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:PlayerImage
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
                if (target.tag!=10) {
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
                            [[SimpleAudioEngine sharedEngine] playEffect:HeartEffect];
                        }else if ([powerUp.name isEqualToString:@"Star"]){
                            [[SimpleAudioEngine sharedEngine] playEffect:BonusEffect];
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
            if (_projectilesDestroyed > LevelBonusKills) {
                CCScene *level4Scene = [Level4Layer scene];
                _projectilesDestroyed = 0;
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.5 scene:level4Scene]];
            }
        }
        
        if (targetsToDelete.count > 0 || monsterHit) {
            [projectilesToDelete addObject:projectile];
        }
        [targetsToDelete release];
        [_hud numCollectedChanged:appDelegate.score];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        //preload music and sound effects
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:LevelBonusMusic];
        [[SimpleAudioEngine sharedEngine] preloadEffect:CondomFired];
        [[SimpleAudioEngine sharedEngine] preloadEffect:LoadingEffect];
        [[SimpleAudioEngine sharedEngine] preloadEffect:BonusEffect];
		// Enable touch events
		self.isTouchEnabled = YES;
		
		// Initialize arrays
		_targets = [[NSMutableArray alloc] init];
		_projectiles = [[NSMutableArray alloc] init];
        
               
		
        // Get the dimensions of the window for calculation purposes
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* background;
        if (winSize.width>1000) {
            //init bg picture
            background = [CCSprite spriteWithFile:LevelBonusBackgroundIphone5];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }else{
            //init bg picture
            background = [CCSprite spriteWithFile:LevelBonusBackground];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }

		
		// Add the player to the middle of the screen along the y-axis,
		// and as close to the left side edge as we can get
		// Remember that position is based on the anchor point, and by default the anchor
		// point is the middle of the object.
        
        _player = [[CCSprite spriteWithFile:PlayerImage] retain];
        _player.position = ccp(_player.contentSize.width/2, winSize.height/2);
        
        [self addChild:_player];
        
        starCounter=0;
        
		// Call game logic about every second
		[self schedule:@selector(gameLogic:) interval:0.2];
		[self schedule:@selector(update:)];
		
		// Start up the background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:LevelBonusMusic loop:YES];
        
        [self schedule:@selector(playOrgasm) interval:8.0f];
        
        id wavesAction = [CCWaves actionWithWaves:15 amplitude:25 horizontal:NO
                                         vertical:YES grid:ccg(10,5) duration:5];
        [background runAction: [CCRepeatForever
                                          actionWithAction:wavesAction]];
        
        //pause menu
        _pauseScreenUp=FALSE;
        CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                     itemFromNormalImage:PauseButton selectedImage:PauseButton
                                     target:self selector:@selector(pauseGame) ];
        
        pauseMenuItem.position = ccp(16, 16);
        
        CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        pauseMenu.position = CGPointZero;
        [self addChild:pauseMenu z:2];
        
	}
	return self;
}
-(void)pauseGame{
    if(_pauseScreenUp ==FALSE)
    {
        _pauseScreenUp=TRUE;
        //if you have music uncomment the line bellow
        //[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
        [[CCDirector sharedDirector] pause];
        CGSize s = [[CCDirector sharedDirector] winSize];
        pauseLayer = [CCLayerColor layerWithColor: ccc4(150, 150, 150, 125) width: s.width height: s.height];
        pauseLayer.position = CGPointZero;
        [self addChild: pauseLayer z:8];
        
        _pauseScreen =[CCSprite spriteWithFile:PauseMenuBg];
        _pauseScreen.position= ccp(250,150);
        [self addChild:_pauseScreen z:8];
        
        CCMenuItem *ResumeMenuItem = [CCMenuItemImage
                                      itemFromNormalImage:PauseResumeButton selectedImage:PauseResumeButton
                                      target:self selector:@selector(ResumeButtonTapped:)];
        ResumeMenuItem.position = ccp(250, 230);
        
        _pauseScreenMenu = [CCMenu menuWithItems:ResumeMenuItem, nil];
        _pauseScreenMenu.position = ccp(0,0);
        [self addChild:_pauseScreenMenu z:10];
    }
}
-(void)ResumeButtonTapped:(id)sender{
    [self removeChild:_pauseScreen cleanup:YES];
    [self removeChild:_pauseScreenMenu cleanup:YES];
    [self removeChild:pauseLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    _pauseScreenUp=FALSE;
}

-(void)playOrgasm{
    [[SimpleAudioEngine sharedEngine] playEffect:LoadingEffect];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    // don't forget to call "super dealloc"
	[super dealloc];
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
