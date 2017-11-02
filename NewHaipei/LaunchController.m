//
//  LaunchController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/22.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "LaunchController.h"
#import "LaunchView.h"
#import "UIImage+TYLaunchImage.h"
#import "AFNetworking.h"
#import "YYWebImage.h"
@interface LaunchController ()
@property (nonatomic, weak) LaunchView *adLaunchView;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) AFHTTPSessionManager *netManager;
@end

@implementation LaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addADLaunchView];
    
    [self loadData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _adLaunchView.frame = self.view.bounds;
    
}

- (void)addADLaunchView
{
    LaunchView *adLaunchView = [[LaunchView alloc]init];
    adLaunchView.skipBtn.hidden = YES;
    adLaunchView.launchImageView.image = [UIImage ty_getLaunchImage];
    [adLaunchView.skipBtn addTarget:self action:@selector(skipADAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adLaunchView];
    _adLaunchView = adLaunchView;
}

- (void)loadData
{
    NSString *urlstr = [NSString stringWithFormat:@"http://i.play.163.com/news/initLogo/ios_iphone6"];
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    _netManager = [AFHTTPSessionManager manager];
    _netManager.requestSerializer     = [AFHTTPRequestSerializer serializer];
    _netManager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    _netManager.requestSerializer.timeoutInterval=15.0;
    
    
    [_netManager GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *responseStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        //解析得到一个html字符串
        //"http://img3.cache.netease.com/game/app/qidong/history/20170413/750x1334.jpg"

        //去除双引号
        responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if (!responseStr || ![responseStr isKindOfClass:[NSString class]]) {
            [self dismissController];
            return;
        }
        //中文转unicode
        NSString * Str = [responseStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self showADImageWithURL:[NSURL URLWithString:Str]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dismissController];
    }];

}
#pragma mark - private

- (void)showADImageWithURL:(NSURL *)url
{

    __weak typeof(self) weakSelf = self;
    [_adLaunchView.adImageView setImageWithURL:url placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        // 启动倒计时
        [weakSelf scheduledGCDTimer];
    }];
}

- (void)showSkipBtnTitleTime:(int)timeLeave
{
    NSString *timeLeaveStr = [NSString stringWithFormat:@"跳过 %ds",timeLeave];
    [_adLaunchView.skipBtn setTitle:timeLeaveStr forState:UIControlStateNormal];
    _adLaunchView.skipBtn.hidden = NO;
}

- (void)scheduledGCDTimer
{
    [self cancleGCDTimer];
    __block int timeLeave = 3; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __typeof (self) __weak weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(timeLeave <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(weakSelf.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //关闭界面
                [weakSelf dismissController];
            });
        }else{
            int curTimeLeave = timeLeave;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面
                [weakSelf showSkipBtnTitleTime:curTimeLeave];
                
            });
            --timeLeave;
        }
    });
    dispatch_resume(_timer);
}

- (void)cancleGCDTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

#pragma mark - action

- (void)skipADAction
{
    [self dismissController];
}

- (void)dismissController
{
    /*
     NSURL *URL = [NSURL URLWithString:@http];
     
     AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
     
     NSURLSessionDataTask *task = [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
     
     NSLog(@"JSON: %@", responseObject);
     
     } failure:^(NSURLSessionTask *operation, NSError *error) {
     
     NSLog(@"Error: %@", error);
     
     }];
     
     //取消单个请求
     
     [task cancel];
     
     //取消当前所有
     
     [manager.operationQueue cancelAllOperations];
     */
    [_netManager.operationQueue cancelAllOperations];
    [self cancleGCDTimer];
    
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self willMoveToParentViewController:nil];
        [self removeFromParentViewController];
       
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [self cancleGCDTimer];
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
