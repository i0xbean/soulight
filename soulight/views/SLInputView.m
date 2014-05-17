//
//  SLInputView.m
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLInputView.h"

@implementation SLInputView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 64)];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    _undoBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 10, 44, 44)];
    [_undoBtn setTitle:@"Undo" forState:UIControlStateNormal];
    [self addSubview:_undoBtn];
}

@end
