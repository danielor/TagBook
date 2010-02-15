//
//  FacebookLayer.h
//  TagBook
//
//  Created by Daniel  Ortiz on 2/14/10.
//  Copyright 2010 University Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyFacebookDelegate<NSObject>
@required
-(void) UIDUpdate:(FBUID)uid;

@end


@interface FacebookLayer : NSObject<FBSessionDelegate, FBDialogDelegate, FBRequestDelegate> {
	FBSession * session;				/* Session variables stores all of the relevant facebook data */
	FBLoginDialog * loginDialog;		/* Logs into facebook */
	FBUID myUid;						/* The user id extracted from the facebook session */
	
	// The delegate
	id myDelegate;						/* I communicate with my parent with the MyFacebookDelegate */
}

@property(nonatomic, retain) FBSession * session;
@property(nonatomic, assign) id<MyFacebookDelegate> myDelegate;
-(void) LogInFacebook;

@end
