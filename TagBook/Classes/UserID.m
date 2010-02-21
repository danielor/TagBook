//
//  UserID.m
//  TagBook
//
//  Created by Daniel  Ortiz on 1/31/10.
//  Copyright 2010 University Michigan. All rights reserved.
//

#import "UserID.h"


@implementation UserID

@synthesize theID;

-(void) setID:(FBUID)u {
	theID = u;
}


-(UserID *) initWithId:(FBUID)u {
	self = [super init];
	if(self){
		[self setID:u];
	}
	
	return self;
}


@end
