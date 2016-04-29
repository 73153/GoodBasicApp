
#import <Foundation/Foundation.h>
#import "Constant.h"

typedef void (^OnSuccess) (NSHTTPURLResponse *response, NSMutableDictionary *bodyDict);
typedef void (^OnFailure) (NSHTTPURLResponse *response, NSString *bodyString, NSError *error);
typedef void (^OnDidSendData) (NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite);
typedef enum {
    HTTPRequestTypeGeneral,
    HTTPRequestTypeLogin,
    HTTPRequestTypeRegister,
    HTTPRequestTypeLogout,
    HTTPRequestTypeForgotPassword,
    HTTPManagerTypeGetContestList,
    HTTPRequestTypeGetVideoList
} HTTPRequestType;


@protocol HTTPManagerDelegate;

@interface HTTPManager : NSObject

@property (nonatomic, retain)id <HTTPManagerDelegate> delegate;
@property (nonatomic, assign)CGFloat totalSize;
@property (nonatomic) HTTPRequestType requestType;
@property (nonatomic, retain) NSString *URL;
@property (nonatomic, retain) NSString *postString;
@property (nonatomic, retain)  id extraInfo;
@property (nonatomic, readonly) NSString *responseString;


+(id)managerWithURL:(NSString*)strURL;
- (void)StartUploadPostData:(NSData *)postContent Boundry:(NSString *)contentBoundry OnSuccess:(OnSuccess)onSuccessBlock
                    failure:(OnFailure)onFailureBlock
                didSendData:(OnDidSendData)onDidSendDataBlock;
- (void)cancelConnection;
- (void)startImageDownloadOnSuccess:(OnSuccess)onSuccessBlock
failure:(OnFailure)onFailureBlock
didSendData:(OnDidSendData)onDidSendDataBlock;

- (void)startDownloadOnSuccess:(OnSuccess)onSuccessBlock
                       failure:(OnFailure)onFailureBlock
                   didSendData:(OnDidSendData)onDidSendDataBlock;
- (NSData *)createFormData:(NSDictionary *)myDictionary withBoundary:(NSString *)myBounds;
@end

@protocol HTTPManagerDelegate <NSObject>
@optional
- (void)HttpManger:(HTTPManager*)manger DownloadedWith:(id)response;
- (void)HttpManger:(HTTPManager*)manger DownloadedWithImage:(UIImage*)image;
- (void)HttpManger:(HTTPManager *)manger FailedWith:(id)response;

@end


