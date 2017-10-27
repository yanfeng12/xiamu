//
//  ThirdViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/12.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "ThirdViewController.h"
#import "NewsTableViewCell.h"
#import "NewsTool.h"
#import "httpTool.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "YYCache.h"
#import "NewsCell.h"
@interface ThirdViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property(copy,nonatomic)NSString *content;//YYCache key
@property(assign,nonatomic)int num;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.content=@"keji";
    self.num=10;
    
    _dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self lzSetNavigationTitle:@"新闻"];

    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self myTableView];
    
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myTableView.mj_header beginRefreshing];
    
}
#pragma mark -- 加载数据
-(void)loadData
{
    //先加载缓存
    YYCache *cache=[YYCache cacheWithName:@"theNewsList"];
    if ([cache containsObjectForKey:self.content]) {
        [self analysisDataWithDictionary:(NSDictionary*)[cache objectForKey:self.content] andType:YES];
        [self.myTableView reloadData];
    }
    __block typeof(self)weakSelf=self;
    // 下拉刷新
    self.myTableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakSelf checkeNetStatue]) {
            [weakSelf loadDataWithBool:YES];
        }else{
            [weakSelf.myTableView.mj_header endRefreshing];
            UILabel *headerLab=[UILabel new];
            headerLab.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38);
            headerLab.text=@"没有网络连接，请稍后重试";
            headerLab.backgroundColor=[UIColor colorWithRed:208/255.0f green:228/255.0f blue:240/255.0f alpha:1.0];
            headerLab.textColor=[UIColor colorWithRed:56/255.0f green:154/255.0f blue:216/255.0f alpha:1.0];
            headerLab.textAlignment=NSTextAlignmentCenter;
            weakSelf.myTableView.tableHeaderView=headerLab;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.myTableView.tableHeaderView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0);
                    weakSelf.myTableView.tableHeaderView=nil;
                } completion:^(BOOL finished) {
                    
                }];
                
            });
        }
        
        
        
    }];
    

    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.myTableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf checkeNetStatue]) {
            [weakSelf loadDataWithBool:NO];
        }else{
            [weakSelf.myTableView.mj_footer endRefreshing];
            UILabel *headerLab=[UILabel new];
            headerLab.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 38);
            headerLab.text=@"没有网络连接，请稍后重试";
            headerLab.backgroundColor=[UIColor colorWithRed:208/255.0f green:228/255.0f blue:240/255.0f alpha:1.0];
            headerLab.textColor=[UIColor colorWithRed:56/255.0f green:154/255.0f blue:216/255.0f alpha:1.0];
            headerLab.textAlignment=NSTextAlignmentCenter;
            weakSelf.myTableView.tableFooterView=headerLab;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.myTableView.tableFooterView.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height+38, [UIScreen mainScreen].bounds.size.width, 0);
                    weakSelf.myTableView.tableFooterView=nil;
                } completion:^(BOOL finished) {
                    
                }];
                
            });
        }
        
        
        
    }];

}
- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.emptyDataSetSource=self;
        table.emptyDataSetDelegate=self;
        table.scrollEnabled = YES;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册NewsTableViewCell
        /*
         *********  注意   *************
         xib使用第一种
         
         1.自定义cell时，
         若使用nib，使用 registerNib: 注册，dequeue时会调用 cell 的 -(void)awakeFromNib(使用xib时用)
         不使用nib，使用 registerClass: 注册, dequeue时会调用 cell 的 
         - (id)initWithStyle:withReuseableCellIdentifier:
         2.需不需要注册？
         使用dequeueReuseableCellWithIdentifier:可不注册，但是必须对获取回来的cell进行判断是否为空，若空则手动创建新的cell；
         使用dequeueReuseableCellWithIdentifier:forIndexPath:必须注册，但返回的cell可省略空值判断的步骤。
         */
        
        
//        [table registerNib:[UINib nibWithNibName:@"NewsCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
        [table registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"NewsCell"];
        [self.view addSubview:table];
        _myTableView = table;
        
        
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
            make.left.right.and.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(0);
        }];
    }
    
    return _myTableView;
}
//返回表格行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
//创建各单元显示内容(创建参数indexPath指定的单元）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];

    cell.opaque=YES;
    cell.layer.drawsAsynchronously=YES;
    cell.layer.rasterizationScale=[UIScreen mainScreen].scale;
    
    //重新加载单元格数据
    [cell reloadDataWithNewsTool:_dataArray[indexPath.row]];
    
    
    return cell;
}
//在本例中，只有一个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //分割线补全
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
#pragma mark -- 缓存数据处理
- (void)analysisDataWithDictionary:(NSDictionary*)dictionary andType:(BOOL)type{
    NSMutableArray *tempArry=[NSMutableArray array];
    NSArray *dataArry=dictionary[@"newslist"];
    for (NSDictionary *dic in dataArry) {
        NewsTool *tool=[[NewsTool alloc]initWithDic:dic];
        [tempArry addObject:tool];
    }
    type?(_dataArray=[tempArry mutableCopy]):([_dataArray addObjectsFromArray:[tempArry copy]]);
}
#pragma mark -- 请求数据
- (void)loadDataWithBool:(BOOL)type{
    if (!type) {
        self.num+=10;
    }
    NSString *urlstr = [NSString stringWithFormat:@"http://api.tianapi.com/%@/?key=52a9ca67f0f797110011bb98770a3163&num=%d",self.content,self.num];
    [httpTool ZBGetNetDataWith:urlstr withDic:nil andSuccess:^(NSDictionary* dictionary) {
        [self analysisDataWithDictionary:dictionary andType:type];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        [self.myTableView reloadData];
        //将数据进行本地存储
        YYCache *cache=[YYCache cacheWithName:@"theNewsList"];
        [cache setObject:dictionary forKey:self.content];
    } andFailure:^{
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark -- 检查网络状态
- (BOOL)checkeNetStatue{
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDelegate.statue==NotReachable) {
        NSLog(@"请设置网络");
        [SVProgressHUD showErrorWithStatus:@"请设置网络"];
        return NO;
    }else{
        return YES;
    }
}
//MARK:-EMPTY TABLE DELEGATE
- (nullable UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    
    UIImage *image=[UIImage imageNamed:@"notask_icon"];
    return image;
    
}


//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
//    NSString *text = @"要闻为您服务";
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor lightGrayColor], NSParagraphStyleAttributeName: paragraph};
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//
//}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
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
