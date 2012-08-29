//
//  LeaderBoard.h
//  Cocos2DSimpleGame
//
//  Created by George Bafaloukas on 6/11/12.
//  Copyright (c) 2012 Iteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LeaderBoard : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * score;

@end
