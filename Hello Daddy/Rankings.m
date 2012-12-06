//
//  Rankings.m
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 8/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "Rankings.h"
#import "AppDelegate.h"
#import "HelloWorldLayer.h"
#import "LeaderBoard.h"

@implementation Rankings

@synthesize label = _label;
@synthesize leaderBoardArray,managedObjectContext;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Rankings *layer = [Rankings node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
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
- (NSString * ) displayQueryResults{
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *myEntityQuery = [NSEntityDescription entityForName:@"LeaderBoard" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:myEntityQuery];
    
    NSError *error = nil;
    
    NSArray *myAuthors = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"score"
                                                  ascending:NO] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    //NSArray *sortedArray;
    self.leaderBoardArray = [[[NSArray alloc] initWithArray:[myAuthors sortedArrayUsingDescriptors:sortDescriptors]] autorelease];
    int i=0;
    NSString *ranknings =[[[NSString alloc] init] autorelease];
    for (LeaderBoard *myLeaderBoard in self.leaderBoardArray) {
        NSLog(@"Name %@",myLeaderBoard.name) ;
        NSLog(@"Name %i",[myLeaderBoard.score intValue]) ;
        ranknings =[ranknings stringByAppendingString:[NSString stringWithFormat:@"%@ - %i \n", myLeaderBoard.name,[myLeaderBoard.score intValue]]];
        if (i<=10) {
            i++;
        }else{
            break;
        }
        
    }

    return ranknings;
    
}

// on "init" you need to initialize your instance
-(id) init
{
	if( (self=[super initWithColor:ccc4(255,255,255,255)] )) {
        self.isTouchEnabled = YES;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        if (winSize.width==568) {
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:HighscoresBackgroundIphone5];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
            
        }else{
            //init bg picture
            CCSprite* background = [CCSprite spriteWithFile:HighscoresBackground];
            background.tag = 1;
            background.anchorPoint = CGPointMake(0, 0);
            [self addChild:background];
        }

        
        
        
        NSString *ranks =[[NSString alloc] initWithString:[self displayQueryResults]];
        // Opening Text
        self.label = [CCLabelTTF labelWithString:ranks dimensions:CGSizeMake(200, 250) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:20];
        _label.color = ccc3(255,255,255);
        _label.position = ccp(winSize.width/2, 130);
        [self addChild:_label];
        
        [ranks release];
        // Standard method to create a button
        CCMenuItem *back = [CCMenuItemImage
                                 itemFromNormalImage:MainMenuBackButton selectedImage:MainMenuBackButton
                                 target:self selector:@selector(returnToMenu) ];
        
        back.position = ccp(winSize.width/2, 290);
        
        CCMenu *levelMenu = [CCMenu menuWithItems:back, nil];
        levelMenu.position = CGPointZero;
        [self addChild:levelMenu];
        
    }
    return self;
}


-(void)returnToMenu{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration: 0.2 scene:[HelloWorldLayer scene]]];
}
-(void) dealloc{
    [super dealloc];
   
}

@end
