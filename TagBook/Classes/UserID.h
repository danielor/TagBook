//
//  UserID.h
//  TagBook
//
//  Created by Daniel  Ortiz on 1/31/10.
//  Copyright 2010 University Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FBConnect.h"


@interface UserID : NSObject {
	FBUID theID;
}

@property (nonatomic) FBUID theID;
-(UserID *) initWithId:(FBUID)u;
-(void) setID:(FBUID)u;

@end
