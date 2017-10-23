//
//  Messageitem.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/18.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <Foundation/Foundation.h>
//消息类型，我的还是别人的
typedef enum : NSUInteger {
    GPLMessageTypeSendToOthers,
    GPLMessageTypeSendToMe
} GPLMessageType;

@interface Messageitem : NSObject

@property (nonatomic, assign) GPLMessageType messageType;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *imageName;
@end
