//
//  CategoriesViewController.h
//  peter
//
//  Created by Peter on 12/30/15.
//  Copyright © 2015 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"

@interface CategoriesViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
-(void)btnSearchPressed;

@end
