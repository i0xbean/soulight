//
//  SLShareCell.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLShareCell.h"

@interface SLShareCell ()

@property (strong, nonatomic)   UIButton *          btn;

@end

@implementation SLShareCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    _btn = ({
        UIButton *b = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLayoutBtnWidth, kLayoutBtnWidth)];
        b.center = self.contentView.center;
        b.backgroundColor = [UIColor clearColor];
        b.layer.cornerRadius = b.width/2;
        b.layer.borderWidth = 1;
        b.showsTouchWhenHighlighted = YES;
        b;
    });
    
    [self.contentView addSubview:_btn];
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
