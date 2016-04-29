//
//  ProductDetailViewController.m
//  peter
//
//  Created by Peter on 2/8/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "SubCategoriesViewController.h"
#import "UIView+Toast.h"
#import "FMDBDataAccess.h"
#import "Base64.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface ProductDetailViewController ()
{
    Globals *OBJGlobal;
    NSString *strlblPrice;
    FMDBDataAccess *dataBaseHelper;
    UIButton *btnBadgeCount;
    
    
}
@end

@implementation ProductDetailViewController
@synthesize numberOfProducts;
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        
        [self setUpImageBackButton:@"left-arrow"];
        [self.viewImage setHidden:YES];
                self.btnClosePopup.layer.masksToBounds = YES;
        self.btnClosePopup.layer.cornerRadius = 10;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnViewImagePressed:(id)sender
{
    [self.viewImage setHidden:NO];
}

- (IBAction)btnAddToFavouritePressed:(id)sender {
    @try{
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            
            Users *objProductDetail = OBJGlobal.user;
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
                    // [self.view makeToast:@"Product added successfully to your favourite list"];
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
        else{
            
            [self.view makeToast:@"Please make login for adding product to favourite list"];
        }
        
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
        if(numberOfProducts==0)
            numberOfProducts=1;
        self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
    self.txtViewPopUpItemDescription.editable=false;
        [self.viewImage setHidden:YES];
        if(!dataBaseHelper)
            dataBaseHelper = [[FMDBDataAccess alloc]init];
        
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
                label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = [self.dicProductDetailValue valueForKey:@"name"];
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        [self setProductDetailValue];
        
        
        NSString *strPrice =[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"price"]];
        float price = [strPrice floatValue];
        self.lblPrice.text =[NSString stringWithFormat:@"$%.2f per 1 lb",price];
        [_txtViewPopUpItemDescription setFont:[UIFont systemFontOfSize:12]];
       
        
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
        //[self.view addGestureRecognizer:tap];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)setProductDetailValue
{
    @try{
        NSString *str;
        if(_isTopProduct){
            if([[self.dicProductDetailValue allKeys] containsObject:@"image_url"])
                str = [self.dicProductDetailValue valueForKey:@"image_url"];
            else
                str = [self.dicProductDetailValue valueForKey:@"imageurl"];
        }
        
        else{
            if([[self.dicProductDetailValue allKeys] containsObject:@"image_url"])
                str = [self.dicProductDetailValue valueForKey:@"image_url"];
            else
                str = [self.dicProductDetailValue valueForKey:@"imageurl"];
        }
        
            if(str.length>0)
        {
                        self.imgProduct.contentMode = UIViewContentModeScaleAspectFit;
            
            [self.imgProduct setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            [self.imgPopProduct setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
                      self.imgPopProduct.contentMode = UIViewContentModeScaleAspectFit;
                   }
        
        
     
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"price"]])
            self.lblPrice.text=[NSString stringWithFormat:@"$%@ per 1 lb",[self.dicProductDetailValue valueForKey:@"price"]];
        strlblPrice=[self.dicProductDetailValue valueForKey:@"price"];
        strlblPrice=[NSString stringWithFormat:@"%@",self.lblPrice];
              self.lblPrice.text=[NSString stringWithFormat:@"%ld per 1 lb", (long)strlblPrice * numberOfProducts];
        
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"name"]])
            self.lblName.text=[self.dicProductDetailValue valueForKey:@"name"];
        
        self.lblName.lineBreakMode=NSLineBreakByWordWrapping;
        self.lblName.numberOfLines =0;

        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"weight"]])
            self.lblWaight.text=[self.dicProductDetailValue valueForKey:@"weight"];
        
        if([OBJGlobal isNotNull:[self.dicProductDetailValue valueForKey:@"description"]])
            self.txtViewPopUpItemDescription.text=[self.dicProductDetailValue valueForKey:@"description"];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnAddToCartPressed:(id)sender
{
    @try{
        
        if(GETBOOL(@"isUserHasLogin")==false){
            NSMutableDictionary *dictProductDetail = [[NSMutableDictionary alloc] initWithDictionary:self.dicProductDetailValue];
            int product = [[NSString stringWithFormat:@"%ld",(long)numberOfProducts] intValue];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%d",product] forKey:@"qty"];
            
            NSString *strPrice = [self.dicProductDetailValue valueForKey:@"price"];
            float price = [strPrice floatValue] *numberOfProducts;
            [dictProductDetail setObject:[NSString stringWithFormat:@"%.2f",price] forKey:@"price"];
            
            if(![[dictProductDetail allKeys] containsObject:@"unit"])
                [ dictProductDetail setObject:@"" forKey:@"dictProductDetail"];
            
            NSString *weight = [self.dicProductDetailValue valueForKey:@"weight"];
            [dictProductDetail setObject:[NSString stringWithFormat:@"%@",weight] forKey:@"weight"];
            
            [self insertProductToLocalDataBase:dictProductDetail];
        }
        if(GETBOOL(@"isUserHasLogin")==true){
            [APPDATA showLoader];
            Users *objUsers = OBJGlobal.user;
            if ([[self.dicProductDetailValue allKeys] containsObject:@"id"])
                // contains key
                objUsers.prodid = [self.dicProductDetailValue valueForKey:@"id"];
            if([[self.dicProductDetailValue allKeys] containsObject:@"prod_id"])
                objUsers.prodid = [self.dicProductDetailValue valueForKey:@"prod_id"];
            objUsers.sku=[[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"sku"]] mutableCopy];
            objUsers.qty=[[NSString stringWithFormat:@"%@",self.lblQntity.text] mutableCopy];
            
            objUsers.flag =[OBJGlobal checkForFlagEditOrUpdate:OBJGlobal.aryKartDataGlobal dictForItemToCheck:self.dicProductDetailValue];
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
                
                objUsers.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
                    [objUsers cartAction:^(NSDictionary *user, NSString *str, int status)
                 {
                     if (status == 1) {
                         
                         [APPDATA hideLoader];
                         OBJGlobal.aryKartDataGlobal=nil;
                         
                         //   [self.view makeToast:@"Product added to cart successfully"];
                         OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[user valueForKey:@"cartitems"]];
                         OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
                         
                         [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:user];
                         [self performSelector:@selector(popCurrentController) withObject:nil afterDelay:1.5];
                         
                         
                         //                         NSMutableArray *totalKartProduct = [[NSMutableArray alloc] initWithArray:OBJGlobal.aryKartDataGlobal];
                         
                         //                         NSDictionary *parameters=[[NSDictionary alloc]init];
                         // NSDictionary *parameetrs =[[NSDictionary alloc] initWithObjects:@[self.zipCode] forKeys:@[@"key"]];
                         
                         //                         [self insertProductToLocalDataBase:[parameters mutableCopy]];
                         
                         NSLog(@"success");
                         
                         return ;
                         //dicContactUs =[user objectForKey:@"msg"];
                         //                DashboardViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                         //                [self.navigationController pushViewController:objDashboardViewController animated:NO];
                         
                     }
                     else {
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
-(void)popCurrentController
{
    OBJGlobal.aryKartDataGlobal = [[NSMutableArray alloc] init];
    [self.navigationController popViewControllerAnimated:true];
    
}

-(void)popImageView:(UITapGestureRecognizer*)sender
{
    
    [self.viewImage setHidden:NO];
    
}
-(IBAction)btnCancelPressed:(id)sender;
{
    
    [self.viewImage setHidden:YES];
}


-(void)toggleHidden:(BOOL)toggle{
    int alpha = toggle?0:1;
    [UIView animateWithDuration:0.3f animations:^{
        self.popUpMainView.alpha = alpha;
    }];
}

- (IBAction)btnMinusPressed:(id)sender {
    @try{
        if(numberOfProducts<=1)
            return;
        numberOfProducts--;
        self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
        
        NSString *strPrice =[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"price"]];
        float price = [strPrice floatValue];
        self.lblPrice.text =[NSString stringWithFormat:@"$%.2f  per 1 lb",price*numberOfProducts];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (IBAction)btnPlusPressed:(id)sender {
    @try{
        numberOfProducts++;
        self.lblQntity.text = [NSString stringWithFormat:@"%ld",(long)numberOfProducts];
        
        NSString *strPrice =[NSString stringWithFormat:@"%@",[self.dicProductDetailValue valueForKey:@"price"]];
        float price = [strPrice floatValue];
        self.lblPrice.text =[NSString stringWithFormat:@"$%.2f  per 1 lb",price*numberOfProducts];
        
        
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
        if([[self.dicProductDetailValue allKeys] containsObject:@"prod_id"])
            [dictProductDetail setObject:[dict valueForKey:@"prod_id"] forKey:@"id"];
        
        if([[self.dicProductDetailValue allKeys] containsObject:@"prod_in_cart"])
            [dictProductDetail setObject:[NSString stringWithFormat:@"%ld",(long)numberOfProducts] forKey:@"prod_in_cart"];
        
        //
        //        NSString *strUrl;
        //        NSData *data;
        //        if([[dict allKeys] containsObject:@"imageurl"]){
        //            strUrl = [dict valueForKey:@"imageurl"];
        //            [dict setObject:strUrl forKey:@"image_url"];
        //            data = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
        //            [dict removeObjectForKey:@"imageurl"];
        //        }
        //        else{
        //            strUrl = [dict valueForKey:@"image_url"];
        //            data = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
        //        }
        
        //        NSString* strImageData1 = [Base64 encode:data];
        //        [dict setObject:@"" forKey:@""];
        // [dict setObject:strImageData1 forKey:@"thumb_CompanyImage"];
        if([dataBaseHelper insertproductdData:dictProductDetail])
        {
            //   [self.view makeToast:@"Product added to Cart"];
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
                    localDBProductCount = numberOfProducts;
                    [dictProductDetail setObject:[NSString stringWithFormat:@"%d",localDBProductCount]  forKey:@"qty"];
                }
            }];
            [dataBaseHelper updateproductdData:[dictProductDetail valueForKey:@"id"] dictData:dictProductDetail];
            //     [self.view makeToast:@"Product Updated successful"];
            
        }
        
        OBJGlobal.aryKartDataGlobal =  [[dataBaseHelper fetchAllProductDataFromLocalDB] mutableCopy];
        OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu",(unsigned long)[OBJGlobal.aryKartDataGlobal count]] mutableCopy];
        [btnBadgeCount setTitle:[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] forState:UIControlStateNormal];
        
        //        NSArray *data = [[dbAccess fetchAllProductDataFromLocalDB] mutableCopy];
        //
        //        NSLog(@"data %@",data);
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

@end
