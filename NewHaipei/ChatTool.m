//
//  ChatTool.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/17.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "ChatTool.h"

@implementation ChatTool
- (id)initWithDic:(NSDictionary *)info
{
    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:info];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
    return;
}
@end
