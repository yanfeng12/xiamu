//
//  NewsTool.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/14.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "NewsTool.h"

@implementation NewsTool
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
