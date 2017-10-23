//
//  SecondViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/12.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "SecondViewController.h"
#import "ChatTool.h"
#import "ChatListCell.h"
#import "httpTool.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "YYCache.h"
#import "ChatViewController.h"
@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property(copy,nonatomic)NSString *content;//YYCache key
@property (strong, nonatomic)NSArray *namesArray;
@property (strong, nonatomic)NSArray *iconNamesArray;
@property (strong, nonatomic)NSArray *messagesArray;
@end

@implementation SecondViewController
-(NSArray *)namesArray
{
    if (!_namesArray) {
        _namesArray = @[@"为情所困",
                       @"世界只因有你",
                       @"她说我死老头子",
                       @"再回首恍然如梦",
                       @"想你夜不能寐",
                       @"習慣沉默",
                       @"你似不似傻",
                       @"仅有的自私",
                       @"普通小姐",
                       @"左手倒影",
                       @"曾经蜡笔没有小新",
                       @"習慣沉默",
                       @"習慣依赖",
                       @"筷子姐妹",
                       @"法海你不懂爱",
                       @"长城长",
                       @"老北京麻辣烫",
                       @"过去多啦不再A梦",
                       @"無盡的蒼穹",
                       @"亲亲我的宝贝",
                       @"给我你的怀抱",
                       @"蒙谁谁傻i",
                       @"听沵唱不懂旳歌",
                       @"出轨丶看看"
                       ];
    }
    return _namesArray;
}

- (NSArray *)iconNamesArray
{
    if (!_iconNamesArray) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 24; i++) {
            NSString *iconName = [NSString stringWithFormat:@"GPL%d.jpg", i];
            [temp addObject:iconName];
        }
        _iconNamesArray = [temp copy];
    }
    return _iconNamesArray;
}

- (NSArray *)messagesArray
{
    if (!_messagesArray) {
        _messagesArray = @[@"只愿在人潮拥挤的街头与命中注定到白头的人撞个满怀。",
                          @"家是有根和有魂的，根和魂是由女人掌控。",
                          @"现在念念不忘以为这辈子都忘不了的事，不知不觉中早已忘记。",
                          @"没钱没事业的人，才有时间去提高自己的人生境界。",
                          @"心累，就是常常徘徊在坚持和放弃之间，举棋不定。烦恼，就是记性太好，该记的，不该记的都会留在记忆里。",
                          @"最简单粗暴的表白：“有时间一起睡个觉。",
                          @"别总把自己的故事说出去，别人能看到你的伤，却不知道你的疼。",
                          @"还没想好要怎么生气，心里就已经原谅了你几百遍。",
                          @"我就是一个无理取闹而不淑女的孩纸。",
                          @"最爱欧巴：[呲牙][呲牙][呲牙]",
                          @"大长腿思密达：[图片]",
                          @"别给我晒脸：坑死我了。。。。。",
                          @"可爱男孩：你谁？？？🐎🐎🐎🐎",
                          @"筷子姐妹：和尚。。尼姑。。",
                          @"法海你不懂爱：春晚太难看啦，妈蛋的🐎🐎🐎🐎🐎🐎🐎🐎",
                          @"长城长：好好好~~~",
                          @"老北京麻辣烫：时间久了，才发现很多该做的事都没做；时间久了，才发现很多该说的话都没说；时间久了，才发现很多该爱的人都没爱；时间久了，才发现很多该忘的情都没忘；时间久了，才发现已经忘记了原来的自己是怎么样的。",
                          @"我不搞笑：寒假过得真快",
                          @"原来我不帅：有木有人儿？",
                          @"亲亲我的宝贝：你🐎说🐎啥🐎呢",
                          @"请叫我吴彦祖：好搞笑🐎🐎🐎，下次还来",
                          @"帅锅莱昂纳多：知音，能有一个已经很好了，不必太多。如果实在没有，还有自己。好好对待自己，跟自己相处，也是一个朋友。",
                          @"星星之火：脱掉，脱掉，统统脱掉🐎",
                          @"雅蠛蝶~雅蠛蝶：好脏，好污，好喜欢"
                          ];
    }
    return _messagesArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.content=@"ChatList";
    _dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self lzSetNavigationTitle:@"聊天"];
    
    [self myTableView];
    
    [self loadData];
    
    [self namesArray];
    [self iconNamesArray];
    [self messagesArray];
    

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myTableView.mj_header beginRefreshing];
    
}
-(void)loadData
{
    //先加载缓存
    YYCache *cache=[YYCache cacheWithName:@"theChatList"];
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
        [table registerNib:[UINib nibWithNibName:@"ChatListCell" bundle:nil] forCellReuseIdentifier:@"ChatCell"];
        [self.view addSubview:table];
        _myTableView = table;
        
        
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
            make.left.right.and.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view).offset(-LZTabBarHeight);
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
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    
    cell.opaque=YES;
    cell.layer.drawsAsynchronously=YES;
    cell.layer.rasterizationScale=[UIScreen mainScreen].scale;
    
    //重新加载单元格数据
    [cell reloadDataWithChatTool:_dataArray[indexPath.row]];
    
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark -- 缓存数据处理
- (void)analysisDataWithDictionary:(NSDictionary*)dictionary andType:(BOOL)type{
    NSMutableArray *tempArry=[NSMutableArray array];
    NSArray *dataArry=dictionary[@"chatlist"];
    for (NSDictionary *dic in dataArry) {
        ChatTool *tool=[[ChatTool alloc]initWithDic:dic];
        [tempArry addObject:tool];
    }
    type?(_dataArray=[tempArry mutableCopy]):([_dataArray addObjectsFromArray:[tempArry copy]]);
}
#pragma mark -- 请求数据
- (void)loadDataWithBool:(BOOL)type{
    if (!type) {
        
    }
    //模拟网络请求数据
    NSMutableArray *tempArry=[NSMutableArray array];
    for (int i=0; i<10; i++) {
        int randomNamesArray = arc4random_uniform((int)_namesArray.count);
        int randomIconNamesArray = arc4random_uniform((int)_iconNamesArray.count);
        int randomMessagesArray = arc4random_uniform((int)_messagesArray.count);
        NSString *nameStr = _namesArray[randomNamesArray];
        NSString *iconNameStr = _iconNamesArray[randomIconNamesArray];
        NSString *messageStr = _messagesArray[randomMessagesArray];
        NSDictionary *tempDic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"title",iconNameStr,@"picUrl",messageStr,@"ctime", nil];
        [tempArry addObject:tempDic];
    }
    NSDictionary *chatDic = [NSDictionary dictionaryWithObjectsAndKeys:tempArry,@"chatlist", nil];
    //NSLog(@"chatDic=============%@",chatDic);
    [self analysisDataWithDictionary:chatDic andType:type];
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];
    [self.myTableView reloadData];
    //将数据进行本地存储
    YYCache *cache=[YYCache cacheWithName:@"theChatList"];
    [cache setObject:chatDic forKey:self.content];
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
