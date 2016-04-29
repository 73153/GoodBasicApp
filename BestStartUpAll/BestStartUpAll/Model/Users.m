//
//  Users.m
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import "Users.h"
#import "APICall.h"
#import "Constant.h"

@implementation Users
@synthesize username,password,userid,accountid,firstname,lastname,mobile,pin,Email,msg,phone,product,msgRequest,orderid,forgotEmail,comment,Pageidentifier,cms,zipCode,prodid,sku,qty,flag,coupon_code,city,state,streetAdd,Apt,region_id,addressid,completeAddress,select_date,select_time,country_id,strReceive,strText,strCall,strAuthorise,aryDeliveryList,pageNo,cardid,cardNumber,cardOwnerName,cardType,cvv,storeCard,expiryMonth,expiryYear,entity_id,checkOutSelectedDate;

-(instancetype)init
{
    self = [super init];
    if(self) {
        self.msgRequest=[[NSMutableString alloc]init];
        self.pageNo=[[NSMutableString alloc]init];
        self.msg=[[NSMutableString alloc]init];
        self.product=[[NSMutableString alloc]init];
        self.phone=[[NSMutableString alloc]init];
        self.username=[[NSMutableString alloc]init];
        self.Email=[[NSMutableString alloc]init];
        self.password=[[NSMutableString alloc]init];
        self.currentPassword=[[NSMutableString alloc]init];
        self.firstname=[[NSMutableString alloc]init];
        self.lastname=[[NSMutableString alloc]init];
        self.mobile=[[NSMutableString alloc]init];
        self.imgPath=[[NSMutableString alloc] init];
        self.deviceToken=[[NSString alloc] init];
        self.forgotEmail=[[NSMutableString alloc]init];
        self.orderid=[[NSMutableString alloc] init];
        self.comment=[[NSMutableString alloc]init];
        self.Pageidentifier=[[NSMutableString alloc]init];
        self.cms=[[NSMutableString alloc]init];
        self.accountid=[[NSMutableString alloc]init];
        self.pin=[[NSMutableString alloc]init];
        self.region_id=[[NSMutableString alloc]init];
        self.country_id=[[NSMutableString alloc]init];
        self.aryDeliveryList = [[NSMutableArray alloc] init];
        self.cardid = [[NSMutableString alloc] init];
        self.completeAddress=[[NSMutableString alloc]init];
        self.fbid=[[NSMutableString alloc]init];
        self.rdate=[[NSMutableString alloc]init];
        self.zipCode=[[NSMutableString alloc]init];
        self.prodid=[[NSMutableString alloc]init];
        self.qty=[[NSMutableString alloc]init];
        self.flag=[[NSMutableString alloc]init];
        self.sku=[[NSMutableString alloc]init];
        self.coupon_code=[[NSMutableString alloc]init];
        self.state=[[NSMutableString alloc]init];
        self.streetAdd=[[NSMutableString alloc]init];
        self.city=[[NSMutableString alloc]init];
        self.Apt=[[NSMutableString alloc]init];
        self.addressid=[[NSMutableString alloc]init];
        self.select_time=[[NSMutableString alloc]init];
        self.select_date=[[NSMutableString alloc]init];
        self.expiryYear=[[NSMutableString alloc]init];
        self.expiryMonth=[[NSMutableString alloc]init];
        self.cvv=[[NSMutableString alloc]init];
        self.cardOwnerName=[[NSMutableString alloc]init];
        self.cardNumber=[[NSMutableString alloc]init];
        self.cardType=[[NSMutableString alloc]init];
        self.storeCard=[[NSMutableString alloc]init];
        self.entity_id=[[NSMutableString alloc]init];
        self.checkOutSelectedDate = [[NSMutableString alloc]init];
    }
    return self;
}

- (BOOL) isNull:(NSObject*) object {
    if (!object)
        return YES;
    else if (object == [NSNull null])
        return YES;
    else if ([object isKindOfClass: [NSString class]]) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"null"]
                || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}

- (BOOL) isNotNull:(NSObject*) object {
    return ![self isNull:object];
}

-(void)registerUser:(user_completion_block)completion{
    @try{
        NSDictionary *parameters = @{@"email":self.Email,@"fname": self.firstname,@"lname":self.lastname, @"pass":self.password};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CUSTOMER_REGISTER];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)loginUser:(user_completion_block)completion{
    @try{
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CUSTOMER_LOGIN];
        NSDictionary *parameters = @{@"email":self.Email,@"pass":self.password};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error, please try again later",-1);
                }
            }
            else{
                if(completion)
                {
                    if ([[user valueForKey:@"status"] integerValue] == 0) {
                        
                        completion(user,@"Login Fail",0);
                        return ;
                    }
                    else
                    {
                        completion(user,@"Login success",1);
                    }
                    
                }
                
                else{
                    completion(user,@"Email ID or Password is invalid",0);
                }
            }
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)forgotPassword:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_FORGOT_PASSWOARD];
        NSDictionary *parameetrs =[[NSDictionary alloc] initWithObjects:@[self.forgotEmail] forKeys:@[@"email"]];
        [APICall callPostWebService:url_String andDictionary:parameetrs completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)contactUs:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CONTACT_US];
        NSDictionary *parameters = @{@"email":self.Email,@"comment":self.comment,@"name":self.username,@"telephone":self.phone};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Update Profile success",0);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)productRequest:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_PRODUCT_REQUEST];
        NSDictionary *parameters = @{@"email":self.Email,@"prod":self.product,@"name":self.username,@"phone":self.phone};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)orderHistory:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_ORDER_HISTORY];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)orderDetail:(user_completion_block)completion{
    @try {
        
        NSString *url_String = [NSString stringWithFormat:@"%@", API_ORDER_DETAIL];
        NSLog(@"%@",APPDATA.user.orderid);
        NSDictionary *parameetrs =[[NSDictionary alloc] initWithObjects:@[self.orderid] forKeys:@[@"orderid"]];
        NSLog(@"before parameters");
        [APICall callPostWebService:url_String andDictionary:parameetrs completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


-(void)zipCodeAvailability:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_ZIPCODE];
        NSDictionary *parameetrs =[[NSDictionary alloc] initWithObjects:@[self.zipCode] forKeys:@[@"key"]];
        [APICall callPostWebService:url_String andDictionary:parameetrs completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)cartAction:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CART_ACTION];
        NSDictionary *parameters=[[NSDictionary alloc]init];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
            
        }
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"prodid":self.prodid,@"qty":self.qty,@"sku":self.sku,@"flag":self.flag};
        
        
        NSString *postString = [NSString stringWithFormat:@"userid=%@&prodid=%@&qty=%@&sku=%@&flag=%@",
                                [NSString stringWithFormat:@"%@",self.userid],
                                [NSString stringWithFormat:@"%@",self.prodid],
                                [NSString stringWithFormat:@"%@",self.qty],
                                [NSString stringWithFormat:@"%@",self.sku],
                                [NSString stringWithFormat:@"%@",self.flag]];
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            
            
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)Search:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_SEARCH_PRODUCT];
        
        NSString *postString;
        NSDictionary *parameters=[[NSDictionary alloc]init];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
            postString= [NSString stringWithFormat:@"userid=%@",
                         [NSString stringWithFormat:@"%@",self.userid]
                         ];
        }
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        if(postString.length>0)
            [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)myCartList:(user_completion_block)completion{
    @try {
        NSString *url_String = API_MY_CART;
        NSDictionary *parameters=[[NSDictionary alloc]init];
        NSString *postString;
        if(GETBOOL(@"isUserHasLogin")==true){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
                postString = [NSString stringWithFormat:@"userid=%@",
                              [NSString stringWithFormat:@"%@",self.userid]];
            }
        }
        
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        if(postString.length>0)
            [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)FAQ:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_FAQ];
        NSDictionary *parameetrs =[[NSDictionary alloc] initWithObjects:@[self.cms] forKeys:@[@"cms"]];
        [APICall callPostWebService:url_String andDictionary:parameetrs completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)MyProfile:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_MY_PROFILE];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        NSDictionary *parameters=[[NSDictionary alloc]init];
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)profileEdit:(user_completion_block)completion{
    @try{
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters = @{@"email":self.Email,@"fname": self.firstname,@"lname":self.lastname, @"password":self.password,@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_MY_PROFILE_EDIT];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)removeWhishListAction:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_MY_REMOVE_WISHLIST];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        NSDictionary *parameters=[[NSDictionary alloc]init];
        NSString *strProductId = [NSString stringWithFormat:@"%@",self.prodid];
        NSString *strUserId =[NSString stringWithFormat:@"%@",self.userid];
        parameters = @{@"userid":strUserId,@"prodid":strProductId};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)AddwishListAction:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_MY_WISHLIST];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        NSDictionary *parameters=[[NSDictionary alloc]init];
        NSString *strProductId = [NSString stringWithFormat:@"%@",self.prodid];
        NSString *strUserId =[NSString stringWithFormat:@"%@",self.userid];
        parameters = @{@"userid":strUserId,@"prodid":strProductId};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)ViewWishList:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_MY_WISHLIST];
        
        NSDictionary *parameters;
        NSString *postString;
        if(GETBOOL(@"isUserHasLogin")==true){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
            }
            
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
            postString = [NSString stringWithFormat:@"userid=%@",
                          [NSString stringWithFormat:@"%@",self.userid]];
        }
        
        
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        if(postString.length>0)
            [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0)
            {
                
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else
                    completion(bodyDict,@"unsuccess",0);
                
            }
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)coupons:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_MY_COUPON];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        parameters = @{@"coupon_code":self.coupon_code,@"flag":self.flag,@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)dashboard:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_DASHBOARD];
        [APICall callPostWebService:url_String andDictionary:nil completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)dashboardList:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_DASHBOARD];
        NSDictionary *parameters;
        NSString *postString;
        if(GETBOOL(@"isUserHasLogin")==true){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
            }
            
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
            postString = [NSString stringWithFormat:@"userid=%@&pageno=%@",
                          [NSString stringWithFormat:@"%@",self.userid],
                          [NSString stringWithFormat:@"%@",self.pageNo]];
        }
        else{
            parameters = @{@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
            postString = [NSString stringWithFormat:@"pageno=%@",
                          [NSString stringWithFormat:@"%@",self.pageNo]];
        }
        
        
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            
            if(bodyDict.count>0)
            {
                
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)topProductList:(user_completion_block)completion{
    @try {
        Globals *objGlobal = [Globals sharedManager];
        NSString *url_String = [NSString stringWithFormat:@"%@", API_TOP_PRODUCTS];
        if(objGlobal.cat_id_TopBarSubCategory.length==0)
            objGlobal.cat_id_TopBarSubCategory = [[NSString stringWithFormat:@"%d",35] mutableCopy];
        NSDictionary *parameters;
        NSString *postString;
        if(GETBOOL(@"isUserHasLogin")==true){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid], @"cat_id":objGlobal.cat_id_TopBarSubCategory};
                
                postString = [NSString stringWithFormat:@"cat_id=%@&userid=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],[NSString stringWithFormat:@"%@",self.userid]];
            }
        }
        else if(GETBOOL(@"isUserHasLogin")==false){
            postString = [NSString stringWithFormat:@"cat_id=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory]];
            
            parameters  = @{@"cat_id":objGlobal.cat_id_TopBarSubCategory};
        }
        
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)brandAssignedProductList:(user_completion_block)completion{
    @try {
        Globals *objGlobal = [Globals sharedManager];
        NSDictionary *parameters;
        NSString *postString;
        NSString *url_String = [NSString stringWithFormat:@"%@",API_BRAND_ASSIGNED_PRODUCT_LIST];
        
        if(GETBOOL(@"isUserHasLogin")==true){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid], @"catid":objGlobal.cat_id_TopBarSubCategory,@"brandid":objGlobal.cat_id_PopularBrandSubCategory};
                
                
                postString = [NSString stringWithFormat:@"userid=%@&catid=%@&brandid=%@",[NSString stringWithFormat:@"%@",self.userid],
                              [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],
                              [NSString stringWithFormat:@"%@",objGlobal.cat_id_PopularBrandSubCategory]];
            }
            
        }else{
            
            parameters = @{@"catid":objGlobal.cat_id_TopBarSubCategory,@"brandid":objGlobal.cat_id_PopularBrandSubCategory};
            
            postString = [NSString stringWithFormat:@"catid=%@&brandid=%@",
                          [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],
                          [NSString stringWithFormat:@"%@",objGlobal.cat_id_PopularBrandSubCategory]];
        }
        
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                    
                }
            }
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)brandList:(user_completion_block)completion{
    @try {
        Globals *objGlobal = [Globals sharedManager];
        NSDictionary *parameters;
        NSString *postString;
        
        NSString *url_String = [NSString stringWithFormat:@"%@", API_BRAND_LIST];
        parameters = @{@"catid":objGlobal.cat_id_TopBarSubCategory};
        
        postString = [NSString stringWithFormat:@"catid=%@",
                      [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory]];
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        [manager setPostString:postString];
        
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                    
                }
            }
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)topBarProductList:(user_completion_block)completion{
    @try {
        Globals *objGlobal = [Globals sharedManager];
        NSString *url_String = [NSString stringWithFormat:@"%@", API_SUB_CATEGORY_PRODUCT];
        
        NSDictionary *parameters = @{@"cat_id":[NSString stringWithFormat:@"%@",objGlobal.cat_id_LeftSideDashBoard]};
        NSString *postString;
        
        if(objGlobal.cat_id_TopBarSubCategory.length>0)
        {
            parameters = @{@"cat_id":[NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory]};
            postString = [NSString stringWithFormat:@"cat_id=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory]];
        }
        else  if(objGlobal.cat_id_LeftSideDashBoard.length==0){
            objGlobal.cat_id_LeftSideDashBoard = [[NSString stringWithFormat:@"%d",2] mutableCopy];
            parameters = @{@"cat_id":@"2"};
            postString = [NSString stringWithFormat:@"cat_id=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_LeftSideDashBoard]];
            
        }
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)CategoryAssignProductList:(user_completion_block)completion{
    @try {
        Globals *objGlobal = [Globals sharedManager];
        NSString *url_String = [NSString stringWithFormat:@"%@",API_CATEGORY_PRODUCT_LIST];
        
        NSDictionary *parameters;
        NSString *postString;
        if(GETBOOL(@"isUserHasLogin")==true){
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                
                
                if(objGlobal.cat_id_TopBarSubCategory.length==0){
                    objGlobal.cat_id_TopBarSubCategory = [[NSString stringWithFormat:@"%d",2] mutableCopy];
                    parameters = @{@"catid":@"2",@"userid":[NSString stringWithFormat:@"%@",self.userid],@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
                    
                    postString = [NSString stringWithFormat:@"catid=%@&userid=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],
                                  [NSString stringWithFormat:@"%@",self.userid]];
                }
                else if(objGlobal.cat_id_TopBarSubCategory.length>0)
                {
                    parameters = @{@"catid":[NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],@"userid":[NSString stringWithFormat:@"%@",self.userid],@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
                    
                    postString = [NSString stringWithFormat:@"catid=%@&userid=%@&pageno=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],
                                  [NSString stringWithFormat:@"%@",self.userid],
                                  [NSString stringWithFormat:@"%@",self.pageNo]];
                }
            }
            
        }else  if(GETBOOL(@"isUserHasLogin")==false){
            if(objGlobal.cat_id_TopBarSubCategory.length==0){
                objGlobal.cat_id_TopBarSubCategory = [[NSString stringWithFormat:@"%d",2] mutableCopy];
                parameters = @{@"catid":@"2",@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
                
                postString = [NSString stringWithFormat:@"catid=%@&pageno=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],
                              [NSString stringWithFormat:@"%@",self.pageNo]];
            }
            else if(objGlobal.cat_id_TopBarSubCategory.length>0)
            {
                parameters = @{@"catid":[NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
                postString = [NSString stringWithFormat:@"catid=%@&pageno=%@", [NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],
                              [NSString stringWithFormat:@"%@",self.pageNo]];
            }
            parameters= @{@"catid":[NSString stringWithFormat:@"%@",objGlobal.cat_id_TopBarSubCategory],@"pageno":[NSString stringWithFormat:@"%@",self.pageNo]};
            
        }
        
        HTTPManager *manager = [HTTPManager managerWithURL:url_String];
        _completionBlock = completion;
        
        [manager setPostString:postString];
        [manager startDownloadOnSuccess:^(NSHTTPURLResponse *response, NSMutableDictionary *bodyDict) {
            
            if(bodyDict.count>0){
                if ([[bodyDict valueForKey:@"status"]integerValue] == jSuccess) {
                    
                    if(completion)
                    {
                        
                        if([[bodyDict valueForKey:@"status"]integerValue]==1)
                        {
                            completion(bodyDict,@"Update Profile success",1);
                        }
                        else{
                            completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                        }
                    }
                }
                else{
                    completion(bodyDict,@"There was some error in updating your profile. Try again",-1);
                }
            }
            
        } failure:^(NSHTTPURLResponse *response, NSString *bodyString, NSError *error) {
            
        } didSendData:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
            
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)checkoutAddress:(user_completion_block)completion{
    @try{
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]] mutableCopy];
        }
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:self.dictAddress options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        if([self.addressid isEqualToString:@"(null)"]){
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"new_address":jsonString};
        }
        else{
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"addressid":[NSString stringWithFormat:@"%@",self.addressid]};
        }
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CHECKOUT_ADDRESS];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)checkoutAddressWithAdd_id:(user_completion_block)completion{
    @try{
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"addressid":[NSString stringWithFormat:@"%@",self.addressid]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CHECKOUT_ADDRESS];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)stateList:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_STATE];
        [APICall callPostWebService:url_String andDictionary:nil completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"There was some error. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==0)
                    {
                        completion(user,@"Check your email id for further instructions",0);
                    }
                    else{
                        completion(user,@"This email id is not registered with us",1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)addressList:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_ADDRESS_LIST];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)AddressDelete:(user_completion_block)completion{
    @try{
        //        if([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"] ){
        //
        //            self.userid=[[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]] mutableCopy];
        //        }
        //
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"addressid":[NSString stringWithFormat:@"%@",self.addressid]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_DELETE_ADDRESS];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)deliveryPreference:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CHECKOUT_DELIVERY_STEP];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"shipping_delivery_date":self.select_date,@"shipping_delivery_time":self.select_time,@"replacement_of_product":self.strAuthorise,@"call_me":self.strCall,@"text_me":self.strText,@"inform_order_status":self.strReceive};
        NSLog(@"%@",parameters);
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
-(void)customerAddressupdate:(user_completion_block)completion{
    @try{
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"address_id":[NSString stringWithFormat:@"%@",self.addressid],@"firstname": self.firstname,@"lastname":self.lastname, @"streetline1":self.streetAdd,@"streetline2":self.Apt,@"city":self.city,@"region":self.state,@"region_id":[NSString stringWithFormat:@"%@",self.region_id],@"postcode":[NSString stringWithFormat:@"%@",self.zipCode],@"telephone":[NSString stringWithFormat:@"%@",self.phone],@"mobile":[NSString stringWithFormat:@"%@",self.mobile]};
        
        NSString *url_String = [NSString stringWithFormat:@"%@", API_ADDRESS_UPDATE];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)addressCreate:(user_completion_block)completion{
    @try{
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"firstname": self.firstname,@"lastname":self.lastname, @"streetline1":self.streetAdd,@"streetline2":self.Apt,@"city":self.city,@"region":self.state,@"region_id":[NSString stringWithFormat:@"%@",self.region_id],@"postcode":[NSString stringWithFormat:@"%@",self.zipCode],@"telephone":[NSString stringWithFormat:@"%@",self.phone],@"mobile":[NSString stringWithFormat:@"%@",self.mobile]};
        
        
        
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CREATE_ADDRESS];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)cardList:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CARD_STORED_LIST];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)cardDataDelete:(user_completion_block)completion{
    @try{
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"cardid":[NSString stringWithFormat:@"%@",self.cardid],@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_CARD_LIST_DELETE];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)paymentProcessing:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_PAYMENT];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        if ([self.cardid isEqualToString:@""]) {
            parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],
                           @"cctype":[NSString stringWithFormat:@"%@",self.cardType],
                           @"ccno":[NSString stringWithFormat:@"%@",self.cardNumber],
                           @"ccexpmonth":[NSString stringWithFormat:@"%@",self.expiryMonth],
                           @"ccexpyear":[NSString stringWithFormat:@"%@",self.expiryYear],
                           @"ccowner":[NSString stringWithFormat:@"%@",self.cardOwnerName],
                           @"cc_cvv":[NSString stringWithFormat:@"%@",self.cvv],
                           @"store_card_flag":[NSString stringWithFormat:@"%@",self.storeCard]};
        }
        else{
            parameters =@{@"userid":[NSString stringWithFormat:@"%@",self.userid],
                          @"credit_card_id":[NSString stringWithFormat:@"%@",self.cardid],
                          @"cc_cvv":[NSString stringWithFormat:@"%@",self.cvv]};
        }
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)reOrder:(user_completion_block)completion{
    @try{
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%ld",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"orderid":[NSString stringWithFormat:@"%@",self.entity_id],@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_REODER];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)checkoutDeliveryDate:(user_completion_block)completion{
    @try{
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"zipcode":[NSString stringWithFormat:@"%@",self.zipCode]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_DATE];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


-(void)checkoutDeliveryTime:(user_completion_block)completion{
    @try{
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"zipcode":[NSString stringWithFormat:@"%@",self.zipCode], @"date":[NSString stringWithFormat:@"%@",self.checkOutSelectedDate]};
        NSString *url_String = [NSString stringWithFormat:@"%@", API_TIME];
        
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(user,@"OOPS Seems like something is wrong with server",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"User account registered successfully ",1);
                    }
                    else if([[user valueForKey:@"status"]integerValue]==0){
                        completion(user,@"Email id is already registered ",0);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)referPoints:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_REFER_POINTS];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid]};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)referral:(user_completion_block)completion{
    @try {
        NSString *url_String = [NSString stringWithFormat:@"%@", API_REFERRAL];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            self.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        }
        
        NSDictionary *parameters=[[NSDictionary alloc]init];
        
        parameters = @{@"userid":[NSString stringWithFormat:@"%@",self.userid],@"email":self.Email,@"message":[NSString stringWithFormat:@"%@",self.msg]};
        [APICall callPostWebService:url_String andDictionary:parameters completion:^(NSDictionary* user, NSError*error, long code){
            if(error)
            {
                if(completion)
                {
                    completion(nil,@"There was some error in updating your profile. Try again",-1);
                }
            }
            else{
                if(completion)
                {
                    if([[user valueForKey:@"status"]integerValue]==1)
                    {
                        completion(user,@"Update Profile success",1);
                    }
                    else{
                        completion(user,@"There was some error in updating your profile. Try again",-1);
                    }
                }
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


@end
