//
//  MMovieModel.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/21.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMovieModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

+ (id)getMovieModelWithTitle:(NSString *)title
                         url:(NSString *)url;

@end
