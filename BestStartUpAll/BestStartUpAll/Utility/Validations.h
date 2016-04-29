//
//  Validations.h
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Validations : NSObject
+ (BOOL)isconnectedToInternet;
+ (BOOL)isValidEmail:(NSString *)Emailid;
+ (BOOL)isValidUrl:(NSURL *)urlString;
+ (BOOL)isEmpty:(NSString *)Field;
+ (NSString *)convertURLFriendlyString : (NSString *) cstring;
+ (BOOL)checkMinLength:(NSString *)Field withLimit:(int)len;
+ (BOOL)checkMaxLength:(NSString *)Field withLimit:(int)len;
+ (BOOL) isValidUnicodeName : (NSString *)name;
+ (BOOL) verifyNumber : (NSString *)name;
+ (BOOL)checkEqual:(NSString *)first withField:(NSString *)second;
+ (BOOL) isValidText : (NSString *)name;
+ (BOOL) verifyPin : (NSString *)name;
+ (BOOL)checkCvvNumber:(NSString *)Field withLimit:(int)len;
@end
