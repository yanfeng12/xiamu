//
//  PasswordTableViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/19.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *passwordShowNotificationKey = @"passwordShowNotification";
//block传值
typedef void(^showPasswordBlock)(BOOL show);
typedef void(^longPressGestureBlock)(NSString *string);

@interface PasswordTableViewCell : UITableViewCell

@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *detailTitle;
@property (assign,nonatomic)BOOL editEnabled;
@property (assign,nonatomic)BOOL showPSW;
@property (copy,nonatomic)showPasswordBlock showBlock;
@property (strong, nonatomic)UITextField *detailField;
@property (copy,nonatomic)longPressGestureBlock longPressBlock;
@end
