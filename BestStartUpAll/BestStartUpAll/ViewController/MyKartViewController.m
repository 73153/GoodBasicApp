//
//  MyKartViewController.m
//  peter
//
//  Created by Peter on 1/12/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "MyKartViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "CuponViewController.h"
#import "UIViewController+RESideMenu.h"
#import "RESideMenu.h"
#import "CheckoutViewController.h"
#import "MyKartTableViewCell.h"
#import "Users.h"
#import "UIView+Toast.h"
#import "FMDBDataAccess.h"
#import "UIImageView+WebCache.h"
#import "PointsViewController.h"
#import "DelivaryAddressViewController.h"
//#import "ImageWithURL.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "SubCategoriesViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface MyKartViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    Globals *OBJGlobal;
    NSMutableArray *aryMyKartProducts;
    float priceTotal;
    FMDBDataAccess *dbAccess;
    UIButton *btnBadgeCount;
    BOOL isDeleteWebServiceCalled;
    NSMutableArray *aryMyKartPriceDetail;
    NSArray *arrProductTotal;
    NSInteger indexToDeleteProduct;
}

@end

@implementation MyKartViewController
@synthesize lblNoKartData;

- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        indexToDeleteProduct = 0;
        aryMyKartProducts = [[NSMutableArray alloc] init];
        OBJGlobal=[Globals sharedManager];
        self.tblView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setUpImageBackButton:@"left-arrow"];
        lblNoKartData.hidden=YES;
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
        OBJGlobal = [Globals sharedManager];
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"My Cart";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        [OBJGlobal setTitleForBadgeCountOnViewAppears:btnBadgeCount];
        
        
        if(GETBOOL(@"isUserHasLogin")==false){
            if(!dbAccess)
                dbAccess = [FMDBDataAccess new];
            
            OBJGlobal.aryKartDataGlobal = [aryMyKartProducts mutableCopy];
            
            if([aryMyKartProducts count]<=0){
                btnBadgeCount.hidden=true;
                priceTotal=0;
                self.lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                [self changeAddMoreprice:priceTotal];
                _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
            }
            else
                btnBadgeCount.hidden=false;
            [self.tblView reloadData];
        }
        if(GETBOOL(@"isUserHasLogin")==true){
            [self myCartMethod];
        }
        else{
            [self myCartMethod];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark -tbleView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [aryMyKartProducts count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try
    {
        static NSString *CellIdentifier = @"MyKartTableViewCell";
        __block UILabel *lblPrice=nil;
        __block UILabel *lblDiscountPrice=nil;
        __block UILabel *lblOrignoalPrice=nil;
        
        MyKartTableViewCell *cell=(MyKartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[MyKartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *subviews = [[NSArray alloc] initWithArray:self.tblView.subviews];
        //        [subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        [subviews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[UIImageView class]])
                [obj removeFromSuperview];
            else if ([obj isKindOfClass:[UILabel class]])
                [obj removeFromSuperview];
            
        }];
        NSDictionary *dictProductDetail = [aryMyKartProducts objectAtIndex:indexPath.row];
        
        if(GETBOOL(@"isUserHasLogin")==false){
            
            if(isDeleteWebServiceCalled)
            {
                if(aryMyKartProducts.count==indexPath.row)
                    isDeleteWebServiceCalled=false;
                //Calculate the total price after delete
                
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                    
                    NSString *strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                    float price = [strPrice floatValue];
                    
                    priceTotal = priceTotal+(cell.numberOfProducts*[[NSString stringWithFormat:@"%.2f",price] floatValue]);
                    _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                    [self changeAddMoreprice:priceTotal];
                    
                    _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                    
                }
            }
        }
        UILabel *lblLocalNumberOfItems = (UILabel*)[cell viewWithTag:indexPath.row+4000];
        if(lblLocalNumberOfItems){
            
            if(cell.numberOfProducts>=1){
                
                cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%ld",(long)cell.numberOfProducts];
                
                if([[dictProductDetail allKeys] containsObject:@"weight"]){
                    if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"weight"]])
                        cell.lblWeight.text = [dictProductDetail valueForKey:@"weight"];
                }
                else{
                    if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"unit"]])
                        cell.lblWeight.text = [dictProductDetail valueForKey:@"unit"];
                }
                
                NSString *str;
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"imageurl"]]){
                    str = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"imageurl"]];
                    
                    [cell.imageProduct setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [cell.imageProduct setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }
            }
        }
        else{
            cell.numberOfProducts=1;
            
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]]){
                
                cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                cell.numberOfProducts = [[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]] intValue];
            }
            cell.lblNumberOfKartItems.tag=indexPath.row+4000;
        }
        if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"name"]]){
            cell.lblName.text = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"name"]];
            cell.lblName.lineBreakMode = NSLineBreakByWordWrapping;
            cell.lblName.numberOfLines = 0;
        }
        
        if([[dictProductDetail allKeys] containsObject:@"weight"]){
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"weight"]])
                cell.lblWeight.text = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"weight"]];
        }
        else{
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"unit"]])
                cell.lblWeight.text = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"unit"]];
        }
        if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"brand"]])
            cell.lblBrandName.text = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"brand"]];
        
        //  Peter discount price
        
        cell.lblPrice.tag=6520+indexPath.row;
        
        lblPrice = (UILabel*)[cell viewWithTag:6520+indexPath.row];
        
        cell.lblOrignoalPrice.tag = 92500+indexPath.row;
        lblOrignoalPrice = (UILabel*)[cell viewWithTag:92500+indexPath.row];
        
        NSString *strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
        float price = [strPrice floatValue];
        NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"discount_price"]];
        cell.lblDiscountPrice.tag=65100+indexPath.row;
        lblDiscountPrice = (UILabel*)[cell viewWithTag:indexPath.row+65100];
        [lblDiscountPrice setHidden:YES];
        
        if([[dictProductDetail allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
        {
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                [lblDiscountPrice setHidden:NO];
                [lblOrignoalPrice setHidden:NO];
                [lblPrice setHidden:YES];
                
                lblOrignoalPrice.text=[NSString stringWithFormat:@"$%.2f",[[dictProductDetail valueForKey:@"price"]floatValue]];
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
                NSString *strQty;
                if([OBJGlobal isNotNull:[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"discount_price"]]])
                    //   strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                    // strPrice = [NSString stringWithFormat:@"%.2f",[strPrice floatValue]];
                    if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]])
                        strQty =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                float priceValue1 = [strDiscountPrice floatValue] * [strQty intValue];
                // float priceValue = [strPrice floatValue];
                cell.lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",priceValue1];
                
                
                
                //  lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                [cell.contentView  addSubview:lblDiscountPrice];
            }
        }
        else
        {
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                
                [lblPrice setHidden:NO];
                [lblDiscountPrice setHidden:YES];
                [lblOrignoalPrice setHidden:YES];
                NSString *strPrice;
                NSString *strQty;
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]])
                    strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                strPrice = [NSString stringWithFormat:@"%.2f",[strPrice floatValue]];
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]])
                    strQty =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                float priceValue = [strPrice floatValue] * [strQty intValue];
                // float priceValue = [strPrice floatValue];
                cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",priceValue];
                
            }
        }
        
        NSString *str;
        if([[dictProductDetail allKeys] containsObject:@"imageurl"] && [OBJGlobal isNotNull:@"imageurl"]){
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"imageurl"]]){
                str = [NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"imageurl"]];
                cell.imageProduct.backgroundColor = [UIColor clearColor];
                
                [cell.imageProduct setContentMode:UIViewContentModeScaleAspectFit];
                
                [cell.imageProduct setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                //                    [cell.imageProduct setImage:[UIImage imageNamed:@"img_not_available.png"]];
                //
                //                    // Load image asynchronously and show the image when loaded.
                //                    [cell.imageProduct loadImageWithURL:str];
                
            }
        }
        if([[dictProductDetail allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:@"image_url"])
        {
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"image_url"]]){
                str = [dictProductDetail valueForKey:@"image_url"];
                cell.imageProduct.backgroundColor = [UIColor clearColor];
                
                [cell.imageProduct setContentMode:UIViewContentModeScaleAspectFit];
                [cell.imageProduct setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
        }
        cell.btnDelete.tag = indexPath.row+13000;
        cell.btnMinus.tag = indexPath.row+8000;
        cell.btnPlus.tag=indexPath.row+10000;
        
        UIButton *btnLocalMinus = (UIButton*)[cell viewWithTag:indexPath.row+8000];
        UIButton *btnLocalPlus = (UIButton*)[cell viewWithTag:indexPath.row+10000];
        UIButton *btnLocalDelete = (UIButton*)[cell viewWithTag:indexPath.row+13000];
        
        
        [btnLocalDelete addTarget:self action:@selector(btnDeletePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnLocalMinus addTarget:self action:@selector(btnMinusPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnLocalPlus addTarget:self action:@selector(btnPlusPressed:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)changeAddMoreprice:(float)pricetoMinus
{
    @try{
        if(pricetoMinus<50){
            _lblAddMore.hidden=false;
            _lblAddMore.text = [NSString stringWithFormat:@"Add $%.2f more for",50-pricetoMinus];
        }else{
            _lblAddMore.hidden=true;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    @try{
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else{
            //reset clicked
            [self deleteKartProductAtIndex:indexToDeleteProduct];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)deleteKartProductAtIndex:(NSInteger)btnTag
{
    @try{
        
        if(GETBOOL(@"isUserHasLogin")==true){
            Users *objUsers = OBJGlobal.user;
            
            NSDictionary *dicProductDetailValue = [aryMyKartProducts objectAtIndex:btnTag];
            if ([[dicProductDetailValue allKeys] containsObject:@"id"])
                objUsers.prodid = [dicProductDetailValue valueForKey:@"id"];
            else
                objUsers.prodid = [dicProductDetailValue valueForKey:@"prod_id"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
            objUsers.qty=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"qty"]] mutableCopy];
            objUsers.flag=[@"remove" mutableCopy];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                priceTotal=0;
                [APPDATA showLoader];
                
                [aryMyKartProducts removeObjectAtIndex:btnTag];
                
                OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] initWithArray:aryMyKartProducts];
                [self.tblView reloadData];
                
                [objUsers cartAction:^(NSDictionary *result, NSString *str, int status)
                 {
                     if (status == 1) {
                         [APPDATA hideLoader];
                         
                         aryMyKartProducts=nil;
                         isDeleteWebServiceCalled=true;
                         OBJGlobal.dictLastKartProduct=nil;
                         
                         //      [self.view makeToast:@"Item deleted from cart successfully"];
                         if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                             aryMyKartProducts=nil;
                             aryMyKartProducts = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"cartitems"]];
                             
                             OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                             OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                             
                             priceTotal=0;
                             [aryMyKartProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 if([OBJGlobal isNotNull:[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"price"]]){
                                     
                                     NSString *strPrice;
                                     NSString *strQty;
                                     NSDictionary *dictProductDetail = [aryMyKartProducts objectAtIndex:idx];
                                     if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]])
                                         strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                                     strPrice = [NSString stringWithFormat:@"%.2f",[strPrice floatValue]];
                                     if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]])
                                         strQty =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                                     
                                     if([[result allKeys] containsObject:@"total"]){
                                         aryMyKartPriceDetail = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"total"]];
                                         
                                         
                                         
                                         [aryMyKartPriceDetail enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                             NSDictionary *dictAmount = [aryMyKartPriceDetail objectAtIndex:idx];
                                             NSString *strAmount;
                                             if([OBJGlobal isNotNull:[dictAmount valueForKey:@"amount"]])
                                                 strAmount = [dictAmount valueForKey:@"amount"];
                                             else
                                                 strAmount=@"0.0";
                                             NSString *strTitle = [dictAmount valueForKey:@"title"];
                                             
                                             float fAmt = [strAmount floatValue];
                                             strAmount = [NSString stringWithFormat:@"%.2f",fAmt];
                                             
                                             
                                             if([strTitle containsString:@"Discount"])
                                                 _lblCouponPoints.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             if([strTitle containsString:@"Shipping & Handling"])
                                                 _lblShipping.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             if([strTitle containsString:@"Subtotal"]){
                                                 _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                                 priceTotal = [strAmount floatValue];
                                             }
                                             
                                             if([strTitle containsString:@"Grand Total"])
                                                 _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             
                                         }];
                                         
                                     }
                                     [self.tblView reloadData];
                                 }
                             }];
                             
                             [self changeAddMoreprice:priceTotal];
                             
                             if(aryMyKartProducts.count==0)
                             {
                                 lblNoKartData.hidden=NO;
                                 self.tblView.alpha=0.5;
                             }
                             else{
                                 lblNoKartData.hidden=YES;
                                 self.tblView.alpha=1;
                             }
                             [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                             [self.tblView reloadData];
                         }
                         else{
                             aryMyKartProducts=nil;
                             OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
                             
                             OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
                             if(aryMyKartProducts.count==0){
                                 _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 [self changeAddMoreprice:priceTotal];
                                 
                                 _lblTotalPoints.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 _lblShipping.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                             }
                             if(aryMyKartProducts.count==0)
                             {
                                 lblNoKartData.hidden=NO;
                                 self.tblView.alpha=0.5;
                             }
                             else{
                                 lblNoKartData.hidden=YES;
                                 self.tblView.alpha=1;
                             }
                             [self.tblView reloadData];
                             
                             NSLog(@"success");
                             
                             return ;
                             
                             
                         }
                     }
                     else {
                         // [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
            }
        }
        if(GETBOOL(@"isUserHasLogin")==false){
            
            if([dbAccess deleteProductData:[NSString stringWithFormat:@"%@",[[aryMyKartProducts objectAtIndex:btnTag] valueForKey:@"id"]]])
                //   [self.view makeToast:@"Product deleted from Cart"];
                [aryMyKartProducts removeObjectAtIndex:btnTag];
            
            OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] initWithArray:aryMyKartProducts];
            
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
            priceTotal=0;
            
            [aryMyKartProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([OBJGlobal isNotNull:[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"price"]]){
                    
                    NSString *strPrice =[NSString stringWithFormat:@"%@",[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"totalPrice"]];
                    float price = [strPrice floatValue];
                    
                    priceTotal = priceTotal+[[NSString stringWithFormat:@"%.2f",price] floatValue];
                }
            }];
            _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
            [self changeAddMoreprice:priceTotal];
            
            _lblPayableTotalAmount.text =[NSString stringWithFormat:@"$%.2f",priceTotal];
            
            if(aryMyKartProducts.count==0)
            {
                lblNoKartData.hidden=NO;
                self.tblView.alpha=0.5;
            }
            else{
                lblNoKartData.hidden=YES;
                self.tblView.alpha=1;
            }
            
            [self.tblView reloadData];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)btnDeletePressed:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-13000;
        indexToDeleteProduct = btnTag;
        NSDictionary *dicProductDetailValue = [aryMyKartProducts objectAtIndex:btnTag];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Remove %@",[dicProductDetailValue valueForKey:@"name"]]
                                                        message:[NSString stringWithFormat:@"Are you sure you want to delete this item %@ from shopping cart ?",[dicProductDetailValue valueForKey:@"name"]]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
        
        [alert show];
        return;
        
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
            Users *objMyKart=[[Users alloc]init];
            objMyKart.prodid = [[aryMyKartProducts objectAtIndex:btnTag] valueForKey:@"id"];
            [objMyKart AddwishListAction:^(NSDictionary *result,NSString *str, int status) {
                
                if (status == 1) {
                    
                    [APPDATA hideLoader];
                    
                    APPDATA.user.msg=[result objectForKey:@"msg"];
                    //     [self.view makeToast:@"Product added successfully to your favourite list"];
                    
                    NSLog(@"success");
                }
                else {
                    //     [self.view makeToast:@"Email and Password Invalid"];
                    NSLog(@"Failed");
                    [APPDATA hideLoader];
                }
            }];
        }
        else{
            [self.view makeToast:@"Please make login for adding product to favourite list"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)btnPlusPressed:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-10000;
        MyKartTableViewCell *Cell=(MyKartTableViewCell*)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        Cell.numberOfProducts++;
        
        __block NSMutableDictionary *dicProductDetailValue = [[NSMutableDictionary alloc] initWithDictionary:[aryMyKartProducts objectAtIndex:btnTag]];
        
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            Users *objUsers = OBJGlobal.user;
            if ([[dicProductDetailValue allKeys] containsObject:@"id"])
                // contains key
                objUsers.prodid = [dicProductDetailValue valueForKey:@"id"];
            if([[dicProductDetailValue allKeys] containsObject:@"prod_id"])
                objUsers.prodid = [dicProductDetailValue valueForKey:@"prod_id"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
            objUsers.qty= [[NSString stringWithFormat:@"%d",Cell.numberOfProducts] mutableCopy];
            objUsers.flag=[@"update" mutableCopy];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                
                [objUsers cartAction:^(NSDictionary *result, NSString *str, int status)
                 {
                     if (status == 1) {
                         [APPDATA hideLoader];
                         aryMyKartProducts=nil;
                         isDeleteWebServiceCalled=true;
                         OBJGlobal.dictLastKartProduct=nil;
                         
                         //      [self.view makeToast:@"Item deleted from cart successfully"];
                         if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                             aryMyKartProducts=nil;
                             aryMyKartProducts = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"cartitems"]];
                             
                             OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                             OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                             
                             priceTotal=0;
                             [aryMyKartProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 if([OBJGlobal isNotNull:[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"price"]]){
                                     
                                     NSString *strPrice;
                                     NSString *strQty;
                                     NSDictionary *dictProductDetail = [aryMyKartProducts objectAtIndex:idx];
                                     if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]])
                                         strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                                     strPrice = [NSString stringWithFormat:@"%.2f",[strPrice floatValue]];
                                     if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]])
                                         strQty =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                                     
                                     
                                     if([[result allKeys] containsObject:@"total"]){
                                         aryMyKartPriceDetail = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"total"]];
                                         
                                         
                                         
                                         [aryMyKartPriceDetail enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                             NSDictionary *dictAmount = [aryMyKartPriceDetail objectAtIndex:idx];
                                             NSString *strAmount;
                                             if([OBJGlobal isNotNull:[dictAmount valueForKey:@"amount"]])
                                                 strAmount = [dictAmount valueForKey:@"amount"];
                                             else
                                                 strAmount=@"0.0";
                                             NSString *strTitle = [dictAmount valueForKey:@"title"];
                                             
                                             float fAmt = [strAmount floatValue];
                                             strAmount = [NSString stringWithFormat:@"%.2f",fAmt];
                                             
                                             
                                             if([strTitle containsString:@"Discount"])
                                                 _lblCouponPoints.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             if([strTitle containsString:@"Shipping & Handling"])
                                                 _lblShipping.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             if([strTitle containsString:@"Subtotal"]){
                                                 _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                                 priceTotal = [strAmount floatValue];
                                             }
                                             
                                             if([strTitle containsString:@"Grand Total"])
                                                 _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             
                                         }];
                                         
                                     }
                                     [self.tblView reloadData];
                                 }
                             }];
                             
                             [self changeAddMoreprice:priceTotal];
                             
                             if(aryMyKartProducts.count==0)
                             {
                                 lblNoKartData.hidden=NO;
                                 self.tblView.alpha=0.5;
                             }
                             else{
                                 lblNoKartData.hidden=YES;
                                 self.tblView.alpha=1;
                             }
                             [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                             [self.tblView reloadData];
                         }
                         else{
                             aryMyKartProducts=nil;
                             OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
                             
                             if(aryMyKartProducts.count==0){
                                 _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 [self changeAddMoreprice:priceTotal];
                                 
                                 _lblTotalPoints.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 _lblShipping.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                             }                         //                         [self performSelectorOnMainThread:@selector(myCartMethod) withObject:nil waitUntilDone:YES];
                             //                         [APPDATA hideLoader];
                             
                             
                             if(aryMyKartProducts.count==0)
                             {
                                 lblNoKartData.hidden=NO;
                                 self.tblView.alpha=0.5;
                             }
                             else{
                                 lblNoKartData.hidden=YES;
                                 self.tblView.alpha=1;
                             }
                             [self.tblView reloadData];
                             
                             NSLog(@"success");
                             
                             return ;
                         }
                     }
                     else {
                         // [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
            }
        }
        if(GETBOOL(@"isUserHasLogin")==false){
            NSString *strPrice =[NSString stringWithFormat:@"%@",[[aryMyKartProducts objectAtIndex:btnTag] valueForKey:@"price"]];
            float price = [strPrice floatValue];
            
            priceTotal = priceTotal+[[NSString stringWithFormat:@"%.2f",price] floatValue];
            _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
            [self changeAddMoreprice:priceTotal];
            
            _lblPayableTotalAmount.text =[NSString stringWithFormat:@"$%.2f",priceTotal];
            
            Cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%d",Cell.numberOfProducts];
            
            Cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",Cell.numberOfProducts*[[NSString stringWithFormat:@"%.2f",price] floatValue]];
            
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%d",Cell.numberOfProducts] forKey:@"qty"];
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%d",Cell.numberOfProducts] forKey:@"prod_in_cart"];
            
            
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.2f",Cell.numberOfProducts*[[NSString stringWithFormat:@"%.2f",price] floatValue]]] forKey:@"totalPrice"];
            
            if([dbAccess updateproductdData:[dicProductDetailValue valueForKey:@"id"] dictData:[dicProductDetailValue mutableCopy]]){
                OBJGlobal.dictLastKartProduct=dicProductDetailValue;
                [self performSelectorOnMainThread:@selector(fetchLocalData) withObject:nil waitUntilDone:YES];
                
                //    [self.view makeToast:@"Product Updated successful"];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)fetchLocalData{
    @try{
        OBJGlobal.aryKartDataGlobal =  [[dbAccess fetchAllProductDataFromLocalDB] mutableCopy];
        OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
        
        NSMutableDictionary *dictkartProductDetail = [[NSMutableDictionary alloc] init];
        [dictkartProductDetail setObject:OBJGlobal.aryKartDataGlobal forKey:@"cartitems"];
        //This for loop iterates through all the view controllers in navigation stack.
        for (UIViewController* viewController in self.navigationController.viewControllers) {
            
            //This if condition checks whether the viewController's class is MyGroupViewController
            // if true that means its the MyGroupViewController (which has been pushed at some point)
            if ([viewController isKindOfClass:[DashboardViewController class]] ) {
                
                DashboardViewController *objDashboard = (DashboardViewController*)viewController;
                
                [objDashboard reloadCartData:dictkartProductDetail];
            }
            else if([viewController isKindOfClass:[SubCategoriesViewController class]])
            {
                SubCategoriesViewController *objSubCategories = (SubCategoriesViewController*)viewController;
                
                [objSubCategories reloadCartData:dictkartProductDetail];
            }
        }
        
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] forState:UIControlStateNormal];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)btnMinusPressed:(id)sender
{
    @try{
        UIButton *btnTapped = (UIButton*)sender;
        NSInteger btnTag = btnTapped.tag-8000;
        
        MyKartTableViewCell *Cell=(MyKartTableViewCell*)[self.tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btnTag inSection:0]];
        
        NSLog(@"Cell.numberOfProducts %ld",(long)Cell.numberOfProducts);
        if(Cell.numberOfProducts <=1)
            return;
        
        Cell.numberOfProducts--;
        
        NSMutableDictionary *dicProductDetailValue = [[NSMutableDictionary alloc] initWithDictionary:[aryMyKartProducts objectAtIndex:btnTag]];
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            Users *objUsers = OBJGlobal.user;
            if ([[dicProductDetailValue allKeys] containsObject:@"id"] && [OBJGlobal isNotNull: [dicProductDetailValue valueForKey:@"id"]])
                // contains key
                objUsers.prodid = [dicProductDetailValue valueForKey:@"id"];
            else if([[dicProductDetailValue allKeys] containsObject:@"prod_id"])
                objUsers.prodid = [dicProductDetailValue valueForKey:@"prod_id"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
            Cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%d",Cell.numberOfProducts];
            int numberOfItem = [[NSString stringWithFormat:@"%@",Cell.lblNumberOfKartItems.text] intValue];
            objUsers.qty= [[NSString stringWithFormat:@"%d",numberOfItem] mutableCopy];
            objUsers.flag=[@"update" mutableCopy];
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                
                [objUsers cartAction:^(NSDictionary *result, NSString *str, int status)
                 {
                     if (status == 1) {
                         [APPDATA hideLoader];
                         aryMyKartProducts=nil;
                         isDeleteWebServiceCalled=true;
                         OBJGlobal.dictLastKartProduct=nil;
                         
                         //      [self.view makeToast:@"Item deleted from cart successfully"];
                         if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                             aryMyKartProducts=nil;
                             aryMyKartProducts = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"cartitems"]];
                             
                             OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                             OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                             
                             priceTotal=0;
                             [aryMyKartProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                 if([OBJGlobal isNotNull:[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"price"]]){
                                     
                                     NSString *strPrice;
                                     NSString *strQty;
                                     NSDictionary *dictProductDetail = [aryMyKartProducts objectAtIndex:idx];
                                     if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]])
                                         strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                                     strPrice = [NSString stringWithFormat:@"%.2f",[strPrice floatValue]];
                                     if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]])
                                         strQty =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                                     //                                 float priceValue = [strPrice floatValue] * [strQty intValue];
                                     
                                     
                                     
                                     if([[result allKeys] containsObject:@"total"]){
                                         aryMyKartPriceDetail = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"total"]];
                                         
                                         
                                         
                                         [aryMyKartPriceDetail enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                             NSDictionary *dictAmount = [aryMyKartPriceDetail objectAtIndex:idx];
                                             NSString *strAmount;
                                             if([OBJGlobal isNotNull:[dictAmount valueForKey:@"amount"]])
                                                 strAmount = [dictAmount valueForKey:@"amount"];
                                             else
                                                 strAmount=@"0.0";
                                             NSString *strTitle = [dictAmount valueForKey:@"title"];
                                             
                                             float fAmt = [strAmount floatValue];
                                             strAmount = [NSString stringWithFormat:@"%.2f",fAmt];
                                             
                                             
                                             if([strTitle containsString:@"Discount"])
                                                 _lblCouponPoints.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             if([strTitle containsString:@"Shipping & Handling"])
                                                 _lblShipping.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             if([strTitle containsString:@"Subtotal"]){
                                                 _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                                 priceTotal = [strAmount floatValue];
                                             }
                                             
                                             if([strTitle containsString:@"Grand Total"])
                                                 _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             
                                         }];
                                         
                                     }
                                     [self.tblView reloadData];
                                 }
                             }];
                             
                             [self changeAddMoreprice:priceTotal];
                             
                             if(aryMyKartProducts.count==0)
                             {
                                 lblNoKartData.hidden=NO;
                                 self.tblView.alpha=0.5;
                             }
                             else{
                                 lblNoKartData.hidden=YES;
                                 self.tblView.alpha=1;
                             }
                             [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                             [self.tblView reloadData];
                         }
                         else{
                             aryMyKartProducts=nil;
                             OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
                             
                             if(aryMyKartProducts.count==0){
                                 _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 [self changeAddMoreprice:priceTotal];
                                 
                                 _lblTotalPoints.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 _lblShipping.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                                 _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                             }                         //                         [self performSelectorOnMainThread:@selector(myCartMethod) withObject:nil waitUntilDone:YES];
                             //                         [APPDATA hideLoader];
                             
                             
                             if(aryMyKartProducts.count==0)
                             {
                                 lblNoKartData.hidden=NO;
                                 self.tblView.alpha=0.5;
                             }
                             else{
                                 lblNoKartData.hidden=YES;
                                 self.tblView.alpha=1;
                             }
                             [self.tblView reloadData];
                             NSLog(@"success");
                             
                             return ;
                             
                         }
                     }
                     else {
                         // [self.view makeToast:[user objectForKey:@"msg"]];
                         NSLog(@"Failed");
                         [APPDATA hideLoader];
                     }
                 }];
            }
        }
        if(GETBOOL(@"isUserHasLogin")==false){
            
            NSString *strPrice =[NSString stringWithFormat:@"%@",[[aryMyKartProducts objectAtIndex:btnTag] valueForKey:@"price"]];
            float price = [strPrice floatValue];
            
            Cell.lblPrice.text = [NSString stringWithFormat:@"$%.2f",Cell.numberOfProducts*[[NSString stringWithFormat:@"%.2f",price] floatValue]];
            Cell.lblNumberOfKartItems.text = [NSString stringWithFormat:@"%d",Cell.numberOfProducts];
            priceTotal = priceTotal - [[NSString stringWithFormat:@"%.2f",price] floatValue];
            _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
            
            [self changeAddMoreprice:priceTotal];
            _lblPayableTotalAmount.text =[NSString stringWithFormat:@"$%.2f",priceTotal];
            
            
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%d",Cell.numberOfProducts] forKey:@"qty"];
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%d",Cell.numberOfProducts] forKey:@"prod_in_cart"];
            
            
            [dicProductDetailValue setValue:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%.2f",Cell.numberOfProducts*[[NSString stringWithFormat:@"%.2f",price] floatValue]]] forKey:@"totalPrice"];
            
            if([dbAccess updateproductdData:[dicProductDetailValue valueForKey:@"id"] dictData:[dicProductDetailValue mutableCopy]]){
                OBJGlobal.dictLastKartProduct=dicProductDetailValue;
                [self performSelectorOnMainThread:@selector(fetchLocalData) withObject:nil waitUntilDone:YES];
                
                //      [self.view makeToast:@"Product Updated successful"];
            }
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    //    [self.tblView reloadData];
    
}
- (IBAction)btnPayFromWalletPressed:(id)sender {
    @try{
        PointsViewController *objCuponViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PointsViewController"];
        [self.navigationController pushViewController:objCuponViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnApplyCouponPressed:(id)sender
{
    @try{
        CuponViewController *objCuponViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CuponViewController"];
        objCuponViewController.strTotal = _lblTotalPoints.text;
        objCuponViewController.strGrantTotal = _lblPayableTotalAmount.text;
        objCuponViewController.strDiscount = _lblCouponPoints.text;
        objCuponViewController.strShipping = _lblShipping.text;
        OBJGlobal.pointsTotal = [[NSString stringWithFormat:@"%@", _lblPayableTotalAmount.text] mutableCopy];
        [self.navigationController pushViewController:objCuponViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnCheckOutPressed:(id)sender
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==false){
            
            [self.view makeToast:@"Please login and add product to kart"];
            LoginViewController *objLoginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            [self.navigationController pushViewController:objLoginViewController animated:NO];
            
            return;
        }
        
        if(aryMyKartProducts.count>0){
            if(OBJGlobal.arrPaypalData.count>0){
                OBJGlobal.arrPaypalData = [[NSMutableArray alloc] init];
            }
            [OBJGlobal.arrPaypalData addObject:aryMyKartProducts];
            [OBJGlobal.arrPaypalData addObject:arrProductTotal];
            DelivaryAddressViewController *objDelivaryAddressViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DelivaryAddressViewController"];
            [self.navigationController pushViewController:objDelivaryAddressViewController animated:NO];
        }
        else{
            [self.view makeToast:@"Please add product to kart"];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)myCartMethod
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            Users *objmyCart = OBJGlobal.user;
            
            [objmyCart myCartList:^(NSDictionary *result, NSString *str, int status)
             {
                 if (status == 1) {
                     
                     [APPDATA hideLoader];
                     arrProductTotal = [result valueForKey:@"total"];
                     
                     if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                         aryMyKartProducts=nil;
                         aryMyKartProducts = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"cartitems"]];
                         
                         OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                         OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                         
                         priceTotal=0;
                         [aryMyKartProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             if([OBJGlobal isNotNull:[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"price"]]){
                                 
                                 NSString *strPrice;
                                 NSString *strQty;
                                 NSDictionary *dictProductDetail = [aryMyKartProducts objectAtIndex:idx];
                                 if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]])
                                     strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
                                 strPrice = [NSString stringWithFormat:@"%.2f",[strPrice floatValue]];
                                 if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"qty"]])
                                     strQty =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"qty"]];
                                 //                                 float priceValue = [strPrice floatValue] * [strQty intValue];
                                 
                                 
                                 
                                 if([[result allKeys] containsObject:@"total"]){
                                     aryMyKartPriceDetail = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"total"]];
                                     
                                     
                                     
                                     [aryMyKartPriceDetail enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                         NSDictionary *dictAmount = [aryMyKartPriceDetail objectAtIndex:idx];
                                         NSString *strAmount;
                                         if([OBJGlobal isNotNull:[dictAmount valueForKey:@"amount"]])
                                             strAmount = [dictAmount valueForKey:@"amount"];
                                         else
                                             strAmount=@"0.0";
                                         NSString *strTitle = [dictAmount valueForKey:@"title"];
                                         
                                         float fAmt = [strAmount floatValue];
                                         strAmount = [NSString stringWithFormat:@"%.2f",fAmt];
                                         
                                         
                                         if([strTitle containsString:@"Discount"])
                                             _lblCouponPoints.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                         if([strTitle containsString:@"Shipping & Handling"])
                                             _lblShipping.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                         if([strTitle containsString:@"Subtotal"]){
                                             _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                             priceTotal = [strAmount floatValue];
                                         }
                                         
                                         if([strTitle containsString:@"Grand Total"])
                                             _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",[strAmount floatValue]];
                                         
                                     }];
                                     
                                 }
                                 [self.tblView reloadData];
                             }
                         }];
                         
                         [self changeAddMoreprice:priceTotal];
                         
                         
                         [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                         [self.tblView reloadData];
                     }
                     else{
                         aryMyKartProducts=nil;
                         if(aryMyKartProducts.count==0){
                             _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                             [self changeAddMoreprice:priceTotal];
                             
                             _lblTotalPoints.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                             _lblShipping.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                             _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                         }
                         //                     [self.view makeToast:@"Please Login to view cart data or you have not added product to cart" duration:5.0f position:CSToastPositionBottom title:@"Alert"];
                     }
                     
                     
                     if (aryMyKartProducts.count==0) {
                         lblNoKartData.hidden=NO;
                         self.tblView.alpha=0.5;
                     }
                     else{
                         lblNoKartData.hidden=YES;
                         self.tblView.alpha=1;
                     }
                     [self.tblView reloadData];
                     
                     NSLog(@"success");
                 }
                 else {
                     // [self.view makeToast:[user objectForKey:@"msg"]];
                     NSLog(@"Failed");
                     [self performSelectorOnMainThread:@selector(myCartMethod) withObject:nil waitUntilDone:YES];
                     if (aryMyKartProducts.count==0) {
                         lblNoKartData.hidden=NO;
                         self.tblView.alpha=0.5;
                     }
                     else{
                         lblNoKartData.hidden=YES;
                         self.tblView.alpha=1;
                         
                     }
                     
                     [APPDATA hideLoader];
                 }
             }];
            
        }
        else{
            if(GETBOOL(@"isUserHasLogin")==false){
                
                OBJGlobal.aryKartDataGlobal = [[dbAccess fetchAllProductDataFromLocalDB] mutableCopy];
                aryMyKartProducts = [NSMutableArray arrayWithArray:OBJGlobal.aryKartDataGlobal];
                [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
                priceTotal=0;
                [aryMyKartProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([OBJGlobal isNotNull:[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"price"]]){
                        
                        NSString *strPrice =[NSString stringWithFormat:@"%@",[[aryMyKartProducts objectAtIndex:idx] valueForKey:@"totalPrice"]];
                        float price = [strPrice floatValue];
                        
                        priceTotal = priceTotal+[[NSString stringWithFormat:@"%.2f",price] floatValue];
                        self.lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                        [self changeAddMoreprice:priceTotal];
                        
                        _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                        
                    }
                }];
                if(aryMyKartProducts.count==0)
                {
                    _lblPriceTotal.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                    [self changeAddMoreprice:priceTotal];
                    
                    _lblTotalPoints.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                    _lblShipping.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                    _lblPayableTotalAmount.text = [NSString stringWithFormat:@"$%.2f",priceTotal];
                    
                    lblNoKartData.hidden=NO;
                    self.tblView.alpha=0.5;
                }
                else{
                    lblNoKartData.hidden=YES;
                    self.tblView.alpha=1;
                }
                [self.tblView reloadData];
            }
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
@end
