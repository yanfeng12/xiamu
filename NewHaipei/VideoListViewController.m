//
//  VideoListViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/20.
//  Copyright © 2017年 guopenglai. All rights reserved.
//
#define FileNamePre         @"直播列表"
#define CanPlayResult   @"CanPlayResult"

#import "VideoListViewController.h"
#import "VideoListTableViewCell.h"
#import "NewPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "MMovieModel.h"
#import "KxMovieViewController.h"
@interface VideoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@property (nonatomic, strong) UIViewController  *playerController;
@property (nonatomic, assign) BOOL              kxResetPop;
@property (nonatomic, strong) UISwitch          *autoPlaySwitch;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation VideoListViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNaviBar];
    [self myTableView];
    
    [self operationStr];
    [self addBackgroundMethod];
    [self registerObserver];
    
    _dataArray = [[NSMutableArray alloc]init];
}
- (void)operationStr{
    
    for (NSInteger count = 1 ; count < NSIntegerMax; count ++) {
        
        NSString *fileName = [NSString stringWithFormat:@"%@%@",FileNamePre,@(count)];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            [self.dataSource addObject:@{@"title":fileName,
                                         @"filePath":filePath}];
        }else {
            NSLog(@"%@.txt不存在", fileName);
            break;
        }
    }
    self.dict = self.dataSource[0];
    NSLog(@"self.dict================%@",self.dict);
    NSString *filePath = self.dict[@"filePath"];
    __block NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        // 去除路径下的某个txt文件
        NSString *videosText = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
             [self transformVideoUrlFromString:videosText error:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                [self.myTableView reloadData];
            });
        });
       
        
    }
    // 网络请求文件
    else if([filePath hasPrefix:@"http"]){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *videosText = [NSString stringWithContentsOfURL:[NSURL URLWithString:filePath] encoding:NSUTF8StringEncoding error:&error];
            [self transformVideoUrlFromString:videosText error:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
            });
        });
    }


}
/**
 *  转换字符串变成视频url+name
 *
 *  @param videosText 视频播放的url
 *  @param error      是否有错误
 */
- (void)transformVideoUrlFromString:(NSString *)videosText error:(NSError *)error
{
    // 过滤掉特殊字符 "\r"。有些url带有"\r",导致转换失败
    videosText = [videosText stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if (!error && (videosText.length > 0)) {
        NSMutableArray *itemArray = [NSMutableArray array];
        // 依据换行符截取一行字符串
        NSArray *videosArray = [videosText componentsSeparatedByString:@"\n"];
        
        for (NSString *subStr in videosArray) {
            // 根据"," 和" " 分割一行的字符串
            NSArray *subStrArray = [subStr componentsSeparatedByString:@","];
            NSArray *sub2StrArray = [subStr componentsSeparatedByString:@" "];
            
            if(subStrArray.count == 2 || (sub2StrArray.count == 2)){
                NSArray *tempArray = (subStrArray.count == 2)? subStrArray : sub2StrArray;
                itemArray = [self checkMultipleUrlInOneUrlWithUrl:[tempArray lastObject] videoName:[tempArray firstObject] itemArray:itemArray];
                NSLog(@"tempArray==========%@",tempArray);
            }
            else if ([subStr stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0){
                // nothing
            }
            else if (subStrArray.count >= 3 || (sub2StrArray.count >= 3)){
                NSArray *tempArray = (subStrArray.count >= 3)? subStrArray : sub2StrArray;
                NSString *tempUrl = [tempArray objectAtIndex:1];
                itemArray = [self checkMultipleUrlInOneUrlWithUrl:tempUrl.length>5?tempUrl:[tempArray objectAtIndex:2] videoName:[tempArray firstObject] itemArray:itemArray];
            }
            else {
                subStrArray = [subStr componentsSeparatedByString:@" "];
                itemArray = [self checkMultipleUrlInOneUrlWithUrl:[subStrArray lastObject] videoName:[subStrArray firstObject] itemArray:itemArray];
            }
        }
        [self.dataArray addObjectsFromArray:itemArray];
        NSLog(@"self.dataArray==========%@",self.dataArray);
    }else {
        NSLog(@"error %@", error);
    }
}
- (NSMutableArray *)checkMultipleUrlInOneUrlWithUrl:(NSString *)url
                                          videoName:(NSString *)videoName
                                          itemArray:(NSMutableArray *)itemArray
{
    NSArray *multipleArray = [url componentsSeparatedByString:@"#"];
    for (NSString *itemUrl in multipleArray) {
        MMovieModel *model = [MMovieModel getMovieModelWithTitle:videoName ?: @"" url:itemUrl ?: @""];
        [itemArray addObject:model];
        /*
         if (![self isContainObject:itemUrl] && itemUrl && videoName) {
         [self writeNotRepeatURL:itemUrl name:videoName fileName:@"NotRepeat"];
         }
         else {
         [self writeNotRepeatURL:itemUrl name:videoName fileName:@"Repeat"];
         }
         */
    }
    NSLog(@"itemArray=============%@",itemArray);
    return itemArray;
}
/**
 *  检查是否有重复url
 *
 *  @param url url description
 *
 *  @return 重复 YES， 不重复返回NO
 */
- (BOOL)isContainObject:(NSString *)url{
    NSString *document = [NSString stringWithFormat:@"%@/Documents/urlsSet.plist",NSHomeDirectory()];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:document]) {
        [[NSFileManager defaultManager] createFileAtPath:document contents:nil attributes:nil];
    }
    
    NSMutableArray *urlArray = [NSMutableArray arrayWithContentsOfFile:document];
    BOOL contain = [urlArray containsObject:url];
    [urlArray addObject:url];
    NSSet *urlSet = [NSSet setWithArray:urlArray];
    urlArray = (id)[urlSet allObjects];
    [urlArray writeToFile:document atomically:YES];
    return contain;
}

/**
 *  把重复的保存在一起，不重复的保存在一起
 *
 *  @param url      url description
 *  @param name     TV name
 *  @param fileName 保存文件名
 */
- (void)writeNotRepeatURL:(NSString *)url name:(NSString *)name fileName:(NSString *)fileName{
    NSString *document = [NSString stringWithFormat:@"%@/Documents/%@.txt",NSHomeDirectory(), fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:document]) {
        [[NSFileManager defaultManager] createFileAtPath:document contents:nil attributes:nil];
    }
    NSLog(@"Home ==== %@", document);
    
    NSError *error = nil;
    NSString *NotRepeat = [NSString stringWithContentsOfFile:document encoding:NSUTF8StringEncoding error:&error];
    NotRepeat = [NotRepeat stringByAppendingFormat:@"%@,%@\n",name, url];
    NSLog(@"读取字符串 error %@", error);
    [NotRepeat writeToFile:document atomically:YES encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"写入 error %@", error);
}

- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"直播列表"];
    
    LZWeakSelf(ws)
    [self lzSetRightButtonWithTitle:nil selectedImage:@"save" normalImage:@"save" actionBlock:^(UIButton *button) {
        [[NSUserDefaults standardUserDefaults] setObject:@(button.selected) forKey:@"kAutoPlaySwitch"];
        
        
    }];
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        
        [ws.navigationController popViewControllerAnimated:YES];
        
    }];
    
}
- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        
        [table registerClass:[VideoListTableViewCell class] forCellReuseIdentifier:@"VideoCell"];
        
        [table setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        
        [self.view addSubview:table];
        _myTableView = table;
        
        LZWeakSelf(ws)
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(ws.view);
            make.top.mas_equalTo(ws.view).offset(LZNavigationHeight);
        }];
    }
    
    
    return _myTableView;
}
#pragma mark -- 添加后台方法
- (void)addBackgroundMethod{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell" forIndexPath:indexPath];
    
    if (indexPath.row < [self.dataArray count]) {
        MMovieModel *model =  self.dataArray[indexPath.row];
        [cell setObject:model];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@-%@",@(indexPath.row+1), model.title];
        [cell checkIsCanPlay:cell.urlLabel.text fileName:self.dict[@"title"]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.dataArray count]) {
        
        VideoListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (![tableView.visibleCells containsObject:cell]) {
            if ((indexPath.row+2) < [self.dataArray count]) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row+2) inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row) inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }
        
        MMovieModel *model =  self.dataArray[indexPath.row];
        NSString *videoName = model.title;
        NSString *movieUrl = [model.url stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
        
        NSLog(@"title%@\n url = %@", videoName, movieUrl);
        self.title = videoName;
        
        [self playVideoWithMovieUrl:movieUrl movieName:videoName indexPath:indexPath];
    }
}

-(void)viewDidLayoutSubviews {
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.myTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

/**
 *  注册前后台观察者
 *  进入后台，暂停。进去前台，播放
 */
- (void)registerObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification{
    if ([self.playerController isKindOfClass:[NewPlayerViewController class]]) {
        [((NewPlayerViewController *)self.playerController).player play];
    }else {
        [((MPMoviePlayerViewController *)self.playerController).moviePlayer play];
    }
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification{
    if ([self.playerController isKindOfClass:[NewPlayerViewController class]]) {
        [((NewPlayerViewController *)self.playerController).player pause];
    }else {
        [((MPMoviePlayerViewController *)self.playerController).moviePlayer pause];
    }
}
#pragma mark - private Method

/**
 *  播放某一个index下的视频。对于可播放的，存储。然后根据条件自动判断是否进行下一个视频播放
 *
 *  kxResetPop 当自动进行下一个播放时，设置为NO，当进行点击操作时，变为YES，这样dispatch_after（）就可以判断不用自动进行下一个了。另外条件就是switch开关。
 *
 *  @param movieUrl  视频的播放地址
 *  @param movieName 视频的名称
 *  @param indexPath 当前播放的视频cell的索引
 */
- (void)playVideoWithMovieUrl:(NSString *)movieUrl
                    movieName:(NSString *)movieName
                    indexPath:(NSIndexPath *)indexPath{
    if (movieUrl == nil) {
        return;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        /** 使用AVPlayer播放
         AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:movieUrl]];
         AVPlayer *avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
         
         NewPlayerViewController *playerVC = [[NewPlayerViewController alloc] init];
         [playerVC setPlayer:avPlayer];
         [avPlayer play];
         self.playerController = playerVC;
         [self presentViewController:playerVC animated:YES completion:nil];
         */
        ///*
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"KxMovieParameterDisableDeinterlacing"] = @(YES);
        KxMovieViewController *vc = [KxMovieViewController
                                     movieViewControllerWithContentPath:movieUrl
                                     parameters:params];
        vc.timeout = 60;
        __block NSString *movieStr = movieUrl;
        __weak __block typeof(self) mySelf = self;
        __weak __block typeof(KxMovieViewController *) myvc = vc;
        
        self.kxResetPop = YES;
        
        vc.VCCallBack = ^(void){
            mySelf.kxResetPop = YES;
        };
        
        vc.playCallBack = ^(NSError *error , BOOL success){
            if (success) {
                VideoListTableViewCell *ttcell = [mySelf.myTableView cellForRowAtIndexPath:indexPath];
                if (ttcell.canPlayLabel.hidden || !ttcell.canPlayLabel) {
                    [mySelf saveCanPlayHistory:movieStr];
                    [mySelf saveCanPlayHistoryToDocument:movieStr name:movieName];
                }
                ttcell.canPlayLabel.hidden = NO;
                mySelf.kxResetPop = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
                    if (mySelf.kxResetPop || !self.autoPlaySwitch.on) {
                        return;
                    }
                    [myvc dismissViewControllerAnimated:YES completion:nil];
                    mySelf.kxResetPop = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
                        if (mySelf.kxResetPop) {
                            return;
                        }
                        [mySelf autoPlayNextVideo:indexPath delegate:mySelf];
                    });
                });
                
            }else {
                [myvc.alertView dismissWithClickedButtonIndex:0 animated:YES];
                [myvc dismissViewControllerAnimated:YES completion:nil];
                mySelf.kxResetPop = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
                    if (mySelf.kxResetPop || !self.autoPlaySwitch.on) {
                        return;
                    }
                    [mySelf autoPlayNextVideo:indexPath delegate:mySelf];
                });
            }
        };
        [self presentViewController:vc animated:YES completion:nil];
        
    }else {
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:movieUrl]];
        self.playerController = player;
        [self presentMoviePlayerViewControllerAnimated:player];
        //   */
    }
}
/**
 *  自动播放下一个cell里的视频
 *
 *  @param currentIndexPath 当前播放的视频cell索引
 *  @param vc
 */
- (void)autoPlayNextVideo:(NSIndexPath *)currentIndexPath delegate:(VideoListViewController *)vc{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndexPath.row+1 inSection:0];
    [vc tableView:self.myTableView didSelectRowAtIndexPath:indexPath];
}

/**
 *  根据一个列表产生一个可播放地址列表
 *
 *  @param movieUrl 播放地址
 */
- (void)saveCanPlayHistory:(NSString *)movieUrl{
    NSMutableDictionary *canPlaylistDict = [NSMutableDictionary dictionary];
    [canPlaylistDict setDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:self.dict[@"title"]]];
    [canPlaylistDict setValue:movieUrl forKey:movieUrl];
    // 保存到 NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:canPlaylistDict forKey:self.dict[@"title"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  保存可以播放的地址进入沙盒
 *
 *  @param movieUrl 播放地址
 *  @param name     播放地址名称
 */
- (void)saveCanPlayHistoryToDocument:(NSString *)movieUrl name:(NSString *)name{
    NSString *documentPath = [VideoListViewController getResultDocumentFilePath];
    NSError *error = nil;
    NSString *oldString = [NSString stringWithContentsOfFile:documentPath encoding:NSUTF8StringEncoding error:&error];
    if (!error) {
        NSLog(@"读取字符串 error %@", error);
    }
    NSString *newString = [NSString stringWithFormat:@"%@\n%@ %@",oldString?:@"", name, movieUrl];
    BOOL success = [newString writeToFile:documentPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!error || !success) {
        NSLog(@"写入字符串 error %@， success %d", error, success);
    }
}

/**
 *  获取过滤后的列表存储地址
 *
 *  @return 沙盒存储地址
 */
+ (NSString *)getResultDocumentFilePath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    documentPath = [NSString stringWithFormat:@"%@/%@.txt", documentPath, CanPlayResult];
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentPath]) {
        [[NSFileManager defaultManager] createFileAtPath:documentPath contents:nil attributes:nil];
    }
    NSLog(@"documentPath  %@", documentPath);
    return documentPath;
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
