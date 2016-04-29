
//
//  APICall.m
//  Rover
//
//  Created by letsnurture on 3/4/15.
//  Copyright (c) 2015 letsnurture. All rights reserved.
//

#import "APICall.h"

@implementation APICall

+(void)callPostWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion
{
    // NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"POST data JSON returned: %@", responseObject);
        if (completion) {
            long code=200;
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:&error];
            completion([json mutableCopy], nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }
     ];
}

+(void)callGetWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter completion:(completion_handler_t)completion{
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"POST data JSON returned: %@", responseObject);
        if (completion) {
            long code=200;
            completion(responseObject, nil,code);
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if (completion) {
            long code=(long)[[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            completion(nil, error,code);
        }
    }
     ];
    
}

+(void)callPutWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter {
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager PUT:urlStr parameters: parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"POST data JSON returned: %@", responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }
     ];
    
}

+(void)callDeleteWebService:(NSString *)urlStr andDictionary:(NSDictionary *)parameter {
    
    NSString *encodedUsernameAndPassword=@"MnhUZ0RBZkpwYzR4TFdSTDN0U0ZleHpGOk56QXdNRGM2TWpvMU5HVm1PREZtWmpvMU5UQmlNekUzWmcuR1l6YUQxRXd6cG5sbWNoV2QxaV9PNndIeE8wWDhzT1RQMmNnOGFsUGN0dw==";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager DELETE:urlStr parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"POST data JSON returned: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}


@end
