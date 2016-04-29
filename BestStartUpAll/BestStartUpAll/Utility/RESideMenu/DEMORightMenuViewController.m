//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMORightMenuViewController.h"
#import "DashboardViewController.h"
#import "SubCategoriesViewController.h"
#import "SearchViewController.h"
#import "LocationViewController.h"
#import "MyKartViewController.h"
#import "PaymentViewController.h"
#import "CheckoutViewController.h"
#import "RegisterViewController.h"
#import "CategoriesViewController.h"
#import "PointsViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ShoppingListViewController.h"
#import "SpecialRequestViewController.h"
#import "ContactUsViewController.h"
#import "FAQViewController.h"
#import "MyOrdesViewController.h"
#import "LoginViewController.h"
#import "MyaccountViewController.h"
#import "FMDBDataAccess.h"


//#import "CalendarVC.h"
//#import "DashboardViewController.h"
//#import "ClassListVC.h"
//#import "MessageVC.h"
#import "Constant.h"
#import "AppDelegate.h"
#import "Globals.h"


//#import "DEMOSecondViewController.h"

@interface DEMORightMenuViewController ()
{
    NSArray *arrTitles;
    NSArray *arrImages;
    UIView *headerView;
    Globals *OBJGlobal;
    FMDBDataAccess *dbAccess;
}

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation DEMORightMenuViewController

-(void)viewWillAppear:(BOOL)animated
{
    if(!OBJGlobal)
        OBJGlobal = [Globals sharedManager];
    if(GETBOOL(@"isUserHasLogin")==true){
        //        OBJGlobal.selectedIndexPathForRightMenu=0;
        [self changeTitleForAccount:@"Log Out"];
    }
    else
        [self changeTitleForAccount:@"Login"];
    
    if(OBJGlobal.isUserHasGotLogin){
        OBJGlobal.isUserHasGotLogin=false;
        OBJGlobal=0;
    }
    self.tableView.contentOffset=CGPointMake(0,20);
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    @try{
        OBJGlobal = [Globals sharedManager];

        UIColor *yourColor = [UIColor colorWithRed:77.0f/255.0f green:22.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
        self.view.backgroundColor = yourColor;
        headerView.backgroundColor = yourColor;
        
        self.tableView = ({
            UITableView *tableView;
            if(IS_IPHONE_6_PLUS)
                tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width,CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
            else
                tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width,CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
            
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
        _tableView.scrollEnabled=true;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UILabel *locationLabel;
        //    _tableView.backgroundColor = [UIColor colorWithRed:(77/255) green:(22/255) blue:(144/255) alpha:1];
        if(IS_IPHONE_6_PLUS)
        {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-220, 15, 272, 200)];
            
            locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-250, 90, 163, 150)];
            locationLabel.textAlignment=NSTextAlignmentCenter;
            
            locationLabel.text =OBJGlobal.pin;
            locationLabel.textColor=[UIColor whiteColor];
         //   [locationLabel setFont:[UIFont boldSystemFontOfSize:16]];
             locationLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:18];
            [headerView addSubview:locationLabel];
            
            UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.frame.origin.x-5, locationLabel.frame.size.height+40, headerView.frame.size.width-90, 2)];
            orangeView.backgroundColor = [UIColor orangeColor];
            [headerView addSubview:orangeView];
            
        }
        else
        {
            headerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-200, 15, 272, 180)];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-150, 55, 68, 68)];
            imageView.image = [UIImage imageNamed:@"logo"];
            [headerView addSubview:imageView];
            
            locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-200, 90, 150, 100)];
            locationLabel.textAlignment=NSTextAlignmentCenter;
            
            locationLabel.text = OBJGlobal.pin;
            
            locationLabel.textColor=[UIColor whiteColor];
            [locationLabel setFont:[UIFont boldSystemFontOfSize:14]];
            [headerView addSubview:locationLabel];
            
            UIView *orangeView = [[UIView alloc] initWithFrame:CGRectMake(locationLabel.frame.origin.x, locationLabel.frame.size.height+55, headerView.frame.size.width-110, 2)];
            orangeView.backgroundColor = [UIColor orangeColor];
            [headerView addSubview:orangeView];
            
        }
        NSString *strLocation =  GETOBJECT(@"Location");
        if(strLocation.length>0)
            locationLabel.text = strLocation;
        headerView.backgroundColor = yourColor;
        if( IS_IPHONE_6_PLUS){
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame)-220, 40, 108, 108)];
            imageView.image = [UIImage imageNamed:@"logo"];
            [headerView addSubview:imageView];
        }
        self.tableView.tableHeaderView = headerView;
        [self.view addSubview:self.tableView];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)changeTitleForAccount:(NSString*)strTitle
{
    if(IS_IPHONE_5 || IS_IPHONE_4){
        arrTitles = @[@"Home", @"Categories",@"My Account", @"My Orders", @"Wallet", @"Shopping List",@"Faq",@"Contact Us",@"Special Request",strTitle,@"",@""];
        arrImages = @[@"home", @"category", @"account", @"order", @"wallet", @"shoppinglist",@"faq",@"contact",@"request",@"account",@"",@""];
    }
    else if (IS_IPHONE_6)
    {
        arrTitles = @[@"Home", @"Categories", @"My Account", @"My Orders", @"Wallet", @"Shopping List",@"Faq",@"Contact Us",@"Special Request",strTitle,@"",@"",@"",@"",@"",@""];
        arrImages = @[@"home", @"category", @"account", @"order", @"wallet", @"shoppinglist",@"faq",@"contact",@"request",@"account",@"",@"",@"",@"",@"",@""];
    }
    else{
        arrTitles = @[@"Home", @"Categories", @"My Account", @"My Orders", @"Wallet", @"Shopping List",@"Faq",@"Contact Us",@"Special Request",strTitle,@"",@"",@"",@"",@"",@"",@"",@""];
        arrImages = @[@"home", @"category", @"account", @"order", @"wallet", @"shoppinglist",@"faq",@"contact",@"request",@"account",@"",@"",@"",@"",@"",@"",@"",@""];
    }
    
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell.textLabel setTextColor:[UIColor orangeColor]];
        
        switch (indexPath.row) {
            case 0: {
                OBJGlobal.selectedIndexPathForRightMenu = indexPath.row;

                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                DashboardViewController *objDashboardViewController=(DashboardViewController *)[storybord  instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:objDashboardViewController]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];}
                
                break;
            case 1: {
                OBJGlobal.selectedIndexPathForRightMenu = indexPath.row;

                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                CategoriesViewController *objDashboardViewController=(CategoriesViewController *)[storybord  instantiateViewControllerWithIdentifier:@"CategoriesViewController"];
                
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:objDashboardViewController]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                
            }
                break;
                
            case 2: {
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                if(GETBOOL(@"isUserHasLogin")==false)
                {
                    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    LoginViewController *objLoginViewController=(LoginViewController *)[storybord  instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    
                    UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                    
                    [mainNavigation pushViewController:objLoginViewController animated:YES];
                    
                    [self.sideMenuViewController hideMenuViewController];
                    
                }
                if(GETBOOL(@"isUserHasLogin")==true){
                    
                    MyaccountViewController *objMyaccountViewController=(MyaccountViewController *)[storybord  instantiateViewControllerWithIdentifier:@"MyaccountViewController"];
                    
                    
                    UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                    
                    [mainNavigation pushViewController:objMyaccountViewController animated:YES];
                    
                    [self.sideMenuViewController hideMenuViewController];
                }
                
            }
                break;
                
                
            case 3: {
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                MyOrdesViewController *objMessageVC=(MyOrdesViewController *)[storybord  instantiateViewControllerWithIdentifier:@"MyOrdesViewController"];
                
                UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                
                [mainNavigation pushViewController:objMessageVC animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
            }
                break;
                
            case 4: {
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                if(GETBOOL(@"isUserHasLogin")==false)
                {
                    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    LoginViewController *objLoginViewController=(LoginViewController *)[storybord  instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    
                    UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                    
                    [mainNavigation pushViewController:objLoginViewController animated:YES];
                    
                    [self.sideMenuViewController hideMenuViewController];
                    
                }
                if(GETBOOL(@"isUserHasLogin")==true){
                    
                    PointsViewController *objMessageVC=(PointsViewController *)[storybord  instantiateViewControllerWithIdentifier:@"PointsViewController"];
                    
                    UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                    
                    [mainNavigation pushViewController:objMessageVC animated:YES];
                    
                    [self.sideMenuViewController hideMenuViewController];
                }
                
            }

                break;
                
                
            case 5: {
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ShoppingListViewController *objMessageVC=(ShoppingListViewController *)[storybord  instantiateViewControllerWithIdentifier:@"ShoppingListViewController"];
                
                UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                
                [mainNavigation pushViewController:objMessageVC animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
            }
                break;
            case 6: {
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                FAQViewController *objMessageVC=(FAQViewController *)[storybord  instantiateViewControllerWithIdentifier:@"FAQViewController"];
                
                UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                
                [mainNavigation pushViewController:objMessageVC animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
            }
                break;
                
            case 7: {
                
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                ContactUsViewController *objDashboardViewController=(ContactUsViewController *)[storybord  instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
                
                
                UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                
                [mainNavigation pushViewController:objDashboardViewController animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
                
            }
                break;
            case 8: {
                
                UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                SpecialRequestViewController *objDashboardViewController=(SpecialRequestViewController *)[storybord  instantiateViewControllerWithIdentifier:@"SpecialRequestViewController"];
                
                UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                
                [mainNavigation pushViewController:objDashboardViewController animated:YES];
                
                [self.sideMenuViewController hideMenuViewController];
            }
                
                break;
            case 9: {
                
                if(GETBOOL(@"isUserHasLogin")==true)
                {
                 
                    [self changeTitleForAccount:@"Login"];
                    SETBOOL(false, @"isUserHasLogin");
                    //                OBJGlobal.rightSideDetectForLogOutPress = [[NSString stringWithFormat:@"%d",1] mutableCopy];
                    OBJGlobal.selectedIndexPathForRightMenu=0;
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailid"];
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Password"];
                    SYNCHRONIZE;
                    [self.tableView reloadData];
                    
                    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    DashboardViewController *objDashboardViewController=(DashboardViewController *)[storybord  instantiateViewControllerWithIdentifier:@"DashboardViewController"];
                    
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:objDashboardViewController]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                }
                else{
                    
                    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    LoginViewController *objLoginViewController=(LoginViewController *)[storybord  instantiateViewControllerWithIdentifier:@"LoginViewController"];
                    
                    UINavigationController *mainNavigation = (UINavigationController *) [self.sideMenuViewController contentViewController];
                    
                    [mainNavigation pushViewController:objLoginViewController animated:YES];
                    
                    [self.sideMenuViewController hideMenuViewController];
                }
                
            }
                break;
                
                
            default:
                break;
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return arrTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RightCell";
    @try{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        UILabel *cellLabel;
        UIImageView *cellimageView;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            UIColor *yourColor = [UIColor colorWithRed:77.0f/255.0f green:22.0f/255.0f blue:114.0f/255.0f alpha:1];
            //        self.tableView.backgroundColor = yourColor ;
            //        self.tableView.backgroundView.backgroundColor = yourColor ;
            cell.backgroundColor = yourColor;
            
            cell.textLabel.highlightedTextColor = [UIColor whiteColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            
            UIImage *img=[UIImage imageNamed:arrImages[indexPath.row]];
            cellimageView = (UIImageView *) [cell viewWithTag:indexPath.row+2000];
            
            cellimageView = [[UIImageView alloc] init];
            if(img)
                cellimageView.image = img;
            cellimageView.tag = indexPath.row+2000;
            int yPos =(cell.frame.size.height -img.size.height)/2;
            
            if(IS_IPHONE_5)
                [cellimageView setFrame:CGRectMake(140, yPos, img.size.width, img.size.height)];
            else if(IS_IPHONE_4)
                [cellimageView setFrame:CGRectMake(120, yPos, img.size.width, img.size.height)];
            else
                [cellimageView setFrame:CGRectMake(190, yPos, img.size.width, img.size.height)];
            
            [cell.contentView addSubview:cellimageView];
            
            if(IS_IPHONE_5)
                cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(cellimageView.frame.origin.x+35, cell.textLabel.frame.origin.y+7, cell.frame.size.width-cellimageView.frame.size.width, 30)];
            else
                cellLabel=[[UILabel alloc]initWithFrame:CGRectMake(cellimageView.frame.origin.x+35, cell.textLabel.frame.origin.y+7,200, 30)];
            
          //  cellLabel.font = [UIFont boldSystemFontOfSize:12.0f];
            
            cellLabel.text = arrTitles[indexPath.row];
          // if(IS_IPHONE_5)
               // cellLabel.font = [UIFont boldSystemFontOfSize:12.0f];
                cellLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
           
            
            cellLabel.textColor=[UIColor whiteColor];
            cellLabel.tag = indexPath.row+6000;
            
            cellLabel.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:cellLabel];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        cellLabel = (UILabel *) [cell viewWithTag:indexPath.row+6000];
        
        cellLabel.text = arrTitles[indexPath.row];
        UIImage *img;
        cellimageView = (UIImageView *) [cell viewWithTag:indexPath.row+2000];
        if(OBJGlobal.selectedIndexPathForRightMenu==indexPath.row){
            cellLabel.textColor = [UIColor orangeColor];
            img = [UIImage imageNamed:[NSString stringWithFormat:@"%@-active.png",arrImages[indexPath.row]]];
            if(img)
                cellimageView.image = img;
            
            NSLog(@"OBJGlobal.selectedIndexPathForRightMenu %ld",(long)OBJGlobal.selectedIndexPathForRightMenu);
        }
        else{
            img = [UIImage imageNamed:arrImages[indexPath.row]];
            
            cellLabel.textColor = [UIColor whiteColor];
            if(img)
                cellimageView.image = img;
            
        }
        
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

@end
