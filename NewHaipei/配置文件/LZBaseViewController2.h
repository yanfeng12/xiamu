//
//  LZBaseViewController2.h
//  NewHaipei
//
//  Created by guopenglai on 2017/10/30.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^lzButtonBlock)(UIButton* button);
@interface LZBaseViewController2 : UIViewController
@property (nonatomic,strong)UIButton *leftButon;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UILabel *customTitleLabel;

@property (nonatomic,copy)NSString *flog;


@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSource;
-(void)registerCellWithNib:(NSString *)nibName tableView:(UITableView *)tableView;

-(void)registerCellWithClass:(NSString *)className tableView:(UITableView *)tableView;

-(int)getRandomNumber:(int)from to:(int)to;


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
