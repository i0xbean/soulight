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
#import "NSArray+MZAddition.h"


@interface SLHistoryViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic)   SLHistoryTopView *          historyTopView;

@property (strong, nonatomic)   NSArray *                   allDates;
@property (strong, nonatomic)   NSArray *                   allDayTextDatas;

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
    
    
    SLTextDataProvider *dataProvider = [SLTextDataProvider sharedInstance];
    
    _allDayTextDatas = dataProvider.allDayTextDatas;
    _allDates = dataProvider.allDates;
    _activeIndexPath = dataProvider.activeIndexPath;
    
    _historyTopView = [[SLHistoryTopView alloc] init];
    [_historyTopView.button bk_addEventHandler:^(id sender) {
        [self createATextData];
        [[SLAppDelegate mzAppDelegate].sideMenu hideMenuViewController];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = ({
        UITableView *t = [[UITableView alloc] initWithFrame:CGRectMake(16, 20, 180, self.view.height-20)
                                                      style:UITableViewStyleGrouped];
        t.allowsMultipleSelection = NO;
        t.allowsMultipleSelectionDuringEditing = NO;
        t.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    if ([_allDayTextDatas containsIndexPath:_activeIndexPath]) {
        [_tableView selectRowAtIndexPath:_activeIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotifDeleteTextDataCell object:nil queue:nil usingBlock:^(NSNotification *note)
    {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                SLHistoryTableViewCell *cell = note.object;
                
                NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
                if (indexPath) {
                    
                    
                    [[SLTextDataProvider sharedInstance] removeTextData:cell.textData];
                    [_tableView beginUpdates];
                    
                    NSArray *dayTextDatas = _allDayTextDatas[indexPath.section];
                    if (dayTextDatas.count > 1) {
                        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    } else {
                        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                    
                    
                    [_tableView endUpdates];
                    
                    if (_allDates.count == 0) {
                        [self createATextData];
                    }
                    
                    if ([indexPath compare:_activeIndexPath] == NSOrderedSame) {
                        NSIndexPath *newIndexPath = [_allDayTextDatas indexPathNextWithIndexPath:indexPath]
                        ?: [_allDayTextDatas indexPathPrevWithIndexPath:indexPath];
                        if (newIndexPath) {
                            //                    [SLTextDataProvider sharedInstance].activeIndexPath = newIndexPath;
                        }
                    }
                }
                
            });

        });

    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotifActiveTextDataChanged object:nil queue:nil usingBlock:^(NSNotification *note) {
        _activeIndexPath = dataProvider.activeIndexPath;
    }];
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
    return _allDates.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *someDayTextDatas = _allDayTextDatas.count > section ? _allDayTextDatas[section] : nil;
    return someDayTextDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdInput forIndexPath:indexPath];
    
    SLTextData *d = _allDayTextDatas[indexPath.section][indexPath.row];
    [cell resetWithTextData: d];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
    NSDate *d = _allDates[section];
    return [NSString stringWithFormat:@"%ld月%ld日", (long)d.month, (long)d.day];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLTextData *d = _allDayTextDatas[indexPath.section][indexPath.row];
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

- (void)createATextData
{
    SLTextData *activeTextData = [SLTextDataProvider sharedInstance].activeTextData;
    if (activeTextData && activeTextData.text.length == 0) {
        [[SLAppDelegate mzAppDelegate].sideMenu hideMenuViewController];
        return;
    }
    
    [[SLTextDataProvider sharedInstance] createTextData];
    [_tableView beginUpdates];
    
    NSArray *dayTextDatas = _allDayTextDatas[_activeIndexPath.section];
    if (dayTextDatas.count > 1) {
        [_tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:_activeIndexPath.section]
                  withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [_tableView endUpdates];
    
    [_tableView selectRowAtIndexPath:_activeIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}


@end
