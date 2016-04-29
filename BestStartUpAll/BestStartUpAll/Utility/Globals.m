//
//  Globals.m
//  Rover
//
//  Created by Aadil Keshwani on 3/17/15.
//  Copyright (c) 2015 Aadil Keshwani. All rights reserved.
//

#import "Globals.h"
#import "CommonPopUpView.h"


@implementation Globals
@synthesize user;
+ (id)sharedManager {
    static Globals *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        self.user=[[Users alloc]init];
        self.aryDashboardGlobal = [[NSMutableArray alloc] init];
        self.aryKartDataGlobal = [[NSMutableArray alloc] init];
        self.cat_id_PopularBrandSubCategory = [[NSMutableString alloc]init];
        self.totalPageDashBoard = [[NSMutableString alloc]init];
        self.cat_id_LeftSideDashBoard = [[NSMutableString alloc]init];
        self.cat_id_TopBarSubCategory = [[NSMutableString alloc]init];
        self.aryLeftSideMenuDetail = [[NSMutableArray alloc] init];
        self.lblSubCategoryName = [[NSString alloc] init];
        self.rightSideDetectForLogOutPress = [[NSMutableString alloc] init];
        self.numberOfCartItems = [[NSMutableString alloc] init];
        self.aryGlobalSearchProduct = [[NSMutableArray alloc] init];
        self.pointsTotal = [[NSMutableString alloc] init];
        self.arrPaypalData = [[NSMutableArray alloc] init];
        self.dictLastKartProduct = [[NSDictionary alloc] init];
        self.strEmailId = [[NSMutableString alloc]init];
        self.aryFavoriteListGlobal = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)setNavigationTitleAndBGImageName:(NSString *)strImageName navigationController:(UINavigationController *)navigationController
{
    navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:strImageName] forBarMetrics:UIBarMetricsDefault];
    
}
- (BOOL) isNull:(NSObject*) object {
    if (!object)
        return YES;
    else if (object == [NSNull null])
        return YES;
    else if ([object isKindOfClass: [NSString class]]) {
        return ([((NSString*)object) isEqualToString:@""]
                || [((NSString*)object) isEqualToString:@"null"]
                || [((NSString*)object) isEqualToString:@"nil"]
                || [((NSString*)object) isEqualToString:@"(null)"]
                || [((NSString*)object) isEqualToString:@"<null>"]);
    }
    return NO;
}


-(void)makeTextFieldBorderRed:(UITextField*)textFieldForRedBorder
{
    textFieldForRedBorder.layer.cornerRadius=8.0f;
    textFieldForRedBorder.layer.masksToBounds=YES;
    textFieldForRedBorder.layer.borderColor=[[UIColor redColor]CGColor];
    textFieldForRedBorder.layer.borderWidth= 1.0f;
}

-(void)makeTextFieldNormal:(UITextField*)textFieldForNormal
{
    textFieldForNormal.layer.cornerRadius=1.0f;
    textFieldForNormal.layer.masksToBounds=YES;
    textFieldForNormal.layer.borderColor=[[UIColor clearColor]CGColor];
    textFieldForNormal.layer.borderWidth= 1.0f;
}

- (BOOL) isNotNull:(NSObject*) object {
    return ![self isNull:object];
}
-(void)setTitleForBadgeCountOnViewAppears:(UIButton *)btnBadgeCount
{
    self.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.aryKartDataGlobal count]] mutableCopy];
    [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",self.numberOfCartItems] forState:UIControlStateNormal];
    self.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)self.aryKartDataGlobal.count] mutableCopy];
    int totalNumberOfProducts = [self.numberOfCartItems intValue];
    
    [btnBadgeCount setTitle:self.numberOfCartItems forState:UIControlStateNormal];
    
    if(totalNumberOfProducts<=0)
        btnBadgeCount.hidden=true;
    else
        btnBadgeCount.hidden=false;
}

-(void)setTitleForBadgeCount:(UIButton *)btnBadgeCount dictKartDetail:(NSDictionary*)dictKartDetail
{
    
    if([[dictKartDetail allKeys] containsObject:@"cartitems"] && [self isNotNull:[dictKartDetail valueForKey:@"cartitems"]])
        self.aryKartDataGlobal=[NSMutableArray arrayWithArray:[dictKartDetail valueForKey:@"cartitems"]];
    else
        self.aryKartDataGlobal = [[NSMutableArray alloc] init];
    
    self.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[self.aryKartDataGlobal count]] mutableCopy];
    if([self isNotNull:btnBadgeCount]){
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",self.numberOfCartItems] forState:UIControlStateNormal];
        
        int totalNumberOfProducts = [self.numberOfCartItems intValue];
        
        [btnBadgeCount setTitle:self.numberOfCartItems forState:UIControlStateNormal];
        
        if(totalNumberOfProducts<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
    }
}
-(NSMutableString*)checkForFlagEditOrUpdate:(NSArray*)aryKartitems dictForItemToCheck:(NSDictionary*)dictForItemToCheck{
    __block NSMutableString *strFlag;
    
    [aryKartitems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dictKartCheckingPorduct = [aryKartitems objectAtIndex:idx];
        NSString *strProductId;
        NSString *strCompareProductId;
        
        if([[dictKartCheckingPorduct allKeys] containsObject:@"prod_id"] && [self isNotNull:[dictKartCheckingPorduct valueForKey:@"prod_id"]])
            strProductId = [dictKartCheckingPorduct valueForKey:@"prod_id"];
        else
            strProductId = [dictKartCheckingPorduct valueForKey:@"id"];
        
        if([[dictForItemToCheck allKeys] containsObject:@"prod_id"] && [self isNotNull:[dictForItemToCheck valueForKey:@"prod_id"]])
            strCompareProductId = [dictForItemToCheck valueForKey:@"prod_id"];
        else
            strCompareProductId = [dictForItemToCheck valueForKey:@"id"];
        
        if([strProductId isEqualToString:strCompareProductId])
            strFlag=[@"update" mutableCopy];
        
    }];
    
    
    if(strFlag.length==0)
        strFlag=[@"add" mutableCopy];
    
    return strFlag;
}

-(BOOL)isProductGotMatchToFavouriteProductList:(NSDictionary*)dictFavouriteProduct aryTotalProduct:(NSArray*)aryTotalProduct
{
    
    NSMutableArray *aryTotalProductList = [[NSMutableArray alloc] initWithArray:aryTotalProduct];
    NSDictionary *dictFavouriteCheckingPorduct = dictFavouriteProduct;
    __block BOOL isProdcutMatchedWithFavouriteProduct=false;
    
    if(dictFavouriteCheckingPorduct.count>0){
        [aryTotalProductList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block NSString *strProductId;
            __block NSString *strCompareProductId;
            
            if([[obj allKeys] containsObject:@"prod_id"])
                strProductId = [obj valueForKey:@"prod_id"];
            else
                strProductId = [obj valueForKey:@"id"];
            
            if([[dictFavouriteCheckingPorduct allKeys] containsObject:@"prod_id"])
                strCompareProductId = [dictFavouriteCheckingPorduct valueForKey:@"prod_id"];
            else
                strCompareProductId = [dictFavouriteCheckingPorduct valueForKey:@"id"];
            
            if([strCompareProductId isEqualToString:strProductId]){
                isProdcutMatchedWithFavouriteProduct=true;
                *stop = YES;    // Stop enumerating
                return;
            }
        }];
    }
    
    return isProdcutMatchedWithFavouriteProduct;
}

-(NSArray*)compareForKartProductAndTotalProductForSubCategory:(NSDictionary*)dictKartProduct aryTotalProduct:(NSArray*)aryTotalProduct
{
    
    NSMutableArray *aryTotalProductList = [[NSMutableArray alloc] initWithArray:aryTotalProduct];
    NSDictionary *dictKartCheckingPorduct = dictKartProduct;
    if(dictKartCheckingPorduct.count>0){
        __block BOOL isProdcutMatchedWithKartProduct=false;
        [aryTotalProductList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            __block NSString *strProductId;
            __block NSString *strCompareProductId;
            
            if([[obj allKeys] containsObject:@"prod_id"])
                strProductId = [obj valueForKey:@"prod_id"];
            else
                strProductId = [obj valueForKey:@"id"];
            
            if([[dictKartCheckingPorduct allKeys] containsObject:@"prod_id"])
                strCompareProductId = [dictKartCheckingPorduct valueForKey:@"prod_id"];
            else
                strCompareProductId = [dictKartCheckingPorduct valueForKey:@"id"];
            
            if([strCompareProductId isEqualToString:strProductId]){
                isProdcutMatchedWithKartProduct=true;
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:dictKartCheckingPorduct];
                if([[dict allKeys] containsObject:@"prod_id"])
                    [dict setObject:[NSString stringWithFormat:@"%@",strCompareProductId] forKey:@"prod_id"];
                else
                    [dict setObject:[NSString stringWithFormat:@"%@",strCompareProductId] forKey:@"id"];
                [aryTotalProductList replaceObjectAtIndex:idx withObject:dict];
            }
            if( isProdcutMatchedWithKartProduct ){
                isProdcutMatchedWithKartProduct=false;
                
                *stop = YES;    // Stop enumerating
                return;
            }

        }];
    }
    
    return [aryTotalProductList mutableCopy];
}

-(NSArray*)compareForKartProductAndTotalProduct:(NSDictionary*)dictKartProduct aryTotalProduct:(NSArray*)aryTotalProduct
{
    NSMutableArray *aryTotalProductList = [[NSMutableArray alloc] initWithArray:aryTotalProduct];
    NSDictionary *dictKartCheckingPorduct = dictKartProduct;
    if(dictKartCheckingPorduct.count>0){
        __block BOOL isProdcutMatchedWithKartProduct=false;
        [aryTotalProductList enumerateObjectsUsingBlock:^(id  _Nonnull object, NSUInteger index, BOOL * _Nonnull stop) {
            
            __block NSString *strProductId;
            __block NSString *strCompareProductId;
            
            NSMutableArray *arrSubProducts =[[NSMutableArray alloc] initWithArray:[object valueForKey:@"prod"]];
            NSMutableDictionary *dicCategory = [[NSMutableDictionary alloc] init];
            
            [arrSubProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                if([[obj allKeys] containsObject:@"prod_id"])
                    strProductId = [obj valueForKey:@"prod_id"];
                else
                    strProductId = [obj valueForKey:@"id"];
                
                if([[dictKartCheckingPorduct allKeys] containsObject:@"prod_id"])
                    strCompareProductId = [dictKartCheckingPorduct valueForKey:@"prod_id"];
                else
                    strCompareProductId = [dictKartCheckingPorduct valueForKey:@"id"];
                
                if([strCompareProductId isEqualToString:strProductId]){
                    isProdcutMatchedWithKartProduct=true;
                    [arrSubProducts replaceObjectAtIndex:idx withObject:dictKartCheckingPorduct];
                }
                
                
                if( isProdcutMatchedWithKartProduct ){
                    
                    isProdcutMatchedWithKartProduct=false;
                    [dicCategory setValue:arrSubProducts forKey:@"prod"];
                    [dicCategory setValue:[object valueForKey:@"category_id"] forKey:@"category_id"];
                    [dicCategory setValue:[object valueForKey:@"category"] forKey:@"category"];
                    
                    [aryTotalProductList replaceObjectAtIndex:index withObject:dicCategory];
                    *stop = YES;    // Stop enumerating
                    return;
                }
            }];
            
            
        }];
    }
    
    return [aryTotalProductList mutableCopy];
}


-(void)setTitleBadgeCountFromLocalDB:(UIButton *)btnBadgeCount aryKartDetail:(NSMutableArray*)aryKartDetail{
    
    self.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[aryKartDetail count]] mutableCopy];
    if([self isNotNull:btnBadgeCount]){
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",self.numberOfCartItems] forState:UIControlStateNormal];
        
        int totalNumberOfProducts = [self.numberOfCartItems intValue];
        
        [btnBadgeCount setTitle:self.numberOfCartItems forState:UIControlStateNormal];
        
        if(totalNumberOfProducts<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
    }
}
-(NSArray*)sortArrayUsingKey:(NSArray*)aryToSort strKey:(NSString*)strKey;
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:strKey
                                        ascending:YES
                                        selector:@selector(compare:)];
    
    //IF WANT TO SORT WITH OTHER KEYS Peter
    //                    NSSortDescriptor *modelDescriptor = [NSSortDescriptor
    //                                                         sortDescriptorWithKey:@"model"
    //                                                         ascending:YES
    //                                                         selector:@selector(caseInsensitiveCompare:)];
    aryToSort=[aryToSort sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor,nil]];
    
    return aryToSort;
}

#pragma textFieldDelegate
-(void)setTextFieldWithSpace:(UITextField*)txtField
{
        txtField.leftViewMode = UITextFieldViewModeAlways;
    
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,15, txtField.frame.size.height)];
        txtField.leftView = paddingView;
    
}

-(NSString*)maxDigitsInString:(NSString *)str
{
    NSString *lastFourChar = [str substringToIndex:5];
    return lastFourChar;
    
}
@end
