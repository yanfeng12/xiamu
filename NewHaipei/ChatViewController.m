//
//  ChatViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/18.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewCell.h"
#import "Messageitem.h"

#import "UITableView+SDAutoTableViewCellHeight.h"
@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;

@property (strong, nonatomic)NSArray *namesArray;
@property (strong, nonatomic)NSArray *iconNamesArray;
@property (strong, nonatomic)NSArray *messagesArray;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self myTableView];
    [self setupNaviBar];
    
    [self namesArray];
    [self iconNamesArray];
    [self messagesArray];
    // Do any additional setup after loading the view.
    
    [self setupDataWithCount:30];
}
- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"消息"];
    
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        LZLog(@"leftButton");
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];

}
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
//模拟消息数据
- (void)setupDataWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        int randomNamesArray = arc4random_uniform((int)_namesArray.count);
        int randomIconNamesArray = arc4random_uniform((int)_iconNamesArray.count);
        int randomMessagesArray = arc4random_uniform((int)_messagesArray.count);
        
        Messageitem *model = [Messageitem new];
        model.messageType = arc4random_uniform(2);
        if (model.messageType==GPLMessageTypeSendToOthers) {
            model.iconName = _iconNamesArray[randomIconNamesArray];
            if (arc4random_uniform(10) > 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg", index];
            }
        } else {
            if (arc4random_uniform(10) < 5) {
                int index = arc4random_uniform(5);
                model.imageName = [NSString stringWithFormat:@"test%d.jpg", index];
            }
            model.iconName = @"GPL2.jpg";
        }
        
        
        model.text = _messagesArray[randomMessagesArray];;
        [self.dataArray addObject:model];
    }
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;

        table.scrollEnabled = YES;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 注册NewsTableViewCell

        [table registerClass:[ChatViewCell class] forCellReuseIdentifier:@"ChatViewCell"];
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
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatViewCell" forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [cell setDidSelectLinkTextOperationBlock:^(NSString *link, MLEmojiLabelLinkType type) {
        if (type == MLEmojiLabelLinkTypeURL) {

        }
    }];

    
    
    return cell;
}
//在本例中，只有一个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat h = [self.myTableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"model" cellClass:[ChatViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    return h;
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
