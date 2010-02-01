//
//  TagBookAppDelegate.m
//  TagBook
//
//  Created by Daniel  Ortiz on 12/12/09.
//  Copyright University Michigan 2009. All rights reserved.
//

#import "TagBookAppDelegate.h"
#import "RootViewController.h"

@implementation TagBookAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
