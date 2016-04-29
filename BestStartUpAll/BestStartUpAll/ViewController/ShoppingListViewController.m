//
//  ShoppingListViewController.m
//  peter
//
//  Created by Peter on 1/22/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ShoppingListViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "CommonPopUpView.h"
#import "ShoppingListCell.h"
#import "UIView+Toast.h"
#import "UIImageView+WebCache.h"
#import "FMDBDataAccess.h"
#import "DashboardViewController.h"
//#import "ImageWithURL.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ShoppingListViewController ()<UIAlertViewDelegate>
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    FMDBDataAccess *dbAccess;
    int numberOfProducts;
    NSArray *handleBadgeWithoutLogin;
    NSInteger indexToDeleteProduct;
    
}
@end

@implementation ShoppingListViewController

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        indexToDeleteProduct = 0;
        [self setUpImageBackButton:@"left-arrow"];
        aryViewShopping=[[NSMutableArray alloc]init];
        [self ShopingMethod];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)setUpContentData
{
    @try{
        UINib * mainView = [UINib nibWithNibName:@"CommonPopUpView" bundle:nil];
        OBJGlobal.objMainPopUp = (CommonPopUpView *)[mainView instantiateWithOwner:self options:nil][0];
        if(IS_IPHONE_6_PLUS)
        {
            OBJGlobal.objMainPopUp.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20);
        }else
            OBJGlobal.objMainPopUp.frame=CGRectMake(0, 5, self.view.frame.size.width, OBJGlobal.objMainPopUp.frame.size.height+60);
        [self.view addSubview:OBJGlobal.objMainPopUp];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Shopping List";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        handleBadgeWithoutLogin = OBJGlobal.aryKartDataGlobal;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)ShopingMethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            
            [APPDATA showLoader];
            Users *objShoping = OBJGlobal.user;
            
            [objShoping ViewWishList:^(NSDictionary *user, NSString *str, int status)
             {
                 if (status == 1) {
                     
                     aryViewShopping = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                     OBJGlobal.aryFavoriteListGlobal = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                     [self.tableView reloadData];
                     [APPDATA hideLoader];
                     
                     NSLog(@"success");
                 }
                 else {
                     if([OBJGlobal isNotNull:[user valueForKey:@"message"]])
                         
                         [self.view makeToast:[user objectForKey:@"message"]];
                     if (aryViewShopping.count==0) {
                         _lblNoShippingData.hidden=NO;
                         self.tableView.alpha=0.5;
                     }
                     else{
                         _lblNoShippingData.hidden=YES;
                         self.tableView.alpha=1;
                         
                     }
                     NSLog(@"Failed");
                     [APPDATA hideLoader];
                 }
             }];
        }
        else{
            [self.view makeToast:@"Please login to view your favourite list"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


#pragma mark - tableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

{
    return aryViewShopping.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{ @try
    {
        static NSString *CellIdentifier = @"ShoppingListCell";
        __block NSString *strProductBadgeCount;
        ShoppingListCell *cell = (ShoppingListCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[ShoppingListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        __block UILabel *lblPrice=nil;
        __block UILabel *lblDiscountPrice=nil;
        __block UILabel *lblOrignoalPrice=nil;
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        dict = [aryViewShopping objectAtIndex:indexPath.row];
        
        if([OBJGlobal isNotNull:[dict valueForKey:@"name"]]){
            cell.lblName.text=[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"name"]];
        }
        if([OBJGlobal isNotNull:[dict valueForKey:@"brand"]]){
            cell.lblBrand.text=[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"brand"]];
            if([cell.lblBrand.text isEqualToString:@"0"])
                cell.lblBrand.text=@"";
            
        }
        
        cell.lblPrice.tag=6520+indexPath.row;
        
        lblPrice = (UILabel*)[cell viewWithTag:6520+indexPath.row];
        
        cell.lblOrignoalPrice.tag = 92500+indexPath.row;
        lblOrignoalPrice = (UILabel*)[cell viewWithTag:92500+indexPath.row];
        
        NSString *strPrice =[NSString stringWithFormat:@"%@",[dict valueForKey:@"price"]];
        float price = [strPrice floatValue];
        NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dict valueForKey:@"discount_price"]];
        cell.lblDiscountPrice.tag=65100+indexPath.row;
        lblDiscountPrice = (UILabel*)[cell viewWithTag:indexPath.row+65100];
        [lblDiscountPrice setHidden:YES];
        
        if([[dict allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
        {
            if([OBJGlobal isNotNull:[dict valueForKey:@"price"]]){
                [lblDiscountPrice setHidden:NO];
                [lblOrignoalPrice setHidden:NO];
                [lblPrice setHidden:YES];
                
                lblOrignoalPrice.text=[NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"]floatValue]];
                lblOrignoalPrice.textColor=[UIColor grayColor];
                
                NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f",price]];
                [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                        value:[NSNumber numberWithInt:1]
                                        range:(NSRange){0,[attributeString length]}];
                [lblOrignoalPrice setAttributedText:attributeString];
            }
            
            
            if(lblDiscountPrice){
                [lblDiscountPrice setHidden:NO];
                [lblPrice setHidden:YES];
                [lblOrignoalPrice setHidden:NO];
                lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                [cell.contentView  addSubview:lblDiscountPrice];
            }
        }
        else
        {
            if([OBJGlobal isNotNull:[dict valueForKey:@"price"]]){
                
                [lblPrice setHidden:NO];
                [lblDiscountPrice setHidden:YES];
                [lblOrignoalPrice setHidden:YES];
                
                lblPrice.text=[NSString stringWithFormat:@"$%.2f",[[dict valueForKey:@"price"]floatValue]];
            }
        }
        
        
        
        //.....
        if([OBJGlobal isNotNull:[dict valueForKey:@"weight"]]){
            NSString *strUnit;
            if([OBJGlobal isNotNull:[dict valueForKey:@"unit"]] && [[dict allKeys] containsObject:@"unit"])
                strUnit = [dict valueForKey:@"unit"];
            else if ([OBJGlobal isNotNull:[dict valueForKey:@"weight"]] && [[dict allKeys] containsObject:@"weight"])
                strUnit = [dict valueForKey:@"weight"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"1 lbs"];
            if([strUnit isEqualToString:@"lbs"] || [strUnit isEqualToString:@" lbs"] || [strUnit isEqualToString:@"1 lbs"])
                strUnit = [NSString stringWithFormat:@"per 1 lbs"];
            
            cell.lblWeight.text=strUnit;
        }
        
        cell.numberOfProducts=1;
        
        if([OBJGlobal isNotNull:[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"qty"]]){
            cell.lblNumberOfKartItems.text=[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"qty"]];
        }
        
        if([OBJGlobal isNotNull:[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"description"]]){
            cell.lblDescription.text=[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"description"]];
        }
        
        [cell.btnMinus addTarget:self action:@selector(btnMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnMinus.tag = indexPath.row+18000;
        
        [cell.btnPlus addTarget:self action:@selector(btnPlusPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnPlus.tag=indexPath.row+11000;
        
        [cell.btnDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnDelete.tag=indexPath.row+13000;
        
        [cell.btnAddToFavourite addTarget:self action:@selector(btnAddToKartPressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnAddToFavourite.tag=indexPath.row+12345;
        
        if(GETBOOL(@"isUserHasLogin")==false){
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *strId = [[handleBadgeWithoutLogin objectAtIndex:idx] valueForKey:@"id"];
                if([strId isEqualToString:[dict valueForKey:@"id"]]){
                    if([OBJGlobal isNotNull:[dict valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [[handleBadgeWithoutLogin objectAtIndex:idx] valueForKey:@"prod_in_cart"];
                }
            }];            }
        else{
            if([OBJGlobal isNotNull:[dict valueForKey:@"prod_in_cart"]])
                strProductBadgeCount = [dict valueForKey:@"prod_in_cart"];
        }
        if([strProductBadgeCount intValue]>0){
            cell.numberOfProducts = [strProductBadgeCount intValue];
            cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
        }
        
        
        
        NSString *strImageUrl;
        if([OBJGlobal isNotNull:[[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"image"]]){
            strImageUrl = [[aryViewShopping objectAtIndex:indexPath.row] valueForKey:@"image"];
            [cell.imgProduct setContentMode:UIViewContentModeScaleAspectFit];
            [cell.imgProduct setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
        }
        
        return cell;
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)btnAddToKartPressed:(id)sender
{
    @try{
        UIButton *btnFavourite = (UIButton*)sender;
        NSInteger btnTag = btnFavourite.tag;
        btnTag = btnTag-12345;
        
        [self shoppingListAction:@"add" index:btnTag];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)insertProductToLocalDataBase:(NSMutableDictionary *)dict
{
    @try{
        NSMutableDictionary *dictProductDetail = [[NSMutableDictionary alloc]initWithDictionary:dict];
        if([[dict allKeys] containsObject:@"prod_id"]){
            [dictProductDetail setObject:[dict valueForKey:@"prod_id"] forKey:@"id"];
        }
        
        if([dbAccess insertproductdData:dictProductDetail])
        {
            // [self.view makeToast:@"Product added to Cart"];
        }
        
        else
        {
            NSArray *aryqtycartItem = OBJGlobal.aryKartDataGlobal;
            [aryqtycartItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *strProductId = [[aryqtycartItem objectAtIndex:idx] valueForKey:@"id"];
                if([strProductId isEqualToString:[dictProductDetail valueForKey:@"id"]])
                {
                    NSString *strQty = [[aryqtycartItem objectAtIndex:idx] valueForKey:@"qty"];
                    int localDBProductCount = [strQty intValue];
                    [dictProductDetail setObject:[NSString stringWithFormat:@"%d",localDBProductCount]  forKey:@"qty"];
                }
            }];
            [dbAccess updateproductdData:[dictProductDetail valueForKey:@"id"] dictData:dictProductDetail];
            // [self.view makeToast:@"Product Updated successful"];
            
        }
        
        OBJGlobal.aryKartDataGlobal =  [[dbAccess fetchAllProductDataFromLocalDB] mutableCopy];
        [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)btnAddToFavouritePressed:(id)sender
{
    @try{
        UIButton *btnFavourite = (UIButton*)sender;
        NSInteger btnTag = btnFavourite.tag;
        btnTag = btnTag-12345;
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            Users *objUsers = OBJGlobal.user;
            NSDictionary *dicProductDetailValue = [aryViewShopping objectAtIndex:btnTag];
            if ([[dicProductDetailValue allKeys] containsObject:@"id"])
                // contains key
                objUsers.prodid = [dicProductDetailValue valueForKey:@"id"];
            else
                objUsers.prodid= [@"566" mutableCopy];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
            objUsers.qty=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"qty"]] mutableCopy];
            objUsers.flag=[@"add" mutableCopy];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                 {
                     if ([[user allKeys] containsObject:@"cartitems"]) {
                         
                         [APPDATA hideLoader];
                         //   [self.view makeToast:@"Product added to cart successfully"];
                         OBJGlobal.aryKartDataGlobal =[user valueForKey:@"cartitems"];
                         aryViewShopping=[user valueForKey:@"cartitems"];
                         [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:user];
                         
                         NSLog(@"success");
                         
                         return ;
                     }
                     else {
                         if([OBJGlobal isNotNull:[user valueForKey:@"msg"]])
                             [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
            }
        }
        else{
            [self.view makeToast:@"Please make login for adding product to favourite list"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
    
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
        ShoppingListCell *cell=(ShoppingListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        if(cell.numberOfProducts==0)
            cell.numberOfProducts=1;
        cell.numberOfProducts++;
        cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
        
        if([OBJGlobal isNotNull:[[aryViewShopping objectAtIndex:btnTag] valueForKey:@"price"]]){
            
            NSString *strPrice =[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:btnTag] valueForKey:@"price"]];
            float price = [strPrice floatValue];
            cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",price];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)btnMinusPressed:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-18000;
        
        ShoppingListCell *cell=(ShoppingListCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        if(cell.numberOfProducts<2)
            return;
        cell.numberOfProducts--;
        cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
        if([OBJGlobal isNotNull:[[aryViewShopping objectAtIndex:btnTag] valueForKey:@"price"]]){
            
            NSString *strPrice =[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:btnTag] valueForKey:@"price"]];
            float price = [strPrice floatValue];
            cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",price];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        //reset clicked
        [self shoppingListAction:@"remove" index:indexToDeleteProduct];
    }
}


-(void)btnDeletePressed:(id)sender
{
    @try{
        
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-13000;
        indexToDeleteProduct = btnTag;
        NSDictionary *dicProductDetailValue = [aryViewShopping objectAtIndex:btnTag];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",[dicProductDetailValue valueForKey:@"name"]]
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete this item %@ ?",[dicProductDetailValue valueForKey:@"name"]]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
        
        [alert show];
        
        
        return;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
    
}
-(void)compareLocalKartProductAndTotalProduct
{
    @try{
        NSArray *aryForCompareForTopProducts = aryViewShopping;
        aryViewShopping = [[NSMutableArray alloc] initWithArray:[OBJGlobal compareForKartProductAndTotalProductForSubCategory:OBJGlobal.dictLastKartProduct aryTotalProduct:aryForCompareForTopProducts]];
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)shoppingListAction:(NSString*)strFlag index:(NSInteger)index
{
    @try{
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        ShoppingListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSMutableDictionary *dicProductDetailValue = [[NSMutableDictionary alloc] initWithDictionary:[aryViewShopping objectAtIndex:index]];
        Users *objUsers = OBJGlobal.user;
        if ([[dicProductDetailValue allKeys] containsObject:@"id"])
            // contains key
            objUsers.prodid = [dicProductDetailValue valueForKey:@"id"];
        if([[dicProductDetailValue allKeys] containsObject:@"prod_id"])
            objUsers.prodid = [dicProductDetailValue valueForKey:@"prod_id"];
        if([[dicProductDetailValue allKeys] containsObject:@"prod_in_cart"])
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
        objUsers.sku=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
        objUsers.qty=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"qty"]] mutableCopy];
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            
            if([strFlag isEqualToString:@"remove"]){
                objUsers.flag=[@"remove" mutableCopy];
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                NSString *strProd_id;
                if([[dicProductDetailValue allKeys] containsObject:@"prod_id"] && [OBJGlobal isNotNull:[dicProductDetailValue valueForKey:@"prod_id"]]){
                    strProd_id  = [dicProductDetailValue valueForKey:@"prod_id"];
                }
                else if([[dicProductDetailValue allKeys] containsObject:@"id"] && [OBJGlobal isNotNull:[dicProductDetailValue valueForKey:@"id"]]){
                    strProd_id  = [dicProductDetailValue valueForKey:@"id"];
                }
                objUsers.prodid = [[NSString stringWithFormat:@"%@",strProd_id] mutableCopy];
                objUsers.flag =[@"remove" mutableCopy];
                [aryViewShopping removeObjectAtIndex:index];
                OBJGlobal.aryFavoriteListGlobal=[NSMutableArray arrayWithArray:aryViewShopping];
                [objUsers removeWhishListAction:^(NSDictionary *user, NSString *str, int status)
                 {
                     if (status == 1) {
                         [APPDATA hideLoader];
                         
                         //[APPDATA hideLoader];
                         if([objUsers.flag isEqualToString:@"remove"])
                             [self.view makeToast:[user valueForKey:@"message"]];
                         if (aryViewShopping.count==0) {
                             _lblNoShippingData.hidden=NO;
                             self.tableView.alpha=0.5;
                         }
                         else{
                             _lblNoShippingData.hidden=YES;
                             self.tableView.alpha=1;
                             
                         }
                         [self.tableView reloadData];
                         
                         
                         NSLog(@"success");
                         return ;
                     }
                     else {
                         // [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
                return;
            }
            
            Users *objUsers = OBJGlobal.user;
            if ([[dicProductDetailValue allKeys] containsObject:@"id"])
                // contains key
                objUsers.prodid = [dicProductDetailValue valueForKey:@"id"];
            if([[dicProductDetailValue allKeys] containsObject:@"prod_id"])
                objUsers.prodid = [dicProductDetailValue valueForKey:@"prod_id"];
            if([[dicProductDetailValue allKeys] containsObject:@"prod_in_cart"])
                [dicProductDetailValue setValue:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
            objUsers.qty=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"qty"]] mutableCopy];
            
            objUsers.qty=[[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] mutableCopy];
            if(!OBJGlobal)
                OBJGlobal = [Globals sharedManager];
            
            int product = [[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] intValue];
            [dicProductDetailValue setObject:[NSString stringWithFormat:@"%d",product] forKey:@"prod_in_cart"];
            
            objUsers.flag =[OBJGlobal checkForFlagEditOrUpdate:OBJGlobal.aryKartDataGlobal dictForItemToCheck:dicProductDetailValue];
            
            if([[dicProductDetailValue allKeys] containsObject:@"prod_in_cart"])
                [dicProductDetailValue setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
            if([[dicProductDetailValue allKeys] containsObject:@"qty"])
                [dicProductDetailValue setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"qty"];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                
                [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                 {
                     if (status == 1) {
                         
                         OBJGlobal.dictLastKartProduct = dicProductDetailValue;
                         
                         if([objUsers.flag isEqualToString:@"update"])
                             //       [self.view makeToast:@"Product updated from cart successfully"];
                             
                             //     else
                             //     [self.view makeToast:@"Product added to cart successfully"];
                             
                             
                             OBJGlobal.aryKartDataGlobal=[user valueForKey:@"cartitems"];
                         OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                         [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:user];
                         
                         [self compareLocalKartProductAndTotalProduct];
                         
                         NSLog(@"success");
                         
                         return ;
                     }
                     else {
                         // [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
            }
        }
        else if(GETBOOL(@"isUserHasLogin")==false){
            
            if([strFlag isEqualToString:@"remove"])
            {
                if([dbAccess deleteProductData:[NSString stringWithFormat:@"%@",[[aryViewShopping objectAtIndex:index] valueForKey:@"id"]]])
                    //   [self.view makeToast:@"Product deleted from Cart"];
                    
                    OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] initWithArray:[[dbAccess fetchAllProductDataFromLocalDB] mutableCopy]];
                [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
                
                [OBJGlobal.aryKartDataGlobal removeObjectAtIndex:index];
                [self.tableView reloadData];
                return;
            }
            
            NSMutableDictionary *dictProductDetail = [[NSMutableDictionary alloc] initWithDictionary:dicProductDetailValue];
            int product = [[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] intValue];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%d",product] forKey:@"qty"];
            
            NSString *strPrice = [dictProductDetail valueForKey:@"price"];
            float price = [strPrice floatValue] *cell.numberOfProducts;
            [dictProductDetail setObject:[NSString stringWithFormat:@"%.2f",price] forKey:@"totalPrice"];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%.2f",[strPrice floatValue]] forKey:@"price"];
            
            NSString *weight = [dicProductDetailValue valueForKey:@"weight"];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%@",weight] forKey:@"weight"];
            
            
            if([[dictProductDetail allKeys] containsObject:@"prod_id"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"prod_id"]]){
                [dictProductDetail setObject:[dictProductDetail valueForKey:@"prod_id"] forKey:@"prod_id"];
            }
            else if([[dictProductDetail allKeys] containsObject:@"id"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"id"]]){
                [dictProductDetail setObject:[dictProductDetail valueForKey:@"id"] forKey:@"prod_id"];
            }
            if([[dictProductDetail allKeys] containsObject:@"prod_id"])
                [dictProductDetail setObject:[dictProductDetail valueForKey:@"prod_id"] forKey:@"id"];
            else if([[dictProductDetail allKeys] containsObject:@"id"])
                [dictProductDetail setObject:[dictProductDetail valueForKey:@"id"] forKey:@"id"];
            
            if([[dictProductDetail allKeys] containsObject:@"prod_in_cart"])
                [dictProductDetail setObject:[NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts] forKey:@"prod_in_cart"];
            
            if([dbAccess insertproductdData:dictProductDetail]){
                OBJGlobal.dictLastKartProduct = dictProductDetail;
                //  [[self parentViewController].view makeToast:@"Product added to Cart"];
            }
            else
            {
                NSArray *aryqtycartItem = OBJGlobal.aryKartDataGlobal;
                [aryqtycartItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    NSString *strProductId = [obj valueForKey:@"id"];
                    if([strProductId isEqualToString:[dictProductDetail valueForKey:@"id"]])
                    {
                        NSString *strQty = [obj valueForKey:@"qty"];
                        NSInteger localDBProductCount = [strQty intValue];
                        localDBProductCount = cell.numberOfProducts;
                        [dictProductDetail setObject:[NSString stringWithFormat:@"%ld",(long)localDBProductCount]  forKey:@"qty"];
                    }
                }];
                
                if([dbAccess updateproductdData:[dictProductDetail valueForKey:@"id"] dictData:dictProductDetail]){
                    OBJGlobal.dictLastKartProduct = dictProductDetail;
                    //   [[self parentViewController].view makeToast:@"Product Updated successful"];
                }
            }
            [self performSelectorOnMainThread:@selector(fetchLocalData) withObject:nil waitUntilDone:YES];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)fetchLocalData{
    @try{
        OBJGlobal.aryKartDataGlobal =  [[dbAccess fetchAllProductDataFromLocalDB] mutableCopy];
        OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] forState:UIControlStateNormal];
        [self.tableView reloadData];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)continueShopingTapped:(UIButton*)sender
{
    @try{
        DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
        [self.navigationController pushViewController:objDashboardViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

@end
