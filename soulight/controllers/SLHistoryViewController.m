//
//  SLHistoryViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHistoryViewController.h"
#import "SLInputTableViewCell.h"
#import "SLInputTableHeaderView.h"



@interface SLHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)   UITableView *tableView;

@end

@implementation SLHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self init
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView = ({
        UITableView *t = [[UITableView alloc] initWithFrame:CGRectMake(16, 20, 180, self.view.height-20)
                                                      style:UITableViewStyleGrouped];
        t.separatorStyle = UITableViewCellSeparatorStyleNone;
        t.showsVerticalScrollIndicator = NO;
        t.backgroundColor = [UIColor clearColor];
        t.dataSource = self;
        t.delegate = self;
        t.sectionFooterHeight = 0;
        t.contentInset = UIEdgeInsetsMake(0, 0, -20, 0);
        t;
    });

    [self.view addSubview:_tableView];
    
    UIButton *settingBtn = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(238, 504, 48, 48)];
        [b setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
        b.showsTouchWhenHighlighted = YES;
        b.layer.cornerRadius = 48/2;
        b.layer.borderWidth = 1;
        b;
    });
    
    
    [self.view addSubview:settingBtn];
    
    // controls setup
    
    [_tableView registerClass:[SLInputTableViewCell class] forCellReuseIdentifier:kCellIdInput];
    [_tableView registerClass:[SLInputTableHeaderView class] forHeaderFooterViewReuseIdentifier:kCellHeaderIdInput];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdInput forIndexPath:indexPath];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SLInputTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellHeaderIdInput];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@ 6月7日", @(section)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 127;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

@end
