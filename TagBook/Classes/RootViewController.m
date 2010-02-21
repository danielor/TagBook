//
//  RootViewController.m
//  TagBook
//
//  Created by Daniel  Ortiz on 12/13/09.
//  Copyright 2009 University Michigan. All rights reserved.
//

#import "TagEntryViewController.h"
#import "TagBookViewController.h"

@implementation RootViewController

@synthesize mainViewController;
@synthesize flipsideViewController;

- (void)loadMainViewController {
	TagBookViewController *viewController = [[TagBookViewController alloc] initWithNibName:@"TagBookViewController" bundle:nil];
	self.mainViewController = viewController;
	self.mainViewController.flipDelegate = self;
	[viewController release];
}

- (void)loadFlipsideViewController {
	TagEntryViewController *viewController = [[TagEntryViewController alloc] initWithNibName:@"TagEntryViewController" bundle:nil];
	self.flipsideViewController = viewController;
	self.flipsideViewController.flipDelegate = self;
	[viewController release];
}

- (void)viewDidLoad {
	[self loadMainViewController]; // Don't load the flipside view unless / until necessary
	[self.view addSubview:mainViewController.view];
}


-(CLLocationCoordinate2D) getCurrentLocation {
	return [self.mainViewController getLocation];
}

-(NSString*) getAuthenticationString {
	return [self.mainViewController getUserString];
}

-(UserID*) getFBUID {
	return [self.mainViewController getUserID];
}

// This method is called when either of the subviews send a delegate message to us.
// It flips the displayed view from the whoever sent the message to the other.
- (void)toggleView:(id)sender {
	if (flipsideViewController == nil) {
		[self loadFlipsideViewController];
	}
	
	UIView *mainView = mainViewController.view;
	UIView *flipsideView = flipsideViewController.view;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:((mainViewController == sender) ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:self.view cache:YES];
	
	if (mainViewController == sender) {
		[flipsideViewController viewWillAppear:YES];
		[mainViewController viewWillDisappear:YES];
		[mainView removeFromSuperview];
		[self.view addSubview:flipsideView];
		[mainViewController viewDidDisappear:YES];
		[flipsideViewController viewDidAppear:YES];
		
	} else {
		[mainViewController viewWillAppear:YES];
		[flipsideViewController viewWillDisappear:YES];
		[flipsideView removeFromSuperview];
		[self.view addSubview:mainView];
		[flipsideViewController viewDidDisappear:YES];
		[mainViewController viewDidAppear:YES];
	}
	[UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[mainViewController release];
	[flipsideViewController release];
	[super dealloc];
}@end
