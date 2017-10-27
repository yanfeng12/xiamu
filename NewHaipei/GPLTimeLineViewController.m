//
//  GPLTimeLineViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/10/27.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "GPLTimeLineViewController.h"
#import "MessageInfoModel1.h"
#import "MessageCell.h"
#import "CommentCell1.h"
//键盘
#import "ChatKeyBoard.h"
#import "FaceSourceManager.h"
#import "MoreItem.h"
#import "ChatToolBarItem.h"
#import "FaceThemeModel.h"
#import "FriendInfoModel.h"
#import "ChatKeyBoardMacroDefine.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
@interface GPLTimeLineViewController ()<ChatKeyBoardDelegate, ChatKeyBoardDataSource,UITableViewDelegate, UITableViewDataSource, MessageCellDelegate>
@property(nonatomic,strong)NSDictionary *jsonDic;
@property (nonatomic, strong) ChatKeyBoard *chatKeyBoard;
@property (nonatomic, assign) CGFloat history_Y_offset;//记录table的offset.y
@property (nonatomic, assign) CGFloat seletedCellHeight;//记录点击cell的高度，高度由代理传过来
@property (nonatomic, assign) BOOL isShowKeyBoard;//记录点击cell的高度，高度由代理传过来

//专门用来回复选中的cell的model
@property (nonatomic, strong) CommentInfoModel1 *replayTheSeletedCellModel;


@property (nonatomic, assign) BOOL needUpdateOffset;//控制是否刷新table的offset

@property (nonatomic,copy)NSIndexPath *currentIndexPath;
@end

@implementation GPLTimeLineViewController

- (NSArray<ChatToolBarItem *> *)chatKeyBoardToolbarItems
{
    ChatToolBarItem *item1 = [ChatToolBarItem barItemWithKind:kBarItemFace normal:@"face" high:@"face_HL" select:@"keyboard"];
    return @[item1];
}

- (NSArray<FaceThemeModel *> *)chatKeyBoardFacePanelSubjectItems
{
    return [FaceSourceManager loadFaceSource];
}
-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:YES];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.dataSource = self;
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"评论";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}
- (void)chatKeyBoardSendText:(NSString *)text{
    MessageInfoModel1 *messageModel = self.dataSource[self.currentIndexPath.row];
    messageModel.shouldUpdateCache = YES;
    
    //创建一个新的CommentModel,并给相应的属性赋值，然后加到评论数组的最后，reloadData
    CommentInfoModel1 *commentModel = [[CommentInfoModel1 alloc]init];
    commentModel.commentUserName = @"文明";
    commentModel.commentUserId = @"274";
    commentModel.commentPhoto = @"http://q.qlogo.cn/qqapp/1104706859/189AA89FAADD207E76D066059F924AE0/100";
    commentModel.commentByUserName = self.replayTheSeletedCellModel?self.replayTheSeletedCellModel.commentUserName:@"";
    commentModel.commentId = [NSString stringWithFormat:@"%i",[self getRandomNumber:100 to:1000]];
    commentModel.commentText = text;
    [messageModel.commentModelArray addObject:commentModel];
    
    messageModel.shouldUpdateCache = YES;
    [self reloadCellHeightForModel:messageModel atIndexPath:self.currentIndexPath];
    
    [self.chatKeyBoard keyboardDownForComment];
    self.chatKeyBoard.placeHolder = nil;
}
- (void)chatKeyBoardFacePicked:(ChatKeyBoard *)chatKeyBoard faceStyle:(NSInteger)faceStyle faceName:(NSString *)faceName delete:(BOOL)isDeleteKey{
    NSLog(@"%@",faceName);
}
- (void)chatKeyBoardAddFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
}
- (void)chatKeyBoardSetFaceSubject:(ChatKeyBoard *)chatKeyBoard{
    NSLog(@"%@",chatKeyBoard);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self lzSetNavigationTitle:@"朋友圈"];
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.tableView];
    UIImageView * backgroundImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LZSCREEN_WIDTH, 260)];
    backgroundImageView.image = [UIImage imageNamed:@"background.jpeg"];
    self.tableView.tableHeaderView = backgroundImageView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(LZNavigationHeight);
        make.left.right.and.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(0);
    }];
    
    //注册键盘出现NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏NSNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [self getTestData];
    [self registerCellWithClass:@"MessageCell" tableView:self.tableView];
    
}
///本地的json测试数据
-(NSDictionary *)jsonDic{
    if (_jsonDic==nil) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"]]];
        _jsonDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    return _jsonDic;
}
#pragma mark
#pragma mark 从本地获取朋友圈的测试数据
-(void)getTestData
{
    for (NSDictionary *eachDic in self.jsonDic[@"data"][@"rows"]) {
        MessageInfoModel1 *messageModel = [[MessageInfoModel1 alloc] initWithDic:eachDic];
        [self.dataSource addObject:messageModel];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
    cell.delegate = self;
    __weak __typeof(self) weakSelf= self;
    
    MessageInfoModel1 *model = self.dataSource[indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    //评论
    cell.CommentBtnClickBlock = ^(UIButton *commentBtn,NSIndexPath * indexPath)
    {
        
        if (weakSelf.isShowKeyBoard) {
            [weakSelf.view endEditing:YES];
            return ;
        }
        
        //不是点击cell进行回复，则置空replayTheSeletedCellModel，因为这个时候是点击评论按钮进行评论，不是回复某某某
        weakSelf.replayTheSeletedCellModel = nil;
        weakSelf.seletedCellHeight = 0.0;
        weakSelf.needUpdateOffset = YES;
        weakSelf.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"评论 %@",model.userName];
        weakSelf.history_Y_offset = [commentBtn convertRect:commentBtn.bounds toView:[UIApplication sharedApplication].keyWindow].origin.y;
        weakSelf.currentIndexPath = indexPath;
        [weakSelf.chatKeyBoard keyboardUpforComment];
    };
    //更多
    cell.MoreBtnClickBlock = ^(UIButton *moreBtn,NSIndexPath * indexPath)
    {
        if (weakSelf.isShowKeyBoard) {
            [weakSelf.view endEditing:YES];
            return ;
        }
        [weakSelf.chatKeyBoard keyboardDownForComment];
        weakSelf.chatKeyBoard.placeHolder = nil;
        model.isExpand = !model.isExpand;
        model.shouldUpdateCache = YES;
        [weakSelf.tableView reloadData];
    };
    
    //点击九宫格
    cell.tapImageBlock = ^(NSInteger index,NSArray *dataSource){
        if (weakSelf.isShowKeyBoard) {
            [weakSelf.view endEditing:YES];
            return ;
        }
        [weakSelf.chatKeyBoard keyboardDownForComment];
    };
    
    
    //点击文字
    cell.TapTextBlock=^(UILabel *desLabel){
        if (weakSelf.isShowKeyBoard) {
            [weakSelf.view endEditing:YES];
            return ;
        }
    };
    
    //点击点赞的人名字
    cell.tapNameBlock = ^(FriendInfoModel *friendModel) {
        if (weakSelf.isShowKeyBoard) {
            [weakSelf.view endEditing:YES];
            return ;
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:friendModel.userName message:[NSString stringWithFormat:@"id = %@",friendModel.userId] delegate:weakSelf cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageInfoModel1 *messageModel = self.dataSource[indexPath.row];
    CGFloat h = [MessageCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        MessageCell *cell = (MessageCell *)sourceCell;
        [cell configCellWithModel:messageModel indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : messageModel.cid,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(messageModel.shouldUpdateCache)};
        messageModel.shouldUpdateCache = NO;
        return cache;
    }];
    return h;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
#pragma mark - passCellHeightWithModel
-(void)passCellHeight:(CGFloat)cellHeight commentModel:(CommentInfoModel1 *)commentModel commentCell:(CommentCell1 *)commentCell messageCell:(MessageCell *)messageCell{
    if (self.isShowKeyBoard) {
        [self.view endEditing:YES];
        return ;
    }
    self.needUpdateOffset = YES;
    self.replayTheSeletedCellModel = commentModel;
    self.currentIndexPath = [self.tableView indexPathForCell:messageCell];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.chatKeyBoard.placeHolder = [NSString stringWithFormat:@"回复 %@",commentModel.commentUserName];
    self.history_Y_offset = [commentCell convertRect:commentCell.bounds toView:window].origin.y;
    self.seletedCellHeight = cellHeight;
    [self.chatKeyBoard keyboardUpforComment];
}
- (void)reloadCellHeightForModel:(MessageInfoModel1 *)model atIndexPath:(NSIndexPath *)indexPath{
    model.shouldUpdateCache = YES;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark
#pragma mark keyboardWillShow
- (void)keyboardWillShow:(NSNotification *)notification
{
    self.isShowKeyBoard = YES;
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    __block  CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    if (keyboardHeight==0) {
        //解决搜狗输入法三次调用此方法的bug、
        //        IOS8.0之后可以安装第三方键盘，如搜狗输入法之类的。
        //        获得的高度都为0.这是因为键盘弹出的方法:- (void)keyBoardWillShow:(NSNotification *)notification需要执行三次,你如果打印一下,你会发现键盘高度为:第一次:0;第二次:216:第三次:282.并不是获取不到高度,而是第三次才获取真正的高度.
        return;
    }
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    CGFloat delta = 0.0;
    if (self.seletedCellHeight){//点击某行row，进行回复某人
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-self.seletedCellHeight-kChatToolBarHeight-2);
    }else{//点击评论按钮
        delta = self.history_Y_offset - ([UIApplication sharedApplication].keyWindow.bounds.size.height - keyboardHeight-kChatToolBarHeight-24-10);//24为评论按钮高度，10为评论按钮上部的5加评论按钮下部的5
    }
    CGPoint offset = self.tableView.contentOffset;
    offset.y += delta;
    if (offset.y < 0) {
        offset.y = 0;
    }
    if (self.needUpdateOffset) {
        [self.tableView setContentOffset:offset animated:YES];
    }
}
#pragma mark
#pragma mark keyboardWillHide
- (void)keyboardWillHide:(NSNotification *)notification {
    self.isShowKeyBoard = NO;
    self.needUpdateOffset = NO;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__FUNCTION__);
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
