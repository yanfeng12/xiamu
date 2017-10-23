//
//  LaunchView.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/22.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "LaunchView.h"
#define kSkipBtnWidth 65
#define kSkipBtnHeight 30
#define kSkipRightEdging 20
#define kSkipTopEdging 40

@interface LaunchView ()
@property (nonatomic, weak) UIImageView *launchImageView;
@property (nonatomic, weak) UIImageView *adImageView;
@property (nonatomic, weak) UIButton *skipBtn;
@end


@implementation LaunchView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addlaunchImageView];
        
        [self addAdImageView];
        
        [self addSkipBtn];
    }
    
    return self;
}

- (void)addlaunchImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _launchImageView = imageView;
}

- (void)addAdImageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self addSubview:imageView];
    _adImageView = imageView;
}

- (void)addSkipBtn
{
    UIButton *skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    skipBtn.titleLabel.textColor = [UIColor whiteColor];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    skipBtn.alpha = 0.92;
    skipBtn.layer.cornerRadius = 4.0;
    skipBtn.clipsToBounds = YES;
    [self addSubview:skipBtn];
    _skipBtn = skipBtn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _launchImageView.frame = self.bounds;
    _adImageView.frame = self.bounds;
    _skipBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - kSkipBtnWidth - kSkipRightEdging, kSkipTopEdging, kSkipBtnWidth, kSkipBtnHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
