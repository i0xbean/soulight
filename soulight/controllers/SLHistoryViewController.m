//
//  SLHistoryViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHistoryViewController.h"
#import "SLHistoryTableViewCell.h"
#import "SLHistoryTableHeaderView.h"
#import "SLShareReusableView.h"
#import "SLTextDataProvider.h"
#import "SLHistoryTopView.h"
#import "SLAppDelegate.h"



@interface SLHistoryViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic)   SLHistoryTopView *          historyTopView;

@property (strong, nonatomic)   NSArray *                   textDateDatas;
@property (strong, nonatomic)   NSArray *                   textDatas;

@property (strong, nonatomic)   NSIndexPath *               activeIndexPath;

@end

@implementation SLHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    _historyTopView = [[SLHistoryTopView alloc] init];
    [_historyTopView.button bk_addEventHandler:^(id sender) {
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationTop];
        SLTextData *d = [[SLTextDataProvider sharedInstance] createTextData];
        [[SLTextDataProvider sharedInstance] setActiveTextData:d];
        
        [self reloadTextData:^{
            [_tableView endUpdates];
            [[SLTextDataProvider sharedInstance] save];
        }];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = ({
        UITableView *t = [[UITableView alloc] initWithFrame:CGRectMake(16, 20, 180, self.view.height-20)
                                                      style:UITableViewStyleGrouped];
        t.allowsMultipleSelectionDuringEditing = NO;
//        t.separatorStyle = UITableViewCellSeparatorStyleNone;
        t.showsVerticalScrollIndicator = NO;
        t.backgroundColor = [UIColor clearColor];
        t.dataSource = self;
        t.delegate = self;
        t.sectionFooterHeight = 0;
        t.separatorInset = UIEdgeInsetsMake(0, 0, 10, 0);
        t.tableHeaderView = _historyTopView;
        t.clipsToBounds = NO;
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
    
    [_tableView registerClass:[SLHistoryTableViewCell class] forCellReuseIdentifier:kCellIdInput];
    [_tableView registerClass:[SLHistoryTableHeaderView class] forHeaderFooterViewReuseIdentifier:kCellHeaderIdInput];
    
    [self reloadTextData:nil];
    
    DDLogInfo(@"loadllll");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [_tableView debugBackgroundColor];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _textDateDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *someDayTextDatas = _textDatas[section];
    return someDayTextDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdInput forIndexPath:indexPath];
    
    SLTextData *d = _textDatas[indexPath.section][indexPath.row];
    [cell resetWithTextData: d];
    
    BOOL selected = [_activeIndexPath compare:indexPath] == NSOrderedSame;
    [cell setSelected:selected animated:YES];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SLHistoryTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kCellHeaderIdInput];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *d = _textDateDatas[section];
    return [NSString stringWithFormat:@"%ld月%ld日", d.month, d.day];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLTextData *d = _textDatas[indexPath.section][indexPath.row];
    return d.reuseHistoryCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLHistoryTableViewCell *cell = (SLHistoryTableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [[SLTextDataProvider sharedInstance] setActiveTextData:cell.textData];
    [[SLAppDelegate mzAppDelegate].sideMenu hideMenuViewController];
}





#pragma mark - private

- (void)reloadTextData:(void(^)(void))block
{
    [[SLTextDataProvider sharedInstance] formatTextDatas:
     ^(NSArray *formatDates, NSArray *formatTextDatas, NSIndexPath *activeIndexPath)
    {
        _textDateDatas = formatDates;
        _textDatas = formatTextDatas;
        _activeIndexPath = activeIndexPath;
        
        if (block) {
            block();
        }

//        [_tableView selectRowAtIndexPath:activeIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        

    }];
}

@end
