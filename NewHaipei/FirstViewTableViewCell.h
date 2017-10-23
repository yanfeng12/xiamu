//
//  FirstViewTableViewCell.h
//  NewHaipei
//
//  Created by guopenglai on 2017/4/13.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewTableViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *Label;
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;
//加载数据
-(void)reloadData:(NSString *)tittle images :(NSArray *)imagesArr;
@end
