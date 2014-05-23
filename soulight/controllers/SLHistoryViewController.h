//
//  SLHistoryViewController.h
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLHistoryTableViewCell;

@protocol SLHistoryDelegate <NSObject>

- (void)tableviewDeleteACell:(SLHistoryTableViewCell*)cell;

@end

@interface SLHistoryViewController : UIViewController

@property (strong, nonatomic)   UITableView *               tableView;



@end
