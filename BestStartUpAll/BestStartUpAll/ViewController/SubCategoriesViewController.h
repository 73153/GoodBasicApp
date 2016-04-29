//
//  SubCategoriesViewController.h
//  peter
//
//  Created by Peter on 1/4/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import "SubcategoryCell.h"
#import "PopUpTableViewController.h"
#import "RESideMenu.h"
#import "SDSegmentedControl.h"

@interface SubCategoriesViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,SubCategoryPopUp>
{
    ALAssetsLibrary *library;
    NSMutableArray *imageArray;
}
@property (weak, nonatomic) IBOutlet SDSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewOne;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewTwo;
@property (nonatomic, strong) PopUpTableViewController *objPopUpTableController;
@property (strong, nonatomic) IBOutlet UILabel *lblNoProduct;
@property (weak, nonatomic) IBOutlet UIButton *btnPopularBrand;
@property (weak, nonatomic) IBOutlet UIButton *popUpBtnClose;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTwoHeightConstant;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *popUpItemDescription;
@property (weak, nonatomic) IBOutlet UIImageView *popUpImage;
@property (weak, nonatomic) IBOutlet UILabel *popUpImageName;
@property (weak, nonatomic) IBOutlet UILabel *popUpItemPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPopUpItemDescription;
@property (weak, nonatomic) IBOutlet UIView *roundedPopUpView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewMore;
@property (weak, nonatomic) IBOutlet UIView *viewRefresh;
@property(weak) id<SubCategoryPopUp> delegatePopUp;

- (IBAction)segmentDidChange:(id)sender;
- (IBAction)btnClosePopUpPressed:(id)sender;
- (IBAction)btnAddItemPressed:(id)sender;
- (IBAction)btnMinuItemPressed:(id)sender;
- (IBAction)btnViewMorePressed:(id)sender;

-(void)showPopUpBrandList;
-(void)categoryAssignProductList:(NSString*)strPageCount;
-(void)reloadCartData:(NSDictionary*)dictResult;
-(void)getCartListForBadgeCount;

//-(void)compareForKartProductAndTotalProduct;

@end
