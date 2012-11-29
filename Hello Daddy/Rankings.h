//
//  Rankings.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 8/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"
#import "Consts.h"
@interface Rankings : CCLayerColor{
    CCLabelTTF *_label;
    NSManagedObjectContext *managedObjectContext;
    NSArray *leaderBoardArray;

}
@property (assign, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic) NSArray *leaderBoardArray;

@property (nonatomic, assign) CCLabelTTF *label;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

- (NSString * ) displayQueryResults;

@end
