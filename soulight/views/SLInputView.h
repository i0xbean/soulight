//
//  SLInputView.h
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLInputView : UIView

@property (strong, nonatomic)       UIButton *      recordBtn;

@property (strong, nonatomic)       UIButton *      undoBtn;
@property (strong, nonatomic)       UIButton *      redoBtn;
@property (strong, nonatomic)       UIButton *      clearBtn;
@property (strong, nonatomic)       UIButton *      hideKeyboardBtn;

@property (assign, nonatomic)       BOOL            isAtBottom;

@end
