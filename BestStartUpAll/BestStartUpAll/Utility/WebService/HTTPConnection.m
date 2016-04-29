//
//  HTTPConnection.h
//  Created by Ashish Patel on 11/26/11.
//

#import "HTTPConnection.h"
#import "AppDelegate.h"

@interface HTTPConnection ()

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, readonly) NSString *body;

@property (nonatomic, copy) OnSuccess onSuccess;
@property (nonatomic, copy) OnFailure onFailure;
@property (nonatomic, copy) OnDidSendData onDidSendData;

@end


@implementation HTTPConnection

- (id)initWithRequest:(NSURLRequest *)urlRequest
{
    self = [super init];
    if (self) {
        self.request = urlRequest;
        
    }
    return self;
}

- (NSString *)body
{
    return [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
}

//- (void)StartUploadPostData:(NSData *)postContent Boundry:(NSString *)contentBoundry {
//    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0 ];
//    [theRequest setHTTPMethod:@"POST"];
//    [theRequest setHTTPBody:postContent];
//    [theRequest addValue:contentBoundry forHTTPHeaderField: @"Content-Type"];
//    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
//    [theConnection start];
//}



- (BOOL)executeRequestOnSuccess:(OnSuccess)onSuccessBlock
                        failure:(OnFailure)onFailureBlock
                    didSendData:(OnDidSendData)onDidSendDataBlock
{
    self.onSuccess = onSuccessBlock;
    self.onFailure = onFailureBlock;
    self.onDidSendData = onDidSendDataBlock;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    return connection != nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)aResponse;
    self.response = httpResponse;
    
    self.data = [NSMutableData data];
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)bytes
{
    [self.data appendData:bytes];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.onFailure)
        self.onFailure(self.response, self.body, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (self.onSuccess) {
        NSError *localError = nil;
        NSMutableDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&localError];
        
        if (localError == nil)
            self.onSuccess(self.response, parsedObject);
        else
            self.onFailure(self.response, self.body, localError);

    }
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten
                                               totalBytesWritten:(NSInteger)totalBytesWritten
                                       totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    if (self.onDidSendData)
        self.onDidSendData(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

- (BOOL)executeSyncRequestOnSuccess:(OnSuccess)onSuccessBlock
                        failure:(OnFailure)onFailureBlock
                    didSendData:(OnDidSendData)onDidSendDataBlock
{
    self.onSuccess = onSuccessBlock;
    self.onFailure = onFailureBlock;
    self.onDidSendData = onDidSendDataBlock;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *newData = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&response error:&error];
    //json parse
    if (self.onSuccess) {
        NSError *localError = nil;
        NSMutableDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:newData options:0 error:&localError];
        
        if (localError == nil)
            self.onSuccess(self.response, parsedObject);
        else
            self.onFailure(self.response, self.body, localError);
        
    }
    else
        self.onFailure(self.response, self.body, nil);
    return false;
}

#pragma mark createFormData
- (NSData *)createFormData:(NSDictionary *)myDictionary withBoundary:(NSString *)myBounds {
    
    NSMutableData *myReturn = [[NSMutableData alloc] init];
    NSArray *formKeys = [myDictionary allKeys];
    for (int i = 0; i < [formKeys count]; i++) {
        [myReturn appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myBounds] dataUsingEncoding:NSASCIIStringEncoding]];
        [myReturn appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",[formKeys objectAtIndex:i],[myDictionary valueForKey:[formKeys objectAtIndex:i]]] dataUsingEncoding:NSASCIIStringEncoding]];
    }
    return myReturn;
}




@end
