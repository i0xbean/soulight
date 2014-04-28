//
//  LIViewController.m
//  lili
//
//  Created by Ming Z. on 14-4-26.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "LIViewController.h"

#import "iflyMSC/IFlySpeechRecognizer.h"

#import <BlocksKit.h>
#import <BlocksKit+UIKit.h>


#define APPID           @"534823e2"
#define TIMEOUT         @"20000"

@interface LIViewController () <IFlySpeechRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *liliBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;



@property (strong, nonatomic)   IFlySpeechRecognizer *          flySpeechRecognizer;

@end

@implementation LIViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSString *initStr = [NSString stringWithFormat:@"appid=%@,timeout=%@",APPID,TIMEOUT];
        _flySpeechRecognizer = [IFlySpeechRecognizer createRecognizer:initStr delegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)liliBtnClicked:(UIButton *)sender
{
    [_flySpeechRecognizer startListening];
}



#pragma mark - IFlySpeechRecognizerDelegate

- (void)onError:(IFlySpeechError *)errorCode
{
    
}

- (void)onResults:(NSArray *)results
{
    NSMutableString *mStr = [NSMutableString stringWithString:_textView.text];
    
    NSDictionary *dic = (NSDictionary*)results.firstObject;
    NSString *s = dic.allKeys.firstObject;
    
    [mStr appendString:s];
    
    _textView.text = mStr;
}

- (void)onBeginOfSpeech
{
    [_liliBtn setTitle:@"停止" forState:UIControlStateNormal];
}

- (void)onEndOfSpeech
{
    [_liliBtn setTitle:@"听写" forState:UIControlStateNormal];
}

- (void)onCancel
{
    
}



@end
