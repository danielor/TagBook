//
//  TagEntryViewController.m
//  TagBook
//
//  Created by Daniel  Ortiz on 12/13/09.
//  Copyright 2009 University Michigan. All rights reserved.
//

#import "TagEntryViewController.h"
#import "UserID.h"


@implementation TagEntryViewController

@synthesize commentOfTag, nameOfTag, ratingSliderOfTag, isTagPublic, sendButton, cancelButton;
@synthesize flipDelegate;

-(id) initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
	if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
		
	}
	return self;
}

-(IBAction) touchSendButton:(id)sender {
	// The current Location of the tag
	CLLocationCoordinate2D currentLocation = [self.flipDelegate getCurrentLocation];
	//NSString * authenticationString = [[NSString alloc] initWithFormat:@"Basic %@", [self.flipDelegate getAuthenticationString]];
	
	// The user id
	UserID * uID = [self.flipDelegate getFBUID];
	FBUID theID = uID.theID;
	
	// Get the tag data
	NSString * commentString = [commentOfTag text];
	NSString * nameString = [nameOfTag text];
	float rating = [ratingSliderOfTag value];
	BOOL isPublic = isTagPublic.on;
	
	
	// Send the new tag
	NSURL * serviceURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://localhost:8000/api/%d/tags", theID]];
	NSMutableString * postBody = [NSMutableString stringWithFormat:@"namespace=%@", [@"test" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendFormat:@"&lat=%f" , currentLocation.latitude];
	[postBody appendFormat:@"&lng=%f", currentLocation.longitude];
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceURL];
	[serviceRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	//[serviceRequest addValue:authenticationString forHTTPHeaderField:@"Authorization"];
	[serviceRequest setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
	[serviceRequest setHTTPMethod:@"POST"];
	
	NSURLResponse * serviceResponse;
	NSError * serviceError;
	serviceResponse = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&serviceResponse error:&serviceError];
	
	// Return to the previouws view
	[self.flipDelegate toggleView:self];
}


-(IBAction) touchCancelButton:(id)sender{
	// Return to the previous view 
	[self.flipDelegate toggleView:self];
}

-(IBAction) dismissKeyboard:(id)sender{
	[sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
