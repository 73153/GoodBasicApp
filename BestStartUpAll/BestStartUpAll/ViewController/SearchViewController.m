//
//  SearchViewController.m
//  peter
//
//  Created by Peter on 1/5/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "SearchViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "SearchTableViewCell.h"
#import "ProductDetailViewController.h"
#import "UIView+Toast.h"
#import "FMDBDataAccess.h"
//#import "ImageWithURL.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITextFieldDelegate>
{
    Globals *OBJGlobal;
    NSMutableArray *aryNumberOfItemsCount;
    UIButton *btnBadgeCount;
    FMDBDataAccess *dataBaseHelper;
    UITextField *txtSearchString;
    NSMutableArray *handleBadgeWithoutLogin;
    BOOL isProductInFavouriteList;
    BOOL isGotWebResponse;
    NSInteger indexForFavouriteRemove;
}

@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)NSArray *keys;
@property (nonatomic, strong)NSMutableArray *results;
@property (nonatomic)BOOL isSearching;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    
    @try{
        [super viewDidLoad];
        dataBaseHelper = [[FMDBDataAccess alloc]init];
        OBJGlobal = [Globals sharedManager];
        [self setUpImageBackButton:@"left-arrow"];
        [self.tableView reloadData];
        _searchBar.delegate=self;
        arrSearchProduct = [[NSArray alloc] init];
        aryNumberOfItemsCount = [[NSMutableArray alloc] init];
        self.txtSearchField.delegate=self;
        
        //TextField Spacing Code
        UIView *paddingTxtfieldView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 42)]; // what ever you want
        self.txtSearchField.leftView = paddingTxtfieldView1;
        self.txtSearchField.leftViewMode = UITextFieldViewModeAlways;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        _lblSearchResult.hidden=true;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Search";
        label.textColor = [UIColor whiteColor];
        _txtSearchField.placeholder = @"Search";
        self.navigationItem.titleView = label;
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
        isGotWebResponse=false;
        
        handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:OBJGlobal.aryKartDataGlobal];
        [self focusSearchBarAnimated:YES];
        
        if(GETBOOL(@"isUserHasLogin")==false){
            
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:[dataBaseHelper fetchAllProductDataFromLocalDB]];
            
            OBJGlobal.aryKartDataGlobal = handleBadgeWithoutLogin;
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        }
        
        if(OBJGlobal.aryGlobalSearchProduct.count==0)
            [self searchProductMethod];
        else{
            arrSearchProduct =  [NSMutableArray arrayWithArray:OBJGlobal.aryGlobalSearchProduct];
            isGotWebResponse=true;
        }
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    if (_isSearching) {
        return _results.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    @try
    {
        __block NSString *strProductBadgeCount=0;
        NSLog(@"indexPath row %ld",(long)indexPath.row);
        SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
        __block UILabel *lblDiscountPrice=nil;
        
        if (cell == nil)
        {
            cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        [cell.subviews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[UIImageView class]])
                [obj removeFromSuperview];
            else if ([obj isKindOfClass:[UILabel class]])
                [obj removeFromSuperview];
        }];
        UIImageView *imageProduct=nil;
        __block UILabel *lblProductCount=nil;
        
        if (_isSearching) {
            
            NSDictionary *dict = [[NSDictionary alloc] init];
            dict = [_results objectAtIndex:indexPath.row];
            
            NSString *strPrice =[NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
            float price = [strPrice floatValue];
            [cell.lblPrice setTextColor:[UIColor orangeColor]];
            
            NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dict valueForKey:@"discount_price"]];
            
            cell.lblDiscountPrice.tag=65000+indexPath.row;
            lblDiscountPrice = (UILabel*)[cell viewWithTag:indexPath.row+65000];
            [lblDiscountPrice setHidden:YES];
            
            if([[dict allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
            {
                if([OBJGlobal isNotNull:[dict valueForKey:@"price"]]){
                    [lblDiscountPrice setHidden:NO];
                    
                    lblDiscountPrice.text=[NSString stringWithFormat:@"$%.2f",price];
                    lblDiscountPrice.textColor=[UIColor orangeColor];
                    [cell.lblPrice setTextColor:[UIColor grayColor]];
                    cell.lblPrice.font = [UIFont fontWithName:@"Avenir-Medium" size:14];
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f",[strPrice floatValue]]];
                    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                            value:[NSNumber numberWithInt:1]
                                            range:(NSRange){0,[attributeString length]}];
                    [cell.lblPrice setAttributedText:attributeString];
                }
                
                if(lblDiscountPrice){
                    [lblDiscountPrice setHidden:NO];
                    [cell.lblPrice setHidden:NO];
                    lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                }
            }
            else
            {
                if([OBJGlobal isNotNull:[dict valueForKey:@"price"]]){
                    
                    [lblDiscountPrice setHidden:YES];
                    [cell.lblPrice setHidden:NO];
                    cell.lblPrice.text=[NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"]floatValue]];
                    cell.lblPrice.font = [UIFont fontWithName:@"Avenir-Black" size:16];
                    
                }
            }
            cell.lblNumberOfKartItems.tag=indexPath.row+45612;
            lblProductCount = (UILabel *)[cell viewWithTag:indexPath.row+45612];
            cell.numberOfProducts=0;
            if(cell.numberOfProducts==0){
                cell.numberOfProducts=1;
                lblProductCount.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
            }
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *strId;
                strProductBadgeCount=nil;
                if([[obj allKeys] containsObject:@"id"])
                    strId = [obj valueForKey:@"id"];
                else
                    strId = [obj valueForKey:@"prod_id"];
                
                if([strId isEqualToString:[dict valueForKey:@"id"]] && [[dict allKeys] containsObject:@"id"]){
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else  if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                    
                }
                else if([strId isEqualToString:[dict valueForKey:@"prod_id"]] && [[dict allKeys] containsObject:@"prod_id"])
                {
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                }
                
                if([strProductBadgeCount intValue]>0){
                    cell.numberOfProducts = [strProductBadgeCount intValue];
                    lblProductCount.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
                    return;
                }
            }];
            
            
            if([OBJGlobal isProductGotMatchToFavouriteProductList:dict aryTotalProduct:OBJGlobal.aryFavoriteListGlobal])
            {
                [cell.btnAddtoFavourite setImage:[UIImage imageNamed:@"fav_Orange"] forState:UIControlStateNormal];
            }
            else{
                [cell.btnAddtoFavourite setImage:[UIImage imageNamed:@"fav"] forState:UIControlStateNormal];
                
            }
            
            [cell.btnMinus addTarget:self action:@selector(btnMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnMinus.tag = indexPath.row+18000;
            
            [cell.btnMyKart addTarget:self action:@selector(btnAddToKartPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnMyKart.tag=indexPath.row+67890;
            
            [cell.btnAddtoFavourite addTarget:self action:@selector(btnAddToFavouritePressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnAddtoFavourite.tag=indexPath.row+12345;
            
            [cell.btnPlus addTarget:self action:@selector(btnPlusPressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnPlus.tag=indexPath.row+11000;
            
            cell.lblName.text=[dict valueForKey:@"name"];
            cell.lblName.lineBreakMode=NSLineBreakByWordWrapping;
            cell.lblName.numberOfLines =0;
            cell.lblName.lineBreakMode=YES;
            if([OBJGlobal isNotNull:[dict valueForKey:@"weight"]])
                cell.lblWeight.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"weight"]];
            if([OBJGlobal isNotNull:[dict valueForKey:@"brand"]])
                cell.lblBrand.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"brand"]];
            
            NSString *srtURL = [dict valueForKey:@"image_url"];
            
            cell.imgProduct.tag=indexPath.row+85612;
            
            imageProduct = (UIImageView *)[cell.imgProduct viewWithTag:indexPath.row+85612];
            
            if(srtURL.length>0 && [OBJGlobal isNotNull:srtURL])
            {
                imageProduct.contentMode = UIViewContentModeScaleAspectFit;
                [imageProduct setImageWithURL:[NSURL URLWithString:srtURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            else
            {
                if([[dict allKeys]containsObject:@"image_url"])
                    srtURL = [dict valueForKey:@"image_url"];
                else
                    srtURL = [dict valueForKey:@"imageurl"];
                
                imageProduct.contentMode = UIViewContentModeScaleAspectFit;
                [imageProduct setImageWithURL:[NSURL URLWithString:srtURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
        }
        
        return cell;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    @try{
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else{
            //reset clicked
            [self favouriteAction:@"remove" dicProductDetailValue:[_results objectAtIndex:indexForFavouriteRemove]];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)favouriteAction:(NSString*)strFlag dicProductDetailValue:(NSDictionary*)dicProductDetailValue
{
    Users *objProductDetail = OBJGlobal.user;
    
    if([strFlag isEqualToString:@"remove"]){
        objProductDetail.flag=[@"remove" mutableCopy];
        objProductDetail.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
        NSString *strProd_id;
        if([[dicProductDetailValue allKeys] containsObject:@"prod_id"] && [OBJGlobal isNotNull:[dicProductDetailValue valueForKey:@"prod_id"]]){
            strProd_id  = [dicProductDetailValue valueForKey:@"prod_id"];
        }
        else if([[dicProductDetailValue allKeys] containsObject:@"id"] && [OBJGlobal isNotNull:[dicProductDetailValue valueForKey:@"id"]]){
            strProd_id  = [dicProductDetailValue valueForKey:@"id"];
        }
        objProductDetail.prodid = [[NSString stringWithFormat:@"%@",strProd_id] mutableCopy];
        objProductDetail.flag =[@"remove" mutableCopy];
        [APPDATA showLoader];
        
        [objProductDetail removeWhishListAction:^(NSDictionary *user, NSString *str, int status) {
            if (status == 1) {
                
                
                NSDictionary *dictFavouriteCheckingPorduct = dicProductDetailValue;
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
                
                if([objProductDetail.flag isEqualToString:@"remove"])
                    // [self.view makeToast:[user valueForKey:@"message"]];
                    [self.tableView reloadData];
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
    
    objProductDetail.prodid=[dicProductDetailValue valueForKey:@"id"];
    if([[dicProductDetailValue allKeys] containsObject:@"prod_id"])
        objProductDetail.prodid=[dicProductDetailValue valueForKey:@"prod_id"];
    if([[dicProductDetailValue allKeys] containsObject:@"id"])
        objProductDetail.prodid=[dicProductDetailValue valueForKey:@"id"];
    
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
            //   [self.view makeToast:@"Product added successfully to your favourite list"];
            [self.tableView reloadData];
            
            //        dicProfileEditData =[user objectForKey:@"userdetails"];
            //                [self.view makeToast:[NSString stringWithFormat:@"%@",APPDATA.user.msg]];
            //    [self.view makeToast:@"login successfully"];
            //  sleep(3);
            
            NSLog(@"success");
        }
        else {
            [self.view makeToast:@"Email and Password Invalid"];
            NSLog(@"Failed");
            [APPDATA hideLoader];
        }
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    @try{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)btnAddToFavouritePressed:(id)sender
{
    [self.view endEditing:true];
    UIButton *btnFavourite = (UIButton*)sender;
    NSInteger btnTag = btnFavourite.tag;
    btnTag = btnTag-12345;
    
    indexForFavouriteRemove = btnTag;
    
    if(GETBOOL(@"isUserHasLogin")==true){
        NSDictionary *dicProductDetailValue;
        if(_isSearching){
            dicProductDetailValue = [_results objectAtIndex:btnTag];
        }
        else{
            dicProductDetailValue = [arrSearchProduct objectAtIndex:btnTag];
        }
        
        
        if(GETBOOL(@"isUserHasLogin")==true){
            
            NSArray *aryFavouriteList = [OBJGlobal aryFavoriteListGlobal];
            if([OBJGlobal isProductGotMatchToFavouriteProductList:dicProductDetailValue aryTotalProduct:aryFavouriteList])
            {
                isProductInFavouriteList=true;
            }
            
            if(isProductInFavouriteList)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favourite Product"
                                                                message:[NSString stringWithFormat:@"Do you really want to remove %@ from favourite list?",[dicProductDetailValue valueForKey:@"name"]]
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Ok", nil];
                
                [alert show];
                return;
            }
            [self favouriteAction:@"Add" dicProductDetailValue:dicProductDetailValue];
        }
        else
        {
            [self.view makeToast:@"Please make login for adding product to favourite list"];
            
        }
    }
    else
    {
        [self.view makeToast:@"Please make login for adding product to favourite list"];
    }
}


- (IBAction)btnAddToKartPressed:(id)sender
{
    @try{
        [self.view endEditing:true];
        UIButton *btnAddToKart = (UIButton*)sender;
        
        NSInteger btnTag = btnAddToKart.tag;
        btnTag = btnTag-67890;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btnTag inSection:0];
        SearchTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSDictionary *dicProductDetailValues = [_results objectAtIndex:btnTag];
        NSMutableDictionary *dictProductDetailed = [[NSMutableDictionary alloc]initWithDictionary:dicProductDetailValues];
        
        [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *strId;
            NSString *strProdInkart;
            if([[obj allKeys] containsObject:@"id"])
                strId = [obj valueForKey:@"id"];
            else
                strId = [obj valueForKey:@"prod_id"];
            
            if([strId isEqualToString:[dictProductDetailed valueForKey:@"id"]] && [[dictProductDetailed allKeys] containsObject:@"id"]){
                if([[obj allKeys] containsObject:@"prod_in_cart"])
                    strProdInkart = [obj valueForKey:@"prod_in_cart"];
                
                if([[dictProductDetailed allKeys] containsObject:@"prod_in_cart"]){
                    [dictProductDetailed setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
                    [dictProductDetailed setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"qty"];
                }
                *stop = YES;    // Stop enumerating
                return;
            }
            else if([strId isEqualToString:[dictProductDetailed valueForKey:@"prod_id"]] && [[dictProductDetailed allKeys] containsObject:@"prod_id"])
            {
                if([[obj allKeys] containsObject:@"prod_in_cart"])
                    strProdInkart = [obj valueForKey:@"prod_in_cart"];
                
                if([[dictProductDetailed allKeys] containsObject:@"prod_in_cart"]){
                    [dictProductDetailed setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
                    [dictProductDetailed setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"qty"];
                }
                *stop = YES;    // Stop enumerating
                return;
            }
            
        }];
        
        if(GETBOOL(@"isUserHasLogin")==false){
            NSString *strPrice =[NSString stringWithFormat:@"%@",[[_results objectAtIndex:btnTag] valueForKey:@"price"]];
            float price = [strPrice floatValue];
            float totalPrice = price*[[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] floatValue];
            [dictProductDetailed setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"totalPrice"];
            
            if([[dictProductDetailed allKeys] containsObject:@"discount_price"]){
                NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dictProductDetailed valueForKey:@"discount_price"]];
                [dictProductDetailed setObject:[NSString stringWithFormat:@"%.2f",[strDiscountPrice floatValue]] forKey:@"discount_price"];
            }
            NSString *str;
            if([[dictProductDetailed allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[dictProductDetailed valueForKey:@"image_url"]])
                str = [dictProductDetailed valueForKey:@"image_url"];
            else
                str = [dictProductDetailed valueForKey:@"imageurl"];
            
            if(str.length>0)
            {
                [dictProductDetailed setObject:[NSString stringWithFormat:@"%@",str] forKey:@"image_url"];
                
                [dictProductDetailed setObject:[NSString stringWithFormat:@"%@",str] forKey:@"imageurl"];
            }
            
            
            if([[dictProductDetailed allKeys] containsObject:@"prod_id"] && [OBJGlobal isNotNull:[dictProductDetailed valueForKey:@"prod_id"]]){
                [dictProductDetailed setObject:[dictProductDetailed valueForKey:@"prod_id"] forKey:@"prod_id"];
            }
            else if([[dictProductDetailed allKeys] containsObject:@"id"] && [OBJGlobal isNotNull:[dictProductDetailed valueForKey:@"id"]]){
                [dictProductDetailed setObject:[dictProductDetailed valueForKey:@"id"] forKey:@"prod_id"];
            }
            if([[dictProductDetailed allKeys] containsObject:@"prod_id"])
                [dictProductDetailed setObject:[dictProductDetailed valueForKey:@"prod_id"] forKey:@"id"];
            else if([[dictProductDetailed allKeys] containsObject:@"id"])
                [dictProductDetailed setObject:[dictProductDetailed valueForKey:@"id"] forKey:@"id"];
            
            
            if([dataBaseHelper insertproductdData:dictProductDetailed]){
                OBJGlobal.dictLastKartProduct = dictProductDetailed;
                //  [[self parentViewController].view makeToast:@"Product added to Cart"];
            }
            else
            {
                if([dataBaseHelper updateproductdData:[dictProductDetailed valueForKey:@"id"] dictData:dictProductDetailed]){
                    OBJGlobal.dictLastKartProduct = dictProductDetailed;
                    //   [[self parentViewController].view makeToast:@"Product Updated successful"];
                }
            }
            [self performSelectorOnMainThread:@selector(fetchLocalData) withObject:nil waitUntilDone:YES];
            
        }
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            
            Users *objUsers = OBJGlobal.user;
            if ([[dictProductDetailed allKeys] containsObject:@"id"])
                // contains key
                objUsers.prodid = [dictProductDetailed valueForKey:@"id"];
            if([[dictProductDetailed allKeys] containsObject:@"prod_id"])
                objUsers.prodid = [dictProductDetailed valueForKey:@"prod_id"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dictProductDetailed valueForKey:@"sku"]] mutableCopy];
            objUsers.qty=[[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] mutableCopy];
            if(!OBJGlobal)
                OBJGlobal = [Globals sharedManager];
            objUsers.flag =[OBJGlobal checkForFlagEditOrUpdate:OBJGlobal.aryKartDataGlobal dictForItemToCheck:dictProductDetailed];
            
            if([dictProductDetailed valueForKey:@"prod_in_cart"])
                
                if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                    
                    objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                    
                    [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                     {
                         if (status == 1) {
                             
                             [APPDATA hideLoader];
                             if([objUsers.flag isEqualToString:@"update"])
                             {
                                 //    [self.view makeToast:@"Product updated from cart successfully"];
                             }
                             else
                             {
                                 //  [self.view makeToast:@"Product added to cart successfully"];
                             }
                             
                             if([OBJGlobal isNotNull:[user valueForKey:@"cartitems"]]){
                                 OBJGlobal.aryKartDataGlobal=nil;
                                 
                                 OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[user valueForKey:@"cartitems"]];
                                 OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
                             }
                             
                             [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:user];
                             
                             
                             NSLog(@"success");
                             
                             return ;
                             
                             
                         }
                         else {
                             if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                                 [self.view makeToast:[user objectForKey:@"msg"]];
                             NSLog(@"Failed");
                             //  [APPDATA hideLoader];
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
        
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] forState:UIControlStateNormal];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (void)btnPlusPressed:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-11000;
        SearchTableViewCell *cell=(SearchTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        if(cell.numberOfProducts==0)
            cell.numberOfProducts=1;
        cell.numberOfProducts++;
        cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_results objectAtIndex:btnTag]];
        
        __block BOOL isProductMatched=false;
        [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSString *strId;
            if([[obj allKeys] containsObject:@"id"])
                strId = [obj valueForKey:@"id"];
            else
                strId = [obj valueForKey:@"prod_id"];
            
            if([strId isEqualToString:[dict valueForKey:@"id"]] && [[dict allKeys] containsObject:@"id"]){
                [dict setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
                [handleBadgeWithoutLogin replaceObjectAtIndex:idx withObject:dict];
                isProductMatched=true;
                *stop = YES;    // Stop enumerating
                return;
            }
            else if([strId isEqualToString:[dict valueForKey:@"prod_id"]] && [[dict allKeys] containsObject:@"prod_id"])
            {
                isProductMatched=true;
                [dict setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
                [handleBadgeWithoutLogin replaceObjectAtIndex:idx withObject:dict];
                *stop = YES;    // Stop enumerating
                return;
            }
            
        }];
        if(!isProductMatched){
            [dict setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
            [handleBadgeWithoutLogin addObject:dict];
        }
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
}

- (void)btnMinusPressed:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-18000;
        
        SearchTableViewCell *cell=(SearchTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        if(cell.numberOfProducts<2)
            return;
        cell.numberOfProducts--;
        cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_results objectAtIndex:btnTag]];
        
        __block BOOL isProductMatched=false;
        [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *strId;
            if([[obj allKeys] containsObject:@"id"])
                strId = [obj valueForKey:@"id"];
            else
                strId = [obj valueForKey:@"prod_id"];
            if([strId isEqualToString:[dict valueForKey:@"id"]] && [[dict allKeys] containsObject:@"id"]){
                [dict setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
                [handleBadgeWithoutLogin replaceObjectAtIndex:idx withObject:dict];
                isProductMatched=true;
                *stop = YES;    // Stop enumerating
                return;
            }
            else if([strId isEqualToString:[dict valueForKey:@"prod_id"]] && [[dict allKeys] containsObject:@"prod_id"])
            {
                isProductMatched=true;
                [dict setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
                [handleBadgeWithoutLogin replaceObjectAtIndex:idx withObject:dict];
                *stop = YES;    // Stop enumerating
                return;
            }
            
        }];
        if(!isProductMatched){
            [dict setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
            [handleBadgeWithoutLogin addObject:dict];
        }
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    @try{
        
        NSUInteger oldLength = [textField.text length];
        NSUInteger replacementLength = [string length];
        NSUInteger rangeLength = range.length;
        
        NSUInteger newLength = oldLength - rangeLength + replacementLength;
        NSString *newString;
        
        if(newLength==0)
        {
            _isSearching = NO;
            newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            [self updateTextLabelsWithText:newString index:newLength];
            
            [_tableView reloadData];
            _lblSearchResult.hidden=true;
            
        }
        else{
            _isSearching = YES;
            _lblSearchResult.hidden=false;
            _results=nil;
            newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            [self updateTextLabelsWithText:newString index:newLength];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    @finally {
    }
}


-(void)updateTextLabelsWithText:(NSString *)string index:(NSInteger)index
{
    @try{
        NSMutableString* theString = [NSMutableString string];
        
        [theString appendString:string];
        
        _txtSearchField.text = theString;
        _results=nil;
        _results = [[NSMutableArray alloc] init];
        //            NSString * strSearchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", @"name",[NSString stringWithFormat:@"%@",theString]];//keySelected is NSString itself
        NSArray *resultArray = [arrSearchProduct filteredArrayUsingPredicate:predicateString] ;
        _lblSearchResult.hidden=false;
        
        _results = [resultArray mutableCopy];
        [_tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


#pragma mark SEARCH DELAGATE
#pragma mark -UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}

- (void)focusSearchBarAnimated:(BOOL)animated {
    //    [_searchBar setShowsCancelButton:YES animated:animated];
    //    [_searchBar becomeFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    _lblSearchResult.hidden=true;
    _isSearching = NO;
    [_tableView reloadData];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    @try{
        if(isGotWebResponse==false)
            return NO;
        else
            return YES;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    @try{
        if ([searchText isEqualToString:@""]) {//clear
            _isSearching = NO;
            _lblSearchResult.hidden=true;
            [_tableView reloadData];
            return;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)clearDataFromTable
{
    @try{
        NSArray *subviews = [[NSArray alloc] initWithArray:self.tableView.subviews];
        
        [subviews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[UIImageView class]])
                [obj removeFromSuperview];
            else if ([obj isKindOfClass:[UILabel class]])
                [obj removeFromSuperview];
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)searchProductMethod
{
    @try{
        [self performSelectorOnMainThread:@selector(clearDataFromTable) withObject:nil waitUntilDone:YES];
        
        [APPDATA showLoader];
        Users *objSearchProduct=[[Users alloc]init];
        [objSearchProduct Search:^(NSDictionary *user, NSString *str, int status)
         {
             if (status == 1) {
                 [APPDATA hideLoader];
                 isGotWebResponse=true;
                 [_txtSearchField becomeFirstResponder];
                 if([OBJGlobal isNotNull:[user objectForKey:@"data"]])
                     arrSearchProduct = [user objectForKey:@"data"];
                 OBJGlobal.aryGlobalSearchProduct = [NSMutableArray arrayWithArray:arrSearchProduct];
                 [_tableView reloadData];
                 //                [self performSelector:@selector(hideLoader) withObject:nil afterDelay:1.5f];
                 
                 NSLog(@"success");
             }
             else {
                 [self searchProductMethod];
                 NSLog(@"Failed");
                 [APPDATA hideLoader];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)hideLoader
{
    [APPDATA hideLoader];
    
}


@end
