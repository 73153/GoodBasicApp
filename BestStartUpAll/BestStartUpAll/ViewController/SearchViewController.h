//
//  SearchViewController.h
//  peter
//
//  Created by Peter on 1/5/16.
//  Copyright © 2016 Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
#import "CommonPopUpView.h"

@interface SearchViewController : UIViewController
{
    NSArray *arrSearchProduct;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *lblSearchResult;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchField;
@property (weak, nonatomic) IBOutlet UILabel *lblSearch;

- (IBAction)btnAddToKartPressed:(id)sender;

- (void)btnPlusPressed:(id)sender;
- (void)btnMinusPressed:(id)sender;
-(void)searchProductMethod;



@end
