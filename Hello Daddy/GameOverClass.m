//
//  GameOverClass.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "GameOverClass.h"
#import "HelloWorldLayer.h"
#import "AppDelegate.h"
#import "LeaderBoard.h"
#import "SimpleAudioEngine.h"

@implementation GameOverScene
@synthesize layer = _layer;

- (id)init {
    
    if ((self = [super init])) {
        self.layer = [GameOverLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    [_layer release];
    _layer = nil;
    [super dealloc];
}

@end

@implementation GameOverLayer
@synthesize label = _label;
@synthesize win;

// My addition
@synthesize managedObjectContext = _managedObjectContext;

- (NSManagedObjectContext *) managedObjectContext {
    
    if(managedObjectContext == nil)
    {
        
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeDatabasedUrl = [url URLByAppendingPathComponent:@"LeaderBoard"];
        // url is now "<Documents Directory>/Default SDiOS Database"
        
        NSError *error = nil;
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [[[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]] autorelease];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeDatabasedUrl options:nil error:&error])
        {
            NSLog(@"Error while loading persistent﻿ store...");
        }
        
        managedObjectContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
    
    return managedObjectContext;
    
}
-(void)insertDataIntoCoreDataDatabase:(NSString *)name andScore:(NSNumber *)score{
    // First enter the information for the first set of records
    LeaderBoard *myEntry = (LeaderBoard *) [NSEntityDescription insertNewObjectForEntityForName:@"LeaderBoard" inManagedObjectContext:self.managedObjectContext];
    myEntry.name = name;
    myEntry.score = score;
    if ([self.managedObjectContext hasChanges])
    {
        [self.managedObjectContext save:nil]; // Only save if changes to the databse has occured. In this example no checking is done to determine if duplicate records exist. Learn about NSFetchRequest to handle that aspect of database management.
    }
}

-(id) init
{
    if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:YouLoseEffect loop:YES];
        if (winSize.width==568) {
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:GameOverBackgroundIphone5];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }else{
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:GameOverBackground];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }

        self.label = [CCLabelTTF labelWithString:@"" dimensions:CGSizeMake(winSize.height, winSize.width/2) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:32 ];
        _label.color = ccc3(255,255,255);
        _label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:_label];
        
        
        /*
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:3],
                         [CCCallFunc actionWithTarget:self selector:@selector(gameOverDone)],
                         nil]];
         */
        
        //[self getNewName];
        self.isAccelerometerEnabled = YES;
        [[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        shake_once = false;
        if (win) {
            [self getNewName];
        }
        
    }	
    return self;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    
     THRESHOLD = 2;
    
    if (acceleration.x > THRESHOLD || acceleration.x < -THRESHOLD ||
        acceleration.y > THRESHOLD || acceleration.y < -THRESHOLD ||
        acceleration.z > THRESHOLD || acceleration.z < -THRESHOLD) {
        
        THRESHOLD = 500;
        self.isAccelerometerEnabled = NO;
        
        [self performSelector:@selector(getNewName)
                   withObject:nil afterDelay:3.0f];
        
        
        
        
    }
    
}

- (void) getNewName;
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You made the High Score List"
                                                    message:@"Please enter your name"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Ok", nil];
    alert.tag=100;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    if (buttonIndex) 
    {
        // call the method or the stuff which you need to perform on click of "OK" button.
        NSString *newName = [[alertView textFieldAtIndex:0] text];
        NSLog(@"NAME: %@",newName);
        [self insertDataIntoCoreDataDatabase:newName andScore:[NSNumber numberWithInt:appDelegate.score]];
        [self gameOverDone];
    }else {
        [self gameOverDone];
    }
}

- (void)gameOverDone {
    
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
    
}

- (void)dealloc {
    [_label release];
    _label = nil;
    [super dealloc];
}

@end
