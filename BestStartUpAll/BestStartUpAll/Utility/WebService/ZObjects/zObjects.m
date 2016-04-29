//
//  zObjects.m
//  LibraryDemo
//
//  Created by peterMAC3 on 10/06/14.
//  Copyright (c) 2014 USBASE Solutions. All rights reserved.
//

#import "zObjects.h"

@implementation NSDictionary (ZDictionary)

- (NSString *)jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"zjsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSString *)jsonString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"zjsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

- (NSDictionary *) dictionaryByReplacingNullsWithStrings {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary:self];
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for(NSString *key in self) {
        const id object = [self objectForKey:key];
        if(object == nul) {
            [replaced setObject:blank forKey:key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:replaced];
}

@end

@implementation NSData (ZData)

- (id)JSONValue {
    NSError *error;
    id jsonResponse = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error || jsonResponse == nil) {
        return nil;
    }
    return jsonResponse;
}
@end
