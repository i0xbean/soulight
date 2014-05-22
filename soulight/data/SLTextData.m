//
//  SLTextData.m
//  Soulight
//
//  Created by Ming Z. on 14-5-21.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLTextData.h"

@implementation SLTextData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    _reuseHistoryCellHeight = kLayoutHistoryCellHeightMin;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    CGRect rect = [_text boundingRectWithSize:CGSizeMake(kLayoutHistoryCellLabelWidth, FLT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{
                                                NSFontAttributeName : kFontH4
                                                }
                                      context:nil];
    _reuseHistoryCellHeight = ceil(rect.size.height) + kLayoutHistoryCellLabelTop*2 + kLayoutHistoryCellMarginBottom + 1;
}


- (float)reuseHistoryCellHeight
{
    return MAX(_reuseHistoryCellHeight, kLayoutHistoryCellHeightMin + kLayoutHistoryCellMarginBottom);
}


@end
