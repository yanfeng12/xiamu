//
//  GPLActivity.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/13.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPLActivity : UIActivity


@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) NSArray * shareContexts;

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type  withShareContext:(NSArray *)shareContexts;
@end
