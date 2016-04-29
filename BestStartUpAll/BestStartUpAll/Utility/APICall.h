//
//  APICall.h
//  Rover
//
//  Created by letsnurture on 3/4/15.
//  Copyright (c) 2015 letsnurture. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface APICall : NSObject
typedef void(^completion_handler_t)(NSMutableDictionary *, NSError*error, long code);
+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion;
+(void)callGetWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion;
+(void)callPutWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter;
+(void)callDeleteWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter;

@end
