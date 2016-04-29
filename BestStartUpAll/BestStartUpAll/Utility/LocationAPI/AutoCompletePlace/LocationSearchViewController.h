//
//  LocationSearchViewController.h
//  SearchTableSample
//
//  Created by Manish on 14/11/13.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate1 <NSObject>

-(void)didSelectSearchedString:(NSString *)selectedString;

@end

@interface LocationSearchViewController : UITableViewController{
    id <SearchDelegate1> delegate;
}
@property (nonatomic, weak) id <SearchDelegate1> delegate;
@property (nonatomic, strong) NSArray *dataSource;
-(void)reloadDataWithSource:(NSArray *)sourceArray;
-(void)toggleHidden:(BOOL)toggle;
@end
