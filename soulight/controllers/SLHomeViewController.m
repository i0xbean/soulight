//
//  SLHomeViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHomeViewController.h"


#import "SLInputView.h"
#import "SLAppDelegate.h"

@interface SLHomeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic)   SLInputView *       accessoryView;
@property (strong, nonatomic)   UIView *            blankInputView;


@property (nonatomic, getter = isStatusBarHidden)   BOOL            statusBarHidden;

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
    
    // self init
    self.title = @"Soulight";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"history"]
                                        style:UIBarButtonItemStylePlain
                                      handler:^(id sender)
    {
        [self presentLeftMenuViewController:nil];
    }];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"share"]
                                        style:UIBarButtonItemStylePlain
                                      handler:^(id sender)
     {
        [self presentRightMenuViewController:nil];
     }];
    
    // controls init
    self.view.backgroundColor = kColorKeyboardBg;
    self.blankInputView = [[UIView alloc] initWithFrame:CGRectZero];
    self.accessoryView = [[SLInputView alloc] init];
    
    
    // controls setup
    _textView.delegate = self;
    _textView.inputAccessoryView = _accessoryView;
    _textView.inputView = _blankInputView;
    
    _blankInputView.alpha = 0;
    
    _accessoryView.isAtBottom = YES;



    // set actions
    
    [_accessoryView.clearBtn bk_addEventHandler:^(id sender) {
        _textView.text = @"";
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_accessoryView.hideKeyboardBtn bk_addEventHandler:^(id sender) {
        [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionOverrideInheritedOptions animations:^{
            if (_textView.inputView == nil) {
                _accessoryView.hideKeyboardBtn.selected = NO;
                _textView.inputView = _blankInputView;
                _accessoryView.isAtBottom = YES;
            } else {
                _accessoryView.hideKeyboardBtn.selected = YES;
                _textView.inputView = nil;
                _accessoryView.isAtBottom = NO;
            }
            [_textView reloadInputViews];
            [_textView scrollRangeToVisible:_textView.selectedRange];
        } completion:^(BOOL finished) {
            
        }];
        
        [self toggleNavigationBarAndStatusBarVisibility];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    // last set
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_textView becomeFirstResponder];
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{

    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

#pragma mark - overwirte

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarHidden;
}

#pragma mark - Public

- (void)toggleNavigationBarAndStatusBarVisibility
{
    BOOL willShow = self.navigationController.navigationBarHidden;
    
    if (willShow) {
        [self toggleStatusBarHiddenWithAppearanceUpdate:NO];
        [self toggleNavigationBarHiddenAnimated:YES];
    } else {
        [self toggleNavigationBarHiddenAnimated:YES];
        [self toggleStatusBarHiddenWithAppearanceUpdate:YES];
    }
}

#pragma mark - Private

- (void)toggleStatusBarHiddenWithAppearanceUpdate:(BOOL)updateAppearance
{
    self.statusBarHidden = !self.isStatusBarHidden;
    
    if (updateAppearance) {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}

- (void)toggleNavigationBarHiddenAnimated:(BOOL)animated
{
    [self.navigationController
     setNavigationBarHidden:!self.navigationController.navigationBarHidden
     animated:animated];
}

- (void)keyboardWillShow:(NSNotification*)note;
{
    float animationDuration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float endFrameY = endFrame.origin.y;
    
    [UIView animateKeyframesWithDuration:animationDuration delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        
        if (_accessoryView.isAtBottom) {
            _textView.y = 80;
            _textView.height = endFrameY - 64 - 16;
        } else {
            _textView.y = 16;
            _textView.height = endFrameY - 16;
        }
        [_accessoryView setNeedsLayout];
       
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification*)note;
{
    
}

#pragma mark - RESideMenuDelegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    [UIView animateKeyframesWithDuration:0.25 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        
        if (_accessoryView.isAtBottom) {
            _textView.y = 80;
            _textView.height = self.view.height - _textView.y - 16;
        } else {
            _textView.y = 16;
            _textView.height = self.view.height - _textView.y - 16;
        }
        [_accessoryView setNeedsLayout];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    [_textView becomeFirstResponder];
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

@end
