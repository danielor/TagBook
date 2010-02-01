//
//  Base64.h
//  TagBook
//
//  Created by Daniel  Ortiz on 1/24/10.
//  Copyright 2010 University Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Base64 : NSObject {

}

- (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
- (NSString*) encode:(NSData*) rawBytes;
- (NSData*) decode:(NSString*) string;
- (NSString*) encode:(NSData*) rawBytes;
- (NSString*) encode:(const uint8_t*) input length:(NSInteger)length;

@end
