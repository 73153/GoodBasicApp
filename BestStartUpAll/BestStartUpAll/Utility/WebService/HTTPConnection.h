//
//  HTTPConnection.h
//  Created by Ashish Patel on 11/26/11.
//

#import <Foundation/Foundation.h>


typedef void (^OnSuccess) (NSHTTPURLResponse *response, NSMutableDictionary *bodyDict);
typedef void (^OnFailure) (NSHTTPURLResponse *response, NSString *bodyString, NSError *error);
typedef void (^OnDidSendData) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);


@interface HTTPConnection : NSObject

- (id)initWithRequest:(NSURLRequest *)urlRequest;

- (BOOL)executeRequestOnSuccess:(OnSuccess)onSuccessBlock
                        failure:(OnFailure)onFailureBlock
                    didSendData:(OnDidSendData)onDidSendDataBlock;
- (BOOL)executeSyncRequestOnSuccess:(OnSuccess)onSuccessBlock
                            failure:(OnFailure)onFailureBlock
                        didSendData:(OnDidSendData)onDidSendDataBlock;


@end
