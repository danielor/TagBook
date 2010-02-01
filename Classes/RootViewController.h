//
//  RootViewController.h
//  TagBook
//
//  Created by Daniel  Ortiz on 12/13/09.
//  Copyright 2009 University Michigan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyFlipControllerDelegate<NSObject>
@required
-(void)toggleView:(id)sender;							/* Change the view */
-(CLLocationCoordinate2D) getCurrentLocation;			/* Get the current location of the phone */
-(NSString*) getAuthenticationString;					/* Get the authentication string for the username */
@end

@class TagBookViewController;
@class TagEntryViewController;

@interface RootViewController : UIViewController<MyFlipControllerDelegate> {
	TagBookViewController * mainViewController;
	TagEntryViewController * flipsideViewController;
}

@property (nonatomic, retain) TagBookViewController *mainViewController;
@property (nonatomic, retain) TagEntryViewController *flipsideViewController;

@end
