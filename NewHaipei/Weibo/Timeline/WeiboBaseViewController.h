//
//  WeiboBaseViewController.h
//  NewHaipei
//
//  Created by guopenglai on 2017/11/1.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^lzButtonBlock)(UIButton* button);
@interface WeiboBaseViewController : UIViewController
@property (nonatomic,strong)UIButton *leftButon;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UILabel *customTitleLabel;

@property (nonatomic,copy)NSString *flog;



- (void)lzSetNavigationTitle:(NSString*)title;
- (void)lzSetLeftButtonWithTitle:(NSString*)title
                   selectedImage:(NSString*)selectImageName
                     normalImage:(NSString*)normalImage
                     actionBlock:(lzButtonBlock)block;

- (void)lzSetRightButtonWithTitle:(NSString*)title
                    selectedImage:(NSString*)selectImageName
                      normalImage:(NSString*)normalImage
                      actionBlock:(lzButtonBlock)block;

- (void)lzHiddenNavigationBar:(BOOL)hidden;
@end
