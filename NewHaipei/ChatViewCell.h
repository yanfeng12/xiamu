//
//  ChatViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/17.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "Messageitem.h"
@interface ChatViewCell : UITableViewCell
@property (nonatomic, strong) Messageitem *model;
@property (nonatomic, copy) void (^didSelectLinkTextOperationBlock)(NSString *link, MLEmojiLabelLinkType type);
@end
