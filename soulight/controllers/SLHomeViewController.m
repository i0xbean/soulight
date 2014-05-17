//
//  SLHomeViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHomeViewController.h"



#import "SLInputView.h"

@interface SLHomeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *inputView;

@end

@implementation SLHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    [_inputView removeFromSuperview];
    _textView.inputAccessoryView = [_inputView copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - actions

- (IBAction)hideKeyboardBtnAction
{
    [self.view endEditing:YES];
}


#pragma mark - private

- (void)keyboardWillShow:(NSNotification*)note;
{
    
}

- (void)keyboardWillHide:(NSNotification*)note;
{
    _inputView.y = 496;
    [self.view addSubview:_inputView];
}

- (void)keyboardFrameChanged:(NSNotification*)note;
{
    NSLog(@"%@", note);
    
    float animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float endFrameY = endFrame.origin.y;
    
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromBottom
                     animations:^
    {
//        _inputView.y = endFrameY - _inputView.height - (endFrameY>479 ? 16 : 0);
//        _textView.height = _inputView.y - 16 - _textView.y;
        
    } completion:^(BOOL finished)
    {
        
    }];

}



@end
