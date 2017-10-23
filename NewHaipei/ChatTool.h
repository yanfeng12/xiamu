//
//  ChatTool.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/17.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatTool : NSObject
@property(copy,nonatomic)NSString*ctime;
@property(copy,nonatomic)NSString*title;
@property(copy,nonatomic)NSString*url;
@property(copy,nonatomic)NSString*picUrl;
@property(copy,nonatomic)NSString*chatInfo;
- (id)initWithDic:(NSDictionary *)info;
@end
