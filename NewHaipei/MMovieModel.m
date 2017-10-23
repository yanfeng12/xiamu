//
//  MMovieModel.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/21.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "MMovieModel.h"

@implementation MMovieModel
+ (id)getMovieModelWithTitle:(NSString *)title
                         url:(NSString *)url {
    MMovieModel *model = [[MMovieModel alloc] init];
    model.title = title;
    model.url = url;
    return model;
}

@end
