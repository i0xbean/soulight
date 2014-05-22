//
//  SLAppDelegate.h
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SLHomeViewController.h"
#import "SLHistoryViewController.h"
#import "SLShareViewController.h"


@interface UIResponder (xx)

+ (instancetype)mzAppDelegate;

@end

@implementation UIResponder (xx)

+ (instancetype)mzAppDelegate;
{
    return [UIApplication sharedApplication].delegate;
}

@end



@interface SLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)   RESideMenu *                    sideMenu;
@property (strong, nonatomic)   SLHomeViewController *          homeVC;
@property (strong, nonatomic)   SLHistoryViewController *       historyVC;
@property (strong, nonatomic)   SLShareViewController *         shareVC;

@end
