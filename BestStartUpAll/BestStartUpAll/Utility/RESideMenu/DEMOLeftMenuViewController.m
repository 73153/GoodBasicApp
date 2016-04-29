//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "DashboardViewController.h"
#import "SubCategoriesViewController.h"
#import "Globals.h"
#import "CommonPopUpView.h"
#import "Constant.h"
#import "CommonPopUpView.h"
#import "AppDelegate.h"

//#import "DEMOSecondViewController.h"

@interface DEMOLeftMenuViewController ()
{
    UIView *headerView;
    NSArray *aryResponseSubProductDetails;
    Globals *OBJGlobal;
    BOOL isResponseReceived;
    
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation DEMOLeftMenuViewController

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
    
    
    if(isResponseReceived==false)
        [self callSubcategoryListService];
    UILabel *lblLocationTitle = (UILabel*)[headerView viewWithTag:7890];
    lblLocationTitle.text = OBJGlobal.pin;
    self.tableView.contentOffset=CGPointMake(0,20);
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        isResponseReceived=false;
        OBJGlobal = [Globals sharedManager];
        //[self callSubcategoryListService];
        
        OBJGlobal.selectedIndexpathForLeft=0;
        
        aryResponseSubProductDetails =@[ @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         @{@"category_id":@"",
                                           @"category_image":@"",
                                           @"category_name":@"",
                                           },
                                         ];
        //                aryResponseSubProductDetails =@[ @{@"category_id":@"4",
        //                                                   @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/fruits-veges.png",
        //                                                   @"category_name":@"Fruits & Vegetables",
        //                                                   },
        //                                                 @{
        //                                                     @"category_id":@"5",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/breakfast.png",
        //                                                     @"category_name":@"Breakfast & Instant Food",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"6",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/beverages.png",
        //                                                     @"category_name":@"Beverages",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"7",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/snacks.png",
        //                                                     @"category_name":@"Snacks",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"9",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/masala.png",
        //                                                     @"category_name":@"Masala & Spices",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"10",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/oil.png",
        //                                                     @"category_name":@"Oils & Ghee",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"11",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/sauces.png",
        //                                                     @"category_name":@"Sauces, Chutneys & Pickle",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"12",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/baking.png",
        //                                                     @"category_name":@"Baking & Mixes",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"14",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/dal-pulses.png",
        //                                                     @"category_name":@"Dals/Pulses & Beans",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"16",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/dryfruits.png",
        //                                                     @"category_name":@"Dry Fruits & Nuts",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"17",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/rice-grains.png",
        //                                                     @"category_name":@"Rice & Grains",
        //                                                     },
        //                                                 @{
        //                                                     @"category_id":@"44",
        //                                                     @"category_image":@"http://216.55.169.45/~peter/master/media/catalog/category/frozen.png",
        //                                                     @"category_name":@"Frozen Foods",
        //                                                     }
        //                                                 ];
        //        isResponseReceived=true;
        //        OBJGlobal.aryLeftSideMenuDetail=[aryResponseSubProductDetails mutableCopy];
        
        if(IS_IPHONE_5){
            
        }
        else
        {
            
        }
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
            tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.opaque = NO;
            // tableView.backgroundColor = [UIColor colorWithRed:(216/255.0f) green:(89/255.0f) blue:(36/255.0f) alpha:1.0f];
            tableView.backgroundView = nil;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.bounces = NO;
            //        tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sidebar"]];
            
            tableView;
        });
        UILabel *locationLabel;
        _tableView.scrollEnabled=true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIColor *yourColor = [UIColor colorWithRed:77.0f/255.0f green:22.0f/255.0f blue:114.0f/255.0f alpha:1];
        
        headerView.backgroundColor = yourColor;
        if(IS_IPHONE_6_PLUS)
        {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 272, 200)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, 100, 100)];
            imageView.image = [UIImage imageNamed:@"logo"];
            [headerView addSubview:imageView];
            
            
            locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 163, 150)];
            //locationLabel.text =OBJGlobal.pin;
           
    
            locationLabel.text=@"CATEGORIES";
             locationLabel.textColor=[UIColor whiteColor];
            locationLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14];
            [headerView addSubview:locationLabel];
            
           // locationLabel.tag=7890;
            UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.frame.origin.x-35, locationLabel.frame.size.height+28, headerView.frame.size.width-90, 2)];
            orangeView.backgroundColor = [UIColor orangeColor];
            [headerView addSubview:orangeView];
        }
        else
        {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 272, 180)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 55, 65, 65)];
            imageView.image = [UIImage imageNamed:@"logo"];
            [headerView addSubview:imageView];
            
            locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 90, 150, 100)];
            locationLabel.text =@"CATEGORIES";
            locationLabel.textColor=[UIColor whiteColor];
            [locationLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:14]];
            [headerView addSubview:locationLabel];
            
            //         UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.size.height+40, headerView.frame.size.width-110, 5)];
            
            UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.frame.origin.x-30, locationLabel.frame.size.height+55, headerView.frame.size.width-120, 2)];
            
            orangeView.backgroundColor = [UIColor orangeColor];
            [headerView addSubview:orangeView];
        }
        
        
        //         UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.size.height+40, headerView.frame.size.width-110, 5)];
         locationLabel.text=@"CATEGORIES";
        headerView.backgroundColor = yourColor;
        self.tableView.tableHeaderView = headerView;
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)callSubcategoryListService
{
    
    @try{
        if(OBJGlobal.aryLeftSideMenuDetail.count>0)
        {
            aryResponseSubProductDetails = OBJGlobal.aryLeftSideMenuDetail;
            [self.tableView reloadData];
            return;
        }
        Users *objDashboard=[[Users alloc]init];
        [APPDATA showLoader];
        
        //[self getImageData];
        [objDashboard topBarProductList:^(id result,NSString *str, int status)
         {
             
//             [APPDATA hideLoader];
             if(status==1)
             {
                 if([OBJGlobal isNotNull:[result valueForKey:@"data"]]){
                     aryResponseSubProductDetails = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"data"]];
                     OBJGlobal.aryLeftSideMenuDetail = [aryResponseSubProductDetails mutableCopy];
                     [self.tableView reloadData];
                 }
                 
             }else{
                 [self callSubcategoryListService];
                 return;
             }
             
             
             isResponseReceived=true;
             
             
         }];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        if(isResponseReceived==false)
            return;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor orangeColor]];
        OBJGlobal.selectedIndexpathForLeft = indexPath.row;
        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NSString *strCat_ID=[[aryResponseSubProductDetails objectAtIndex:indexPath.row] valueForKey:@"category_id"];
        
        OBJGlobal.lblSubCategoryName = [[aryResponseSubProductDetails objectAtIndex:OBJGlobal.selectedIndexpathForLeft] valueForKey:@"category_name"];
        OBJGlobal.cat_id_TopBarSubCategory = [strCat_ID mutableCopy];
        
        SubCategoriesViewController *objClassListVC=(SubCategoriesViewController *)[storybord  instantiateViewControllerWithIdentifier:@"SubCategoriesViewController"];
        
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:objClassListVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return aryResponseSubProductDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UIImageView *cellimageView;
        
        NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
        for (UILabel *subview in subviews) {
            [subview removeFromSuperview];
        }
        
        for (UIImageView *subview in subviews) {
            [subview removeFromSuperview];
        }
        UILabel *cellLabel;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIColor *yourColor = [UIColor colorWithRed:77.0f/255.0f green:22.0f/255.0f blue:114.0f/255.0f alpha:1];
            cell.backgroundColor = yourColor;
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        if(isResponseReceived)
        {
            cellLabel = (UILabel *) [cell viewWithTag:indexPath.row+6000];
            
            if(!cellLabel){
                if(IS_IPHONE_5 || IS_IPHONE_4)
                {
                    cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, cell.textLabel.frame.origin.y, 200,50)];
                    //                    cellLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightBlack];
                    cellLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
                    
                    
                }
                else{
                    cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, cell.textLabel.frame.origin.y, 200,50)];
                    //  cellLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightBlack];
                    cellLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
                }
                
                //            cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(cellimageView.frame.origin.x-170, cell.textLabel.frame.origin.y+7, cell.frame.size.width-cellimageView.frame.size.width, 50)];
                //        [cell.contentView addSubview:cellimageView];
                
                //    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+10, cell.textLabel.frame.origin.y+7, cell.frame.size.width-imageView.frame.size.width, 30)];
                cellLabel.tag = indexPath.row+6000;
                
                if([OBJGlobal isNotNull:[[aryResponseSubProductDetails objectAtIndex:indexPath.row] valueForKey:@"category_name"]])
                    cellLabel.text = [[aryResponseSubProductDetails objectAtIndex:indexPath.row] valueForKey:@"category_name"];
                cellLabel.textColor=[UIColor whiteColor];
                cellLabel.backgroundColor=[UIColor clearColor];
                cellLabel.lineBreakMode=NSLineBreakByWordWrapping;
                cellLabel.numberOfLines =0;
                //                cellLabel.adjustsFontSizeToFitWidth = YES;
                cellLabel.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:cellLabel];
            }
            
            if([OBJGlobal isNotNull:[[aryResponseSubProductDetails objectAtIndex:indexPath.row] valueForKey:@"category_name"]])
                cellLabel.text = [[aryResponseSubProductDetails objectAtIndex:indexPath.row] valueForKey:@"category_name"];
            
            //   cellLabel.font = [UIFont boldSystemFontOfSize:11.0f];
            UIImage *img;
            cellimageView = (UIImageView *) [cell viewWithTag:indexPath.row+2000];
            cellimageView.image = img;
            
            img=[UIImage imageNamed:[NSString stringWithFormat:@"%@-default",@"arrow"]];
            
            cellimageView = [[UIImageView alloc] init];
            if(img)
                cellimageView.image = img;
            
            cellimageView.tag = indexPath.row+2000;
            
            //    [cellimageView setFrame:CGRectMake(cellLabel.frame.size.width-200, cellLabel.frame.origin.y, img.size.width, img.size.height)];
            //    10, cell.textLabel.frame.origin.y+7, cell.frame.size.width-cellimageView.frame.size.width-30,50
            [cellimageView setFrame:CGRectMake(cellLabel.frame.size.width+cellLabel.frame.origin.x, cellLabel.frame.size.height/2, img.size.width, img.size.height)];
            
            
            if(OBJGlobal.selectedIndexpathForLeft==indexPath.row){
                NSLog(@"%@", cellLabel.textColor);
                cellLabel.textColor = [UIColor orangeColor];
                img = [UIImage imageNamed:[NSString stringWithFormat:@"%@-active",@"arrow"]];
                
                if(img)
                    cellimageView.image = img;
                
                NSLog(@"OBJGlobal.selectedIndexpathForLeft %ld",(long)OBJGlobal.selectedIndexpathForLeft);
            }
            else{
                img = [UIImage imageNamed:[NSString stringWithFormat:@"%@-default",@"arrow"]];
                
                cellLabel.textColor = [UIColor whiteColor];
                if(img)
                    cellimageView.image = img;
                
            }
            [cell.contentView addSubview:cellimageView];
        }
        
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

//- (UIView *)tableView : (UITableView *)tableView viewForHeaderInSection : (NSInteger) section {
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    imgView.image = [UIImage imageNamed:@"sponsor"];
//
//    return imgView;
//}
@end
