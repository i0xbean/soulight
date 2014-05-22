//
//  UIView+MZDebug.m
//  Soulight
//
//  Created by Ming Z. on 14-5-21.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "UIView+MZDebug.h"


@implementation UIView (MZDebug)


- (void)debugBackgroundColor;
{
    [self __mzSetBackgroundColorIndex:0 forView:self];
}

- (void)__mzSetBackgroundColorIndex:(int)idx forView:(UIView*)v
{
    NSArray *bgColors = @[[UIColor redColor],
                          [UIColor orangeColor],
                          [UIColor yellowColor],
                          [UIColor greenColor],
                          [UIColor blueColor],
                          [UIColor purpleColor],
                          ];
    
    UIColor *c = bgColors[idx%bgColors.count];
    v.backgroundColor = c;
    
    for (UIView *subV in v.subviews) {
        [self __mzSetBackgroundColorIndex:idx+1 forView:subV];
    }
}

@end
