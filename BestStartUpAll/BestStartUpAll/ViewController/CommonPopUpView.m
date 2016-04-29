//
//  CommonPopUpView.m
//  AcademicPulse
//
//  Created by dhara on 11/7/15.
//  Copyright © 2015 com.USBASE. All rights reserved.
//

#import "CommonPopUpView.h"
#import "Globals.h"
#import "CommonPopUpView.h"
#import "UIView+Toast.h"
#import "PopUpTableViewController.h"
#import "AppDelegate.h"
#import "FMDBDataAccess.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "SubCategoriesViewController.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "DashboardViewController.h"
#import "SubCategoriesViewController.h"
#import "SearchViewController.h"
#import "ShoppingListViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#define pageWidth           280

@implementation CommonPopUpView
{
    Globals *OBJGlobal;
    NSString *strlblPrice;
    FMDBDataAccess *dataBaseHelper;
    UIButton *btnBadgeCount;
    BOOL isProductInFavouriteList;
    NSMutableArray *aryImages;
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@synthesize numberOfProducts,lblDiscountPrice;
+ (CommonPopUpView*) CommonPopUpView
{
    NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"CommonPopUpView" owner:nil options:nil];
    
    return [array objectAtIndex:0];
}
-(void)initGlobalSharedObject
{
    if(!OBJGlobal)
        OBJGlobal = [Globals sharedManager];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    @try{
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnViewImagePressed:(id)sender
{
    //    [self.viewImage setHidden:NO];
}


-(void)initDataForPopUp
{
    @try{
        lblDiscountPrice.hidden=true;
        isProductInFavouriteList=false;
        _btnTitleName.userInteractionEnabled=false;
        _btnTitleName.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _btnTitleName.titleLabel.numberOfLines = 0;
        _lblTitleName.lineBreakMode=NSLineBreakByWordWrapping;
        _lblTitleName.numberOfLines = 0;
        [_btnTitleName setTitle:[self.dicProductDetailValue valueForKey:@"name"] forState:UIControlStateNormal];
        _lblTitleName.hidden=true;
        self.lblDescription.hidden=NO;
        if(self.dicProductDetailValue.count>0){
            if(!OBJGlobal)
                OBJGlobal = [Globals sharedManager];
            [self setProductDetailValue];
            
            
            self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
            
            self.txtViewPopUpItemDescription.editable=false;
            
            [self.viewImage setHidden:YES];
            
            dataBaseHelper = [[FMDBDataAccess alloc]init];
            
            [_txtViewPopUpItemDescription setFont:[UIFont systemFontOfSize:12]];
            
            
            NSString *strQty;
            if([[self.dicProductDetailValue allKeys]containsObject:@"qty"])
                strQty = [self.dicProductDetailValue valueForKey:@"qty"];
            else
                strQty = [self.dicProductDetailValue valueForKey:@"prod_in_cart"];
            
            int productCount = [strQty intValue];
            
            numberOfProducts =productCount;
            if(numberOfProducts==0)
                numberOfProducts=1;
            self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
            
            strlblPrice=[NSString stringWithFormat:@"%@",self.lblPrice.text];
            
            strlblPrice = [_dicProductDetailValue valueForKey:@"price"];
            
            float priceLbl = [strlblPrice floatValue];
            
            float price = [[NSString stringWithFormat:@"%.2f", priceLbl] floatValue];
            
            NSString *strUnit;
            if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"unit"]] && [[self.dicProductDetailValue allKeys] containsObject:@"unit"])
                strUnit = [self.dicProductDetailValue valueForKey:@"unit"];
            else if ([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"weight"]] && [[self.dicProductDetailValue allKeys] containsObject:@"weight"])
                strUnit = [self.dicProductDetailValue valueForKey:@"weight"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"1 lbs"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"per 1 lbs"];
            
            self.lblPrice.text = [NSString stringWithFormat:@"$%.2f", price];
            self.lblWeight.text =  [NSString stringWithFormat:@"%@",strUnit];
            
            self.lblPrice.textColor=[UIColor orangeColor];
            
            NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"discount_price"]];
            
            if([[self.dicProductDetailValue allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
            {
                //Discount Price
                lblDiscountPrice.hidden=false;
                lblDiscountPrice.textColor=[UIColor orangeColor];
                lblDiscountPrice.font = [UIFont fontWithName:@"Avenir-Black" size:15];
                lblDiscountPrice.textAlignment=NSTextAlignmentCenter;
                
                lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f", [strDiscountPrice floatValue]];
                
                NSString *strUnit;
                if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"unit"]] && [[self.dicProductDetailValue allKeys] containsObject:@"unit"])
                    strUnit = [self.dicProductDetailValue valueForKey:@"unit"];
                else if ([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"weight"]] && [[self.dicProductDetailValue allKeys] containsObject:@"weight"])
                    strUnit = [self.dicProductDetailValue valueForKey:@"weight"];
                if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                    strUnit = [NSString stringWithFormat:@"1 lbs"];
                if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"] || [strUnit isEqualToString:@"1 lbs"])
                    strUnit = [NSString stringWithFormat:@"per 1 lbs"];
                self.lblWeight.text =  [NSString stringWithFormat:@"%@",strUnit];
                self.lblPrice.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
                self.lblPrice.textColor=[UIColor grayColor];
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f",price]];
                [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                        value:[NSNumber numberWithInt:1]
                                        range:(NSRange){0,[attributeString length]}];
                
                [self.lblPrice setAttributedText:attributeString];
            }
            
            
        }
        
        
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
        
        NSArray *aryFavouriteList = [OBJGlobal aryFavoriteListGlobal];
        if([OBJGlobal isProductGotMatchToFavouriteProductList:self.dicProductDetailValue aryTotalProduct:aryFavouriteList])
        {
            isProductInFavouriteList=true;
            [self.btnFavourite setImage:[UIImage imageNamed:@"fav_Orange"] forState:UIControlStateNormal];
        }
        else{
            isProductInFavouriteList=false;
            [self.btnFavourite setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)setProductDetailValue
{
    @try{
        NSString *str;
        if([[self.dicProductDetailValue allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"image_url"]])
            str = [self.dicProductDetailValue valueForKey:@"image_url"];
        else
            str = [self.dicProductDetailValue valueForKey:@"imageurl"];
        
        
        
        aryImages =  [NSMutableArray arrayWithArray:[self.dicProductDetailValue valueForKey:@"multiple_images"]];
        self.scrView.pagingEnabled=YES;
        self.scrView.showsHorizontalScrollIndicator=NO;
        self.scrView.delegate = self;
        
        __block UIImageView *page=nil;
        __block UIButton *btnForImagePop=nil;
        
        NSArray *subviews = [[NSArray alloc] initWithArray:self.scrView.subviews];
        
        [subviews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
            
        }];
        [aryImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *strImageUrl = [obj valueForKey:@"multiple"];
            if(idx==0){
                page=[[UIImageView alloc] initWithFrame:CGRectMake(self.scrView.frame.size.width/2-80, 0,160, 160)];
            }
            else if (idx==1)
            {
                page=[[UIImageView alloc] initWithFrame:CGRectMake(self.scrView.frame.size.width+(self.scrView.frame.size.width/2-(idx*80)), 0, 160,160)];
                
            }
            else{
                page=[[UIImageView alloc] initWithFrame:CGRectMake((idx*self.scrView.frame.size.width)+(self.scrView.frame.size.width/2-(idx*80)), 0, 160,160)];
                
            }
            btnForImagePop = [[UIButton alloc] initWithFrame:page.frame];
            btnForImagePop.tag=idx+23456;
            [page setContentMode:UIViewContentModeScaleAspectFit];
            [page setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            page.tag=44567+idx;
            [btnForImagePop addTarget:self action:@selector(btnImagePopPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrView addSubview:page];
            [self.scrView addSubview:btnForImagePop];
            
        }];
        if(aryImages.count==1 || aryImages.count==0)
            self.pageControl.hidden=true;
        else
            self.pageControl.hidden=false;
        
        if(page==nil)
        {
            page=[[UIImageView alloc] initWithFrame:CGRectMake(self.scrView.frame.size.width/2-80, 0,160, 160)];
            
            btnForImagePop = [[UIButton alloc] initWithFrame:page.frame];
            btnForImagePop.tag=23456;
            [page setContentMode:UIViewContentModeScaleAspectFit];
            if(str.length>0)
                [page setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            page.tag=44567;
            [btnForImagePop addTarget:self action:@selector(btnImagePopPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.scrView addSubview:page];
            [self.scrView addSubview:btnForImagePop];
        }
        [self.pageControl setNumberOfPages:aryImages.count];
        self.scrView.contentSize=CGSizeMake(self.scrView.frame.size.width*aryImages.count, self.scrView.frame.size.height);
        
        self.pageControl.backgroundColor=[UIColor clearColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slider-pager-active"]];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"slider-pager-default"]];
        
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"price"]]){
            
            NSString *strPrice;
            if([[self.dicProductDetailValue allKeys] containsObject:@"discount_price"])
                strPrice = [self.dicProductDetailValue valueForKey:@"discount_price"];
            else
                strPrice = [self.dicProductDetailValue valueForKey:@"price"];
            float price = [strPrice floatValue];
            NSString *strUnit;
            if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"unit"]] && [[self.dicProductDetailValue allKeys] containsObject:@"unit"])
                strUnit = [self.dicProductDetailValue valueForKey:@"unit"];
            else if ([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"weight"]] && [[self.dicProductDetailValue allKeys] containsObject:@"weight"])
                strUnit = [self.dicProductDetailValue valueForKey:@"weight"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"1 lbs"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"per 1 lbs"];
            
            self.lblWeight.text =  [NSString stringWithFormat:@"%@",strUnit];
            self.lblPrice.text= [NSString stringWithFormat:@"$%.2f", price];
            strlblPrice=[NSString stringWithFormat:@"%.2f",price];
            
        }
        
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"name"]]){
            NSString *strName;
            strName = [NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"name"]];
            if(strName.length>15)
                _btnTitleName.titleLabel.textAlignment=NSTextAlignmentLeft;
            else
                _btnTitleName.titleLabel.textAlignment=NSTextAlignmentCenter;
            
            [_btnTitleName setTitle:[self.dicProductDetailValue valueForKey:@"name"] forState:UIControlStateNormal];
            
        }
        
        self.lblName.lineBreakMode=NSLineBreakByWordWrapping;
        self.lblName.numberOfLines =0;
        
        NSString *strUnit;
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"unit"]] && [[self.dicProductDetailValue allKeys] containsObject:@"unit"])
            strUnit = [self.dicProductDetailValue valueForKey:@"unit"];
        else if ([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"weight"]] && [[self.dicProductDetailValue allKeys] containsObject:@"weight"])
            strUnit = [self.dicProductDetailValue valueForKey:@"weight"];
        if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
            strUnit = [NSString stringWithFormat:@"1 lbs"];
        if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
            strUnit = [NSString stringWithFormat:@"per 1 lbs"];
        
        self.lblWeight.text=strUnit;
        
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"description"]])
        {
            self.txtViewPopUpItemDescription.text=[self.dicProductDetailValue valueForKey:@"description"];
            self.lblDescription.hidden=NO;
        }
        else
        {
            self.txtViewPopUpItemDescription.text=@"";
            self.lblDescription.hidden=YES;
        }
        
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"brand"]])
            self.lblBrand.text=[self.dicProductDetailValue valueForKey:@"brand"];
        else
            self.lblBrand.text=@"";
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)pageChanged:(id)sender {
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    @try{
        NSLog(@"called");
        int contentOffset=scrollView.contentOffset.x;
        NSInteger currentPage=contentOffset/self.scrView.frame.size.width;
        self.pageControl.currentPage=currentPage;
        NSLog(@"offset x: %d",contentOffset);
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)btnCloseCommonPopUpPressed:(id)sender
{
    [self toggleHidden:YES];
}

- (IBAction)btnAddToCartPressed:(id)sender
{
    @try{
        [self toggleHidden:YES];
        OBJGlobal.isfirstTimeDashBoardDataReceived=true;
        if(GETBOOL(@"isUserHasLogin")==false){
            NSMutableDictionary *dictProductDetail = [[NSMutableDictionary alloc] initWithDictionary:self.dicProductDetailValue];
            NSString *strDescription;
            strDescription = [NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"description"]];
            if(strDescription.length>100)
                strDescription = [strDescription substringWithRange:NSMakeRange(0, 100)];
            
            [dictProductDetail setObject:strDescription forKey:@"description"];
            int product = [[NSString stringWithFormat:@"%ld",(long)numberOfProducts] intValue];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%d",product] forKey:@"qty"];
            
            NSString *strPrice;
            if([[self.dicProductDetailValue allKeys] containsObject:@"discount_price"])
                strPrice = [self.dicProductDetailValue valueForKey:@"discount_price"];
            else
                strPrice = [self.dicProductDetailValue valueForKey:@"price"];
            
            float price = [strPrice floatValue] *numberOfProducts;
            [dictProductDetail setObject:[NSString stringWithFormat:@"%.2f",price] forKey:@"totalPrice"];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%.2f",[strPrice floatValue]] forKey:@"price"];
            
            NSString *strUnit;
            if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"unit"]] && [[self.dicProductDetailValue allKeys] containsObject:@"unit"])
                strUnit = [self.dicProductDetailValue valueForKey:@"unit"];
            else if ([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"weight"]] && [[self.dicProductDetailValue allKeys] containsObject:@"weight"])
                strUnit = [self.dicProductDetailValue valueForKey:@"weight"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"1 lbs"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"per 1 lbs"];
            
            [dictProductDetail setObject:[NSString stringWithFormat:@"%@",strUnit] forKey:@"weight"];
            [self.viewImage setHidden:YES];
            [self insertProductToLocalDataBase:dictProductDetail];
        }
        if(GETBOOL(@"isUserHasLogin")==true){
            //[APPDATA showLoader];
            NSMutableDictionary *dictProductDetail = [[NSMutableDictionary alloc] initWithDictionary:self.dicProductDetailValue];
            [APPDATA showLoader];
            Users *objUsers = OBJGlobal.user;
            if ([[dictProductDetail allKeys] containsObject:@"id"])
                // contains key
                objUsers.prodid = [dictProductDetail valueForKey:@"id"];
            if([[dictProductDetail allKeys] containsObject:@"prod_id"])
                objUsers.prodid = [dictProductDetail valueForKey:@"prod_id"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"sku"]] mutableCopy];
            objUsers.qty=[[NSString stringWithFormat:@"%@",self.lblQntity.text] mutableCopy];
            if(!OBJGlobal)
                OBJGlobal = [Globals sharedManager];
            
            int product = [[NSString stringWithFormat:@"%ld",(long)numberOfProducts] intValue];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%d",product] forKey:@"prod_in_cart"];
            
            objUsers.flag =[OBJGlobal checkForFlagEditOrUpdate:OBJGlobal.aryKartDataGlobal dictForItemToCheck:dictProductDetail];
            
            
            if([dictProductDetail valueForKey:@"prod_in_cart"])
                if([[self.dicProductDetailValue allKeys] containsObject:@"prod_in_cart"])
                    [dictProductDetail setObject:[NSString stringWithFormat:@"%ld",(long)numberOfProducts] forKey:@"prod_in_cart"];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                
                [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                 {
                     if (status == 1) {
                         
                         OBJGlobal.dictLastKartProduct = dictProductDetail;
                         
                         if([objUsers.flag isEqualToString:@"update"])
                             //                             [[self parentViewController].view makeToast:@"Product updated from cart successfully"];
                             //
                             //                         else
                             //                             [[self parentViewController].view makeToast:@"Product added to cart successfully"];
                             
                             if([OBJGlobal isNotNull:[user valueForKey:@"cartitems"]]){
                                 OBJGlobal.aryKartDataGlobal=nil;
                                 OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[user valueForKey:@"cartitems"]];
                                 OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
                             }
                         
                         UIViewController *popUpParent = [self parentViewController];
                         if([popUpParent isKindOfClass:[DashboardViewController class]])
                         {
                             DashboardViewController *objDashboard = (DashboardViewController*)popUpParent;
                             
                             [objDashboard reloadCartData:user];
                             
                         }
                         else if([popUpParent isKindOfClass:[SubCategoriesViewController class]])
                         {
                             SubCategoriesViewController *objSubCategories = (SubCategoriesViewController*)popUpParent;
                             
                             [objSubCategories reloadCartData:user];
                             
                         }
                         
                         
                         [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:user];
                         
                         
                         NSLog(@"success");
                         
                         return ;
                         
                         
                     }
                     else {
                         [self btnAddToCartPressed:nil];
                         // [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)fetchLocalData{
    @try{
        OBJGlobal.aryKartDataGlobal =  [[dataBaseHelper fetchAllProductDataFromLocalDB] mutableCopy];
        OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
        UIViewController *popUpParent = [self parentViewController];
        NSMutableDictionary *dictkartProductDetail = [[NSMutableDictionary alloc] init];
        [dictkartProductDetail setObject:OBJGlobal.aryKartDataGlobal forKey:@"cartitems"];
        if([popUpParent isKindOfClass:[DashboardViewController class]])
        {
            DashboardViewController *objDashboard = (DashboardViewController*)popUpParent;
            
            
            [objDashboard reloadCartData:dictkartProductDetail];
            
        }
        else if([popUpParent isKindOfClass:[SubCategoriesViewController class]])
        {
            SubCategoriesViewController *objSubCategories = (SubCategoriesViewController*)popUpParent;
            
            [objSubCategories reloadCartData:dictkartProductDetail];
            
        }
        
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] forState:UIControlStateNormal];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        //reset clicked
        [self favouriteAction:@"remove"];
    }
}
- (IBAction)btnAddToFavouritePressed:(id)sender {
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            
            NSArray *aryFavouriteList = [OBJGlobal aryFavoriteListGlobal];
            if([OBJGlobal isProductGotMatchToFavouriteProductList:self.dicProductDetailValue aryTotalProduct:aryFavouriteList])
            {
                isProductInFavouriteList=true;
                [self.btnFavourite setImage:[UIImage imageNamed:@"fav_Orange"] forState:UIControlStateNormal];
            }
            
            if(isProductInFavouriteList)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favourite Product"
                                                                message:[NSString stringWithFormat:@"Do you really want to remove %@ from favourite list?",[self.dicProductDetailValue valueForKey:@"name"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Ok", nil];
                
                [alert show];
                return;
            }
            [self favouriteAction:@"Add"];
        }
        else
        {
            [[self parentViewController].view makeToast:@"Please login to add product in your favourite list"];
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)favouriteAction:(NSString*)strFlag
{
    Users *objProductDetail = OBJGlobal.user;
    
    if([strFlag isEqualToString:@"remove"]){
        objProductDetail.flag=[@"remove" mutableCopy];
        objProductDetail.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        NSString *strProd_id;
        if([[self.dicProductDetailValue allKeys] containsObject:@"prod_id"] && [OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"prod_id"]]){
            strProd_id  = [self.dicProductDetailValue valueForKey:@"prod_id"];
        }
        else if([[self.dicProductDetailValue allKeys] containsObject:@"id"] && [OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"id"]]){
            strProd_id  = [self.dicProductDetailValue valueForKey:@"id"];
        }
        objProductDetail.prodid = [[NSString stringWithFormat:@"%@",strProd_id] mutableCopy];
        objProductDetail.flag =[@"remove" mutableCopy];
        [APPDATA showLoader];
        
        [objProductDetail removeWhishListAction:^(NSDictionary *user, NSString *str, int status) {
            if (status == 1) {
                
                
                NSDictionary *dictFavouriteCheckingPorduct = self.dicProductDetailValue;
                
                [OBJGlobal.aryFavoriteListGlobal enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
                        isProductInFavouriteList=false;
                        [OBJGlobal.aryFavoriteListGlobal removeObjectAtIndex:idx];
                    }
                }];
                
                [APPDATA hideLoader];
                [self.btnFavourite setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
                
                if([objProductDetail.flag isEqualToString:@"remove"])
                    //  [[self parentViewController].view makeToast:[user valueForKey:@"message"]];
                    
                    NSLog(@"success");
                
                return ;
                
            }
            else {
                NSLog(@"Failed");
                [APPDATA hideLoader];
            }
        }];
        
        return;
    }
    [APPDATA showLoader];
    
    objProductDetail.prodid=[self.dicProductDetailValue valueForKey:@"id"];
    if([[self.dicProductDetailValue allKeys] containsObject:@"prod_id"])
        objProductDetail.prodid=[self.dicProductDetailValue valueForKey:@"prod_id"];
    if([[self.dicProductDetailValue allKeys] containsObject:@"id"])
        objProductDetail.prodid=[self.dicProductDetailValue valueForKey:@"id"];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] )
    {
        
        objProductDetail.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
    }
    
    [objProductDetail AddwishListAction:^(NSDictionary *user, NSString *str, int status) {
        if (status == 1) {
            
            [APPDATA hideLoader];
            APPDATA.user.msg=[user objectForKey:@"msg"];
            if([OBJGlobal isNotNull:[user valueForKey:@"data"]]){
                OBJGlobal.aryFavoriteListGlobal=nil;
                OBJGlobal.aryFavoriteListGlobal = [[NSMutableArray alloc] initWithArray:[user valueForKey:@"data"]];
            }
            [self.btnFavourite setImage:[UIImage imageNamed:@"fav_Orange"] forState:UIControlStateNormal];
            // [[self parentViewController].view makeToast:@"Product added successfully to your favourite list"];
            //        dicProfileEditData =[user objectForKey:@"userdetails"];
            //                [[self parentViewController].view makeToast:[NSString stringWithFormat:@"%@",APPDATA.user.msg]];
            //    [[self parentViewController].view makeToast:@"login successfully"];
            //  sleep(3);
            
            NSLog(@"success");
        }
        else {
            [[self parentViewController].view makeToast:@"Email and Password Invalid"];
            NSLog(@"Failed");
            [APPDATA hideLoader];
        }
    }];
}

-(void)btnClosePopUpPressed:(id)sender{
    [self.viewImage setHidden:YES];
}

-(void)popCurrentController
{
    
    //    [[self parentViewController].navigationController popViewControllerAnimated:true];
    
}

-(void)popImageView:(UITapGestureRecognizer*)sender
{
    
    //    [self.viewImage setHidden:NO];
    
}

-(void)btnImagePopPressed:(id)sender
{
    @try{
        [self.viewImage setHidden:NO];
        UIButton *btnOnImage = (UIButton*)sender;
        NSInteger btntag = btnOnImage.tag-23456;
        
        if(aryImages.count>0)
            [self.imgPopProduct setImageWithURL:[NSURL URLWithString:[[aryImages objectAtIndex:btntag] valueForKey:@"multiple"]] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        else{
            NSString *str;
            if([[self.dicProductDetailValue allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"image_url"]])
                str = [self.dicProductDetailValue valueForKey:@"image_url"];
            else
                str = [self.dicProductDetailValue valueForKey:@"imageurl"];
            
            [self.imgPopProduct setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
-(IBAction)btnCancelPressed:(id)sender;
{
    [self.viewImage setHidden:YES];
}
-(void)toggleHidden:(BOOL)toggle{
    int alpha = toggle?0:1;
    
    self.alpha = alpha;
}

- (IBAction)btnMinusPressed:(id)sender {
    @try{
        if(numberOfProducts<=1)
            return;
        numberOfProducts--;
        self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
        
        //        NSString *strPrice =[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"price"]];
        //        float price = [strPrice floatValue];
        //        self.lblPrice.text= [NSString stringWithFormat:@"$%.2f per %d lb", price*numberOfProducts,numberOfProducts];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnPlusPressed:(id)sender {
    @try{
        numberOfProducts++;
        self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)insertProductToLocalDataBase:(NSMutableDictionary *)dict
{
    @try{
        NSMutableDictionary *dictProductDetail = [[NSMutableDictionary alloc]initWithDictionary:dict];
        if([[dict allKeys] containsObject:@"prod_id"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"prod_id"]]){
            [dictProductDetail setObject:[dict valueForKey:@"prod_id"] forKey:@"prod_id"];
        }
        else if([[dict allKeys] containsObject:@"id"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"id"]]){
            [dictProductDetail setObject:[dict valueForKey:@"id"] forKey:@"prod_id"];
        }
        if([[dict allKeys] containsObject:@"prod_id"])
            [dictProductDetail setObject:[dict valueForKey:@"prod_id"] forKey:@"id"];
        else if([[dict allKeys] containsObject:@"id"])
            [dictProductDetail setObject:[dict valueForKey:@"id"] forKey:@"id"];
        
        if([[self.dicProductDetailValue allKeys] containsObject:@"prod_in_cart"])
            [dictProductDetail setObject:[NSString stringWithFormat:@"%ld",(long)numberOfProducts] forKey:@"prod_in_cart"];
        
        if([[self.dicProductDetailValue allKeys] containsObject:@"discount_price"]){
            NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"discount_price"]];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%.2f",[strDiscountPrice floatValue]] forKey:@"discount_price"];
        }
        NSString *str;
        if([[self.dicProductDetailValue allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"image_url"]])
            str = [self.dicProductDetailValue valueForKey:@"image_url"];
        else
            str = [self.dicProductDetailValue valueForKey:@"imageurl"];
        
        if(str.length>0)
        {
            [dictProductDetail setObject:[NSString stringWithFormat:@"%@",str] forKey:@"image_url"];
            
            [dictProductDetail setObject:[NSString stringWithFormat:@"%@",str] forKey:@"imageurl"];
        }
        
        if([dataBaseHelper insertproductdData:dictProductDetail]){
            OBJGlobal.dictLastKartProduct = dictProductDetail;
            //    [[self parentViewController].view makeToast:@"Product added to Cart"];
        }
        else
        {
            NSArray *aryqtycartItem = OBJGlobal.aryKartDataGlobal;
            [aryqtycartItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *strProductId = [obj valueForKey:@"id"];
                if([strProductId isEqualToString:[dictProductDetail valueForKey:@"id"]])
                {
                    NSString *strQty = [obj valueForKey:@"qty"];
                    int localDBProductCount = [strQty intValue];
                    localDBProductCount = numberOfProducts;
                    [dictProductDetail setObject:[NSString stringWithFormat:@"%d",localDBProductCount]  forKey:@"qty"];
                }
            }];
            
            if([dataBaseHelper updateproductdData:[dictProductDetail valueForKey:@"id"] dictData:dictProductDetail]){
                OBJGlobal.dictLastKartProduct = dictProductDetail;
                //  [[self parentViewController].view makeToast:@"Product Updated successful"];
            }
        }
        [self performSelectorOnMainThread:@selector(fetchLocalData) withObject:nil waitUntilDone:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


#pragma mark - parentViewController

- (UIViewController *)parentViewController {
    
    UIResponder *responder = self;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}

@end
