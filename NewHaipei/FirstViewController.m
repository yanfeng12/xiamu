//
//  FirstViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/12.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstDetilViewController.h"
#import "FirstViewTableViewCell.h"
#import "GPLActivity.h"
#import "WeiboActivity.h"

@interface FirstViewController ()
{
    NSArray *tittleArr;
    NSArray *imgArr;
}
@property (nonatomic, strong) WeiboActivity *weiboActivity;
@end

@implementation FirstViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupNaviBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoViewController:) name:@"gotoViewController" object:nil];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
        });
    });
    
    tittleArr = [NSArray arrayWithObjects:@"五月新书",@"六月新书",@"七月新书", nil];
    NSArray *bookArr1 = [NSArray arrayWithObjects:@"0.jpg", @"1.jpg",@"2.jpg",@"3.jpg",
                         @"4.jpg",@"5.jpg",@"6.jpg", nil];
    NSArray *bookArr2 = [NSArray arrayWithObjects:@"7.jpg", @"8.jpg",@"9.jpg", nil];
    NSArray *bookArr3 = [NSArray arrayWithObjects:@"10.jpg", @"11.jpg",@"12.jpg",@"13.jpg",@"14.jpg", nil];
    imgArr = [NSArray arrayWithObjects:bookArr1,bookArr2,bookArr3, nil];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
        make.left.right.and.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-LZTabBarHeight);
    }];
    [self registerCellWithNib:@"FirstViewTableViewCell" tableView:self.tableView];
}

#pragma mark --自定义Activity
#define CAL_GET_OBJECT(objc) if (objc) return objc
- (WeiboActivity *)weiboActivity {
    
    CAL_GET_OBJECT(_weiboActivity);
    
    _weiboActivity = [[WeiboActivity alloc] init];
    
    [_weiboActivity setWeiboBlock:^{
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"新浪微博"
                                                            message:@"分享至新浪微博"
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }];
    
    return _weiboActivity;
}
-(void)makeActivity
{
//    NSString *text = @"自定义Activity";
//    UIImage *image = [UIImage imageNamed:@"icon"];
//    NSURL *url = [NSURL URLWithString:@"https://www.jianshu.com/u/d07fe467cee6"];
//    NSArray *activityItems = @[url,text,image];
    
    NSURL*urlToShare=  [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video0" ofType:@"mp4"]];
    
    NSArray *activityItems2 = @[urlToShare];

    NSArray *activities = @[self.weiboActivity];
    //创建分享视图控制器
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems2 applicationActivities:activities];
    //关闭系统的一些activity类型
    activityVC.excludedActivityTypes = @[];
    //在展现view controller时，必须根据当前的设备类型，使用适当的方法。在iPad上，必须通过popover来展现view controller。在iPhone和iPodtouch上，必须以模态的方式展现。
    [self presentViewController:activityVC animated:YES completion:nil];
}
#pragma mark --runtime传值
-(void)gpl_setssid:(NSString*)assid {
    
    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@",assid]];

}
- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"首页"];
    
    LZWeakSelf(ws)
    [self lzSetRightButtonWithTitle:nil selectedImage:@"add_new" normalImage:@"add_new" actionBlock:^(UIButton *button) {
        
        
        [ws gotoFirstDetilAnimated:YES];
    }];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"save" normalImage:@"save" actionBlock:^(UIButton *button) {
        
        [self makeActivity];

    }];

}
#pragma mark -- 收到通知后进行页面跳转
-(void)gotoViewController:(NSNotification*) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        id notificationObject = [notification object];
        if ([notificationObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:notificationObject];
            NSString *typeStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
            if ([typeStr isEqualToString:@"跳转详情"]) {
                [self gotoFirstDetilAnimated:NO];
            }
        }

    });

}
#pragma mark -- 跳转详情
-(void)gotoFirstDetilAnimated:(BOOL)isAnimation
{
    FirstDetilViewController *FirstDetil = [[FirstDetilViewController alloc]init];

    [self.navigationController pushViewController:FirstDetil animated:isAnimation];
}
//返回表格行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return imgArr.count;
}
//创建各单元显示内容(创建参数indexPath指定的单元）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FirstViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FirstViewTableViewCell" forIndexPath:indexPath];
    //下面这两个语句一定要添加，否则第一屏显示的collection view尺寸，以及里面的单元格位置会不正确
    cell.frame = tableView.bounds;
    [cell layoutIfNeeded];
    
    //重新加载单元格数据
    [cell reloadData:tittleArr[indexPath.row] images:imgArr[indexPath.row]];
    
    return cell;
}
//在本例中，只有一个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
