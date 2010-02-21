//
//  CoreLocationController.h
//  PowerShopper
//
//  Created by Daniel  Ortiz on 9/12/09.
//  Copyright 2009 University Michigan. All rights reserved.
//

@protocol MyCLControllerDelegate <NSObject>
@required
- (void)locationUpdate:(CLLocation *)location oldLocation:(CLLocation*)Old; 
- (void)locationError:(NSError *)error;
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <MyCLControllerDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

@end

