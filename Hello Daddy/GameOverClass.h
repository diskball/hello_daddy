//
//  GameOverClass.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 5/27/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor  {
    CCLabelTTF *_label;
    NSManagedObjectContext *managedObjectContext;
    BOOL shake_once;
    float THRESHOLD;
    BOOL win;
}
@property (nonatomic, retain) CCLabelTTF *label;
@property (nonatomic, assign) BOOL win;
// My addition
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// My additions
- (void) insertDataIntoCoreDataDatabase:(NSString *)name andScore:(NSNumber *)score;

@end

@interface GameOverScene : CCScene {
    GameOverLayer *_layer;
    
}
@property (nonatomic, retain) GameOverLayer *layer;


@end