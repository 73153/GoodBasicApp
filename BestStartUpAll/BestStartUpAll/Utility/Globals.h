//
//  Globals.h
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"
#import <UIKit/UIKit.h>
#import "CommonPopUpView.h"

@interface Globals : NSObject
+ (id)sharedManager;
@property Users *user;
//@property Video *video;
@property NSMutableArray *users, *aryKartDataGlobal, *aryGlobalSearchProduct, *arrPaypalData,*aryFavoriteListGlobal;
@property NSMutableArray *aryDashboardGlobal,*aryLeftSideMenuDetail,*aryDeliveryList;
@property NSMutableString *cat_id_LeftSideDashBoard,*cat_id_TopBarSubCategory,*cat_id_PopularBrandSubCategory,*rightSideDetectForLogOutPress,*numberOfCartItems,*pointsTotal,*totalPageDashBoard;
@property BOOL isProductAddedToKart,isFirstTimeFetchKartData,isfirstTimeDashBoardDataReceived;
@property  CommonPopUpView *objMainPopUp;
@property BOOL isUserHasGotLogin,isDeliveryPreferencePopUp,isEditAddress,isDeliveryAddressListNill,isCardlistNill;
@property   NSInteger selectedIndexPathForRightMenu;
@property NSString *pin,*lblSubCategoryName;
@property NSInteger selectedIndexpathForLeft,pageNoCountDashBoard;
@property NSDictionary *dictLastKartProduct;
@property NSMutableString *strEmailId;
- (BOOL) isNotNull:(NSObject*) object;

-(NSMutableString*)checkForFlagEditOrUpdate:(NSArray*)aryKartitems dictForItemToCheck:(NSDictionary*)dictForItemToCheck;

-(void)setNavigationTitleAndBGImageName:(NSString *)strImageName navigationController:(UINavigationController *)navigationController;
-(void)setTextFieldWithSpace:(UITextField*)txtField;

-(NSString*)maxDigitsInString:(NSString*)str;

-(void)setTitleBadgeCountFromLocalDB:(UIButton *)btnBadgeCount aryKartDetail:(NSMutableArray*)aryKartDetail;

-(void)setTitleForBadgeCount:(UIButton *)btnBadgeCount dictKartDetail:(NSDictionary*)dictKartDetail;
-(void)setTitleForBadgeCountOnViewAppears:(UIButton *)btnBadgeCount;
-(NSArray*)compareForKartProductAndTotalProduct:(NSDictionary*)dictKartProduct aryTotalProduct:(NSArray*)aryTotalProduct;
-(NSArray*)compareForKartProductAndTotalProductForSubCategory:(NSDictionary*)dictKartProduct aryTotalProduct:(NSArray*)aryTotalProduct;

-(NSArray*)sortArrayUsingKey:(NSArray*)aryToSort strKey:(NSString*)strKey;
-(BOOL)isProductGotMatchToFavouriteProductList:(NSDictionary*)dictFavouriteProduct aryTotalProduct:(NSArray*)aryTotalProduct;
-(void)makeTextFieldBorderRed:(UITextField*)textFieldForRedBorder;
-(void)makeTextFieldNormal:(UITextField*)textFieldForNormal;
@end
