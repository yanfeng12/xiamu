//
//  NewsTableViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/14.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTool.h"
@interface NewsTableViewCell : UITableViewCell
@property(strong,nonatomic)UIImageView*LeftImage;
@property (strong, nonatomic)UILabel *title;
@property (strong, nonatomic)UILabel *company;
@property(strong,nonatomic)UILabel *time;
- (void)reloadDataWithNewsTool:(NewsTool *)NewsTool;
@end
