//
//  SLHistoryHeaderView.m
//  soulight
//
//  Created by Ming Z. on 14-5-22.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHistoryTopView.h"

@interface SLHistoryTopView ()



@end

@implementation SLHistoryTopView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit;
{
    self.width = kLayoutHistoryCellWidth;
    self.height = kLayoutHistoryCellHeightMin;
    
    _button = ({
        UIButton *b =
            [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLayoutHistoryCellWidth, kLayoutHistoryCellHeightMin)];
        [b setImage:[UIImage imageNamed:@"new"] forState:UIControlStateNormal];
        b.showsTouchWhenHighlighted = YES;
        b;
    });
    
    [self addSubview:_button];
    
    self.backgroundColor = kColorKeyboardBg;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
