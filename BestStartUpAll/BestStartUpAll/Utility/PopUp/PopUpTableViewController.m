//
//  PopUpTableViewController.m
//  SearchTableSample
//
//  Created by Manish on 14/11/13.
//  Copyright (c) 2013 Self. All rights reserved.
//

#import "PopUpTableViewController.h"
#import "Globals.h"
@interface PopUpTableViewController ()<PopUpDelegate>
{
    Globals *OBJGlobal;
}
@end

@implementation PopUpTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.tableView.tableHeaderView = ({
    //
    //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 800, 80)];
    //        UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [sampleButton setFrame:CGRectMake(140, 30, 120, 30)];
    //        [sampleButton setTitle:@"Done" forState:UIControlStateNormal];
    //        [sampleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [sampleButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    //         sampleButton.layer.masksToBounds = YES;
    //         sampleButton.layer.cornerRadius = 5.0;
    //        [sampleButton setBackgroundColor:[UIColor blackColor]];
    //        [view addSubview:sampleButton];
    //
    //        view;
    //    });
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
-(void)buttonPressed
{
    UITableViewCell *cell =  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = [self.dataSource[0] objectForKey:@"description"];
    
    [self toggleHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadDataWithSource:(NSArray *)sourceArray{
    if(!OBJGlobal)
        OBJGlobal = [Globals sharedManager];
    
    self.dataSource = sourceArray;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //    [self.tableView reloadData];
}

-(void)toggleHidden:(BOOL)toggle{
    int alpha = toggle?0:1;
    //    [UIView animateWithDuration:0.0f animations:^{
    self.tableView.alpha = alpha;
    //    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    [subviews enumerateObjectsUsingBlock:^(UIView  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UILabel class]])
            [obj removeFromSuperview];
        if ([obj isKindOfClass:[UIButton class]])
            [obj removeFromSuperview];
        
    }];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
//    if(OBJGlobal.isDeliveryPreferencePopUp==false && indexPath.row==0 && indexPath.section==0){
//        UIButton *btnClose;
//        btnClose = (UIButton*)[cell.contentView viewWithTag:indexPath.row+2222];
//        if(!btnClose){
//            UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(cell.frame.size.width-50, 0, 50, 50)];
//            [btnClose setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
//            [btnClose addTarget:self action:@selector(buttonClosePressed:) forControlEvents:UIControlEventTouchUpInside];
//            btnClose.tag=indexPath.row+2222;
//            [cell.contentView addSubview:btnClose];
//        }
//    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    if (indexPath.row == 0) {
////        return 100;
////    }
////    else {
//        return 60;
////    }
//}
-(void)buttonClosePressed:(id)sender
{
    [self.delegate btnClosePopUp];
    
}
#pragma mark popup delegate
-(void)btnClosePopUp{
}
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectedRegionString:self.dataSource[indexPath.row] tableView:self];
    
}

-(void)didSelectedRegionString:(NSString *)selectedString tableView:(id)tableView
{
    
}



@end
