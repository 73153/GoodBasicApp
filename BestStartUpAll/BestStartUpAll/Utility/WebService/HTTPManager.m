

#import "HTTPManager.h"
#import "ParseManager.h"
#import "ApplicationData.h"
#import "Globals.h"
#import "Users.h"

@interface HTTPManager () {
    NSURLConnection *theConnection;
    NSMutableData *receiveData;
    BOOL isReqForImage;
    UIImage *downloadedImage;
    Globals *OBJGlobal;
    
}
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, readonly) NSString *body;

@property (nonatomic, copy) OnSuccess onSuccess;
@property (nonatomic, copy) OnFailure onFailure;
@property (nonatomic, copy) OnDidSendData onDidSendData;

@end

@implementation HTTPManager

@synthesize totalSize;
@synthesize URL;
@synthesize responseString;

+(id)managerWithURL:(NSString*)strURL {
    HTTPManager *manager = [[HTTPManager alloc] init];
    manager.URL = [strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return manager;
}
//download image

- (void)startImageDownloadOnSuccess:(OnSuccess)onSuccessBlock
                            failure:(OnFailure)onFailureBlock
                        didSendData:(OnDidSendData)onDidSendDataBlock {
    self.onSuccess = onSuccessBlock;
    self.onFailure = onFailureBlock;
    self.onDidSendData = onDidSendDataBlock;
    
    ApplicationData *appData=[ApplicationData sharedInstance];
    if([appData connectedToNetwork]) {
        isReqForImage = TRUE;
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        if ([NSURLConnection canHandleRequest:request]) {
            theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            [theConnection start];
        }
    }
    else {
        [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Error" Message:@"Could not establish connection. please check your network"];
    }
}

//get string data
- (void)startDownloadOnSuccess:(OnSuccess)onSuccessBlock
                       failure:(OnFailure)onFailureBlock
                   didSendData:(OnDidSendData)onDidSendDataBlock {
    self.onSuccess = onSuccessBlock;
    self.onFailure = onFailureBlock;
    self.onDidSendData = onDidSendDataBlock;
    
    isReqForImage = FALSE;
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:180.0 ];
    if(self.postString.length) {
        [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [theRequest setHTTPMethod:@"POST"];
        NSMutableData *oHttpBody = [NSMutableData data];
        [oHttpBody appendData:[self.postString dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[oHttpBody length]];
        [theRequest addValue:postLength forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPBody:oHttpBody];
    }
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection start];
}

- (void)StartUploadPostData:(NSData *)postContent Boundry:(NSString *)contentBoundry OnSuccess:(OnSuccess)onSuccessBlock
                    failure:(OnFailure)onFailureBlock
                didSendData:(OnDidSendData)onDidSendDataBlock {
    self.onSuccess = onSuccessBlock;
    self.onFailure = onFailureBlock;
    self.onDidSendData = onDidSendDataBlock;
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0 ];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody:postContent];
    [theRequest addValue:contentBoundry forHTTPHeaderField: @"Content-Type"];
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection start];
}

#pragma mark -
#pragma mark NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    receiveData = [[NSMutableData alloc] init];
    self.totalSize=[response expectedContentLength];
    //	NSLog(@"Total Size : %f",self.totalSize);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receiveData appendData:data];
    //	CGFloat progress=[receiveData length]/self.totalSize ;
    //NSLog(@"Progress : %f",progress);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    ApplicationData *appDelegate = [ApplicationData sharedInstance];
    if(!OBJGlobal)
        OBJGlobal = [Globals sharedManager];
    if(OBJGlobal.isfirstTimeDashBoardDataReceived==true)
        [appDelegate hideLoader];
    if (isReqForImage) {
        downloadedImage = [[UIImage alloc]initWithData:receiveData];
        if([self.delegate respondsToSelector:@selector(HttpManger:DownloadedWithImage:)])
        {
            [self.delegate HttpManger:self DownloadedWithImage:downloadedImage];
        }
    }
    else {
        
        responseString = [[NSString alloc] initWithData:receiveData encoding:NSUTF8StringEncoding];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""];
        
        id returnValue=responseString;
        switch (self.requestType) {
            case HTTPRequestTypeGeneral:
                returnValue = [ParseManager parseGeneralResponse:receiveData];
                break;
            case HTTPRequestTypeForgotPassword:
                returnValue = [ParseManager parseForgotPasswordResponse:receiveData];
                break;
            case HTTPRequestTypeLogin:
                returnValue = [ParseManager parseLoginResponse:receiveData];
                break;
            case HTTPManagerTypeGetContestList:
                returnValue = [ParseManager parseContenstListResponse:receiveData];
                break;
            case HTTPRequestTypeGetVideoList:
                returnValue = [ParseManager parseVideoListResponse:receiveData];
                break;
            default:
                returnValue = [ParseManager parseGeneralResponse:receiveData];
                break;
        }
        
        if(returnValue == nil) // Invalid Response or Error
        {
            self.onFailure(self.response, self.body, returnValue);
        }
        else
            self.onSuccess(self.response, returnValue);
    }
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    ApplicationData *appDelegate = [ApplicationData sharedInstance];
    [appDelegate hideLoader];
//    self.onFailure(self.response, self.body, 0);
    if(!OBJGlobal)
        OBJGlobal = [Globals sharedManager];
    Users *objUser = OBJGlobal.user;

    NSString *strError = [error localizedDescription];
    if([strError isEqualToString:@"The network connection was lost."])
    {
//        [self stopDownload];
        [self startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            
            
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(objUser.completionBlock)
                    {
                        //objGlobal.cat_id_TopBarSubCategory = [[NSString stringWithFormat:@"%d",2] mutableCopy];
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            objUser.completionBlock(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            objUser.completionBlock(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    objUser.completionBlock(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            //            [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Alert" Message:[error localizedDescription]];
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];

    }
    else{
        [[ApplicationData sharedInstance] ShowAlertWithTitle:@"Error" Message:strError];
    }
    return;
    
    
    //    if([self.delegate respondsToSelector:@selector(HttpManger:FailedWith:)]) {
    //        [self.delegate HttpManger:self FailedWith:nil];
    //    }
}


- (void)stopDownload {
    //取消 httpRequest
    if (theConnection) {
        [theConnection cancel];
        theConnection = nil;
    }
}
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    //	float progress = [[NSNumber numberWithInteger:totalBytesWritten] floatValue];
    //	float total = [[NSNumber numberWithInteger: totalBytesExpectedToWrite] floatValue];
    
    //    NSLog(@"Bytes Uploaded %f/%f ",total,progress);
}

- (void)cancelConnection {
    [theConnection cancel];
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
