//
//  DashboardViewController.m
//  peter
//
//  Created by Peter on 12/28/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import "DashboardViewController.h"
#import "UIViewController+NavigationBar.h"

#import "LocationViewController.h"

#import "Constant.h"
#import "Users.h"

#import "Globals.h"
#import "CommonPopUpView.h"
#import "UIImageView+WebCache.h"
#import "ProductDetailViewController.h"
#import "SubCategoriesViewController.h"
#import "FMDBDataAccess.h"
#import "SpecialRequestViewController.h"
#import "UIView+Toast.h"
#import <Crashlytics/Crashlytics.h>
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"


@interface DashboardViewController ()<UIGestureRecognizerDelegate,ReloadCartDataDelegate>
{
    Globals *OBJGlobal;
    NSMutableArray *aryDashBoard;
    NSMutableDictionary *dicDashboardCategory;
    UIButton *btnBadgeCount;
    FMDBDataAccess *dbAccess;
    NSMutableArray *arrProductsForPatch;
    ProductDetailViewController *objProductDetailViewController;
    UIView *HeaderView;
    CommonPopUpView *log;
    UIView *footerView;
    NSArray *handleBadgeWithoutLogin;
    int dashBoardWebServiceFailedCount;
    NSMutableDictionary *dictProductDetail;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *spinner;
    BOOL isCallDashboardService;
}
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation DashboardViewController
- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        [self setMenuIconForSideBar:@"cal"];
        aryDashBoard = [[NSMutableArray alloc]init];
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        //  [[Crashlytics sharedInstance] crash];
        dbAccess = [FMDBDataAccess new];
        btnBadgeCount = [self setUpImageSecondRightButton:@"menu" secondImage:@"search" thirdImage:@"logo" badgeCount:[[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] integerValue]];
        
        
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 44, 56)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Dashboard";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        _popUpItemDescription.hidden=true;
        _roundedPopUpView.layer.masksToBounds = YES;
        _roundedPopUpView.layer.cornerRadius = 15;
        [self setUpContentData];
        
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    @try{
        _popUpItemDescription.hidden=true;
        self.tableView.contentOffset = CGPointMake(0,0);
        isCallDashboardService=true;
        handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:OBJGlobal.aryKartDataGlobal];
        if(!spinner){
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [spinner stopAnimating];
            spinner.hidesWhenStopped = NO;
            spinner.frame = CGRectMake(0, self.tableView.frame.size.height-60, 320, 60);
            self.tableView.tableFooterView = spinner;
            self.tableView.tableFooterView.hidden = TRUE;
        }
        if(OBJGlobal.aryDashboardGlobal.count==0)
        {
            [APPDATA showLoader];
            OBJGlobal.pageNoCountDashBoard=1;
            OBJGlobal.totalPageDashBoard=[[NSString stringWithFormat:@"%d",1] mutableCopy];
            [self loadDashBoardData:[NSString stringWithFormat:@"%ld",(long)OBJGlobal.pageNoCountDashBoard]];
            
            refreshControl = [[UIRefreshControl alloc] init];
            
            isCallDashboardService=true;
        }
        else{
            aryDashBoard = [[NSMutableArray alloc] initWithArray:OBJGlobal.aryDashboardGlobal];
        }
        if(GETBOOL(@"isUserHasLogin")==false){
            
            NSArray *arrLocalKartData = [dbAccess fetchAllProductDataFromLocalDB] ;
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:arrLocalKartData];        }
        else{
            [self getkartListForTheFirstTime];
        }
        OBJGlobal.aryKartDataGlobal = [NSMutableArray arrayWithArray:handleBadgeWithoutLogin];
        
        [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        [self.tableView reloadData];
        
        //This is not required for now
        //    if (GETBOOL(@"isUserHasLogin")==true){
        //        OBJGlobal.pageNoCountDashBoard=1;
        //        [APPDATA showLoader];
        //        [self loadDashBoardData:[NSString stringWithFormat:@"%d",OBJGlobal.pageNoCountDashBoard]];
        //        [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        //    }
        if([OBJGlobal.numberOfCartItems intValue]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


-(void)loadDashBoardData:(NSString*)pageNo{
    //    [NSThread detachNewThreadSelector:@selector(showLoader) toTarget:APPDATA withObject:nil];
    @try{
        //[APPDATA showLoader];
        if(GETBOOL(@"isUserHasLogin")==false){
            NSArray *arrLocalKartData = [dbAccess fetchAllProductDataFromLocalDB] ;
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:arrLocalKartData];
            OBJGlobal.aryKartDataGlobal = [NSMutableArray arrayWithArray:arrLocalKartData];
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
        }
        Users *objDashboard= OBJGlobal.user;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] ){
            
            objDashboard.userid=[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]] mutableCopy];
            objDashboard.pageNo=[[NSString stringWithFormat:@"%@",pageNo] mutableCopy];
        }else
        {
            objDashboard.pageNo=[[NSString stringWithFormat:@"%@",pageNo] mutableCopy];
        }
        
        [objDashboard dashboardList:^(id result,NSString *str, int status)
         {
             if(status==1)
             {
                 NSArray *resultForDashboardList = [result valueForKey:@"data"];
                 
                 OBJGlobal.totalPageDashBoard = [[NSString stringWithFormat:@"%@",[result valueForKey:@"total_page"]] mutableCopy];
                 if(OBJGlobal.pageNoCountDashBoard==1){
                     aryDashBoard = [[NSMutableArray alloc] init];
                     DashboardCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                     [cell.scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                 }
                 if(OBJGlobal.pageNoCountDashBoard>1)
                     OBJGlobal.isfirstTimeDashBoardDataReceived=true;
                 [aryDashBoard addObjectsFromArray:resultForDashboardList];
                 
                 if([OBJGlobal.totalPageDashBoard integerValue]>=OBJGlobal.pageNoCountDashBoard){
                     if(GETBOOL(@"isUserHasLogin")==false){
                         OBJGlobal.pageNoCountDashBoard++;
                     }
                 }
                 
                 [self performSelectorOnMainThread:@selector(compareForKartProductAndTotalProduct) withObject:nil waitUntilDone:YES];
                 
                 
                 [APPDATA hideLoader];
                 isCallDashboardService=true;
                 self.tableView.tableFooterView.hidden = TRUE;
                 OBJGlobal.aryDashboardGlobal=nil;
                 OBJGlobal.aryDashboardGlobal = [[NSMutableArray alloc] initWithArray:aryDashBoard];
             }
             else{
                 NSLog(@"Failed");
                 dashBoardWebServiceFailedCount++;
                 if(dashBoardWebServiceFailedCount>4){
                     [NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:APPDATA withObject:nil];
                     [self.view makeToast:@"Server is down or check your internet connection."];
                     return ;
                 }
                 [self loadDashBoardData:[NSString stringWithFormat:@"%ld",(long)OBJGlobal.pageNoCountDashBoard]];
             }
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)reloadDataAndThenHideLoader
{
    
}
-(void)compareForKartProductAndTotalProduct
{
    NSArray *aryDashBoardData = aryDashBoard;
    aryDashBoard = [[NSMutableArray alloc] initWithArray:[OBJGlobal compareForKartProductAndTotalProduct:OBJGlobal.dictLastKartProduct aryTotalProduct:aryDashBoardData]];
    [self.tableView reloadData];
    
}
-(void)getkartListForTheFirstTime{
    @try{
        if(GETBOOL(@"isUserHasLogin")==true && OBJGlobal.isFirstTimeFetchKartData==false){
            
            Users *objmyCart = OBJGlobal.user;
            
            [objmyCart myCartList:^(NSDictionary *result, NSString *str, int status)
             {
                 if (status == 1) {
                     OBJGlobal.isFirstTimeFetchKartData=true;
                     
                     if(GETBOOL(@"isUserHasLogin")==true){
                         if([OBJGlobal isNotNull:[result valueForKey:@"cartitems"]]){
                             OBJGlobal.aryKartDataGlobal=nil;
                             
                             OBJGlobal.aryKartDataGlobal=[NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                             OBJGlobal.numberOfCartItems = [[NSString stringWithFormat:@"%lu", (unsigned long)OBJGlobal.aryKartDataGlobal.count] mutableCopy];
                             [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:result];
                             
                             handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:[result valueForKey:@"cartitems"]];
                             [self.tableView reloadData];
                             [self shopingListMethod];
                             
                         }
                         else{
                             //                     [self.view makeToast:@"Please Login to view cart data or you have not added product to cart" duration:5.0f position:CSToastPositionBottom title:@"Alert"];
                         }
                     }
                     NSLog(@"success");
                     [APPDATA hideLoader];
                 }
                 else {
                     // [self.view makeToast:[user objectForKey:@"msg"]];
                     NSLog(@"Failed");
                     [APPDATA hideLoader];
                 }
             }];
        }
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
            OBJGlobal.objMainPopUp.dicProductDetailValue=dictProductDetail;
            OBJGlobal.objMainPopUp.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            
            OBJGlobal.objMainPopUp.commonPopUpContentView.frame=CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
            //            if(IS_IPHONE_6_PLUS || IS_IPHONE_6)
            //            {
            //                OBJGlobal.objMainPopUp.frame=CGRectMake(10, 10, self.view.frame.size.width-20,self.view.frame.size.height-20);
            //
            //                OBJGlobal.objMainPopUp.commonPopUpContentView.frame=CGRectMake(10, 10, self.view.frame.size.width-20, self.view.frame.size.height-20);
            //            }
            //                         else{
            //                 OBJGlobal.objMainPopUp.frame=CGRectMake(10, 10, self.view.frame.size.width-20, OBJGlobal.objMainPopUp.frame.size.height-180);
            //
            //                 OBJGlobal.objMainPopUp.commonPopUpContentView.frame=CGRectMake(10, 10, self.view.frame.size.width-20,OBJGlobal.objMainPopUp.commonPopUpContentView.frame.size.height-180);
            //             }
            
            [OBJGlobal.objMainPopUp initDataForPopUp];
            OBJGlobal.objMainPopUp.backgroundColor = [UIColor clearColor];
            [self.view insertSubview:OBJGlobal.objMainPopUp atIndex:1000];
            [OBJGlobal.objMainPopUp toggleHidden:YES];
            
            
        }
        else{
            [OBJGlobal.objMainPopUp toggleHidden:YES];
            OBJGlobal.objMainPopUp.dicProductDetailValue=dictProductDetail;
            [OBJGlobal.objMainPopUp initDataForPopUp];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

// Peter

-(void)loadView
{
    @try{
        [super loadView];
        
        const NSInteger numberOfTableViewRows = 20;
        const NSInteger numberOfCollectionViewCells = 15;
        
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:numberOfTableViewRows];
        
        for (NSInteger tableViewRow = 0; tableViewRow < numberOfTableViewRows; tableViewRow++)
        {
            NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:numberOfCollectionViewCells];
            
            for (NSInteger collectionViewItem = 0; collectionViewItem < numberOfCollectionViewCells; collectionViewItem++)
            {
                
                CGFloat red = arc4random() % 255;
                CGFloat green = arc4random() % 255;
                CGFloat blue = arc4random() % 255;
                UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0f];
                
                [colorArray addObject:color];
            }
            
            [mutableArray addObject:colorArray];
        }
        
        self.colorArray = [NSArray arrayWithArray:mutableArray];
        
        self.contentOffsetDictionary = [NSMutableDictionary dictionary];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return aryDashBoard.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @try{
        UIButton *hyperlinkButton;
        hyperlinkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        [hyperlinkButton setBackgroundColor:[UIColor whiteColor]];
        UILabel *lblCategory ;
        if (IS_IPHONE5 || IS_IPHONE_4) {
            
            lblCategory = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 80)];
            
        }
        else
        {
            lblCategory = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 220, 80)];
        }
        
        NSDictionary *dic=[aryDashBoard objectAtIndex:section];
        if (aryDashBoard.count>0) {
            lblCategory.lineBreakMode=NSLineBreakByWordWrapping;
            lblCategory.numberOfLines =0;
            
            lblCategory.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"category"]];
            lblCategory.textAlignment = NSTextAlignmentLeft;
            UIColor *yourColor = [UIColor colorWithRed:77.0f/255.0f green:22.0f/255.0f blue:114.0f/255.0f alpha:1];
            lblCategory.textColor = yourColor;
            
            lblCategory.font = [UIFont fontWithName:@"Avenir-medium" size:18];
            [hyperlinkButton addSubview:lblCategory];
        }
        
        hyperlinkButton.titleLabel.textAlignment=NSTextAlignmentRight;
        hyperlinkButton.titleLabel.textColor = [UIColor blackColor];
        hyperlinkButton.tag = section+123456;
        [hyperlinkButton addTarget:self action:@selector(btnViewAllPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:@"Go To Aisle >>"];
        
        hyperlinkButton.titleEdgeInsets = UIEdgeInsetsMake(20, self.navigationController.navigationBar.frame.size.width-110, 0, 0);
        hyperlinkButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
        [hyperlinkButton setAttributedTitle:commentString forState:UIControlStateNormal];
        [self.view addSubview:hyperlinkButton];
        
        
        return hyperlinkButton;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section #%ld", (long)section+1];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        static NSString *CellIdentifier = @"DashboardCell";
        
        DashboardCell *cell = (DashboardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[DashboardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIScrollView *scrollView;
        scrollView = (UIScrollView*)[cell viewWithTag:999786+indexPath.row];
        if(!scrollView){
            scrollView = cell.scrollView;
            scrollView.tag=999786+indexPath.row;
        }
        [scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        NSDictionary *dicTemp=[aryDashBoard objectAtIndex:indexPath.section];
        if (!cell)
        {
            cell = [[DashboardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        __block UIImageView *imgProduct=nil;
        __block UIImageView *imgProductBadge=nil;
        __block UILabel *lblProductName=nil;
        __block UILabel *lblBrandName=nil;
        __block UILabel *lblWeight=nil;
        __block UILabel *lblbadgeCount=nil;
        __block UILabel *lblPrice=nil;
        __block UILabel *lblDiscountPrice=nil;
        __block NSDictionary *dic=nil;
        __block UIView *whiteViewBackground=nil;
        __block UIButton *btnTransparentForClick=nil;
        __block UIImageView *imgPlaceRequest=nil;
        __block NSString *productname=nil;
        float deviceWidth = DEVICE_WIDTH;
        
        NSMutableArray *arrProducts =[[NSMutableArray alloc] initWithArray:[dicTemp valueForKey:@"prod"]];
        [scrollView setContentSize:CGSizeMake(0, 0)];
        [scrollView setContentOffset:CGPointMake(0, 0)];
        
        scrollView.tag=indexPath.section+1000;
        [scrollView setUserInteractionEnabled:YES];
        
        
        [arrProducts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *srtURL;
            __block NSString *strProductBadgeCount;
            
            dic=[arrProducts objectAtIndex:idx];
            srtURL = [dic valueForKey:@"imageurl"];
            
            whiteViewBackground = (UIView*)[cell viewWithTag:idx+567825];
            if(!whiteViewBackground){
                if (IS_IPHONE_5 || IS_IPHONE_4 )
                    
                    whiteViewBackground = [[UIView alloc] initWithFrame:CGRectMake(((idx* deviceWidth/3.5)), 8, 80, 215)];
                else if(IS_IPHONE_6)
                    whiteViewBackground = [[UIView alloc] initWithFrame:CGRectMake(((idx* deviceWidth/3.5)+5), 8, 90, 215)];
                else
                    whiteViewBackground = [[UIView alloc] initWithFrame:CGRectMake(((idx* deviceWidth/3.5)+10), 8, 105, 215)];
                
                whiteViewBackground.backgroundColor = [UIColor whiteColor];
                whiteViewBackground.tag=idx+567825;
                
                [scrollView  insertSubview:whiteViewBackground atIndex:100];
            }
            
            imgProduct = (UIImageView*)[cell viewWithTag:idx+99999];
            if(!imgProduct){
                
                if (IS_IPHONE_5 || IS_IPHONE_4 )
                    
                    imgProduct = [[UIImageView alloc]initWithFrame:CGRectMake(((idx* deviceWidth/3.5)), 15, 80, 80)];
                else if(IS_IPHONE_6)
                    imgProduct = [[UIImageView alloc]initWithFrame:CGRectMake(((idx* deviceWidth/3.5)+10),20, 80, 80)];
                else
                    imgProduct = [[UIImageView alloc]initWithFrame:CGRectMake(((idx* deviceWidth/3.5)+20), 20, 80, 80)];
                
                
                if(srtURL.length==0)
                    srtURL = [[[dictProductDetail valueForKey:@"multiple_images"] objectAtIndex:0] valueForKey:@"multiple"];
                
                UIImageView *imageView1 = (UIImageView *)[cell.imageView viewWithTag:indexPath.row+20034];
                if(!imageView1){
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,80, 80)];
                    
                    imageView.tag=idx+20034;
                    imageView.clipsToBounds = YES;
                    
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                    
                    [imageView setImageWithURL:[NSURL URLWithString:srtURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    
                    [imgProduct  addSubview:imageView];
                }
                
                imgProduct.tag=idx+99999;
                [scrollView  addSubview:imgProduct];
            }
            else {
                
            }
            CGRect imageRect = imgProduct.frame;
            
            [handleBadgeWithoutLogin enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger index, BOOL * _Nonnull stop) {
                NSString *strId;
                strProductBadgeCount=nil;
                if([[obj allKeys] containsObject:@"id"])
                    strId = [obj valueForKey:@"id"];
                else
                    strId = [obj valueForKey:@"prod_id"];
                
                if([strId isEqualToString:[dic valueForKey:@"id"]] && [[dic allKeys] containsObject:@"id"]){
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else  if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                    
                }
                else if([strId isEqualToString:[dic valueForKey:@"prod_id"]] && [[dic allKeys] containsObject:@"prod_id"])
                {
                    if ([[obj allKeys]containsObject:@"qty"])
                        strProductBadgeCount = [obj valueForKey:@"qty"];
                    else if([OBJGlobal isNotNull:[obj valueForKey:@"prod_in_cart"]])
                        strProductBadgeCount = [obj valueForKey:@"prod_in_cart"];
                }
                
                if([strProductBadgeCount intValue]>0){
                    
                    imgProductBadge = (UIImageView*)[cell viewWithTag:idx+78999];
                    if(!imgProductBadge){
                        //IMAGE BADGE
                        [imgProductBadge setBackgroundColor:[UIColor whiteColor]];
                        imgProductBadge.tag=idx+78999;
                        if(IS_IPHONE_4 || IS_IPHONE_5)
                            imgProductBadge=[[UIImageView alloc]initWithFrame:CGRectMake((((idx* deviceWidth/3.5))+imageRect.size.width/2), imageRect.origin.y-5, imageRect.size.width/2, imageRect.size.height/2.6)];
                        
                        else
                            imgProductBadge=[[UIImageView alloc]initWithFrame:CGRectMake((((idx* deviceWidth/3.5))+imageRect.size.width)-12, imageRect.origin.y-10, imageRect.size.width/2.2, imageRect.size.height/2.6)];
                        
                        imgProductBadge.image = [UIImage imageNamed:@"kart-badge"];
                        
                        [scrollView  addSubview:imgProductBadge];
                    }
                    lblbadgeCount = (UILabel*)[cell viewWithTag:idx+101010];
                    if(!lblbadgeCount){
                        //IMAGE BADGE
                        lblbadgeCount.tag=idx+101010;
                        
                        lblbadgeCount=[[UILabel alloc] initWithFrame:CGRectMake(imgProductBadge.frame.origin.x+imgProductBadge.frame.size.width/2-8,imgProductBadge.frame.size.height/2+5, 35, 10)];
                        lblbadgeCount.textAlignment=NSTextAlignmentCenter;
                        if([strProductBadgeCount intValue]>=100)
                            lblbadgeCount.font = [UIFont systemFontOfSize:12 weight:UIFontWeightBlack];
                        
                        lblbadgeCount.text = [NSString stringWithFormat:@"%@",strProductBadgeCount];
                        if([strProductBadgeCount intValue]>99)
                            lblbadgeCount.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBlack];
                        else
                            lblbadgeCount.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBlack];
                        
                        [lblbadgeCount setTextColor:[UIColor whiteColor]];
                        
                        [scrollView  addSubview:lblbadgeCount];
                    }
                    
                }
            }];
            
            
            lblProductName = (UILabel*)[cell viewWithTag:idx+4000];
            imgPlaceRequest = (UIImageView*)[cell viewWithTag:484848];
            
            if(!lblProductName)
            {
                lblProductName = [[UILabel alloc]initWithFrame:CGRectMake(imageRect.origin.x, imageRect.origin.y+80,imageRect.size.width,90)];
                
                lblProductName.tag=idx+4000;
                lblProductName.lineBreakMode=NSLineBreakByWordWrapping;
                lblProductName.font =   [UIFont fontWithName:@"Avenir-Book" size:12];
                
                lblProductName.numberOfLines =0;
                lblProductName.backgroundColor = [UIColor redColor];
                lblProductName.textAlignment = NSTextAlignmentCenter;
                
                CGSize maximumSize = CGSizeMake(300, 9999);
                CGSize dateStringSize = [[dic valueForKey:@"name"] sizeWithFont:lblProductName.font constrainedToSize:maximumSize lineBreakMode:lblProductName.lineBreakMode];
                
                
                UITextView *txtTemp=[[UITextView alloc]initWithFrame:lblProductName.frame];
                NSString *brandName;
                if([[dic allKeys]containsObject:@"brand"])
                    brandName = [NSString stringWithFormat:@"%@",[dic valueForKey:@"brand"]];
                NSString *strspace = [brandName stringByAppendingString:@" "];
                
                if([[dic allKeys]containsObject:@"name"])
                    productname= [strspace stringByAppendingString:[dic valueForKey:@"name"]];
                txtTemp.text=productname;
                [txtTemp setTextAlignment:NSTextAlignmentCenter];
                [txtTemp setUserInteractionEnabled:NO];
                txtTemp.font=lblProductName.font;
                [scrollView addSubview:txtTemp];
                
                lblProductName.frame=CGRectMake(lblProductName.frame.origin.x, lblProductName.frame.origin.y, lblProductName.frame.size.width,dateStringSize.height);
                
            }
            else {
                lblProductName.text =productname;
                
            }
            lblBrandName = (UILabel*)[cell viewWithTag:idx+6000];
            if(!lblBrandName)
            {
                //BRAND NAME
                if (IS_IPHONE_5 || IS_IPHONE_4)
                    lblBrandName = [[UILabel alloc]initWithFrame:CGRectMake(lblProductName.frame.origin.x, lblProductName.frame.origin.y+80,lblProductName.frame.size.width,30)];
                else
                    lblBrandName = [[UILabel alloc]initWithFrame:CGRectMake(lblProductName.frame.origin.x, lblProductName.frame.origin.y+80,lblProductName.frame.size.width,30)];
                lblBrandName.textAlignment=NSTextAlignmentCenter;
                lblBrandName.tag=idx+6000;
                lblBrandName.lineBreakMode=NSLineBreakByWordWrapping;
                lblBrandName.numberOfLines =0;
                lblBrandName.hidden=YES;
                lblBrandName.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBlack];
                
                lblBrandName.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"brand"]];
                if([lblBrandName.text isEqualToString:@"0"])
                    lblBrandName.text=@"";
                [scrollView  addSubview:lblBrandName];
            }
            else {
                lblBrandName.text =[NSString stringWithFormat:@"%@",[dic valueForKey:@"brand"]];
            }
            
            lblWeight = (UILabel*)[cell viewWithTag:idx+77777];
            if(!lblWeight)
            {
                NSString *str1=productname;
                if(str1.length>=26)
                    lblWeight = [[UILabel alloc] initWithFrame:CGRectMake(lblProductName.frame.origin.x, lblProductName.frame.origin.y+86,lblProductName.frame.size.width,15)];
                else if(str1.length>=19)
                    lblWeight = [[UILabel alloc] initWithFrame:CGRectMake(lblProductName.frame.origin.x, lblProductName.frame.origin.y+75,lblProductName.frame.size.width,15)];
                else
                    lblWeight = [[UILabel alloc] initWithFrame:CGRectMake(lblProductName.frame.origin.x, lblProductName.frame.origin.y+60,lblProductName.frame.size.width,15)];
                
                lblWeight.tag=idx+77777;
                
                lblWeight.textColor=[UIColor grayColor];
                lblWeight.font = [UIFont fontWithName:@"Avenir-Book" size:12];
                lblWeight.textAlignment=NSTextAlignmentCenter;
                NSString *strWeight =[NSString stringWithFormat:@"%@",[dic valueForKey:@"unit"]];
                if([strWeight isEqualToString:@"lbs"] || [strWeight isEqualToString:@" lbs"])
                    strWeight = [NSString stringWithFormat:@"1 lbs"];
                lblWeight.text = strWeight;
                [scrollView  addSubview:lblWeight];
            }
            
            lblPrice = (UILabel*)[cell viewWithTag:idx+8000];
            
            if(!lblPrice)
            {
                NSString *strPrice =[NSString stringWithFormat:@"%@",[dic valueForKey:@"price"]];
                float price = [strPrice floatValue];
                NSString *strDiscountPrice =[NSString stringWithFormat:@"%@",[dic valueForKey:@"discount_price"]];
                
                if([[dic allKeys] containsObject:@"discount_price"] && price>[strDiscountPrice floatValue])
                {
                    lblDiscountPrice = (UILabel*)[cell viewWithTag:idx+9000];
                    
                    if(!lblDiscountPrice){
                        
                        //Discount Price
                        lblDiscountPrice = [[UILabel alloc] initWithFrame:CGRectMake(lblProductName.frame.origin.x+22,lblProductName.frame.origin.y+105,lblProductName.frame.size.width,20)];
                        lblDiscountPrice.textColor=[UIColor orangeColor];
                        lblDiscountPrice.font = [UIFont fontWithName:@"Avenir-Black" size:14];
                        lblDiscountPrice.textAlignment=NSTextAlignmentCenter;
                        lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                        
                        lblDiscountPrice.tag=idx+9000;
                        [scrollView  addSubview:lblDiscountPrice];
                    }
                    else{
                        lblDiscountPrice.text = [NSString stringWithFormat:@"$%.2f",[strDiscountPrice floatValue]];
                    }
                    
                    lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(lblProductName.frame.origin.x-20,lblProductName.frame.origin.y+105,lblProductName.frame.size.width,20)];
                    lblPrice.textColor=[UIColor grayColor];
                    lblPrice.font = [UIFont fontWithName:@"Avenir-Medium" size:13];
                    lblPrice.textAlignment=NSTextAlignmentCenter;
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%.2f",price]];
                    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                            value:[NSNumber numberWithInt:1]
                                            range:(NSRange){0,[attributeString length]}];
                    
                    lblPrice.textAlignment=NSTextAlignmentCenter;
                    [lblPrice setAttributedText:attributeString];
                }
                else
                {
                    lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(lblProductName.frame.origin.x+3,lblProductName.frame.origin.y+105,lblProductName.frame.size.width,20)];
                    lblPrice.textColor=[UIColor orangeColor];
                    lblPrice.font = [UIFont fontWithName:@"Avenir-Black" size:16];
                    lblPrice.textAlignment=NSTextAlignmentCenter;
                    lblPrice.text = [NSString stringWithFormat:@"$%.2f",price];
                    lblPrice.tag=idx+8000;
                    
                }
                [scrollView  addSubview:lblPrice];
            }
            else {
                
                NSString *strPrice =[NSString stringWithFormat:@"%@",[dic valueForKey:@"price"]];
                float price = [strPrice floatValue];
                lblPrice.textAlignment=NSTextAlignmentCenter;
                lblPrice.text = [NSString stringWithFormat:@"$%.2f",price];
            }
            
            btnTransparentForClick = (UIButton*)[cell viewWithTag:idx+86785];
            if(!btnTransparentForClick){
                if (IS_IPHONE_5 || IS_IPHONE_4 )
                    
                    btnTransparentForClick = [[UIButton alloc] initWithFrame:CGRectMake(((idx* deviceWidth/3.5)), 8, 80, 215)];
                else if(IS_IPHONE_6)
                    btnTransparentForClick = [[UIButton alloc] initWithFrame:CGRectMake(((idx* deviceWidth/3.5)+5), 8, 90, 215)];
                else
                    btnTransparentForClick = [[UIButton alloc] initWithFrame:CGRectMake(((idx* deviceWidth/3.5)+10), 8, 105, 215)];
                
                btnTransparentForClick.backgroundColor = [UIColor clearColor];
                btnTransparentForClick.tag=idx+86785;
                [scrollView  addSubview:btnTransparentForClick];
                [btnTransparentForClick addTarget:self action:@selector(handleButtonForPopUppressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            
        }];
        [scrollView setContentSize:CGSizeMake((((arrProducts.count+1)* deviceWidth/3.5)), scrollView.frame.size.height)];
        
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}


- (UIImage *)getThumbImage:(UIImage *)image {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void) handleButtonForPopUppressed:(id)sender {
    @try{
        
        UIButton *btnTransparent = (UIButton*)sender;
        NSInteger scrollTag =0;
        if([btnTransparent.superview isKindOfClass:[UIScrollView class]]){
            UIScrollView *scrollView = (UIScrollView*)btnTransparent.superview;
            scrollTag = scrollView.tag-1000;
        }
        NSInteger btnTag = btnTransparent.tag;
        btnTag = btnTag-86785;
        
        NSDictionary *dic = [aryDashBoard objectAtIndex:scrollTag];
        
        NSArray *arrProducts =[dic valueForKey:@"prod"];
        if(btnTag>=arrProducts.count)
        {
            UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SpecialRequestViewController *objDashboardViewController=(SpecialRequestViewController *)[storybord  instantiateViewControllerWithIdentifier:@"SpecialRequestViewController"];
            [self.navigationController pushViewController:objDashboardViewController animated:YES];
            return;
        }
        dictProductDetail = [[NSMutableDictionary alloc] initWithDictionary:[arrProducts objectAtIndex:btnTag]];
        
        [dictProductDetail setObject:[NSString stringWithFormat:@"1"] forKeyedSubscript:@"prod_in_cart"];
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
        
        
        OBJGlobal.objMainPopUp.dicProductDetailValue=dictProductDetail;
        [OBJGlobal.objMainPopUp initDataForPopUp];
        [OBJGlobal.objMainPopUp toggleHidden:NO];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"%@",NSStringFromCGSize(scrollView.contentSize));
}
-(void)btnViewAllPressed:(id)sender
{
    @try{
        UIButton *btnViewAll = (UIButton*)sender;
        NSInteger btnTag = btnViewAll.tag;
        btnTag = btnTag-123456;
        OBJGlobal.selectedIndexpathForLeft=0;
        
        NSString *strCat_ID=[[aryDashBoard objectAtIndex:btnTag] valueForKey:@"category_id"];
        
        OBJGlobal.lblSubCategoryName = [[aryDashBoard objectAtIndex:btnTag] valueForKey:@"category"];
        OBJGlobal.cat_id_TopBarSubCategory = [strCat_ID mutableCopy];
        OBJGlobal.cat_id_PopularBrandSubCategory = [strCat_ID mutableCopy];
        
        SubCategoriesViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubCategoriesViewController"];
        [self.navigationController pushViewController:objDashboardViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

#pragma mark Delegate for the Cart Action
-(void)reloadCartData:(NSDictionary *)dictResult
{
    
    @try{
        if(GETBOOL(@"isUserHasLogin")==false){
            [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:dictResult];
            NSArray *arrLocalKartData = [dbAccess fetchAllProductDataFromLocalDB] ;
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:arrLocalKartData];
            
            OBJGlobal.aryKartDataGlobal = [NSMutableArray arrayWithArray:arrLocalKartData];
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
            [self compareForKartProductAndTotalProduct];
        }
        else if (GETBOOL(@"isUserHasLogin")==true){
            //        [APPDATA showLoader];
            [OBJGlobal setTitleForBadgeCount:btnBadgeCount dictKartDetail:dictResult];
            //        OBJGlobal.pageNoCountDashBoard=1;
            handleBadgeWithoutLogin = [NSMutableArray arrayWithArray:OBJGlobal.aryKartDataGlobal];
            [self compareForKartProductAndTotalProduct];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)shopingListMethod
{
    @try{
        if(OBJGlobal.aryFavoriteListGlobal.count==0)
            if(GETBOOL(@"isUserHasLogin")==true){
                
                //            [APPDATA showLoader];
                Users *objShoping = OBJGlobal.user;
                
                [objShoping ViewWishList:^(NSDictionary *user, NSString *str, int status)
                 {
                     if (status == 1) {
                         
                         if([OBJGlobal isNotNull:[user valueForKey:@"data"]])
                             OBJGlobal.aryFavoriteListGlobal = [[NSMutableArray alloc] initWithArray:[user objectForKey:@"data"]];
                         
                         
                         NSLog(@"success");
                     }
                     
                 }];
            }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark release memory on full
-(void)removeDataOnMemoryFull
{
    @try{
        [aryDashBoard enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
            DashboardCell *cell =[self.tableView cellForRowAtIndexPath:indexPath];
            UIScrollView *scrollView = cell.scrollView;
            
            [scrollView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
       }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    [self performSelectorOnMainThread:@selector(removeDataOnMemoryFull) withObject:nil waitUntilDone:YES];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @try{
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            CGPoint offset = scrollView.contentOffset;
            CGRect bounds = scrollView.bounds;
            CGSize size = scrollView.contentSize;
            UIEdgeInsets inset = scrollView.contentInset;
            float y = offset.y + bounds.size.height - inset.bottom;
            float h = size.height;
            
            float reload_distance = 50;
            if(y > h + reload_distance && isCallDashboardService==true) {
                NSLog(@"load more data");
                
                if([OBJGlobal.totalPageDashBoard integerValue]>=OBJGlobal.pageNoCountDashBoard && spinner){
                    isCallDashboardService=false;
                    self.tableView.tableFooterView.hidden = FALSE;
                    
                    spinner.hidden=false;
                    refreshControl.hidden=false;
                    [spinner startAnimating];
                    [APPDATA hideLoader];
                    
                    //                [APPDATA showLoader];
                    if(GETBOOL(@"isUserHasLogin")==true)
                        OBJGlobal.pageNoCountDashBoard++;
                    [self loadDashBoardData:[NSString stringWithFormat:@"%ld",(long)OBJGlobal.pageNoCountDashBoard]];
                    
                }
                else{
                    self.tableView.tableFooterView.hidden = true;
                    spinner.hidden=true;
                    refreshControl.hidden=true;
                }
                
            }
            else {
                if(!([OBJGlobal.totalPageDashBoard integerValue]>=OBJGlobal.pageNoCountDashBoard)){
                    if(spinner && refreshControl){
                        [spinner removeFromSuperview];
                        [refreshControl removeFromSuperview];
                        spinner=nil;
                        refreshControl=nil;
                    }
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

@end


