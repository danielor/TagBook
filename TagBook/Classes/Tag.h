//
//  Tag.h
//  TagBook
//
//  Created by Daniel  Ortiz on 12/13/09.
//  Copyright 2009 University Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tag : NSObject {
	NSString * nspace;				/* The namespace string */
	float latitude;					/* The latitude of the tag */
	float longitude;				/* The longitude of the tag */
	NSString * comment;				/* The comment at the tag */
	bool isPublic;					/* Boolean value that states whether your this tag is part of your social circle */
	float rating;					/* The rating of the tag */
}

@property (nonatomic, retain) NSString * nspace;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic) bool isPublic;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float rating;

@end
