//
//  FacebookLayer.m
//  TagBook
//
//  Created by Daniel  Ortiz on 2/14/10.
//  Copyright 2010 University Michigan. All rights reserved.
//

#import "FacebookLayer.h"


@implementation FacebookLayer

static NSString* kApiKey = @"2aa6f7fae37f1c583afab564d683f5eb";
static NSString* kApiSecret = @"fa4fb5ea7fe682ebe5cbe1d75dc467ed";

@synthesize session;
@synthesize myDelegate;

-(id) init {
	self = [super init];
    if (self != nil)
	{
		session = [[FBSession sessionForApplication:kApiKey secret:kApiSecret delegate:self] retain];

	}
	return self;
}

-(void) LogInFacebook {
	loginDialog = [[[FBLoginDialog alloc] initWithSession:session] autorelease];
    [loginDialog show];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError*)error
{
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// FBSessionDelegate
- (void)session:(FBSession*)session didLogin:(FBUID)uid
{
	myUid = uid;
	
	// Dismiss the dialog we have the uid!
	[loginDialog dismissWithSuccess:YES animated:YES];
	
	// Send the uid to the parent class
	[self.myDelegate UIDUpdate:uid];
}

- (void)sessionDidNotLogin:(FBSession*)session
{
}

- (void)sessionDidLogout:(FBSession*)session
{
}


//FYI:
//Called when the facebook login dialog button is pushed
- (void)dialogDidSucceed:(FBDialog*)dialog
{
}

//FYI:
//Called when the facebook login cancel button is pushed
- (void)dialogDidCancel:(FBDialog*)dialog
{
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

- (void)request:(FBRequest*)request didLoad:(id)result
{
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error
{
	NSLog([NSString stringWithFormat:@"Error(%d) %@", error.code, error.localizedDescription]);
}


-(FBUID) getID{
	return myUid;
}

- (void)dealloc {
	[session.delegates removeObject:self];
	[session release], session = nil;
	[super dealloc];
}
@end
