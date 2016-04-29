//
//  ProductDetailViewController.h
//  peter
//
//  Created by Peter on 2/8/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"
#import "UIImageView+WebCache.h"
//#import "ImageWithURL.h"

@interface ProductDetailViewController : UIViewController<UIGestureRecognizerDelegate>

@property NSString *strProductDetailValue;
@property NSMutableDictionary *dicProductDetailValue;
@property BOOL isTopProduct;
@property NSInteger numberOfProducts;
@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIImageView *imgPopProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblQntity;
@property (weak, nonatomic) IBOutlet UILabel *lblWaight;
@property (weak, nonatomic) IBOutlet UITextView *txtViewPopUpItemDescription;
@property (nonatomic,strong) IBOutlet UIView *viewImage;
@property (strong, nonatomic) IBOutlet UIView *popUpMainView;
@property (weak, nonatomic) IBOutlet UIButton *btnClosePopup;
@property (weak, nonatomic) IBOutlet UIButton *btnViewImage;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfKartItems;


-(IBAction)btnCancelPressed:(id)sender;
- (IBAction)btnAddToCartPressed:(id)sender;
- (IBAction)btnMinusPressed:(id)sender;
- (IBAction)btnPlusPressed:(id)sender;
- (IBAction)btnViewImagePressed:(id)sender;
- (IBAction)btnAddToFavouritePressed:(id)sender;

-(void)toggleHidden:(BOOL)toggle;
-(void)setProductDetailValue;

@end
