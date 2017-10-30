//
//  DiscoverViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/10/27.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "DiscoverViewController.h"
#import "GPLTimeLineViewController.h"
#import "PersonCenterCell.h"
#import "GPLTimeLineViewController.h"
#import "ThirdViewController.h"
@interface DiscoverViewController ()
{
    
}
///强引用朋友圈VC，做到像微信朋友圈一样，再次进入朋友圈依然显示上次浏览的位置
@property(nonatomic,strong)GPLTimeLineViewController *timeLineVC;
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self lzSetNavigationTitle:@"发现"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
        make.left.right.and.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-LZTabBarHeight);
    }];
    [self registerCellWithNib:@"PersonCenterCell" tableView:self.tableView];
   // [self registerCellWithClass:@"PersonCenterCell" tableView:self.tableView];
}
#pragma mark 懒加载朋友圈
-(GPLTimeLineViewController *)timeLineVC;
{
    if (_timeLineVC==nil) {
        _timeLineVC = [[GPLTimeLineViewController alloc]init];
    }
    return _timeLineVC;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCenterCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section==0) {//我的好友
        cell.titleIV.image = [UIImage imageNamed:@"ff_IconShowAlbum"];
        cell.titleLabel.text = @"朋友圈";
        
    }else if (indexPath.section==1){//设置
        if (indexPath.row==0) {
            cell.titleIV.image = [UIImage imageNamed:@"ff_IconQRCode"];
            cell.titleLabel.text = @"扫一扫";
            
        }else if (indexPath.row==1){
            cell.titleIV.image = [UIImage imageNamed:@"ff_IconShake"];
            cell.titleLabel.text = @"摇一摇";
        }
        
    }else if(indexPath.section==2){
        cell.titleIV.image = [UIImage imageNamed:@"ff_IconLocationService"];
        cell.titleLabel.text = @"附近的人";
    }else if(indexPath.section==3){
        if (indexPath.row==0) {
            cell.titleIV.image = [UIImage imageNamed:@"CreditCard_ShoppingBag"];
            cell.titleLabel.text = @"购物";
        }else if (indexPath.row==1){
            cell.titleIV.image = [UIImage imageNamed:@"MoreGame"];
            cell.titleLabel.text = @"新闻";
        }
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        [self.navigationController pushViewController:[[GPLTimeLineViewController alloc]init] animated:YES];
    }
    if (indexPath.section==3) {
        if (indexPath.row==1) {
                    [self.navigationController pushViewController:[[ThirdViewController alloc]init] animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
