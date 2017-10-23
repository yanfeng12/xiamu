//
//  ChatListCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/17.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatTool.h"
@interface ChatListCell : UITableViewCell
@property(strong,nonatomic)UIImageView*LeftImage;
@property (strong, nonatomic)UILabel *title;
@property (strong, nonatomic)UILabel *company;
@property(strong,nonatomic)UILabel *time;
- (void)reloadDataWithChatTool:(ChatTool *)ChatTool;
@end
