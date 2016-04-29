//
//  CommonPopUpView.h
//  AcademicPulse
//
//  Created by dhara on 11/7/15.
//  Copyright © 2015 com.USBASE. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageWithURL.h"


@protocol ReloadCartDataDelegate <NSObject>

@optional

-(void)reloadCartData:(NSDictionary*)dictResult;

@end

@interface CommonPopUpView : UIView <UIScrollViewDelegate>
{
    
}

@property BOOL isTopProduct;
@property int numberOfProducts;
@property NSString *strProductDetailValue;
@property NSMutableDictionary *dicProductDetailValue;
@property (strong, nonatomic) IBOutlet UIScrollView *scrView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imgPopProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblQntity;
@property (weak, nonatomic) IBOutlet UILabel *lblWeight;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPopUpItemDescription;
@property (nonatomic,strong) IBOutlet UIView *viewImage;
@property (strong, nonatomic) IBOutlet UIView *popUpMainView;
@property (weak, nonatomic) IBOutlet UIView *commonPopUpContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfKartItems;
@property (weak, nonatomic) IBOutlet UIButton *btnTitleName;
@property (weak, nonatomic) IBOutlet UIButton *btnFavourite;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblBrand;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property(strong,nonatomic) id<ReloadCartDataDelegate> delegateCartData;

- (IBAction)pageChanged:(id)sender;
- (IBAction)btnCloseCommonPopUpPressed:(id)sender;
- (IBAction)btnAddToFavouritePressed:(id)sender;
- (IBAction)btnAddToCartPressed:(id)sender;
- (IBAction)btnClosePopUpPressed:(id)sender;
- (IBAction)btnMinusPressed:(id)sender;
- (IBAction)btnPlusPressed:(id)sender;
- (IBAction)btnViewImagePressed:(id)sender;

-(void)initDataForPopUp;
-(void)toggleHidden:(BOOL)toggle;
-(void)setProductDetailValue;

@end
