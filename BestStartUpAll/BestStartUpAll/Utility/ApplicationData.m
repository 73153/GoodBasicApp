

#import "ApplicationData.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netinet/in.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"


@implementation UINavigationController (SafePushing)

- (id)navigationLock
{
    return self.topViewController;
}


+(UIImage*)imageWithImage:(UIImage*)image
             scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        [self pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        return [self popToRootViewControllerAnimated:animated];
    return @[];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock
{
    if (!navigationLock || self.topViewController == navigationLock)
        return [self popToViewController:viewController animated:animated];
    return @[];
}

@end


static ApplicationData *applicationData = nil;

@implementation ApplicationData
@synthesize object;

- (id)init {
	if(self == [super init]) {
    }    
	return self;
}

- (void)initialize {
    // Initilize Default Values Here
    
    
}

+ (ApplicationData*)sharedInstance {
    if (applicationData == nil) {
        applicationData = [[super allocWithZone:NULL] init];
		[applicationData initialize];
        
    }
    return applicationData;
}

-(NSString *)isNullOrEmpty:(NSString *)inString
{
    NSString *strText = @"";
    if ([inString isKindOfClass:[NSNull class]]) {
        return strText;
    }
    if (inString == nil || inString == (id)[NSNull null]||[inString isEqualToString:@""] || [inString isEqualToString:@"<null>"] || [inString isEqualToString:@"(null)"] || [inString isEqualToString:@"(null) (null)"]) {
        // nil branch
        return strText;
    } else {
        return inString;
    }
    return nil;
}
-(NSString *)isValueNullOrEmpty:(NSString *)inString
{
    NSString *strText = @"0";
    if ([inString isKindOfClass:[NSNull class]]) {
        return strText;
    }
    if (inString == nil || inString == (id)[NSNull null]||[inString isEqualToString:@""] || [inString isEqualToString:@"<null>"] || [inString isEqualToString:@"(null)"] || [inString isEqualToString:@"(null) (null)"]) {
        // nil branch
        return strText;
    } else {
        return inString;
    }
    return nil;
}


-(void) setImageWithURL1:(NSURL *)url withImage:(UIImageView *)imgView{
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    imgView.image = [UIImage imageWithData:imageData];
   // [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"carrot"]];
    //    [downloader downloadImageWithURL:url
    //                             options:0
    //                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //                                // progression tracking code
    //
    //                            }
    //                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
    //                               if (image && finished) {
    //                                   imgView.image=image;
    //
    //                                   // do something with image
    //                               }
    //                           }];
}

#pragma mark - ProgresLoader

- (void)showLoader {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)showLoaderWith:(MBProgressHUDMode)mode {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
    hud.mode = mode;
}

- (void)hideLoader {
    if([UIApplication sharedApplication].isNetworkActivityIndicatorVisible) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    [hud removeFromSuperview];
}
- (void)showLoaderIn:(UIView *)view {
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    if(!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    else {
        [[UIApplication sharedApplication].keyWindow addSubview:hud];
    }
}
#pragma mark DateFormatter 
- (NSString *)getFormattedStringFrom:(NSDate *)date formatter:(NSString *)format {
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:format];
    return [dtFormatter stringFromDate:date];
}

- (NSDate *)getFormattedDateFrom:(NSString *)string formatter:(NSString *)format {
    NSDateFormatter *dtFormatter = [[NSDateFormatter alloc] init];
    [dtFormatter setDateFormat:format];
    return [dtFormatter dateFromString:string];
}



- (void)setBorderFor:(UIView *)aView {
    aView.layer.borderWidth = 3;
    aView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width {
//    CGSize  textSize = { width, 10000.0 };
//	CGSize size = [string sizeWithFont:aFont
//                   constrainedToSize:textSize
//                       lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize maximumLabelSize = CGSizeMake(width, CGFLOAT_MAX);
    CGRect textRect = [string boundingRectWithSize:maximumLabelSize
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName:aFont}
                                             context:nil];

    return textRect.size.height;
}

- (void)playYouTubeVideoInWebView:(UIWebView*)webview youTubeURL:(NSString*)url {
    url = [url stringByReplacingOccurrencesOfString:@"watch?" withString:@""];
    url = [url stringByReplacingOccurrencesOfString:@"=" withString:@"/"];
    
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0px\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    
    NSString* html = [NSString stringWithFormat:embedHTML, url,webview.frame.size.width,webview.frame.size.height];
    
    [webview loadHTMLString:html baseURL:nil];
    //http://www.youtube.com/watch?v=betzZgt81ko
}

- (void)setTextFieldLeftView:(UITextField *)txtField {
    txtField.leftViewMode = UITextFieldViewModeAlways;
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    aView.backgroundColor = [UIColor clearColor];
    txtField.leftView = aView;
}

- (void)setButtonUnderLine:(UIButton *)button {
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:[button titleForState:UIControlStateNormal]];
    
    [commentString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [commentString length])];
    
    [commentString addAttribute:NSForegroundColorAttributeName value:[button titleColorForState:UIControlStateNormal] range:NSMakeRange(0, [commentString length])];
    [button setAttributedTitle:commentString forState:UIControlStateNormal];
}

#pragma mark Internet Connection
- (BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    BOOL isconnected = (isReachable && !needsConnection) ? YES : NO;
    if (!isconnected) {
        //[self ShowAlertWithTitle:@"Alert" Message:@"Please check internet connection in this device!"];
    }
    return isconnected;
}




#pragma mark Alert
- (void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message {
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark Validation Methods

- (BOOL) validateEmail: (NSString *) candidate {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	
    return [emailTest evaluateWithObject:candidate];
}
- (BOOL) validateWebURL : (NSString *) weburl {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:weburl];
}

- (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


- (UIImage *)getThumbImage:(UIImage *)image {
    float ratio;
    float delta;
    float px = 100; // Double the pixels of the UIImageView (to render on Retina)
    CGPoint offset;
    CGSize size = image.size;
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    UIGraphicsBeginImageContext(CGSizeMake(px, px));
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgThumb;
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //return image
    return image;
}

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:cornerRadius] addClip];
    // Draw your image
    [original drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return imageView.image;
}



//- (void)zoomToFitMapAnnotations:(MKMapView*)mapView {
//    if([mapView.annotations count] == 0)
//        return;
//    CLLocationCoordinate2D topLeftCoord;
//    topLeftCoord.latitude = -90;
//    topLeftCoord.longitude = 180;
//    CLLocationCoordinate2D bottomRightCoord;
//    bottomRightCoord.latitude = 90;
//    bottomRightCoord.longitude = -180;
//    
//    for(MapViewAnnotation* annotation in mapView.annotations){
//        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
//        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude  );
//        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
//        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
//    }
//    MKCoordinateRegion region;
//    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude -    topLeftCoord.longitude) * 0.5;
//    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2; // Add a little extra space on the sides
//    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2; // Add a little extra space on the sides
//    region = [mapView regionThatFits:region];
//    [mapView setRegion:region animated:YES];
//}





//-(JImage *)getJImage:(NSString *)imgName {
//    JImage *photoImage=[[JImage alloc] init];
//    
//    photoImage.backgroundColor = [UIColor clearColor];
//    
//    [photoImage setFrame:frame];
//    
//    [photoImage setContentMode:UIViewContentModeScaleToFill];
//    
//    [photoImage initWithImageAtURL:[NSURL URLWithString:imgName]];
//    
//    return photoImage;
//    
//}
//

-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text{
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:label.font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){label.frame.size.width, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    return ceil(rect.size.height);
}



//-(void)starTimeForBanner{
// self.timer =  [NSTimer scheduledTimerWithTimeInterval:[kSponserChangeTime floatValue] target:self selector:@selector(getUserPermissions) userInfo:nil repeats:YES];
//}
//-(void) stopTimer {
//    [self.timer invalidate];
//}
//- (void) getUserPermissions {
//   
//    NSString *strUserName = UDGetObject(USERNAME);
//    NSString *strPasword = UDGetObject(PASSWRD);
//    NSString *postString = [NSString stringWithFormat:@"sUserName=%@&sPassword=%@",strUserName,strPasword];
//    HTTPManager *manager = [HTTPManager managerWithURL:URL_LOGIN];
//    [manager setPostString:postString];
//    manager.requestType= HTTPRequestTypeLogin;
//        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
//            
//        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
//            
//        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
//            
//        }];
//
//}


- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
    fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}
@end
