//
//  EditViewController.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/18.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZBaseViewController.h"
#import "LZDataModel.h"
#import "LZGroupModel.h"
@interface EditViewController : LZBaseViewController
@property (strong, nonatomic)LZDataModel *model;
@property (strong, nonatomic)LZGroupModel *defaultGroup;
@end
