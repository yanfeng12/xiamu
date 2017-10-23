//
//  RemarkTableViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/19.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemarkTableViewCell : UITableViewCell
@property (copy,nonatomic)NSString *title;
@property (copy,nonatomic)NSString *detailTitle;
@property (assign,nonatomic)BOOL editEnabled;

@property (strong, nonatomic)UITextView *textView;
@end
