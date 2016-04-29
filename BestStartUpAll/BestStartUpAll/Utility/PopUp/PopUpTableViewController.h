//
//  PopUpTableViewController.h
//  SearchTableSample
//
//  Created by Peter on 14/11/15.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUpDelegate <NSObject>

-(void)didSelectedRegionString:(NSString *)selectedString tableView:(id)tableView;
-(void)btnClosePopUp;

@end

@interface PopUpTableViewController : UITableViewController{
    id <PopUpDelegate> delegate;
}
@property (nonatomic, weak) id <PopUpDelegate> delegate;
@property (nonatomic, strong) NSArray *dataSource;
-(void)reloadDataWithSource:(NSArray *)sourceArray;
-(void)toggleHidden:(BOOL)toggle;


//Peter
//@property (nonatomic, strong) PopUpTableViewController *objPopUpTableController;
@end
