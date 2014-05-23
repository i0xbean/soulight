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
@property (strong, nonatomic)   UILabel *           deleteLabel;
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
    
//    [self debugBackgroundColor];
    
    
    _paper = ({
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kLayoutHistoryCellWidth, kLayoutHistoryCellHeightMin)];
        v.contentMode = UIViewContentModeCenter;
        v.backgroundColor = kColorKeyboardBg;
        v.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        v;
    });
    
    _tLabel = ({
        UILabel *l = [[UILabel alloc] init];
        l.text =  @"君不见，黄河之水天上来，奔流到海不复回。君不见，高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯。岑夫子，丹丘生，将进酒，杯莫停。与君歌一曲，请君为我侧耳听。钟鼓馔玉不足贵，但愿长醉不复醒。古来圣贤皆寂寞，惟有饮者留其名。陈王昔时宴平乐，斗酒十千恣欢谑。主人何为言少钱，径须沽取对君酌。五花马，千金裘，呼儿将出换美酒，与尔同销万古愁。";
        l.numberOfLines = 0;
        l.font = kFontH4;
        l.backgroundColor = [UIColor whiteColor];
        l.highlightedTextColor = [UIColor redColor];
        l.size = CGSizeMake(kLayoutHistoryCellLabelWidth, _paper.height-kLayoutHistoryCellLabelTop*2);
        l.center = _paper.center;
        l.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        l;
    });
    
    [_paper addSubview:_tLabel];
    
    _deleteLabel = ({
        UILabel *l = [[UILabel alloc] init];
        l.numberOfLines = 0;
        l.size = CGSizeMake(kLayoutHistoryCellDeleteWidth, kLayoutHistoryCellHeightMin);
        l.x = kLayoutHistoryCellWidth - l.size.width;
        l.textColor = [UIColor redColor];
        l.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        l.font = kFontH4;
        l.text = @"左划删除";
        l.textAlignment = NSTextAlignmentRight;
        l;
    });
    
    [self.contentView addSubview:_deleteLabel];
    [self.contentView addSubview:_paper];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        UIPanGestureRecognizer *ges = (UIPanGestureRecognizer*)sender;
        CGPoint p = [ges translationInView:self];
        
        if (state == UIGestureRecognizerStateChanged && p.x < 0) {
            _deleteLabel.text = p.x < -kLayoutHistoryCellDeleteWidth ? @"释放删除" : @"左划删除";
            _paper.x = p.x;
        } else if (state == UIGestureRecognizerStateEnded) {
            BOOL delete = p.x < -kLayoutHistoryCellDeleteWidth;
            [UIView animateKeyframesWithDuration:0.2
                                           delay:0
                                         options:(UIViewKeyframeAnimationOptionBeginFromCurrentState
                                                  | UIViewKeyframeAnimationOptionCalculationModeCubicPaced)
                                      animations:^
            {
                _paper.x = delete ? -kLayoutHistoryCellWidth - 20 : 0;
            } completion:^(BOOL finished) {
                if (delete) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifDeleteTextDataCell object:self userInfo:nil];
                }
            }];
        }
        
    }];
    pan.delegate = self;
    [_paper addGestureRecognizer:pan];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
//    DDLogWarn(@"www|%@|%d", _textData.text, selected);
    _tLabel.textColor = selected ? [UIColor redColor] : [UIColor blackColor];
}

#pragma mark - public

- (void)resetWithTextData:(SLTextData*)data;
{
    
    _textData = data;
    _tLabel.text = _textData.text.length == 0 ? @"空白笔记" : _textData.text;

}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint t = [pan translationInView:self.contentView];
        return fabs(t.x) > fabs(t.y);
    }
    return NO;

}

@end
