//
//  SLInputTableViewCell.m
//  soulight
//
//  Created by Ming Z. on 14-5-20.
//  Copyright (c) 2014年 i0xbean. All rights reserved.
//

#import "SLInputTableViewCell.h"

@interface SLInputTableViewCell ()

@property (strong, nonatomic)   UIView *            paperView;
@property (strong, nonatomic)   UILabel *           tLabel;

@end

@implementation SLInputTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    _paperView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 111)];
        view.backgroundColor = kColorKeyboardBg;
        view;
    });
    
    _tLabel = ({
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, _paperView.width-16, _paperView.height-16)];
        l.text =  @"君不见，黄河之水天上来，奔流到海不复回。君不见，高堂明镜悲白发，朝如青丝暮成雪。人生得意须尽欢，莫使金樽空对月。天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯。岑夫子，丹丘生，将进酒，杯莫停。与君歌一曲，请君为我侧耳听。钟鼓馔玉不足贵，但愿长醉不复醒。古来圣贤皆寂寞，惟有饮者留其名。陈王昔时宴平乐，斗酒十千恣欢谑。主人何为言少钱，径须沽取对君酌。五花马，千金裘，呼儿将出换美酒，与尔同销万古愁。";
        l.font = [UIFont systemFontOfSize:14];
        l.backgroundColor = [UIColor whiteColor];

        l.numberOfLines = 5;
        l;
    });
    
    self.backgroundColor = [UIColor clearColor];
    
    [_paperView addSubview:_tLabel];
    [self.contentView addSubview:_paperView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
