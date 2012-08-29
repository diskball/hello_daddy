//
//  AppDelegate.h
//  Hello Daddy
//
//  Created by George Bafaloukas on 8/29/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    int score;
    int lives;
    BOOL secondTime;
}

@property (nonatomic, retain) UIWindow *window;
@property int score;
@property int lives;
@property BOOL secondTime;

@end
