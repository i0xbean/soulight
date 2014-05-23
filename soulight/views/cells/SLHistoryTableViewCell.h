//
//  SLInputTableViewCell.h
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLTextData.h"

#import "SLHistoryViewController.h"

@interface SLHistoryTableViewCell : UITableViewCell

@property (strong, nonatomic)   SLTextData *                textData;

@property (weak, nonatomic)     id<SLHistoryDelegate>       delegate;

- (void)resetWithTextData:(SLTextData*)data;




@end
