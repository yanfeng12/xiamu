//
//  VideoListTableViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/21.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *canPlayLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *urlLabel;

- (void)checkIsCanPlay:(NSString *)url fileName:(NSString *)fileName;

- (void)setObject:(id)anObject;

@end
