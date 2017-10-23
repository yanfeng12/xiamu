//
//  NewsTableViewCell.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/14.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "UIImageView+WebCache.h"

#define ZB_SCREEN_W   [UIScreen mainScreen].bounds.size.width
#define ZB_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define ZB_CAL(b)  ZB_SCREEN_H*b/736
#define ZB_NUMBER(a) [NSNumber numberWithFloat:ZB_CAL(a)]
@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // cell页面布局
        [self createView];
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
-(void)createView
{
    //左边图像
    _LeftImage=[UIImageView new];
    
    [self.contentView addSubview:_LeftImage];
    [_LeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(ZB_CAL(10));
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(ZB_CAL(-10));
        make.width.mas_equalTo(ZB_CAL(100));
        make.top.equalTo(self.contentView.mas_top).with.offset(ZB_CAL(10));
    }];

    //标题
    _title =[UILabel new];
    _title.backgroundColor=[UIColor whiteColor];
    _title.textColor=[UIColor blackColor];
    _title.numberOfLines=0;
    _title.font=[UIFont systemFontOfSize:ZB_CAL(15)];
    _title.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.left.equalTo(_LeftImage.mas_right).offset(ZB_CAL(10));
         make.right.equalTo(self.contentView.mas_right).offset(ZB_CAL(-10));
         make.top.equalTo(self.contentView.mas_top).offset(ZB_CAL(10));
         // make.height.equalTo(ZB_NUMBER(20));
     }];

    //来源
    _company=[UILabel new];
    _company.font=[UIFont systemFontOfSize:ZB_CAL(13)];
    _company.textAlignment=NSTextAlignmentRight;
    _company.backgroundColor=[UIColor whiteColor];
    _company.textColor=[UIColor grayColor];
    
    [self.contentView addSubview:_company];
    [_company mas_makeConstraints:^(MASConstraintMaker *make)
     {
         
         make.right.equalTo(self.contentView.mas_right).with.offset(ZB_CAL(-10));
         make.bottom.equalTo(self.contentView.mas_bottom);
         make.height.equalTo(ZB_NUMBER(25));
         make.width.equalTo(ZB_NUMBER(150));
         
         
     }];
 
}
- (void)reloadDataWithNewsTool:(NewsTool *)NewsTool
{
    [_LeftImage sd_setImageWithURL:[NSURL URLWithString:NewsTool.picUrl]];
    _title.text=NewsTool.title;
    _company.text=NewsTool.ctime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
