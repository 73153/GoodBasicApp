//
//  NSString+Md5.m
//  peter
//
//  Created by Bhumesh on 01/04/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "NSString+Md5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Md5)

//- (NSString *)MD5 {
//    
//    const char * pointer = [self UTF8String];
//    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
//    
//    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
//    
//    NSMutableString * string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [string appendFormat:@"%02x",md5Buffer[i]];
//    
//    return string;
//}

- (NSString *)MD5 {
const char * pointer = [self UTF8String];
unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];

CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);

NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
[string appendFormat:@"%02x",md5Buffer[i]];

return string;
}
- (NSString *)md5 {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

@end
