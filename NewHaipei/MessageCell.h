//
//  MessageCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/10/27.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGGView.h"
#import "CommentCell1.h"
#import "LikeUsersCell1.h"
#import "MessageInfoModel1.h"
#import "CommentInfoModel1.h"
@class MessageCell;

@protocol MessageCellDelegate <NSObject>

- (void)reloadCellHeightForModel:(MessageInfoModel1 *)model atIndexPath:(NSIndexPath *)indexPath;

- (void)passCellHeight:(CGFloat )cellHeight commentModel:(CommentInfoModel1 *)commentModel   commentCell:(CommentCell1 *)commentCell messageCell:(MessageCell *)messageCell;

@end

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) JGGView *jggView;

/**
 *  评论按钮的block
 */
@property (nonatomic, copy)void(^CommentBtnClickBlock)(UIButton *commentBtn,NSIndexPath * indexPath);

/**
 *  更多按钮的block
 */
@property (nonatomic, copy)void(^MoreBtnClickBlock)(UIButton *moreBtn,NSIndexPath * indexPath);


/**
 *  点击图片的block
 */
@property (nonatomic, copy)TapBlcok tapImageBlock;

/**
 *  点击文字的block
 */
@property (nonatomic, copy)void(^TapTextBlock)(UILabel *desLabel);
@property(nonatomic ,copy)TapNameBlock tapNameBlock;

@property (nonatomic, weak) id<MessageCellDelegate> delegate;

- (void)configCellWithModel:(MessageInfoModel1 *)model indexPath:(NSIndexPath *)indexPath;


@end
