//
//  TagBookViewController.m
//  TagBook
//
//  Created by Daniel  Ortiz on 12/12/09.
//  Copyright University Michigan 2009. All rights reserved.
//

#import "TagBookViewController.h"

@implementation TagBookViewController

@synthesize  theMap, tagButton, geocoder, mPlacemark, tagParser, receivedData, currentElementValue, username, tagList;
@synthesize flipDelegate, uID;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		username = [[NSString alloc] initWithFormat:@"test"];
		password = [[NSString alloc] initWithFormat:@"testpassword"];
		base64Converter = [[Base64 alloc] init];
		uID = [[UserID alloc] init];
		
		// Create the database
		NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString * documentsDirectory = [paths objectAtIndex:0];
		NSString * dbFileName = [documentsDirectory stringByAppendingString:@"/test.db"];
		EXFile * file = [EXFile fileWithName:dbFileName];
		theDatabase = [[EXContainer alloc] initWithFile:file];
    }
    return self;
}




// Start the location controller manager
- (void)viewDidLoad {
	// Setup the location controller
	locationController = [[CoreLocationController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
		
    [super viewDidLoad];
}

-(CLLocationCoordinate2D) getLocation {
	return currentLocation;
}

-(NSString*) getUserString {
	NSString * compositeString = [[NSString alloc] initWithFormat:@"%@:%@", username, password];
	NSData * data = [compositeString dataUsingEncoding:NSUTF8StringEncoding];
	return [base64Converter encode:data];
}

// Protocol functions for NSURLConnection
-(void) connection:(NSURLConnection*) connection didReceiveResponse:(NSURLResponse*) response {
	// Function can be called multiple times in the case of a redirect
	[receivedData setLength:0];
}

-(void)connection:(NSURLConnection*) connection didReceiveData:(NSData*)data{
	// Append the new data to the received data
	[receivedData appendData:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
	// Rellease the connection and the received data/ad
	[connection release];
	[receivedData release];
	
	// Format and display error
	NSString * errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@", [error localizedDescription],
							  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]];
}

-(void) connectionDidFinishLoading:(NSURLConnection*)connection{
	BOOL success;
	
	if(tagParser){
		[tagParser release];
	}
	
	// Set up the tag parser
	if([receivedData length] != 0){
		tagParser = [[NSXMLParser alloc] initWithData:receivedData];
		[tagParser setDelegate:self];
		[tagParser setShouldResolveExternalEntities:YES];
		success = [tagParser parse];
		if(success){
			// We have got some new tags. Show them!
			[self displayListOfTags];
		}
	}
	
	// Release the data/connection
	[connection release];
	[receivedData release];
}

// Get all tags
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary*) attributeDict{
	
	// Setup the tagList
	if([elementName isEqualToString:@"response"]){
		if(tagList){
			[tagList release];
		}
		
		tagList	= [[NSMutableArray alloc] init];
	}
	
	// Create the current tag to populate
	if([elementName isEqualToString:@"resource"]){
		if(currentTag){
			[currentTag release];
		}
		
		currentTag = [[Tag alloc] init];
	}
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	if(!currentElementValue){
		currentElementValue = [[NSMutableString alloc] init];
	}
	[currentElementValue appendString:string];
	
}

- (void) parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName{
	// namespace
	// lat
	// lng
	if([elementName isEqualToString:@"namespace"]){
		currentTag.nspace = [NSString stringWithString:currentElementValue];
	}
	
	if([elementName isEqualToString:@"lat"]){
		currentTag.latitude = [currentElementValue floatValue];
	}
	
	if([elementName isEqualToString:@"lng"]){
		currentTag.longitude = [currentElementValue floatValue];
		
		// Add to the tagList
		[tagList addObject:currentTag];
	}
	
	// Release the current element value
	[currentElementValue release];
	currentElementValue = nil;
}

-(IBAction) touchTagButton:(id)sender {
	[self.flipDelegate toggleView:self];

}

-(void)createTag {
	[self.flipDelegate toggleView:self];
}

- (void)locationError:(NSError *)error {
	
}

- (void)locationUpdate:(CLLocation *)newLocation oldLocation:(CLLocation*)OldLocation {
	// Get the coordinate and format the string
	currentLocation = [newLocation coordinate];
	
	// Find location of the value on the map
	MKCoordinateRegion region;
	region.center = currentLocation;
	
	// Set the zoom level and span level
	MKCoordinateSpan span;
	span.latitudeDelta = .02;
	span.longitudeDelta = .02;
	region.span = span;
	
	// Set up the geodecoder
	if(!geocoder){
		// The geocoder
		geocoder = [[MKReverseGeocoder alloc] initWithCoordinate: currentLocation];
		geocoder.delegate = self;
		[geocoder start];
		
		// Set up the MapView
		theMap.showsUserLocation = TRUE;
		theMap.mapType = MKMapTypeStandard;
		theMap.delegate = self;
	}
	
	// Get all of the tags at the current location
	[self getAllTags];
	
	// Set the region of the map view
	[theMap setRegion:region animated:TRUE];
}

-(void) getAllTags {
	// Get the coordinate and format the string
	NSString * userString = [self getUserString];
	NSString * authenticationString = [[NSString alloc] initWithFormat:@"Basic %@", userString];
	
	// Send the tag
	NSURL * serviceURL = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://localhost:8000/api/tags"]];
	NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceURL];
//[serviceRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	[serviceRequest addValue:authenticationString forHTTPHeaderField:@"Authorization"];
	[serviceRequest setHTTPMethod:@"GET"];

	// Create the connection
	NSURLConnection * theConnection = [[NSURLConnection alloc] initWithRequest:serviceRequest delegate:self];
	NSError * serviceError;
	NSURLResponse * serviceResponse = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&serviceResponse error:&serviceError];
	if(theConnection){
		// Initialize the received data
		if(receivedData){
			[receivedData release];
		}
		receivedData = [[NSMutableData alloc] init];
	}else{
		
	}
}

-(void) displayListOfTags {
	unsigned count = [tagList count];
	while (count--) {
		Tag * tag = (Tag *)([tagList objectAtIndex:count]);
		BOOL inMap = [self locationOnMap:tag.latitude lon:tag.longitude];
		if(inMap){
			CLLocationCoordinate2D tagCoord;
			tagCoord.latitude = tag.latitude;
			tagCoord.longitude = tag.longitude;
			
			// Add the annotation. The address dictionary is of limitted value to me. The address dictionary of the initial decoding is
			// used no more. 
			MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:tagCoord addressDictionary:[mPlacemark addressDictionary]];
			[theMap addAnnotation:placemark];

		}
	}
}

- (BOOL) locationOnMap:(float) latitude lon:(float) longitude {
	
	// Extract the map views currently open values
	MKCoordinateRegion region = theMap.region;
	MKCoordinateSpan span = region.span;
	CLLocationCoordinate2D coord = region.center;
	
	// The maximum lattitude and longitude
	if(latitude > coord.latitude - span.latitudeDelta && latitude < coord.latitude + span.latitudeDelta){
		if(longitude > coord.longitude - span.longitudeDelta && longitude < coord.longitude + span.longitudeDelta){
			return YES;
		}
	}
	return NO;
}


// The reverse geodecoder interface
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error{
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark{
	mPlacemark=placemark;
	[theMap addAnnotation:placemark];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
	MKPinAnnotationView *test=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"parkingloc"];
	if([annotation title]==@"Current Location")
	{
		[test setPinColor:MKPinAnnotationColorPurple];
	}
	else
	{
		[test setPinColor:MKPinAnnotationColorGreen];
	}
	return test;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	
}


- (void)dealloc {
	[theMap release];
	[username release];
	[password release];
	[base64Converter release];
	[uID release];
	[theDatabase release];
    [super dealloc];
}

@end
