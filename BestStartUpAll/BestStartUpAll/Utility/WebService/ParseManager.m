#import "ParseManager.h"
#import "zObjects.h"
#import "ApplicationData.h"

@implementation ParseManager

+ (id)parseGeneralResponse:(NSData *)jsonContent {
    
    NSMutableDictionary *jsonResponse = [jsonContent JSONValue];
    if (jsonResponse == nil) {
        return nil;
    }
    return jsonResponse;
}

+ (id)parseForgotPasswordResponse:(NSData *)jsonContent {
    NSMutableDictionary *jsonResponse = [jsonContent JSONValue];
    if (jsonResponse == nil) {
        return nil;
    }
    return jsonResponse;
}

+ (id)parseContenstListResponse:(NSData *)jsonContent
{
    return jsonContent;
}


+ (id)parseLoginResponse:(NSData *)jsonContent {
    
    NSMutableDictionary *jsonResponse = [jsonContent JSONValue];
    if (jsonResponse != nil) {
       
        return jsonResponse;
    }
    else
        return nil;
}


+ (id)parseVideoListResponse:(NSData *)jsonContent {
    NSMutableDictionary *jsonResponse = [jsonContent JSONValue];
    //ApplicationData *appData = [ApplicationData sharedInstance];
    if (jsonResponse != nil) {
        
        return jsonResponse;
    }
    else
        return nil;

}




@end

