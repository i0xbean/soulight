//
//  SLHomeViewController.m
//  soulight
//
//  Created by Ming Z. on 14-5-17.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHomeViewController.h"

#import <iflyMSC/IFlySpeechUser.h>
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>

#import "SLInputView.h"
#import "SLAppDelegate.h"
#import "SLTextDataProvider.h"



@interface SLHomeViewController () <UITextViewDelegate, IFlySpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic)   SLTextData *                        activeTextData;

@property (strong, nonatomic)   SLInputView *                       accessoryView;
@property (strong, nonatomic)   UIView *                            blankInputView;

@property (strong, nonatomic)   IFlySpeechUser *                    flyUser;
@property (weak, nonatomic)     IFlySpeechRecognizer *              flySpeechRecognizer;


@property (nonatomic, getter = isStatusBarHidden)   BOOL            statusBarHidden;

@end

@implementation SLHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    NSString *flyLoginStr = [NSString stringWithFormat:@"appid=%@", kAPIFlyAppId];
    _flyUser = [[IFlySpeechUser alloc] init];
    [_flyUser login:nil pwd:nil param:flyLoginStr];
    
    NSString *flyRegInitStr = [NSString stringWithFormat:@"appid=%@,timeout=%d", kAPIFlyAppId, kAPIFlyTimeout];
    _flySpeechRecognizer = [IFlySpeechRecognizer createRecognizer:flyRegInitStr delegate:self];
    
    NSDictionary *flyRegConfig =
        @{
          @"domain"         : @"iat",           //取值为iat、at、search、video、poi、music、asr；iat：普通文本转写； search：热词搜索； video：视频音乐搜索； asr：命令词识别;
          @"vad_bos"        : @"10000",         //前端点检测；静音超时时间，即用户多长时间不说话则当做超时处理； 单位：ms； engine指定iat识别默认值为5000； 其他情况默认值为 4000，范围 0-10000。
          @"vad_eos"        : @"10000",         //后断点检测；后端点静音检测时间，即用户停止说话多长时间内即认为不再输入， 自动停止录音；单位:ms，sms 识别默认值为 1800，其他默认值为 700，范围 0-10000。
          @"sample_rate"    : @"16000",         //采样率，目前支持的采样率设置有 16000 和 8000。
          @"asr_ptt"        : @"1",             //否返回无标点符号文本； 默认为 1，当设置为 0 时，将返回无标点符号文本。
          };
    
    BOOL configRs = [flyRegConfig bk_all:^BOOL(NSString *key, NSString *value) {
        return [_flySpeechRecognizer setParameter:key value:value];
    }];
    if (!configRs) {
        DDLogError(@"fly config error.");
    }
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
    
    [_accessoryView.recordBtn bk_addEventHandler:^(UIButton* recordBtn) {
        if (recordBtn.selected == NO) {
            if (![_flySpeechRecognizer startListening]) {
                DDLogError(@"fly starting error.");
            }
        } else {
            [_flySpeechRecognizer cancel];
        }
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_accessoryView.undoBtn bk_addEventHandler:^(UIButton* undoBtn) {
        [_textView.undoManager undo];
        [self reloadUndoRedoButtons];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_accessoryView.redoBtn bk_addEventHandler:^(UIButton* redoBtn) {
        [_textView.undoManager redo];
        [self reloadUndoRedoButtons];
    } forControlEvents:UIControlEventTouchUpInside];
    
    [_accessoryView.clearBtn bk_addEventHandler:^(id sender) {
        _textView.text = nil;
        [_textView.undoManager removeAllActions];
        [self reloadUndoRedoButtons];
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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kNotifActiveTextDataChanged
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification *note)
    {
        [self reloadActiveTextData];
    }];
    
    [self reloadActiveTextData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (void)textViewDidChange:(UITextView *)textView
{
    [self reloadUndoRedoButtons];
    _activeTextData.text = _textView.text;
    
    UITableView *tv = [SLAppDelegate mzAppDelegate].historyVC.tableView;
    
    [tv reloadRowsAtIndexPaths:tv.indexPathsForSelectedRows withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (void)reloadActiveTextData
{
    _activeTextData = [SLTextDataProvider sharedInstance].activeTextData;
    
    _textView.text = _activeTextData.text;
    [_textView.undoManager removeAllActions];
    
    [self reloadUndoRedoButtons];
    
    [_flySpeechRecognizer cancel];
}

#pragma mark - Private



- (void)reloadUndoRedoButtons
{
    [_accessoryView.undoBtn setEnabled:_textView.undoManager.canUndo];
    [_accessoryView.redoBtn setEnabled:_textView.undoManager.canRedo];
    
}

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
    [[SLTextDataProvider sharedInstance] save];
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


#pragma mark - IFlySpeechRecognizerDelegate

- (void)onError:(IFlySpeechError *)errorCode
{
    _accessoryView.recordBtn.selected = NO;
    DDLogError(@"fly:%d|%@", errorCode.errorCode, errorCode.errorDesc);
    //todo: 一分钟超时
}

- (void)onResults:(NSArray *)results
{
    for (NSDictionary *dic in results) {
        DDLogInfo(@"fly result:%@|%@", dic.allKeys.firstObject, dic.allValues.firstObject);
    }
    
    NSDictionary *dic = results.firstObject;
    NSString *text = dic.allKeys.firstObject;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_textView.undoManager beginUndoGrouping];
        [_textView insertText:text];
        [_textView.undoManager endUndoGrouping];
    });
}

- (void)onVolumeChanged:(int)volume
{
    
}

- (void)onBeginOfSpeech
{
    _accessoryView.recordBtn.selected = YES;
}

- (void)onEndOfSpeech
{
    
}

- (void)onCancel
{
    _accessoryView.recordBtn.selected = NO;
}



@end

