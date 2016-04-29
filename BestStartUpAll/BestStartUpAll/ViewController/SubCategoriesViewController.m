//
//  SubCategoriesViewController.m
//  peter
//
//  Created by Peter on 1/4/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import "SubCategoriesViewController.h"
#import "BeaverageCollectionViewCell.h"
#import "UIViewController+NavigationBar.h"
#import "Constant.h"
#import "LocationViewController.h"
#import "ADPageControl.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"
#import "UIView+Toast.h"
#import "FMDBDataAccess.h"
//#import "ImageWithURL.h"
#import "SDSegmentedControl.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "SpecialRequestViewController.h"
#pragma mark SUB CATEGORY CONTROLLER IMPLEMENTATION

@interface SubCategoriesViewController ()<PopUpDelegate,ADPageControlDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,PopUpDelegate>
{
    ADPageControl   *_pageControl;
    Globals *OBJGlobal;
    NSArray *arrBrandList;
    Users *objSubCategory;
    NSMutableArray *arrTopProductList;
    UIButton *btnBadgeCount;
    UITapGestureRecognizer *recognizer;
    FMDBDataAccess *dbAccess;
    NSMutableArray *aryTopProductList;
    NSMutableArray *arrTopBarProductList;
    BOOL isResponseRecievedForFirstTime;
    NSArray *handleBadgeWithoutLogin;
    int pageNoCount;
    NSString *totalPage;
    NSString *BrandMsg;
    BOOL isRecievedMemoryWarning;
    float heightLastestForCollectionTwo;
    UIRefreshControl *refreshControl;
    NSMutableDictionary *dictForLastObject;
    
}

@property (nonatomic, strong) NSMutableArray *aryCategoryAssignProductList;

@property (nonatomic, strong) NSMutableArray *aryDropDownList;

@end

@implementation SubCategoriesViewController
@synthesize spinner;
- (void)viewDidLoad {
    @try{
        [super viewDidLoad];
        heightLastestForCollectionTwo=0;
        isRecievedMemoryWarning=false;
        isResponseRecievedForFirstTime=false;
        _scrollView.delegate=self;
        _lblNoProduct.hidden=true;
        if(!OBJGlobal)
            OBJGlobal = [Globals sharedManager];
        dbAccess= [[FMDBDataAccess alloc]init];
        arrTopProductList = [[NSMutableArray alloc] init];
        OBJGlobal = [Globals sharedManager];
        aryTopProductList = [[NSMutableArray alloc] init];
        self.aryDropDownList = [[NSMutableArray alloc] init];
        arrTopBarProductList = [[NSMutableArray alloc] init];
        [self setMenuIconForSideBar:@"cal"];
        btnBadgeCount =  [self setUpImageThirdRightButton:@"menu" secondImage:@"search" thirdImage:@"logo" badgeCount:[[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] integerValue] fouthImage:@"brand"];
        _roundedPopUpView.layer.masksToBounds = YES;
        _roundedPopUpView.layer.cornerRadius = 15;
        _popUpItemDescription.hidden=true;
        [self loadPopUpTable];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        
        if ([self.view viewWithTag:11]) {
            [[self.view viewWithTag:11] removeFromSuperview];
        }
        _segmentedControl.hidden=true;
        
        refreshControl = [[UIRefreshControl alloc]init];
        
        [spinner stopAnimating];
        spinner.hidesWhenStopped = NO;
        spinner.hidden=true;
        _viewRefresh.hidden=true;
        self.collectionViewOne.delegate=self;
        self.collectionViewTwo.delegate=self;
        self.aryCategoryAssignProductList= [[NSMutableArray alloc] init];
        totalPage = [NSString stringWithFormat:@"%d",1];
        pageNoCount=1;
        
        [self initPlaceRequestData];
        objSubCategory = OBJGlobal.user;
        
        [self getCartListForBadgeCount];
        [self getTopBarNameList];
        [self getBrandListResponseMethod];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)refershControlAction:(UIRefreshControl*)sender{
    [sender endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated

{
    @try{
        [self setMenuIconForSideBar:@"cal"];
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 44, 56)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:17];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        label.text = OBJGlobal.lblSubCategoryName;
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        _popUpItemDescription.hidden=true;
        [self.objPopUpTableController toggleHidden:YES];
        
        [OBJGlobal setTitleForBadgeCountOnViewAppears:btnBadgeCount];
        _popUpItemDescription.hidden=true;
        
        if([OBJGlobal.aryKartDataGlobal count]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
        handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:OBJGlobal.aryKartDataGlobal];
        
        if(GETBOOL(@"isUserHasLogin")==false){
            
            NSArray *arrLocalKartData = [dbAccess fetchAllProductDataFromLocalDB] ;
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:arrLocalKartData];
            OBJGlobal.aryKartDataGlobal = [NSMutableArray arrayWithArray:arrLocalKartData];
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
            
        }
        if(aryTopProductList.count==0 || self.aryCategoryAssignProductList==0){
            if(isResponseRecievedForFirstTime){
                [self topProductListMethod];
            }
        }
        _viewRefresh.hidden=YES;
        [self setUpContentData];
        [self.collectionViewOne reloadData];
        [self.collectionViewTwo reloadData];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)getCartListForBadgeCount
{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true && OBJGlobal.isProductAddedToKart){
            
            [APPDATA showLoader];
            Users *objmyCart = OBJGlobal.user;
            
            [objmyCart myCartList:^(NSDictionary *result, NSString *str, int status)
             {
                 if ([[result allKeys] containsObject:@"cartitems"]) {
                     
                     if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                         OBJGlobal.aryKartDataGlobal=nil;
                         OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                         OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                         [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                     }
                     
                     [APPDATA hideLoader];
                     
                     NSLog(@"success");
                 }
                 else {
                     // [self.view makeToast:[user objectForKey:@"msg"]];
                     NSLog(@"Failed");
                     [APPDATA hideLoader];
                 }
             }];
            
        }if(GETBOOL(@"isUserHasLogin")==false){
            NSArray *arrLocalKartData = [dbAccess fetchAllProductDataFromLocalDB] ;
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:arrLocalKartData];
            OBJGlobal.aryKartDataGlobal = [NSMutableArray arrayWithArray:arrLocalKartData];
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
- (IBAction)segmentDidChange:(id)sender
{
    @try{
        
        NSInteger index =  [[NSString stringWithFormat:@"%ld", self.segmentedControl.selectedSegmentIndex] integerValue];
        _popUpItemDescription.hidden=true;
        
        OBJGlobal.cat_id_TopBarSubCategory = [[NSString stringWithFormat:@"%@",[[arrTopBarProductList objectAtIndex:index] valueForKey:@"category_id"]] mutableCopy];
        OBJGlobal.cat_id_PopularBrandSubCategory = OBJGlobal.cat_id_TopBarSubCategory;
        
        
        pageNoCount=1;
        totalPage = [NSString stringWithFormat:@"%d",1];
        [APPDATA showLoader];
        [self topProductListMethod];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}



-(void)getTopBarNameList
{
    @try{
        [APPDATA showLoader];
        
        [objSubCategory topBarProductList:^(NSDictionary *result, NSString *str, int status) {
            
            if([[result allKeys] containsObject:@"data"])
            {
                _segmentedControl.hidden=false;
                _segmentedControl.backgroundColor=  [UIColor colorWithPatternImage:[UIImage imageNamed:@"header"]];
                
                NSArray *arrayResponse = [[NSArray alloc] init];
                NSDictionary *allStrDict = @{@"category_name":@"All",@"category_id":OBJGlobal.cat_id_TopBarSubCategory,@"category_image":@""};
                if([arrTopBarProductList isKindOfClass:[NSArray class]])
                    arrTopBarProductList = [[NSMutableArray alloc] init];
                [arrTopBarProductList addObject:allStrDict];
                
                if([OBJGlobal isNotNull:[result valueForKey:@"data"]])
                    arrayResponse =[result valueForKey:@"data"];
                [arrTopBarProductList addObjectsFromArray:arrayResponse];
                
                [arrTopBarProductList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    [self.segmentedControl insertSegmentWithTitle:[[arrTopBarProductList objectAtIndex:idx] valueForKey:@"category_name"] atIndex:idx animated:YES];
                    if(idx==0){
                        self.segmentedControl.selected=true;
                    }
                    
                }];
                self.segmentedControl.selectedSegmentIndex=0;
                
                isResponseRecievedForFirstTime=true;
                [APPDATA showLoader];
                [self topProductListMethod];
                
            }
            else{
                [APPDATA hideLoader];
                
                if([OBJGlobal isNotNull:[result valueForKey:@"msg"]])
                    [self.view makeToast:[result valueForKey:@"msg"]];
                
                if(aryTopProductList.count==0)
                    _lblNoProduct.hidden=false;
                else
                    _lblNoProduct.hidden=true;
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)onSelectColor {
    UIColor *yourColor = [UIColor colorWithRed:77.0f/255.0f green:22.0f/255.0f blue:114.0f/255.0f alpha:1];
    
    [_segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName :yourColor} forState:UIControlStateSelected];
    
    
}



-(void)gestureAction:(UITapGestureRecognizer *) sender
{
    @try{
        
        CGPoint touchLocationOnCollectionTwo = [sender locationOfTouch:0 inView:self.collectionViewTwo];
        
        NSIndexPath *indexPath = [self.collectionViewTwo indexPathForItemAtPoint:touchLocationOnCollectionTwo];
        __block NSDictionary *dic;
        if(indexPath.row>self.aryCategoryAssignProductList.count)
            return;
        
        if(self.scrollView.contentOffset.y>600 && indexPath.row==0)
        {
            return;
        }
        dic=[self.aryCategoryAssignProductList objectAtIndex:indexPath.row];
        if([[dic valueForKey:@"name"] isEqualToString:@"Can't find what you are looking for?"]){
            UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SpecialRequestViewController *objDashboardViewController=(SpecialRequestViewController *)[storybord  instantiateViewControllerWithIdentifier:@"SpecialRequestViewController"];
            [self.navigationController pushViewController:objDashboardViewController animated:YES];
            
            return;
        }
        
        [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            NSString *strId;
            if([[obj allKeys] containsObject:@"id"])
                strId = [obj valueForKey:@"id"];
            else
                strId = [obj valueForKey:@"prod_id"];
            
            if([strId isEqualToString:[dic valueForKey:@"id"]] && [[dic allKeys] containsObject:@"id"]){
                dic=obj;
            }
            else if([strId isEqualToString:[dic valueForKey:@"prod_id"]] && [[dic allKeys] containsObject:@"prod_id"])
            {
                dic=obj;
                
            }
        }];
        
        OBJGlobal.objMainPopUp.dicProductDetailValue=[dic mutableCopy];
        OBJGlobal.objMainPopUp.isTopProduct=false;
        [OBJGlobal.objMainPopUp initDataForPopUp];
        [OBJGlobal.objMainPopUp toggleHidden:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)setUpContentData
{
    @try{
        if(OBJGlobal.objMainPopUp){
            [OBJGlobal.objMainPopUp removeFromSuperview];
            OBJGlobal.objMainPopUp=nil;
        }
        if (!OBJGlobal.objMainPopUp) {
            UINib * mainView = [UINib nibWithNibName:@"CommonPopUpView" bundle:nil];
            OBJGlobal.objMainPopUp = (CommonPopUpView *)[mainView instantiateWithOwner:self options:nil][0];
            OBJGlobal.objMainPopUp.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            
            OBJGlobal.objMainPopUp.commonPopUpContentView.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
            [OBJGlobal.objMainPopUp initDataForPopUp];
            OBJGlobal.objMainPopUp.backgroundColor = [UIColor clearColor];
            [self.view insertSubview:OBJGlobal.objMainPopUp atIndex:1000];
            [OBJGlobal.objMainPopUp toggleHidden:YES];
        }
        else{
            [OBJGlobal.objMainPopUp toggleHidden:YES];
            [OBJGlobal.objMainPopUp initDataForPopUp];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //MANAGE HEIGHT OF THE EACH IMAGE IN THE CELL
    return CGSizeMake((DEVICE_WIDTH/3)-30, 200);
}

-(void)setnavigationImage:(NSString *)strImageName
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:strImageName] forBarMetrics:UIBarMetricsDefault];
}

- (IBAction)btnClosePopUpPressed:(id)sender {
    _popUpItemDescription.hidden=true;
    _viewRefresh.hidden=YES;
}

- (IBAction)btnAddItemPressed:(id)sender {
}

- (IBAction)btnMinuItemPressed:(id)sender {
}

#pragma mark POPUP CLOSE
-(void)btnClosePopUp
{
    _popUpItemDescription.hidden=true;
}
#pragma mark --UICollectionViewDelegateFlowLayout

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    @try{
        if(collectionView==self.collectionViewOne){
            
            return [aryTopProductList count];
        }
        if(collectionView==self.collectionViewTwo){
            return [self.aryCategoryAssignProductList count];
        }
        return 0;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        SubcategoryCell *cell;
        __block NSDictionary *dictProductDetail=nil;
        __block NSString *strProductBadgeCount=nil;
        __block UILabel *lblProductName=nil;
        __block UILabel *lblBrand=nil;
        __block UILabel *lblWeight=nil;
        __block UILabel *lblBadgeCount=nil;
        __block UIImageView *imgProductbadge=nil;
        __block UILabel *lblPrice=nil;
        __block NSString *strProductNameAndBrand=nil;
        __block UIImageView *imageProduct=nil;
        __block UILabel *lblDiscountPrice=nil;
        __block UILabel *lblOrignoalPrice=nil;
        __block UIButton *btnPlacereqeust=nil;
        __block NSString *strId=nil;
        
        if(collectionView==self.collectionViewOne){
            
            static NSString *identifier = @"SubcategoryCell";
            cell = (SubcategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            
            if (cell == nil) {
                [self.collectionViewOne registerClass:[SubcategoryCell class] forCellWithReuseIdentifier:@"SubcategoryCell"];
                
            }
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            CGSize size = cell.bounds.size;
            dictProductDetail = [aryTopProductList objectAtIndex:indexPath.row];
            
            NSString *srtURL=nil;
            
            if([[dictProductDetail allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"image_url"]])
                srtURL = [dictProductDetail valueForKey:@"image_url"];
            else if([[dictProductDetail allKeys] containsObject:@"imageurl"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"imageurl"]])
                srtURL = [dictProductDetail valueForKey:@"imageurl"];
            
            imageProduct = (UIImageView *)[cell viewWithTag:indexPath.row+65612];
            if(!imageProduct){
                imageProduct = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height/2)];
                imageProduct.tag=indexPath.row+65612;
                if(!srtURL.length>0)
                    srtURL = [[[dictProductDetail valueForKey:@"multiple_images"] objectAtIndex:0] valueForKey:@"multiple"];
                
                if(imageProduct){
                    imageProduct.contentMode = UIViewContentModeScaleAspectFit;
                    [imageProduct setImageWithURL:[NSURL URLWithString:srtURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }
                [cell.contentView addSubview:imageProduct];
            }
            
            lblProductName = (UILabel*)[cell viewWithTag:500+indexPath.row];
            if(!lblProductName)
            {
                lblProductName = [[UILabel alloc]initWithFrame:CGRectMake(0, (size.height/2), size.width,65)];
                lblProductName.tag=500+indexPath.row;
                lblProductName.lineBreakMode=NSLineBreakByWordWrapping;
                lblProductName.numberOfLines =0;
                lblProductName.textAlignment = NSTextAlignmentCenter;
                lblProductName.font =   [UIFont fontWithName:@"Avenir-Book" size:12];
                
                [cell.contentView addSubview:lblProductName];
            }
            
            
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"name"]]){
                NSString *strBrandName;
                if([OBJGlobal isNotNull:[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"brand"]]]){
                    strBrandName =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"brand"]];
                    NSString *strspace = [strBrandName stringByAppendingString:@" "];
                    
                    strProductNameAndBrand= [strspace stringByAppendingString:[dictProductDetail valueForKey:@"name"]];
                    
                    lblProductName.text=strProductNameAndBrand;
                    
                }
                else
                {
                    lblProductName.text=[dictProductDetail valueForKey:@"name"];
                }
            }
            
            lblWeight = (UILabel*)[cell viewWithTag:1000+indexPath.row];
            if(!lblWeight)
            {
                lblWeight = [[UILabel alloc]initWithFrame:CGRectMake(0, lblProductName.frame.origin.y+lblProductName.frame.size.height, size.width,15)];
                lblWeight.tag=1000+indexPath.row;
                lblWeight.lineBreakMode=NSLineBreakByWordWrapping;
                lblWeight.numberOfLines =0;
                lblWeight.textColor=[UIColor grayColor];
                lblWeight.textAlignment = NSTextAlignmentCenter;
                lblWeight.font = [UIFont fontWithName:@"Avenir-Book" size:12];
                
                [cell.contentView addSubview:lblWeight];
            }
            
            NSString *strWeight;
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"weight"]]){
                if(lblWeight){
                    strWeight = [dictProductDetail valueForKey:@"weight"];
                    if([strWeight isEqualToString:@"lbs"] || [strWeight isEqualToString:@" lbs"])
                        strWeight = [NSString stringWithFormat:@"1 lbs"];
                    lblWeight.text=strWeight;
                    lblWeight.lineBreakMode=YES;
                }else{
                    strWeight = [dictProductDetail valueForKey:@"weight"];
                    if([strWeight isEqualToString:@"lbs"] || [strWeight isEqualToString:@" lbs"])
                        strWeight = [NSString stringWithFormat:@"1 lbs"];
                    lblWeight.text=strWeight;
                }
            }
            lblBadgeCount = (UILabel*)[cell viewWithTag:1500+indexPath.row];
            cell.lblPrice.tag=30000+indexPath.row;
            
            lblPrice = (UILabel*)[cell viewWithTag:30000+indexPath.row];
            if(!lblPrice)
            {
                lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0,size.height-15, size.width,15)];
                lblPrice.tag=30000+indexPath.row;
                lblPrice.textColor=[UIColor orangeColor];
                lblPrice.font = [UIFont fontWithName:@"Avenir-Black" size:16];
                lblPrice.lineBreakMode=NSLineBreakByWordWrapping;
                lblPrice.numberOfLines =0;
                lblPrice.textAlignment = NSTextAlignmentCenter;
                
                [cell.contentView addSubview:lblPrice];
            }
            
            NSString *strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
            float price = [strPrice floatValue];
            NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"discount_price"]];
            //            cell.lblDiscountPrice.tag=70000+indexPath.row;
            lblDiscountPrice = (UILabel*)[cell viewWithTag:indexPath.row+70000];
            if(!lblDiscountPrice){
                if(IS_IPHONE_4 || IS_IPHONE_5)
                {
                    lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2-22,size.height-15, size.width,15)];
                }
                else
                {
                    lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2-25,size.height-15, size.width,15)];

                }
               // lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2-25,size.height-15, size.width,15)];
                lblDiscountPrice.tag=indexPath.row+70000;
                lblDiscountPrice.font = [UIFont fontWithName:@"Avenir-Black" size:16];
                [lblDiscountPrice setTextColor:[UIColor orangeColor]];
                [lblDiscountPrice setHidden:YES];
                lblDiscountPrice.lineBreakMode=NSLineBreakByWordWrapping;
                lblDiscountPrice.numberOfLines =0;
                lblDiscountPrice.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lblDiscountPrice];
                
            }
            
            cell.lblBadgeCount.tag=400010+indexPath.row;
            cell.imgProductbadge.tag=480010+indexPath.row;
            lblBadgeCount = (UILabel*)[cell viewWithTag:400010+indexPath.row];
            imgProductbadge = (UIImageView*)[cell viewWithTag:480010+indexPath.row];
            if(!imgProductbadge)
            {
                imgProductbadge = [[UIImageView alloc]initWithFrame:CGRectMake(size.width-imageProduct.frame.size.width/2.2,0, imageProduct.frame.size.width/2.2, imageProduct.frame.size.height/3.2)];
                imgProductbadge.tag=480010+indexPath.row;
                [cell.contentView addSubview:imgProductbadge];
            }
            
            if(!lblBadgeCount)
            {
                lblBadgeCount = [[UILabel alloc]initWithFrame:CGRectMake(size.width-imageProduct.frame.size.width/2.2+8,0, imageProduct.frame.size.width/2.2, imageProduct.frame.size.height/3.2)];
                lblBadgeCount.tag=400010+indexPath.row;
                lblBadgeCount.textAlignment = NSTextAlignmentCenter;
                lblBadgeCount.textColor=[UIColor whiteColor];
                [cell.contentView addSubview:lblBadgeCount];
            }
            
            if(lblBadgeCount){
                lblBadgeCount.hidden=true;
                lblBadgeCount.text = [NSString stringWithFormat:@"%d",[strProductBadgeCount intValue]];
                
            }
            
            if(imgProductbadge){
                imgProductbadge.hidden=true;
            }
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                strId=nil;
                strProductBadgeCount=nil;
                if([[obj allKeys] containsObject:@"id"])
                    strId = [obj valueForKey:@"id"];
                else
                    strId = [obj valueForKey:@"prod_id"];
                
                if([strId isEqualToString:[dictProductDetail valueForKey:@"id"]] && [[dictProductDetail allKeys] containsObject:@"id"]){
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else  if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                    
                }
                else if([strId isEqualToString:[dictProductDetail valueForKey:@"prod_id"]] && [[dictProductDetail allKeys] containsObject:@"prod_id"])
                {
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                }
                
                if([strProductBadgeCount intValue]>0){
                    if([strProductBadgeCount intValue]>99)
                        lblBadgeCount.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBlack];
                    else
                        lblBadgeCount.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBlack];
                    
                    lblBadgeCount.hidden=false;
                    lblBadgeCount.text = [NSString stringWithFormat:@"%d",[strProductBadgeCount intValue]];
                    imgProductbadge.hidden=false;
                    imgProductbadge.image=[UIImage imageNamed:@"kart-badge"];
                    *stop = YES;    // Stop enumerating
                    return ;
                    
                }
            }];
            
            if([[dictProductDetail allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
            {
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                    //                    [lblDiscountPrice setHidden:NO];
                    [lblPrice setHidden:NO];
                    [lblDiscountPrice setHidden:NO];
                    lblPrice.font = [UIFont fontWithName:@"Avenir-Medium" size:12];
                    lblDiscountPrice.font = [UIFont fontWithName:@"Avenir-Black" size:14];
                    if(IS_IPHONE_4 || IS_IPHONE_5){
                        lblPrice.frame = CGRectMake(-2, size.height-15, size.width/2, 15);
                    }
                    else{
                        lblPrice.frame = CGRectMake(5, size.height-15, size.width/2, 15);
                    }
                    lblPrice.text=[NSString stringWithFormat:@"$%.2f",[[dictProductDetail valueForKey:@"price"]floatValue]];
                    lblPrice.textColor=[UIColor grayColor];
                    
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f",price]];
                    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                            value:[NSNumber numberWithInt:1]
                                            range:(NSRange){0,[attributeString length]}];
                    [lblPrice setAttributedText:attributeString];
                }
                
                
                if(lblDiscountPrice){
                    [lblDiscountPrice setHidden:NO];
                    [lblPrice setHidden:NO];
                    lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                }
            }
            else
            {
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                    [lblPrice setHidden:NO];
                    [lblDiscountPrice setHidden:NO];
                    lblPrice.text=[NSString stringWithFormat:@"$%.2f",[[dictProductDetail valueForKey:@"price"]floatValue]];
                }
            }
            
            return cell;
        }
        
        else if(collectionView==self.collectionViewTwo){
            
            static NSString *identifier = @"SubcategoryCell";
            cell = (SubcategoryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
            if (cell == nil) {
                [self.collectionViewTwo registerClass:[SubcategoryCell class] forCellWithReuseIdentifier:@"SubcategoryCell"];
            }
            if(isRecievedMemoryWarning)
                return cell;
            
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
            dictProductDetail = [self.aryCategoryAssignProductList objectAtIndex:indexPath.row];
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            CGSize size = cell.bounds.size;
            
            imageProduct = (UIImageView *)[cell viewWithTag:indexPath.row+85612];
            if(!imageProduct){
                imageProduct = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height/2)];
                imageProduct.tag=indexPath.row+85612;
                
                NSString *srtURL;
                if([[dictProductDetail allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"image_url"]])
                    srtURL = [dictProductDetail valueForKey:@"image_url"];
                else if([[dictProductDetail allKeys] containsObject:@"imageurl"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"imageurl"]])
                    srtURL = [dictProductDetail valueForKey:@"imageurl"];
                
                if(!srtURL.length>0)
                    srtURL = [[[dictProductDetail valueForKey:@"multiple_images"] objectAtIndex:0] valueForKey:@"multiple"];
                
                if(imageProduct){
                    imageProduct.contentMode = UIViewContentModeScaleAspectFit;
                    [imageProduct setImageWithURL:[NSURL URLWithString:srtURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }
                [cell.contentView addSubview:imageProduct];
            }
            
            
            lblProductName = (UILabel*)[cell viewWithTag:3500+indexPath.row];
            if(!lblProductName)
            {
                lblProductName = [[UILabel alloc]initWithFrame:CGRectMake(0, (size.height/2), size.width,65)];
                lblProductName.tag=3500+indexPath.row;
                lblProductName.lineBreakMode=NSLineBreakByWordWrapping;
                lblProductName.numberOfLines =0;
                lblProductName.textAlignment = NSTextAlignmentCenter;
                lblProductName.font =   [UIFont fontWithName:@"Avenir-Book" size:12];
                
                [cell.contentView addSubview:lblProductName];
            }
            
            
            lblWeight = (UILabel*)[cell viewWithTag:5500+indexPath.row];
            if(!lblWeight)
            {
                lblWeight = [[UILabel alloc]initWithFrame:CGRectMake(0, lblProductName.frame.origin.y+lblProductName.frame.size.height, size.width,15)];
                lblWeight.tag=5500+indexPath.row;
                lblWeight.lineBreakMode=NSLineBreakByWordWrapping;
                lblWeight.numberOfLines =0;
                lblWeight.textColor=[UIColor grayColor];
                lblWeight.textAlignment = NSTextAlignmentCenter;
                lblWeight.font = [UIFont fontWithName:@"Avenir-Book" size:12];
                [cell.contentView addSubview:lblWeight];
            }
            cell.lblWeight.tag=5500+indexPath.row;
            
            lblWeight = (UILabel*)[cell viewWithTag:5500+indexPath.row];
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"weight"]]){
                
                NSString *strWeight;
                if(lblWeight){
                    strWeight = [dictProductDetail valueForKey:@"weight"];
                    if([strWeight isEqualToString:@"lbs"] || [strWeight isEqualToString:@" lbs"])
                        strWeight = [NSString stringWithFormat:@"1 lbs"];
                    lblWeight.text=strWeight;
                }
                else{
                    strWeight = [dictProductDetail valueForKey:@"weight"];
                    if([strWeight isEqualToString:@"lbs"] || [strWeight isEqualToString:@" lbs"])
                        strWeight = [NSString stringWithFormat:@"1 lbs"];
                    lblWeight.text=strWeight;
                }
            }
            
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"brand"]]){
                if(lblBrand){
                    
                    lblBrand.text=[dictProductDetail valueForKey:@"brand"];
                    
                }else{
                    lblBrand.text = [dictProductDetail valueForKey:@"brand"];
                }
            }
            
            if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"name"]]){
                
                NSString *brandName;
                if([OBJGlobal isNotNull:[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"brand"]]]){
                    brandName =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"brand"]];
                    NSString *strspace = [brandName stringByAppendingString:@" "];
                    
                    strProductNameAndBrand= [strspace stringByAppendingString:[dictProductDetail valueForKey:@"name"]];
                    
                    lblProductName.text=strProductNameAndBrand;
                    lblProductName.lineBreakMode=NSLineBreakByWordWrapping;
                    lblProductName.numberOfLines =0;
                }
                else
                {
                    lblProductName.text=[dictProductDetail valueForKey:@"name"];
                }
            }
            
            imgProductbadge = (UIImageView*)[cell viewWithTag:980010+indexPath.row];
            if(!imgProductbadge)
            {
                imgProductbadge = [[UIImageView alloc]initWithFrame:CGRectMake(size.width-imageProduct.frame.size.width/2.2,0, imageProduct.frame.size.width/2.2, imageProduct.frame.size.height/3.2)];
                imgProductbadge.tag=980010+indexPath.row;
                [cell.contentView addSubview:imgProductbadge];
            }
            lblBadgeCount = (UILabel*)[cell viewWithTag:600010+indexPath.row];
            
            if(!lblBadgeCount)
            {
                lblBadgeCount = [[UILabel alloc]initWithFrame:CGRectMake(size.width-imageProduct.frame.size.width/2.2+8,0, imageProduct.frame.size.width/2.2, imageProduct.frame.size.height/3.2)];
                lblBadgeCount.tag=600010+indexPath.row;
                lblBadgeCount.textAlignment = NSTextAlignmentCenter;
                lblBadgeCount.textColor=[UIColor whiteColor];
                [cell.contentView addSubview:lblBadgeCount];
            }
            
            if(lblBadgeCount){
                lblBadgeCount.hidden=true;
                lblBadgeCount.text = [NSString stringWithFormat:@"%d",[strProductBadgeCount intValue]];
            }
            
            if(imgProductbadge){
                imgProductbadge.hidden=true;
            }
            
            
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                strId=nil;
                strProductBadgeCount=nil;
                if([[obj allKeys] containsObject:@"id"])
                    strId = [obj valueForKey:@"id"];
                else
                    strId = [obj valueForKey:@"prod_id"];
                
                if([strId isEqualToString:[dictProductDetail valueForKey:@"id"]] && [[dictProductDetail allKeys] containsObject:@"id"]){
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else  if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                    
                }
                else if([strId isEqualToString:[dictProductDetail valueForKey:@"prod_id"]] && [[dictProductDetail allKeys] containsObject:@"prod_id"])
                {
                    
                    
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                }
                
                if([strProductBadgeCount intValue]>0){
                    
                    if([strProductBadgeCount intValue]>99)
                        lblBadgeCount.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBlack];
                    else
                        lblBadgeCount.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBlack];
                    lblBadgeCount.hidden=false;
                    lblBadgeCount.text = [NSString stringWithFormat:@"%d",[strProductBadgeCount intValue]];
                    imgProductbadge.hidden=false;
                    imgProductbadge.image=[UIImage imageNamed:@"kart-badge"];
                    *stop = YES;    // Stop enumerating
                    return;
                    
                }
            }];
            
            lblPrice = (UILabel*)[cell viewWithTag:6000+indexPath.row];
            if(!lblPrice)
            {
                lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0,size.height-15, size.width,15)];
                lblPrice.tag=6000+indexPath.row;
                lblPrice.textColor=[UIColor orangeColor];
                lblPrice.font = [UIFont fontWithName:@"Avenir-Black" size:16];
                lblPrice.lineBreakMode=NSLineBreakByWordWrapping;
                lblPrice.numberOfLines =0;
                lblPrice.textAlignment = NSTextAlignmentCenter;
                
                [cell.contentView addSubview:lblPrice];
            }
            
            lblDiscountPrice = (UILabel*)[cell viewWithTag:indexPath.row+90000];
            if(!lblDiscountPrice){
              if(IS_IPHONE_4 || IS_IPHONE_5)
              {
                  lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2-20,size.height-15, size.width,15)];
              }
                else
                {
                    lblDiscountPrice = [[UILabel alloc]initWithFrame:CGRectMake(size.width/2-25,size.height-15, size.width,15)];
                }
                lblDiscountPrice.tag=indexPath.row+90000;
                lblDiscountPrice.font = [UIFont fontWithName:@"Avenir-Black" size:16];
                [lblDiscountPrice setTextColor:[UIColor orangeColor]];
                [lblDiscountPrice setHidden:YES];
                lblDiscountPrice.lineBreakMode=NSLineBreakByWordWrapping;
                lblDiscountPrice.numberOfLines =0;
                lblDiscountPrice.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:lblDiscountPrice];
                
            }
            
            NSString *strPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"price"]];
            float price = [strPrice floatValue];
            NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dictProductDetail valueForKey:@"discount_price"]];
            cell.lblDiscountPrice.tag=65000+indexPath.row;
            
            if([[dictProductDetail allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
            {
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                    [lblPrice setHidden:NO];
                    [lblDiscountPrice setHidden:NO];
                    lblPrice.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
                    lblDiscountPrice.font = [UIFont fontWithName:@"Avenir-Black" size:14];
                    if(IS_IPHONE_4 || IS_IPHONE_5)
                    {
                    lblPrice.frame = CGRectMake(0, size.height-15, size.width/2, 15);
                    }
                    else{
                    lblPrice.frame = CGRectMake(5, size.height-15, size.width/2, 15);
                    }
                    
                    lblPrice.text=[NSString stringWithFormat:@"$%.2f",[[dictProductDetail valueForKey:@"price"]floatValue]];
                    lblPrice.textColor=[UIColor grayColor];
                    
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f",price]];
                    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                            value:[NSNumber numberWithInt:1]
                                            range:(NSRange){0,[attributeString length]}];
                    [lblPrice setAttributedText:attributeString];
                }
                
                
                if(lblDiscountPrice){
                    [lblDiscountPrice setHidden:NO];
                    [lblPrice setHidden:NO];
                    lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                    [cell.contentView  addSubview:lblDiscountPrice];
                }
            }
            else
            {
                if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"price"]]){
                    [lblPrice setHidden:NO];
                    [lblDiscountPrice setHidden:YES];
                    lblPrice.text=[NSString stringWithFormat:@"$%.2f",[[dictProductDetail valueForKey:@"price"]floatValue]];
                }
            }
            
            
            NSString *srtURL;
            if([[dictProductDetail allKeys] containsObject:@"image_url"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"image_url"]])
                srtURL = [dictProductDetail valueForKey:@"image_url"];
            else if([[dictProductDetail allKeys] containsObject:@"imageurl"] && [OBJGlobal isNotNull:[dictProductDetail valueForKey:@"imageurl"]])
                srtURL = [dictProductDetail valueForKey:@"imageurl"];
            
            cell.btnPlacerequest.tag = indexPath.row+25612;
            btnPlacereqeust = (UIButton*)[cell viewWithTag:indexPath.row+25612];
            
            if(!btnPlacereqeust){
                btnPlacereqeust = [[UIButton alloc]initWithFrame:CGRectMake(0,lblProductName.frame.origin.y+lblProductName.frame.size.height, size.width,25)];
                btnPlacereqeust.tag=indexPath.row+25612;
                [btnPlacereqeust setHidden:YES];
                [cell.contentView addSubview:btnPlacereqeust];
                
            }
            btnPlacereqeust.hidden=true;
            if([[dictProductDetail valueForKey:@"name"] isEqualToString:@"Can't find what you are looking for?"]){
                lblPrice.text = @"";
                imageProduct.image = [UIImage imageNamed:@"kart-box"];
                lblBrand.text = @"";
                btnPlacereqeust.backgroundColor = [UIColor clearColor];
                btnPlacereqeust.hidden=false;
                lblWeight.text = @"";
                lblBadgeCount.text = @"";
                lblPrice.text = @"";
                lblDiscountPrice.text = @"";
                lblOrignoalPrice.text = @"";
                [btnPlacereqeust setImage:[UIImage imageNamed:@"request-btn"] forState:UIControlStateNormal];
                
            }
            
        }
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(UIImage *)getThumbImage:(UIImage *)image {
    float ratio;
    float delta;
    float px = 100; // Double the pixels of the UIImageView (to render on Retina)
    CGPoint offset;
    CGSize size = image.size;
    if (size.width > size.height) {
        ratio = px / size.width;
        delta = (ratio*size.width - ratio*size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = px / size.height;
        delta = (ratio*size.height - ratio*size.width);
        offset = CGPointMake(0, delta/2);
    }
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * size.width) + delta,
                                 (ratio * size.height) + delta);
    UIGraphicsBeginImageContext(CGSizeMake(px, px));
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *imgThumb = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgThumb;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    @try{
        _popUpItemDescription.hidden=true;
        
        __block NSDictionary *dic;
        if(collectionView==self.collectionViewOne){
            
            dic = [aryTopProductList objectAtIndex:indexPath.row];
            
            
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
                NSString *strId;
                if([[obj allKeys] containsObject:@"id"])
                    strId = [obj valueForKey:@"id"];
                else
                    strId = [obj valueForKey:@"prod_id"];
                
                if([strId isEqualToString:[dic valueForKey:@"id"]] && [[dic allKeys] containsObject:@"id"]){
                    dic=obj;
                }
                else if([strId isEqualToString:[dic valueForKey:@"prod_id"]] && [[dic allKeys] containsObject:@"prod_id"])
                {
                    dic=obj;
                    
                }
            }];
            
            OBJGlobal.objMainPopUp.dicProductDetailValue=[dic mutableCopy];
            OBJGlobal.objMainPopUp.isTopProduct=true;
            [OBJGlobal.objMainPopUp initDataForPopUp];
            [OBJGlobal.objMainPopUp toggleHidden:NO];
        }
        if(collectionView==self.collectionViewTwo){
            dic=[self.aryCategoryAssignProductList objectAtIndex:indexPath.row];
            
            if([[dic valueForKey:@"name"] isEqualToString:@"Can't find what you are looking for?"]){
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SpecialRequestViewController *objDashboardViewController=(SpecialRequestViewController *)[storybord  instantiateViewControllerWithIdentifier:@"SpecialRequestViewController"];
                [self.navigationController pushViewController:objDashboardViewController animated:YES];
                
                return;
            }
            
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
                NSString *strId;
                if([[obj allKeys] containsObject:@"id"])
                    strId = [obj valueForKey:@"id"];
                else
                    strId = [obj valueForKey:@"prod_id"];
                
                if([strId isEqualToString:[dic valueForKey:@"id"]] && [[dic allKeys] containsObject:@"id"]){
                    dic=obj;
                }
                else if([strId isEqualToString:[dic valueForKey:@"prod_id"]] && [[dic allKeys] containsObject:@"prod_id"])
                {
                    dic=obj;
                    
                }
            }];
            
            OBJGlobal.objMainPopUp.dicProductDetailValue=[dic mutableCopy];
            OBJGlobal.objMainPopUp.isTopProduct=false;
            [OBJGlobal.objMainPopUp initDataForPopUp];
            [OBJGlobal.objMainPopUp toggleHidden:NO];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)adPageControlCurrentVisiblePageIndex:(int) iCurrentVisiblePage
{
    NSLog(@"ADPageControl :: Current visible page index : %d",iCurrentVisiblePage);
}

- (void)didReceiveMemoryWarning
{
    @try{
        isRecievedMemoryWarning=true;
        [self.collectionViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.collectionViewOne.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        isRecievedMemoryWarning=false;
        [self.collectionViewOne reloadData];
        [self.collectionViewTwo reloadData];
        [super didReceiveMemoryWarning];

    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)btnViewMorePressed:(id)sender {
    @try{
        if ([totalPage intValue]>=pageNoCount && [OBJGlobal isNotNull:totalPage]) {
            _viewRefresh.hidden=YES;
            [self categoryAssignProductList:[NSString stringWithFormat:@"%d",pageNoCount]];
            pageNoCount++;
            
        }
        else{
            _viewRefresh.hidden=YES;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
#pragma mark touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _popUpItemDescription.hidden=true;
}

#pragma mark POPUP Delegate

-(void)loadPopUpTable{
    @try{
        self.objPopUpTableController = [[PopUpTableViewController alloc] initWithStyle:UITableViewStylePlain];
        self.objPopUpTableController.dataSource =  nil;
        if(IS_IPHONE_5 ||  IS_IPHONE_4)
            self.objPopUpTableController.tableView.frame = CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH-50)/2,80,self.view.frame.size.width-50,self.view.frame.size.height-100);
        else if(IS_IPHONE_6)
            self.objPopUpTableController.tableView.frame = CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH-70)/2,80,self.view.frame.size.width-120,self.view.frame.size.height-220);
        else if(IS_IPHONE_6_PLUS)
            self.objPopUpTableController.tableView.frame = CGRectMake(SCREEN_WIDTH/2-(SCREEN_WIDTH-90)/2,80,self.view.frame.size.width-180,self.view.frame.size.height-300);
        self.objPopUpTableController.view.layer.masksToBounds = YES;
        self.objPopUpTableController.view.layer.cornerRadius = 15;
        self.popUpBtnClose.layer.masksToBounds = YES;
        self.popUpBtnClose.layer.cornerRadius = 10;
        self.objPopUpTableController.delegate=self;
        self.objPopUpTableController.view.layer.zPosition = 20000;
        [self.objPopUpTableController toggleHidden:YES];
        
        [_popUpItemDescription insertSubview:self.objPopUpTableController.tableView atIndex:2000];
        
        self.objPopUpTableController.tableView.layer.borderWidth = 2;
        self.objPopUpTableController.tableView.layer.borderColor = [[UIColor blackColor] CGColor];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark - Search Delegate

-(void)didSelectedRegionString:(NSString *)selectedString tableView:(id)tableView{
    @try{
        if([selectedString isEqualToString:@"Top Brand"])
        {
            [self.view makeToast:@"Please select top brand categoty"];
            return;
        }
        _popUpItemDescription.hidden=true;
        
        [arrBrandList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *strName = [[arrBrandList objectAtIndex:idx] valueForKey:@"value"];
            if([selectedString isEqualToString:strName]){
                OBJGlobal.cat_id_PopularBrandSubCategory = [[NSString stringWithFormat:@"%@",[[arrBrandList objectAtIndex:idx] valueForKey:@"id"]] mutableCopy];
                
            }
        }];
        [self.btnPopularBrand setTitle:selectedString forState:UIControlStateNormal];
        pageNoCount=1;
        totalPage = [NSString stringWithFormat:@"%d",1];
        
        [APPDATA showLoader];
        [self brandAssignedProductListMethod:[NSString stringWithFormat:@"%d",pageNoCount]];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)brandAssignedProductListMethod:(NSString*)strPageCount
{
    @try{
        objSubCategory.pageNo=[[NSString stringWithFormat:@"%@",strPageCount] mutableCopy];
        
        
        [objSubCategory brandAssignedProductList:^(NSDictionary *result, NSString *str, int status) {
            
            if([[result allKeys]containsObject:@"data"])
            {
                if([objSubCategory isNotNull:[result valueForKey:@"data"]]){
                    
                    if([strPageCount isEqualToString:@"1"])
                        totalPage = [result valueForKey:@"total_page"];
                    
                    if(pageNoCount==1){
                        self.aryCategoryAssignProductList=nil;
                        self.aryCategoryAssignProductList = [[NSMutableArray alloc] init];
                        _scrollView.contentOffset=CGPointMake(0, 0);
                        
                        [self.collectionViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                        
                    }
                    
                    NSArray *aryCategoryList = [result valueForKey:@"data"];
                    //                    aryCategoryList = [OBJGlobal sortArrayUsingKey:aryCategoryList strKey:@"name"];
                    [self performSelectorOnMainThread:@selector(addCollectionTwoWithData:) withObject:aryCategoryList waitUntilDone:YES];
                    
                    pageNoCount++;
                    
                    if([totalPage intValue]<=[strPageCount intValue]){
                        if (dictForLastObject.count==0)
                            [self initPlaceRequestData];
                        [self.aryCategoryAssignProductList addObject:dictForLastObject];
                    }
                    
                    NSInteger totalProducts = [self.aryCategoryAssignProductList count];
                    
                    _scrollView.scrollEnabled=false;
                    self.collectionViewTwo.scrollEnabled=true;
                    [self performSelectorOnMainThread:@selector(reloadCollectionTwoData) withObject:nil waitUntilDone:YES];
                    self.collectionViewTwo.scrollEnabled=false;
                    
                    _scrollView.backgroundColor = [UIColor clearColor];
                    _scrollView.scrollEnabled=true;
                    
                    int scrollHeight =  ((totalProducts*213)/3)+_collectionViewTwo.frame.origin.y+160;
                    
                    //For the pagination storing the collection height
                    heightLastestForCollectionTwo = ((totalProducts*213)/3)-300;
                    _collectionViewTwo.frame = CGRectMake(_collectionViewTwo.frame.origin.x,_collectionViewTwo.frame.origin.y,_collectionViewTwo.frame.size.width,scrollHeight );
                    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, scrollHeight);
                    _scrollView.backgroundColor = [UIColor clearColor];
                    _collectionViewTwo.backgroundColor = [UIColor clearColor];
                    _viewRefresh.hidden=true;
                    
                    [APPDATA hideLoader];
                    
                }
                
                [APPDATA hideLoader];
            }
            else{
                [APPDATA hideLoader];
                if([OBJGlobal isNotNull:[result valueForKey:@"msg"]])
                    [self.view makeToast:[result valueForKey:@"msg"]];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)reloadCollectionOneData{
    [self.collectionViewOne reloadData];
}

-(void)topProductListMethod
{
    @try{
        
        [objSubCategory topProductList:^(NSDictionary *result, NSString *str, int status) {
            [APPDATA showLoader];
            [self categoryAssignProductList:[NSString stringWithFormat:@"%d",pageNoCount]];
            
            if([[result allKeys]containsObject:@"data"])
            {
                
                if([objSubCategory isNotNull:[result valueForKey:@"data"]]){
                    aryTopProductList=nil;
                    [self.collectionViewOne.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    
                    aryTopProductList = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"data"]];
                }
                
                if(aryTopProductList.count==0)
                    _lblNoProduct.hidden=false;
                else
                    _lblNoProduct.hidden=true;
                [self.collectionViewOne reloadData];
            }
            else{
                
                if([OBJGlobal isNotNull:[result valueForKey:@"msg"]])
                    [self.view makeToast:[result valueForKey:@"msg"]];
                if(aryTopProductList.count==0)
                    _lblNoProduct.hidden=false;
                else
                    _lblNoProduct.hidden=true;
                
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)addCollectionTwoWithData:(NSArray*)aryCategoryList
{
    @try{
        [self.aryCategoryAssignProductList addObjectsFromArray:aryCategoryList];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)categoryAssignProductList:(NSString*)strPageCount
{
    @try{
        
        objSubCategory.pageNo=[[NSString stringWithFormat:@"%@",strPageCount] mutableCopy];
        
        [objSubCategory CategoryAssignProductList:^(NSDictionary *result, NSString *str, int status) {
            
            if([[result allKeys]containsObject:@"data"])
            {
                
                if([objSubCategory isNotNull:[result valueForKey:@"data"]]){
                    if([strPageCount isEqualToString:@"1"])
                        totalPage = [result valueForKey:@"total_page"];
                    
                    if(pageNoCount==1){
                        self.aryCategoryAssignProductList=nil;
                        self.aryCategoryAssignProductList = [[NSMutableArray alloc] init];
                        _scrollView.contentOffset=CGPointMake(0, 0);
                        [self.collectionViewTwo.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                    }
                    
                    NSArray *aryCategoryList = [result valueForKey:@"data"];
                    //                    aryCategoryList = [OBJGlobal sortArrayUsingKey:aryCategoryList strKey:@"name"];
                    [self performSelectorOnMainThread:@selector(addCollectionTwoWithData:) withObject:aryCategoryList waitUntilDone:YES];
                    
                    
                    pageNoCount++;
                    
                    if([totalPage intValue]<=[strPageCount intValue]){
                        if (dictForLastObject.count==0)
                            [self initPlaceRequestData];
                        [self.aryCategoryAssignProductList addObject:dictForLastObject];
                    }
                    
                    NSInteger totalProducts = [self.aryCategoryAssignProductList count];
                    
                    _scrollView.scrollEnabled=false;
                    self.collectionViewTwo.scrollEnabled=true;
                    [self performSelectorOnMainThread:@selector(reloadCollectionTwoData) withObject:nil waitUntilDone:YES];
                    self.collectionViewTwo.scrollEnabled=false;
                    
                    _scrollView.backgroundColor = [UIColor clearColor];
                    _scrollView.scrollEnabled=true;
                    
                    int scrollHeight =  ((totalProducts*213)/3)+_collectionViewTwo.frame.origin.y+160;
                    
                    //For the pagination storing the collection height
                    heightLastestForCollectionTwo = ((totalProducts*213)/3)-300;
                    _collectionViewTwo.frame = CGRectMake(_collectionViewTwo.frame.origin.x,_collectionViewTwo.frame.origin.y,_collectionViewTwo.frame.size.width,scrollHeight );
                    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, scrollHeight);
                    _scrollView.backgroundColor = [UIColor clearColor];
                    _collectionViewTwo.backgroundColor = [UIColor clearColor];
                    _viewRefresh.hidden=true;
                    
                    [APPDATA hideLoader];
                    
                }
                else
                {
                    _viewRefresh.hidden=true;
                    [APPDATA hideLoader];
                }
            }
            else{
                _viewRefresh.hidden=true;
                
                if([OBJGlobal isNotNull:[result valueForKey:@"msg"]])
                    
                    [self.view makeToast:[result valueForKey:@"msg"]];
                
                [APPDATA hideLoader];
            }
        }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)reloadCollectionTwoData{
    [self.collectionViewTwo reloadData];
}


-(void)getBrandListResponseMethod
{
    @try{
        
        if(arrBrandList.count==0){
            [objSubCategory brandList:^(id result,NSString *str, int status)
             {
                 if(status==1)
                 {
                     if([OBJGlobal isNotNull:[result valueForKey:@"data"]]){
                         arrBrandList =[result valueForKey:@"data"];
                         NSMutableArray *arrLocalName = [[NSMutableArray alloc] init];
                         [arrLocalName addObject:@"Top Brand"];
                         [arrBrandList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                             if([OBJGlobal isNotNull:[obj valueForKey:@"value"]])
                                 [arrLocalName addObject:[obj valueForKey:@"value"]];
                         }];
                         [self.objPopUpTableController reloadDataWithSource:arrLocalName];
                     }
                     [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onSelectColor) userInfo:nil repeats:FALSE];
                 }
                 else{
                     if([OBJGlobal isNotNull:[result valueForKey:@"msg"]])
                     {
                         BrandMsg=[result valueForKey:@"msg"];
                     }
                     [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onSelectColor) userInfo:nil repeats:FALSE];
                     
                     
                 }
             }];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}



-(void)showPopUpBrandList
{
    if(!BrandMsg.length==0)
    {
        [self.view makeToast:BrandMsg];
        return;
    }
    else if (arrBrandList.count==0){
        [self.view makeToast:@"Please wait"];
        return;
    }
    
    
    [_popUpBtnClose sendSubviewToBack:self.objPopUpTableController.view];
    _popUpItemDescription.hidden=false;
    _viewRefresh.hidden=YES;
    [self.objPopUpTableController toggleHidden:NO];
}


- (void) handleImageTap:(UIGestureRecognizer *)gestureRecognizer {
    
    @try{
        UIImageView *image = (UIImageView*)gestureRecognizer.view;
        NSInteger imageTag = image.tag;
        imageTag = imageTag-99999;
        if (self.scrollView.contentOffset.y<600) {
            [self.scrollView removeGestureRecognizer:recognizer];
            recognizer=nil;
        }
        
        
        if(self.scrollView.contentOffset.y>600 && imageTag==0)
        {
            return;
        }
        __block NSDictionary *dictProductDetail = [aryTopProductList objectAtIndex:imageTag];
        if([[dictProductDetail valueForKey:@"name"] isEqualToString:@"Can't find what you are looking for?"]){
            UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SpecialRequestViewController *objDashboardViewController=(SpecialRequestViewController *)[storybord  instantiateViewControllerWithIdentifier:@"SpecialRequestViewController"];
            [self.navigationController pushViewController:objDashboardViewController animated:YES];
            
            return;
        }
        
        [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
            NSString *strId;
            if([[obj allKeys] containsObject:@"id"])
                strId = [obj valueForKey:@"id"];
            else
                strId = [obj valueForKey:@"prod_id"];
            
            if([strId isEqualToString:[dictProductDetail valueForKey:@"id"]] && [[dictProductDetail allKeys] containsObject:@"id"]){
                dictProductDetail=obj;
            }
            else if([strId isEqualToString:[dictProductDetail valueForKey:@"prod_id"]] && [[dictProductDetail allKeys] containsObject:@"prod_id"])
            {
                dictProductDetail=obj;
                
            }
        }];
        OBJGlobal.objMainPopUp.dicProductDetailValue=[dictProductDetail mutableCopy];
        OBJGlobal.objMainPopUp.isTopProduct=false;
        [OBJGlobal.objMainPopUp initDataForPopUp];
        [OBJGlobal.objMainPopUp toggleHidden:NO];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}
#pragma mark Scroll delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView      // called when scroll view grinds to a halt
{
    @try{
        if(heightLastestForCollectionTwo<scrollView.contentOffset.y)
        {
            
            if([totalPage intValue]>=pageNoCount && _viewRefresh.isHidden==true){
                spinner.hidden=false;
                _viewRefresh.hidden=false;
                [spinner startAnimating];
                [APPDATA hideLoader];
                [self categoryAssignProductList:[NSString stringWithFormat:@"%d",pageNoCount]];
                
                
                //                [APPDATA showLoader];
            }
            
            if(!([totalPage intValue]>=pageNoCount)){
                if(_viewRefresh){
                    _viewRefresh.hidden=true;
                }
            }
            
        }
        
        if(scrollView.contentOffset.y>=130)
        {
            if(!recognizer){
                recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
                [recognizer setNumberOfTapsRequired:1];
                self.scrollView.userInteractionEnabled = YES;
                self.scrollView.scrollEnabled = YES;
                
                [self.scrollView addGestureRecognizer:recognizer];
            }
        }
        else{
            if(recognizer){
                [self.scrollView removeGestureRecognizer:recognizer];
                recognizer=nil;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}


-(void)compareLocalKartProductAndTotalProductSubCategory
{
    NSArray *aryForCompareForTopProducts = aryTopProductList;
    aryTopProductList = [[NSMutableArray alloc] initWithArray:[OBJGlobal compareForKartProductAndTotalProductForSubCategory:OBJGlobal.dictLastKartProduct aryTotalProduct:aryForCompareForTopProducts]];
    [self.collectionViewOne reloadData];
    NSArray *aryCompareForCategoryProducts = self.aryCategoryAssignProductList;
    
    self.aryCategoryAssignProductList = [[NSMutableArray alloc] initWithArray:[OBJGlobal compareForKartProductAndTotalProductForSubCategory:OBJGlobal.dictLastKartProduct aryTotalProduct:aryCompareForCategoryProducts]];
    [self.collectionViewTwo reloadData];
    
    
}
#pragma mark Delegate for the Cart Action
-(void)reloadCartData:(NSDictionary *)dictResult
{
    
    if(GETBOOL(@"isUserHasLogin")==false){
        if(!dbAccess)
            dbAccess = [FMDBDataAccess new];
        NSArray *arrLocalKartData = [dbAccess fetchAllProductDataFromLocalDB] ;
        handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:arrLocalKartData];
        OBJGlobal.aryKartDataGlobal = [NSMutableArray arrayWithArray:arrLocalKartData];
        [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        [self.collectionViewOne reloadData];
        [self.collectionViewTwo reloadData];
    }
    else if (GETBOOL(@"isUserHasLogin")==true){
        [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:dictResult];
        handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:OBJGlobal.aryKartDataGlobal];
        [self.collectionViewOne reloadData];
        [self.collectionViewTwo reloadData];
        
    }
    
}

-(void)initPlaceRequestData
{
    dictForLastObject=nil;
    dictForLastObject = [[NSMutableDictionary alloc] init];
    
    [dictForLastObject setObject:@"" forKey:@"prod_id"];
    [dictForLastObject setObject:@"" forKey:@"description"];
    [dictForLastObject setObject:@"" forKey:@"discount_price"];
    [dictForLastObject setObject:@"" forKey:@"name"];
    [dictForLastObject setObject:@"" forKey:@"sku"];
    [dictForLastObject setObject:@"Can't find what you are looking for?" forKey:@"name"];
    [dictForLastObject setObject:@"" forKey:@"description"];
    [dictForLastObject setObject:@"" forKey:@"brand"];
    [dictForLastObject setObject:@"" forKey:@"unit"];
    [dictForLastObject setObject:@"" forKey:@"weight"];
    [dictForLastObject setObject:@"" forKey:@"price"];
    [dictForLastObject setObject:@"" forKey:@"prod_in_cart"];
    [dictForLastObject setObject:@"" forKey:@"image_url"];
}


@end
