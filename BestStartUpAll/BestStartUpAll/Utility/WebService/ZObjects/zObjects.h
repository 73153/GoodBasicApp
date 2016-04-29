//
// zObjects.h
//  LibraryDemo
//
//  Created by peterMAC3 on 10/06/14.
//  Copyright (c) 2014 USBASE Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZDictionary)
- (NSString *)jsonStringWithPrettyPrint:(BOOL) prettyPrint;
- (NSString *)jsonString;

- (NSDictionary *) dictionaryByReplacingNullsWithStrings;

@end

@interface NSData (ZData)
- (id)JSONValue;
@end
