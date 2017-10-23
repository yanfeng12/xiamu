//
//  FirstViewTableViewCell.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/13.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "FirstViewTableViewCell.h"
#import "FirstViewCollectionViewCell.h"
#import "FirstViewCollectionViewCell.h"
@implementation FirstViewTableViewCell
{
    NSArray *array;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //设置collectionView的代理
    self.CollectionView.delegate = self;
    self.CollectionView.dataSource = self;
    
    // 注册CollectionViewCell
    [self.CollectionView registerNib:[UINib nibWithNibName:@"FirstViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"myCell"];
    
    array = [[NSArray alloc]init];

}
//加载数据
-(void)reloadData:(NSString *)tittle images :(NSArray *)imagesArr
{
    //设置标题
    self.Label.text = tittle ;
    //保存图片数据
    array = [NSArray arrayWithArray:imagesArr];
    //collectionView重新加载数据
    [self.CollectionView reloadData];
    //更新collectionView的高度约束
    self.collectionViewHeight.constant = self.CollectionView.collectionViewLayout.collectionViewContentSize.height;
    
}
//返回collectionView的单元格数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return array.count;
}
//返回对应的单元格
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FirstViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.imgView.image = [UIImage imageNamed:array[indexPath.item]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellStr = [NSString stringWithFormat:@"%@", array[indexPath.item]];
    UIViewController* viewController = [[NSClassFromString(@"FirstViewController") alloc] init];
    SEL aSelector = NSSelectorFromString(@"gpl_setssid:");
    if ([viewController respondsToSelector:aSelector]) {
        IMP aIMP = [viewController methodForSelector:aSelector];
        void (*setter)(id, SEL, NSString*) = (void(*)(id, SEL, NSString*))aIMP;
        setter(viewController, aSelector,cellStr);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
