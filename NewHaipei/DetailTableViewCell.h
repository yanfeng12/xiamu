//
//  DetailTableViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/19.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *detailTitle;
@property (assign,nonatomic)BOOL editEnabled;

@property (strong, nonatomic)UITextField *detailField;
@end
