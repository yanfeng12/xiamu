//
//  VideoListTableViewCell.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/21.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "VideoListTableViewCell.h"
#import "Masonry.h"
#import "MMovieModel.h"
@implementation VideoListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _canPlayLabel.backgroundColor = [UIColor darkGrayColor];
    }
    else {
        _canPlayLabel.backgroundColor = [UIColor greenColor];
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    
    [self addSubview:self.nameLabel];
    [self addSubview:self.urlLabel];
    [self addSubview:self.canPlayLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(10));
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self).offset(-20);
    }];
    
    [self.canPlayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.right.equalTo(self).offset(-20);
    }];
}
- (void)setObject:(MMovieModel *)anObject{
    self.urlLabel.text = [anObject.url stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
    
}
- (void)checkIsCanPlay:(NSString *)url fileName:(NSString *)fileName{
    NSDictionary *canPlaylistDict = [[NSUserDefaults standardUserDefaults] objectForKey:fileName];
    NSString *tmpUrl = [canPlaylistDict objectForKey:url];
    self.canPlayLabel.hidden = !tmpUrl;
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        _canPlayLabel.backgroundColor = [UIColor darkGrayColor];
    }
    else {
        _canPlayLabel.backgroundColor = [UIColor greenColor];
    }
}
#pragma mark -
- (UILabel *)canPlayLabel{
    if (!_canPlayLabel) {
        _canPlayLabel = [[UILabel alloc] init];
        _canPlayLabel.backgroundColor = [UIColor greenColor];
        _canPlayLabel.textAlignment = NSTextAlignmentCenter;
        _canPlayLabel.text = @"可播";
        _canPlayLabel.font = [UIFont systemFontOfSize:14];
        _canPlayLabel.hidden = YES;
        
    }
    return _canPlayLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nameLabel;
}

- (UILabel *)urlLabel{
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc] init];
        _urlLabel.font = [UIFont systemFontOfSize:13];
        _urlLabel.numberOfLines = 0;
    }
    return _urlLabel;
}



@end
