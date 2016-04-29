//
//  CategoriesViewController.m
//  peter
//
//  Created by Peter on 12/30/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import "CategoriesViewController.h"
#import "CollectionCell.h"
#import "UIViewController+NavigationBar.h"
#import "SubCategoriesViewController.h"
#import "UIImageView+WebCache.h"
#import "Constant.h"
#import "FMDBDataAccess.h"
//#import "ImageWithURL.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface CategoriesViewController ()
{
    Globals *OBJGlobal;
    UIButton *btnBadgeCount;
    FMDBDataAccess *dbAccess;
}
@end

@implementation CategoriesViewController
{
    NSArray *_contents;
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
        _contents = OBJGlobal.aryLeftSideMenuDetail;
        [OBJGlobal setNavigationTitleAndBGImageName:@"header" navigationController:self.navigationController];
        [OBJGlobal setTitleForBadgeCountOnViewAppears:btnBadgeCount];
        
        if([OBJGlobal.aryKartDataGlobal count]<=0)
            btnBadgeCount.hidden=true;
        else
            btnBadgeCount.hidden=false;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)viewDidLoad
{
    @try{
        [super viewDidLoad];
        OBJGlobal = [Globals sharedManager];
        dbAccess = [[FMDBDataAccess alloc] init];
        [self setMenuIconForSideBar:@"cal"];
        btnBadgeCount = [self setUpImageSecondRightButton:@"menu" secondImage:@"search" thirdImage:@"logo" badgeCount:[[NSString stringWithFormat:@"%@",OBJGlobal.numberOfCartItems] integerValue]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 44, 56)];
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines =0;
        
        label.font = [UIFont fontWithName:@"Avenir-Black" size:18];
        label.text = @"Categories";
        label.textColor = [UIColor whiteColor];
        self.navigationItem.titleView = label;
        
        if(GETBOOL(@"isUserHasLogin")==true){
            [OBJGlobal setTitleForBadgeCountOnViewAppears:btnBadgeCount];
        }
        if(GETBOOL(@"isUserHasLogin")==false){
            OBJGlobal.aryKartDataGlobal = [[dbAccess fetchAllProductDataFromLocalDB] mutableCopy];
            [OBJGlobal setTitleBadgeCountFromLocalDB:btnBadgeCount aryKartDetail:OBJGlobal.aryKartDataGlobal];
            
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSArray *subviews = [[NSArray alloc] initWithArray:self.collectionView.subviews];
        
        [subviews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[UIImageView class]])
                [obj removeFromSuperview];
            
        }];
        NSDictionary *dictProductDetail;
        dictProductDetail = [_contents objectAtIndex:indexPath.row];
        
        if([OBJGlobal isNotNull:[dictProductDetail valueForKey:@"category_image"]] && [[dictProductDetail allKeys] containsObject:@"category_image"])
        {
            NSString *strURL = [dictProductDetail valueForKey:@"category_image"];
            
            cell.imageView.tag = indexPath.row+40034;
            UIImageView *imageView1 = (UIImageView *)[cell.imageView viewWithTag:indexPath.row+40034];
            
            
            if(imageView1){
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,120, 115)];
                
                imageView.tag=indexPath.row+40034;
                imageView.clipsToBounds = YES;
                imageView.contentMode =UIViewContentModeScaleAspectFit;
                
                //                    NSURL *Url =[NSURL URLWithString:strURL];
                //                    imageView.imageURL = Url;
                //                [imageView setImage:[UIImage imageNamed:@"img_not_available.png"]];
                [imageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [cell.imageView  addSubview:imageView];
            }
            else{
                [cell.imageView setImageWithURL:[NSURL URLWithString:strURL] placeholderImage:[UIImage imageNamed:@"img_not_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                // Load image asynchronously and show the image when loaded.
                //                    [imageView loadImageWithURL:strURL];
                //
            }
            
            //                [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView1];
            
            //            [cell.imageView initWithImageAtURL:[NSURL URLWithString:srtURL] image:cell.imageView];
            
            
            //            [cell.imageView sd_setImageWithURL:[[NSURL alloc] initWithString:srtURL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //            }];
            
        }
        
        cell.label.text = [dictProductDetail valueForKey:@"category_name"];
        cell.label.lineBreakMode=NSLineBreakByWordWrapping;
        cell.label.numberOfLines =0;
        //        cell.label.lineBreakMode=YES;
        cell.label.font = [UIFont boldSystemFontOfSize:14];
        cell.label.font = [UIFont fontWithName:@"Avenir-Book" size:14];
        
        cell.label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
        cell.label.adjustsFontSizeToFitWidth = YES;
        
        return cell;
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        OBJGlobal.selectedIndexpathForLeft=indexPath.row;
        NSString *strCat_ID=[[_contents objectAtIndex:indexPath.row] valueForKey:@"category_id"];
        OBJGlobal.lblSubCategoryName = [[_contents objectAtIndex:indexPath.row] valueForKey:@"category_name"];
        OBJGlobal.cat_id_TopBarSubCategory = [strCat_ID mutableCopy];
        OBJGlobal.cat_id_PopularBrandSubCategory = [strCat_ID mutableCopy];
        
        SubCategoriesViewController *objDashboardViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SubCategoriesViewController"];
        [self.navigationController pushViewController:objDashboardViewController animated:NO];
    } @catch (NSException *exception) {
        NSLog(@"Exception At: %s %d %s %s %@", __FILE__, __LINE__, __PRETTY_FUNCTION__, __FUNCTION__,exception);
    }
}

-(void)btnSearchPressed
{
    
}

@end
