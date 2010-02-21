//
//  TagBookViewController.h
//  TagBook
//
//  Created by Daniel  Ortiz on 12/12/09.
//  Copyright University Michigan 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

// My classes
#import "CoreLocationController.h"
#import "Tag.h"
#import "RootViewController.h"
#import "Base64.h"
#import "UserID.h"

// The Entropy database
#import "EXContainer.h"
#import "EXFile.h"
#import "FacebookLayer.h"


@interface TagBookViewController : UIViewController<MyCLControllerDelegate, MyFacebookDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate> {
	// The outlets for the GUI builder
	IBOutlet UIButton * tagButton;			/* The toolbar */
	IBOutlet MKMapView * theMap;			/* The map */
	
	// The location manager
	CoreLocationController * locationController;
	
	// Location decoders and the current location on the map
	MKPlacemark * mPlacemark;
	MKReverseGeocoder * geocoder;
	
	// The current location
	CLLocationCoordinate2D currentLocation;
	
	// The XML parsing
	NSMutableData * receivedData;				/* The mutable data that stores the tag */
	NSXMLParser * tagParser;					/* The XML parser */
	NSMutableString * currentElementValue;		/* The current value of the tag */
	Tag * currentTag;							/* The current tag */
	NSMutableArray * tagList;					/* The tag list */
	
	// The decoder
	Base64 * base64Converter;
	
	// The username 
	UserID * uID;
	BOOL setUID;
	NSString * username;
	NSString * password;
	
	// The database
	EXContainer * theDatabase;
	
	// The Facebook layers
	FacebookLayer * loginLayer;
	
	// The flip delegate
	id flipDelegate;
}

@property (nonatomic, assign) id<MyFlipControllerDelegate> flipDelegate;
@property (nonatomic, retain) MKMapView * theMap;
@property (nonatomic, retain) UIButton * tagButton;
@property (nonatomic, retain) MKReverseGeocoder * geocoder;
@property (nonatomic, retain) MKPlacemark * mPlacemark;
@property (nonatomic, retain) NSXMLParser * tagParser;
@property (nonatomic, retain) NSMutableData * receivedData;
@property (nonatomic, retain) NSMutableString * currentElementValue;
@property (nonatomic, retain) Tag * currentTag;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSMutableArray * tagList;
@property (nonatomic, retain) Base64 * base64Converter;
@property (nonatomic, retain) UserID * uID;
@property (nonatomic, retain) EXContainer * theDatabase;
@property (nonatomic, retain) FacebookLayer * loginLayer;
@property (nonatomic) BOOL setUID;

// MyCLControlDelegate protocol
- (void) locationUpdate:(CLLocation*)location oldLocation:(CLLocation*)OldLocation;
- (void) locationError:(NSError*)error;

// MyFacebookDelegate protocol
-(void) UIDUpdate:(FBUID)uid;

// Interface methods
-(CLLocationCoordinate2D) getLocation;
-(NSString*) getUserString;
-(UserID*) getUserID;

// Get data from the server, and display them
-(void) getAllTags;
-(void) displayListOfTags;
- (BOOL) locationOnMap:(float) latitude lon:(float) longitude;

// The action functions
-(IBAction) touchTagButton:(id)sender;

@end

