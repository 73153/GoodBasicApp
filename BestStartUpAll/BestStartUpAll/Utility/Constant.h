//
//  Constant.h
//  Challenge Me

#import "Validations.h"
#import "MBProgressHUD.h"
#import "ApplicationData.h"
//#import "PopupViewController.h"
#import "Globals.h"
#import "CommonPopUpView.h"
#import "AppDelegate.h"



#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4 (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)



#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6      (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#if DEBUG
#define DLOG(format, ...)     ///((@"%s:%d %s " format), \
strrchr ("/" __FILE__, '/') + 1, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)

#else
#define DLOG(format, ...)

#endif
#define DEVICE_FRAME [[ UIScreen mainScreen ] bounds ]
#define OS_VER [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
#define DEVICE_ID [[[UIDevice currentDevice]identifierForVendor]UUIDString]

#define APPDATA [ApplicationData sharedInstance]

#define RGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RECT(x,y,w,h)  CGRectMake(x, y, w, h)
#define POINT(x,y)     CGPointMake(x, y)
#define SIZE(w,h)      CGSizeMake(w, h)
#define RANGE(loc,len) NSMakeRange(loc, len)

#define NAV_COLOR       RGB(3,143,113)
#define TEXT_COLOR      RGB(52,65,71)
#define BORDER_COLOR    RGB(122,145,158)
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define SETOBJECT(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]

#define SETBOOL(bool,key)[[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]


#define UDSetObject(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetBool(value, key) [[NSUserDefaults standardUserDefaults] setBool:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetInteger(value, key) [[NSUserDefaults standardUserDefaults] setInteger:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDGetObject(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define UDGetBool(key) [[NSUserDefaults standardUserDefaults] boolForKey:(key)]
#define UDGetInteger(key) (int)[[NSUserDefaults standardUserDefaults] integerForKey:key]


#define GETOBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define GETBOOL(key)   [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define SYNCHRONIZE   [[NSUserDefaults standardUserDefaults] synchronize];

#define KEYBORAD_HEIGHT_IPHONE 216

#import "HTTPManager.h"
//LOCAL URL
//#define BASE_URL        @"http://216.55.169.45/~peter/master/web/"
//
//SERVER LIVE URL
#define BASE_URL        @"http://www.mycampusgenie.com/web/"
#define API_USER          (BASE_URL@"register.php")
#define API_USER_LOGIN    (BASE_URL@"login.php")
#define API_CUSTOMER_LOGIN    (BASE_URL@"customerLogin.php")
#define API_CUSTOMER_REGISTER    (BASE_URL@"customerRegistration.php")
#define API_DASHBOARD    (BASE_URL@"dashboardProductList.php")
#define API_CONTACT_US    (BASE_URL@"contactUs.php")
#define API_BRAND_ASSIGNED_PRODUCT_LIST (BASE_URL@"brandAssignedProductList.php")
#define API_CATEGORY_PRODUCT_LIST   (BASE_URL@"categoryAssignedProdList.php")
#define API_TOP_PRODUCTS    (BASE_URL@"topProductsPerCategoryList.php")
#define API_SUB_CATEGORY_PRODUCT    (BASE_URL@"categorySub.php")
#define API_BRAND_LIST    (BASE_URL@"brandList.php")
#define API_CART_ACTION    (BASE_URL@"cartActions.php")
#define API_MY_CART   (BASE_URL@"customercart.php")
#define API_MY_PROFILE   (BASE_URL@"customerInfo.php")
#define API_MY_PROFILE_EDIT   (BASE_URL@"customerInfoUpdate.php")
#define API_MY_WISHLIST   (BASE_URL@"wishlist.php")
#define API_MY_COUPON   (BASE_URL@"couponActions.php")
#define API_CHECKOUT_ADDRESS   (BASE_URL@"checkoutAddressStep.php")
#define API_CREATE_ADDRESS   (BASE_URL@"customerAddressCreate.php")
#define API_UPDATE_ADDRESS   (BASE_URL@"customerAddressUpdate.php")
#define API_DELETE_ADDRESS   (BASE_URL@"customerAddressDelete.php")
#define API_MY_REMOVE_WISHLIST    (BASE_URL@"remove_wishlist.php")
#define keyID @"id"
#define keyName @"name"
#define keySelected @"isSelected"
#define API_CHECKOUT_DELIVERY_STEP    (BASE_URL@"checkoutDeliveryStep.php")




#define API_PRODUCT_REQUEST    (BASE_URL@"productRequest.php")
#define API_ORDER_HISTORY    (BASE_URL@"customerOrderHistoryList.php")
#define API_ORDER_DETAIL    (BASE_URL@"customerOrderInfo.php")
#define API_FORGOT_PASSWOARD    (BASE_URL@"forgetPassword.php")
#define API_FAQ    (BASE_URL@"cmsContent.php")
#define API_SEARCH_PRODUCT    (BASE_URL@"searchprod.php")
#define API_ZIPCODE    (BASE_URL@"zipcodeAvailability.php")
#define API_STATE    (BASE_URL@"stateList.php")
#define API_ADDRESS_LIST    (BASE_URL@"customerAddressList.php")
#define API_DELIVERY_ADDRESS    (BASE_URL@"checkoutOrderReview.php")
#define API_ADDRESS_DELETE    (BASE_URL@"customerAddressDelete.php")
#define API_ADDRESS_INFO   (BASE_URL@"customerAddressInfo.php")
#define API_ADDRESS_UPDATE   (BASE_URL@"customerAddressUpdate.php") 
#define API_CARD_STORED_LIST   (BASE_URL@"checkoutPaymentStep.php")
#define API_CARD_LIST_DELETE   (BASE_URL@"deleteCreditCard.php")
#define API_PAYMENT   (BASE_URL@"checkoutPlaceOrder.php") 
#define API_REODER (BASE_URL@"reorder.php")
#define API_DATE (BASE_URL@"checkoutDeliveryDates.php")
#define API_TIME (BASE_URL@"checkoutDeliveryTime.php")
#define API_REFER_POINTS (BASE_URL@"customerReferralPoints.php")
#define API_REFERRAL (BASE_URL@"referralws.php")

#if DEBUG
#define DLOG(format, ...)     ///((@"%s:%d %s " format), \
strrchr ("/" __FILE__, '/') + 1, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)

#else
#define DLOG(format, ...)

#endif
#define DEVICE_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define DEVICE_FRAME [[ UIScreen mainScreen ] bounds ]
#define OS_VER [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? YES : NO)
#define DEVICE_ID [[[UIDevice currentDevice]identifierForVendor]UUIDString]

#define APPDATA [ApplicationData sharedInstance]

#define RGB(r,g,b)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RECT(x,y,w,h)  CGRectMake(x, y, w, h)
#define POINT(x,y)     CGPointMake(x, y)
#define SIZE(w,h)      CGSizeMake(w, h)
#define RANGE(loc,len) NSMakeRange(loc, len)


#define NAV_COLOR       RGB(3,143,113)
#define TEXT_COLOR      RGB(52,65,71)
#define BORDER_COLOR    RGB(122,145,158)
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define SETOBJECT(object,key) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key]

#define SETBOOL(bool,key)[[NSUserDefaults standardUserDefaults] setBool:bool forKey:key]


#define UDSetObject(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetBool(value, key) [[NSUserDefaults standardUserDefaults] setBool:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDSetInteger(value, key) [[NSUserDefaults standardUserDefaults] setInteger:value forKey:(key)];[[NSUserDefaults standardUserDefaults] synchronize]
#define UDGetObject(key) [[NSUserDefaults standardUserDefaults] objectForKey:(key)]
#define UDGetBool(key) [[NSUserDefaults standardUserDefaults] boolForKey:(key)]
#define UDGetInteger(key) (int)[[NSUserDefaults standardUserDefaults] integerForKey:key]


#define GETOBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define GETBOOL(key)   [[NSUserDefaults standardUserDefaults] boolForKey:key]

#define SYNCHRONIZE   [[NSUserDefaults standardUserDefaults] synchronize];

#define KEYBORAD_HEIGHT_IPHONE 216



#define CommentCellFont  [UIFont fontWithName:@"AvenirNextCondensed-Regular" size:14]
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

// For Validation Messages
#define ERROR_NAME @"Please enter Valid Name."
#define kMethod @"method"

#define ERROR_PRODUCTNAME @"Please enter Valid product Name."
#define ERROR_COMMENT @"Please enter Valid Comment."
#define ERROR_ADDRESS @"Please enter Valid address."
#define ERROR_FNAME @"Please enter Valid First Name."
#define ERROR_LNAME @"Please enter Valid Last Name."
#define ERROR_UNAME @"Please enter Valid User Name."
#define ERROR_EMAIL @"Please enter Valid Email Address."
#define ERROR_COMPANY @"Please enter Valid Company Name."
#define ERROR_WEBSITE @"Please enter Valid Website"
#define ERROR_PASSWORD @"Password length should be at least 6 character"
#define ERROR_CONFIRMPASSWORD @"Password does not match"
#define ERROR_CITY @"Please enter Valid City Name."
#define ERROR_STATE @"Please enter Valid state Name."
#define ERROR_CODE @"Please enter Valid Code."
#define ERROR_APISUIT @"Please enter Valid API/SUIT."
#define ERROR_Number @"Please enter Valid Number."
#define ERROR_CCVNUMBER @"Please enter Valid CVV Number."
#define ERROR_CARDNAME @"Please enter Valid Card Name."
#define kError @"error"
#define ERROR_Number @"Please enter Valid Number."
#define ERROR_CCVNUMBER @"Please enter Valid CVV Number."
#define ERROR_CARDTYPE @"Please enter Valid Card Type."
#define ERROR_CARDNUMBER @"Please enter Valid Number."
#define ERROR_CARDNAME @"Please enter Valid Card Name."
#define ERROR_YEAREXPIRED @"Please enter Valid expired year."
#define ERROR_MONTHEXPIRED @"Please enter Valid expired month."
#define ERROR_DATEEMPTY @"Please select date."
#define ERROR_TIMEEMPTY @"Please select time."


typedef enum {
    jServerError = 0,
    jSuccess,
    jGeneralQuery,
    jInvalidResponse,
    jNetworkError,
    jFailResponse,
}ErrorCode;
