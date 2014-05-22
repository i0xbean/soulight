//
//  SLInputTableViewCell.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLHistoryTableViewCell.h"
#import "SLTextDataProvider.h"

@interface SLHistoryTableViewCell () <UIGestureRecognizerDelegate>

@property (strong, nonatomic)   UIView *            paper;
@property (strong, nonatomic)   UILabel *           tLabel;

@end

@implementation SLHistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = self.contentView.backgroundColor = [UIColor clearColor];
    self.size = self.contentView.size = CGSizeMake(kLayoutHistoryCellWidth, kLayoutHistoryCellHeightMin+kLayoutHistoryCellMarginBottom);
    self.contentView.height -= kLayoutHistoryCellMarginBottom;
    self.textLabel.numberOfLines = 0;
    
    self.textLabel.font = kFontH4;
    self.textLabel.backgroundColor = [UIColor whiteColor];
    self.textLabel.highlightedTextColor = [UIColor redColor];
    
    [self debugBackgroundColor];
    
    _tLabel = ({
        UILabel *l = [[UILabel alloc] init];
        l.text =  @"君不见，黄河之水天上来，奔流到海不复回。君不见，高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯。岑夫子，丹丘生，将进酒，杯莫停。与君歌一曲，请君为我侧耳听。钟鼓馔玉不足贵，但愿长醉不复醒。古来圣贤皆寂寞，惟有饮者留其名。陈王昔时宴平乐，斗酒十千恣欢谑。主人何为言少钱，径须沽取对君酌。五花马，千金裘，呼儿将出换美酒，与尔同销万古愁。";

        l;
    });
    
    _paper = ({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLayoutHistoryCellWidth, kLayoutHistoryCellHeightMin)];
        v.contentMode = UIViewContentModeCenter;
        v.backgroundColor = kColorKeyboardBg;
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        v;
    });
    
    self.textLabel.size = CGSizeMake(kLayoutHistoryCellLabelWidth, _paper.height-kLayoutHistoryCellLabelTop*2);
    self.textLabel.center = self.contentView.center;
    
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [_paper addSubview:_tLabel];
//    [self.contentView addSubview:_paper];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UIPanGestureRecognizer *ges = (UIPanGestureRecognizer*)sender;
        CGPoint p = [ges translationInView:self];
        
        if (state == UIGestureRecognizerStateChanged && p.x < 0) {
            
            DDLogInfo(@"%f", p.x);
            self.contentView.x = p.x;
        } else if (state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.1 animations:^{
                self.contentView.x = 0;
            }];
        }
        
    }];
    pan.delegate = self;
    [self.contentView addGestureRecognizer:pan];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    _tLabel.textColor = selected ? [UIColor redColor] : [UIColor yellowColor];
}

#pragma mark - public

- (void)resetWithTextData:(SLTextData*)data;
{
    [_textData removeObserver:self forKeyPath:@"text"];
    
    _textData = data;
    self.textLabel.text = _textData.text.length == 0 ? @"空白笔记" : _textData.text;
    
    [_textData addObserver:self forKeyPath:@"text" options:(NSKeyValueObservingOptionNew) context:nil];
    
    
//    self.height = self.contentView.height = _textData.reuseHistoryCellHeight;
//    [self.contentView setNeedsLayout];
//    [self setNeedsLayout];

}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _tLabel.text = _textData.text.length == 0 ? @"空白笔记" : _textData.text;
    
    [self.contentView setNeedsLayout];
    [self setNeedsLayout];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint velocity = [pan velocityInView:self];
        return fabs(velocity.x) > fabs(velocity.y);
    }
    return NO;

}

@end
