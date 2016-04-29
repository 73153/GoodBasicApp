//
//  Validations.m
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import "Validations.h"

@implementation Validations
+ (BOOL)isValidEmail:(NSString *)Emailid
{
    NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]+$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:Emailid options:0 range:NSMakeRange(0, [Emailid length])];
    if (regExMatches == 0){
        return NO;
    }
    else
        return YES;
}
+ (BOOL)isconnectedToInternet
{
    NSURL *url=[NSURL URLWithString:@"http://www.google.com"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode]==200)?YES:NO;
}
+ (BOOL)isValidUrl:(NSURL *)urlString
{
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    return [NSURLConnection canHandleRequest:request];
}
+ (BOOL)isEmpty:(id)Field
{
    NSString * value=[Field stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([value length] == 0)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)checkMinLength:(NSString *)Field withLimit:(int)len
{
    if([Field length] >= len)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)checkMaxLength:(NSString *)Field withLimit:(int)len
{
    if([Field length] <= len)
    {
        return YES;
    }
    return NO;
}
+ (BOOL)checkCvvNumber:(NSString *)Field withLimit:(int)len
{
    if([Field length] == len)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)checkEqual:(NSString *)first withField:(NSString *)second
{
    if([first isEqualToString:second])
    {
        return YES;
    }
    return NO;
}
+ (NSString *)convertURLFriendlyString : (NSString *) cstring
{
    NSString *bg = [cstring stringByReplacingOccurrencesOfString:@" "
                                                     withString:@"%20"];
    return bg;
}
+(BOOL) isValidUnicodeName : (NSString *)name
{
    NSString *regExPattern = @"^[^\\p{C}\\p{S}\\p{Zl}\\p{Zp}]+$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}
+(BOOL) isValidUnicodeText : (NSString *)name
{
    NSString *regExPattern = @"^[^\\p{C}]+$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}
+(BOOL) verifyPin : (NSString *)name
{
    NSString *regExPattern = @"^[0-9]{6}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}
//+(BOOL) verifyMobileNumber : (NSString *)name
//{
//    NSString *regExPattern = @"^[0-9]{10}$";
//    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
//    if (regExMatches == 0)
//    {
//        return NO;
//    }
//    else
//        return YES;
//}
+(BOOL) verifyNumber : (NSString *)name
{
     NSString *regExPattern = @"^[0-9]{10}$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}


+(BOOL) isValidGenericText : (NSString *)name
{
    NSString *regExPattern = @"^[A-Za-z0-9\\-_\\.]+$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}
+(BOOL) isValidText : (NSString *)name
{
    NSString *regExPattern = @"^[A-Z]+$";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if (regExMatches == 0)
    {
        return NO;
    }
    else
        return YES;
}
@end
