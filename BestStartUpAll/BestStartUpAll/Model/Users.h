//
//  Users.h
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Users : NSObject
@property NSMutableString *userid,*pin, *accountid;
typedef void(^user_completion_block)(NSDictionary *user,NSString *, int status);
@property NSMutableString *username,*firstname,*lastname,*password,*mobile,*rdate,*currentPassword,*fbid,*imgPath,*Email,*product,*phone,*msg,*msgRequest,*orderid,*forgotEmail,*comment,*Pageidentifier,*cms,*zipCode,*sku,*flag,*prodid,*qty,*coupon_code,*city,*state,*streetAdd,*Apt,*region_id,*addressid,*select_date, *select_time,*country_id,*strAuthorise, *strText, *strCall, *strReceive,* pageNo,*cardid,*cvv,*cardNumber,*expiryYear,*expiryMonth,*cardOwnerName,*cardType,*storeCard,*entity_id,*checkOutSelectedDate;

@property NSMutableString *completeAddress;
@property NSString *deviceToken;
@property (nonatomic, copy) user_completion_block completionBlock;
@property NSMutableDictionary *dictAddress;
@property (strong,nonatomic) NSMutableArray *aryDeliveryList;

- (BOOL) isNotNull:(NSObject*) object ;

-(void)dashboardList:(user_completion_block)completion;
-(void)brandAssignedProductList:(user_completion_block)completion;
-(void)topBarProductList:(user_completion_block)completion;
-(void)topProductList:(user_completion_block)completion;

-(void)forgotPassword:(user_completion_block)completion;
-(void)contactUs:(user_completion_block)completion;
-(void)registerUser:(user_completion_block)completion;
-(void)FAQ:(user_completion_block)completion;
-(void)loginUser:(user_completion_block)completion;
-(void)dashboard:(user_completion_block)completion;
-(void)productRequest:(user_completion_block)completion;
-(void)orderHistory:(user_completion_block)completion;
-(void)orderDetail:(user_completion_block)completion;
-(void)Search:(user_completion_block)completion;
-(void)brandList:(user_completion_block)completion;
-(void)zipCodeAvailability:(user_completion_block)completion;
-(void)cartAction:(user_completion_block)completion;
-(void)myCartList:(user_completion_block)completion;
-(void)CategoryAssignProductList:(user_completion_block)completion;
-(void)MyProfile:(user_completion_block)completion;
-(void)profileEdit:(user_completion_block)completion;
-(void)ViewWishList:(user_completion_block)completion;
-(void)coupons:(user_completion_block)completion;
-(void)AddwishListAction:(user_completion_block)completion;
-(void)removeWhishListAction:(user_completion_block)completion;
-(void)checkoutAddress:(user_completion_block)completion;
-(void)stateList:(user_completion_block)completion;
-(void)addressList:(user_completion_block)completion;
-(void)checkoutAddressWithAdd_id:(user_completion_block)completion;
-(void)AddressDelete:(user_completion_block)completion;
 -(void)deliveryPreference:(user_completion_block)completion;
-(void)customerAddressupdate:(user_completion_block)completion;
-(void)addressCreate:(user_completion_block)completion;
-(void)cardList:(user_completion_block)completion;
-(void)cardDataDelete:(user_completion_block)completion;
-(void)paymentProcessing:(user_completion_block)completion;
-(void)reOrder:(user_completion_block)completion;
-(void)checkoutDeliveryDate:(user_completion_block)completion;
-(void)checkoutDeliveryTime:(user_completion_block)completion;
-(void)referPoints:(user_completion_block)completion;
-(void)referral:(user_completion_block)completion;


@end
