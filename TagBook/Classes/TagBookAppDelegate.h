//
//  TagBookAppDelegate.h
//  TagBook
//
//  Created by Daniel  Ortiz on 12/12/09.
//  Copyright University Michigan 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface TagBookAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *viewController;

@end

