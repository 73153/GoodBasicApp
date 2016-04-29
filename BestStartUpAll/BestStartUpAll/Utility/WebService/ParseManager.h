#import <Foundation/Foundation.h>


@interface ParseManager :NSObject

+ (id)parseGeneralResponse:(NSData *)jsonContent;
+ (id)parseForgotPasswordResponse:(NSData *)jsonContent;
+ (id)parseLoginResponse:(NSData *)jsonContent;
+ (id)parseContenstListResponse:(NSData *)jsonContent;
+ (id)parseVideoListResponse:(NSData *)jsonContent;

@end
