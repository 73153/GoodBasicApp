

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constant.h"
#import "Users.h"
#import "MBProgressHUD.h"

@interface UINavigationController (SafePushing)

- (id)navigationLock; ///< Obtain "lock" for pushing onto the navigation controller

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock; ///< Uses a horizontal slide transition. Has no effect if the view controller is already in the stack. Has no effect if navigationLock is not the current lock.
- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated navigationLock:(id)navigationLock; ///< Pops view controllers until the one specified is on top. Returns the popped controllers. Has no effect if navigationLock is not the current lock.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated navigationLock:(id)navigationLock; ///< Pops until there's only a single view controller left on the stack. Returns the popped controllers. Has no effect if navigationLock is not the current lock.

@end

@interface ApplicationData : NSObject<UIActionSheetDelegate> {
    // Share
    MBProgressHUD *hud;
 }
@property(nonatomic,strong)id object;
@property (nonatomic) Users *user;
//@property (nonatomic) MyActivity *activity;
//@property (nonatomic) DashBoard *dashboard;
//@property (nonatomic) RecentEntries *recent;
//@property (nonatomic) Contest *contest;
//@property (nonatomic) Group *group;

@property (nonatomic) BOOL isUserLogin;
+ (ApplicationData *)sharedInstance;
- (BOOL) validateEmail: (NSString *)candidate;
- (BOOL) validateWebURL : (NSString *) weburl;
//-(void)hidePopover;
- (void)showLoader;
- (void)hideLoader;
//- (void) setBackButtonLogo;
- (NSString *)getFormattedStringFrom:(NSDate *)date formatter:(NSString *)format;
- (NSDate *)getFormattedDateFrom:(NSString *)string formatter:(NSString *)format;


-(void) setImageWithURL1:(NSURL *)url withImage:(UIImageView *)imgView;

- (UIImage *)getThumbImage:(UIImage *)image;

- (void)setTextFieldLeftView:(UITextField *)txtField;

- (void)setButtonUnderLine:(UIButton *)button;

- (BOOL)connectedToNetwork;

- (void)ShowAlertWithTitle:(NSString *)title Message:(NSString *)message;
- (float)getTextHeightOfText:(NSString *)string font:(UIFont *)aFont width:(float)width;

//- (void)ShareMessageON:(NSString *)service image:(UIImage *)_image message:(NSString *)_message  from:(UIViewController *)controller url:(NSString *)_url;

- (void)setBorderFor:(UIView *)aView;

- (void)playYouTubeVideoInWebView:(UIWebView*)webview youTubeURL:(NSString*)url;

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size;
- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original;
-(CGFloat)heightForLabel:(UILabel *)label withText:(NSString *)text;
-(NSString *)isNullOrEmpty:(NSString *)inString;
//-(void) setImageWithURL:(NSURL *)url withImage:(UIImageView *)imgView;
//- (void) getLoginVC;
//- (void)turnBackToAnOldViewController:(UIViewController *)AnOldViewController;
- (void)pushNewViewController:(UIViewController *)NewViewController;
-(NSString *)isValueNullOrEmpty:(NSString *)inString;

//-(void)btnContestsPressedTab;
//
//- (void)btnuploadPressedTab;
//
//- (void)btnMyphotoPressedTab;

//- (void)btninfoPressedTab;
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

+(UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

@end
