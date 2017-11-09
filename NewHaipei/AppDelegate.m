//
//  AppDelegate.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/12.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "AppDelegate.h"
#import "LZSqliteTool.h"
#import "LZTabBarController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "DiscoverViewController.h"
//#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "LZBaseNavigationController.h"
#import "TouchIdUnlock.h"


#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()
@property(strong,nonatomic)Reachability*hostReach;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:2.0];
    
    //创建tabbar
    [self setTabbarControllerWithIdentifier:nil];
    //密码解锁
    [self verifyPassword];
    //设置3DTouch
    [self configShortCutItems];
    //注册通知
    [self registerLocalNotification];
    //初始化网络状态监听
    [self ReachabilityStatus];
    //创建数据库
    [self createSqlite];
    //设置启动页
//    [self addADLaunchController];
    return YES;
}
//- (void)addADLaunchController
//{
//    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([appdelegate.window.rootViewController isKindOfClass:[LZBaseNavigationController class]] == YES) {
//        // 为所欲为
//        LaunchController *launchController = [[LaunchController alloc]init];
//        [appdelegate.window.rootViewController addChildViewController:launchController];
//        launchController.view.frame = appdelegate.window.rootViewController.view.frame;
//        [appdelegate.window.rootViewController.view addSubview:launchController.view];
//    }
//    
//    
////    UIViewController *rootViewController = self.window.rootViewController;
////    LaunchController *launchController = [[LaunchController alloc]init];
////    [rootViewController addChildViewController:launchController];
////    launchController.view.frame = rootViewController.view.frame;
////    [rootViewController.view addSubview:launchController.view];
//}
- (void)createSqlite {
    
    [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    [LZSqliteTool LZDefaultDataBase];
    [LZSqliteTool LZCreateDataTableWithName:LZSqliteDataTableName];
    [LZSqliteTool LZCreateGroupTableWithName:LZSqliteGroupTableName];
    [LZSqliteTool createPswTableWithName:LZSqliteDataPasswordKey];
    
    NSInteger groups = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteGroupTableName];
    NSInteger count = [LZSqliteTool LZSelectElementCountFromTable:LZSqliteDataTableName];
    NSUserDefaults *us = [NSUserDefaults standardUserDefaults];
    BOOL isDataInit = [us objectForKey:@"dataAlreadyInit"];
    if (count <= 0 && groups <= 0 && !isDataInit) {
        
        [self creatData];
    }
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    BOOL isPswAlreadySaved = [[df objectForKey:@"pswAlreadySavedKey"] boolValue];
    
    if (!isPswAlreadySaved) {
        NSString *psw = [df objectForKey:@"redomSavedKey"];
        
        if (psw.length > 0) {
            
            [LZSqliteTool LZInsertToPswTable:LZSqliteDataPasswordKey passwordKey:LZSqliteDataPasswordKey passwordValue:psw];
        }
        
        [df setBool:YES forKey:@"pswAlreadySavedKey"];
    }
}
- (void)creatData
{
    
}
#pragma mark -- 网络状态监听
-(void)ReachabilityStatus
{
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(reachabilityChanged:)
     
                                                 name: kReachabilityChangedNotification
     
                                               object: nil];
    
    _hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];//可以以多种形式初始化
    
    [_hostReach startNotifier];  //开始监听,会启动一个run loop
}
//MARK: 处理网络监听
// 连接改变
- (void) reachabilityChanged: (NSNotification* )note

{
    Reachability* curReach = [note object];
    
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    
    [self updateInterfaceWithReachability: curReach];
}
//处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NSLog(@"网络状况发生改变");
    //对连接改变做出响应的处理动作。
    _statue = [curReach currentReachabilityStatus];
}

#pragma mark -- 3DTouch
/** 创建shortcutItems ----------abner */
- (void)configShortCutItems
{
    
    NSMutableArray *shortcutItems = [NSMutableArray array];
    //    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"1" localizedTitle:@"添加账号"];
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc]initWithType:@"1" localizedTitle:@"数据库测试" localizedSubtitle:nil icon:icon userInfo:nil];
    [shortcutItems addObject:item];
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}
//3DTouch
/** 处理shortcutItem */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    switch (shortcutItem.type.integerValue)
    {
        case 1:
        {
            /*
             这个地方可以直接设置成想要的 vc 但是这个用起来不够爽 体验不好
             
             这个地方实际上我建议使用通知来控制
             [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoViewController" object:self userInfo:@{@"type":@"添加账号"}];
             
             最好做个双保险的  先检查 rootVC 是否已经存在  不存在的话创建 rootVC 再到以创建的rootVC里面处理跳转逻辑
             
             ps: 因为现在的支付宝还有微信都是这么处理的  在特定的页面打开以后  依然可以继续玩其他的功能
             */
            
//            [self setTabbarControllerWithIdentifier:@"shortcut"];
            
            /*
             获取rootViewController
             第一种方法：
             
             UIWindow *window = [UIApplication sharedApplication].keyWindow;
             UIViewController *rootViewController = window.rootViewController;
             第二种方法：
             
             AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             UIViewController *rootViewController1 = appdelegate.window.rootViewController;
             
             
             第一种方法在AlertView弹出的时候去获取RootViewController，并且对你认为获取正确的RootViewController做相关的操作，你会死的很惨。
             所以,建议用第二种
             */
            AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if ([appdelegate.window.rootViewController isKindOfClass:[LZBaseNavigationController class]] == YES) {
                // 为所欲为
                
            }else
            {
                [self setTabbarControllerWithIdentifier:@"shortcut"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoViewController" object:@{@"type":@"跳转详情"}];

        }
        default:
            break;
    }
}
#pragma mark --Tabbar
- (void)setTabbarControllerWithIdentifier:(NSString *)identifier {

    FirstViewController *main = [[FirstViewController alloc]init];
    if (identifier!=nil)
    {
        main.flog = identifier;
    }

    SecondViewController *second = [[SecondViewController alloc]init];

//    ThirdViewController *third = [[ThirdViewController alloc]init];
    DiscoverViewController *third = [[DiscoverViewController alloc]init];
    
    FourthViewController *fourth = [[FourthViewController alloc]init];
    
    LZTabBarController *tabbar = [LZTabBarController createTabBarController:^LZTabBarConfig *(LZTabBarConfig *config) {
        
        config.viewControllers = @[main, second, third,fourth];
        config.titles = @[@"首页",@"消息", @"发现", @"设置"];
        config.isNavigation = NO;
        
        config.selectedImages = @[@"Firstselected", @"Secondselected", @"Thirdselected",@"Fourthselected"];
        config.normalImages = @[@"Firstunselected", @"Secondunselected", @"Thirdunselected",@"Fourthunselected"];
        config.selectedColor = LZColorBase;
        return config;
    }];
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    self.window.rootViewController = tabbar;
//    [self.window makeKeyAndVisible];
    
    LZBaseNavigationController *nav = [[LZBaseNavigationController alloc]initWithRootViewController:tabbar];
    
    nav.hidesBottomBarWhenPushed = YES;
    
    self.window.rootViewController = nav;
    
}
- (void)verifyPassword {
    
    if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
        
        [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
            
            
        }];
    }

}
#pragma mark --registerLocalNotification
- (void)registerLocalNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        [self registeriOS10LocalNotification];
    } else {
        [self registeriOS8LocalNotification];
    }
}
- (void)registeriOS10LocalNotification
{
    //iOS10特有
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // 必须写代理，不然无法监听通知的接收与点击
    center.delegate = self;
    
    /**
     UNNotificationActionOptionAuthenticationRequired: 锁屏时需要解锁才能触发事件，触发后不会直接进入应用
     UNNotificationActionOptionDestructive：字体会显示为红色，且锁屏时触发该事件不需要解锁，触发后不会直接进入应用
     UNNotificationActionOptionForeground：锁屏时需要解锁才能触发事件，触发后会直接进入应用界面
     */
    UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:kNotificationActionIdentifileStar title:@"赞" options:UNNotificationActionOptionAuthenticationRequired];
    UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:kNotificationActionIdentifileComment title:@"评论一下吧" options:UNNotificationActionOptionForeground textInputButtonTitle:@"评论" textInputPlaceholder:@"请输入评论"];
    UNNotificationCategory *catetory = [UNNotificationCategory categoryWithIdentifier:kNotificationCategoryIdentifile actions:@[action1, action2] intentIdentifiers:@[kNotificationActionIdentifileStar, kNotificationActionIdentifileComment] options:UNNotificationCategoryOptionNone];
    
    [center setNotificationCategories:[NSSet setWithObject:catetory]];
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //用户点击允许
            NSLog(@"注册成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
            }];
        } else {
            //用户点击不允许
            NSLog(@"注册失败");
        }
    }];
}

- (void)registeriOS8LocalNotification
{
    //创建消息上面要添加的动作（iOS9才支持）
    UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
    action1.identifier = kNotificationActionIdentifileStar;
    action1.title = @"赞";
    //当点击的时候不启动程序，在后台处理
    action1.activationMode = UIUserNotificationActivationModeBackground;
    //需要解锁才能处理(意思就是如果在锁屏界面收到通知，并且用户设置了屏幕锁，用户点击了赞不会直接进入我们的回调进行处理，而是需要用户输入屏幕锁密码之后才进入我们的回调)，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action1.authenticationRequired = YES;
    /*
     destructive属性设置后，在通知栏或锁屏界面左划，按钮颜色会变为红色
     如果两个按钮均设置为YES，则均为红色（略难看）
     如果两个按钮均设置为NO，即默认值，则第一个为蓝色，第二个为浅灰色
     如果一个YES一个NO，则都显示对应的颜色，即红蓝双色 (CP色)。
     */
    action1.destructive = NO;
    
    //第二个动作
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
    action2.identifier = kNotificationActionIdentifileComment;
    action2.title = @"评论";
    //当点击的时候不启动程序，在后台处理
    action2.activationMode = UIUserNotificationActivationModeBackground;
    //设置了behavior属性为 UIUserNotificationActionBehaviorTextInput 的话，则用户点击了该按钮会出现输入框供用户输入
    action2.behavior = UIUserNotificationActionBehaviorTextInput;
    //这个字典定义了当用户点击了评论按钮后，输入框右侧的按钮名称，如果不设置该字典，则右侧按钮名称默认为 “发送”
    action2.parameters = @{UIUserNotificationTextInputActionButtonTitleKey: @"评论"};
    
    //创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    //这组动作的唯一标示
    category.identifier = kNotificationCategoryIdentifile;
    //最多支持两个，如果添加更多的话，后面的将被忽略
    [category setActions:@[action1, action2] forContext:(UIUserNotificationActionContextMinimal)];
    //创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObject:category]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
}
#pragma mark - iOS10 接收推送的两个方法
/**
 本地和远程推送合为一个，通过 response.notification.request.trigger 来区分
 1.UNPushNotificationTrigger （远程通知） 远程推送的通知类型
 
 2.UNTimeIntervalNotificationTrigger （本地通知） 一定时间之后，重复或者不重复推送通知。我们可以设置timeInterval（时间间隔）和repeats（是否重复）。
 
 3.UNCalendarNotificationTrigger（本地通知） 一定日期之后，重复或者不重复推送通知 例如，你每天8点推送一个通知，只要dateComponents为8，如果你想每天8点都推送这个通知，只要repeats为YES就可以了。
 
 4.UNLocationNotificationTrigger （本地通知）地理位置的一种通知，
 当用户进入或离开一个地理区域来通知。在CLRegion标识符必须是唯一的。因为如果相同的标识符来标识不同区域的UNNotificationRequests，会导致不确定的行为。
 */
//接收到通知的事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    //这个和下面的userNotificationCenter:didReceiveNotificationResponse withCompletionHandler: 处理方法一样
    NSDictionary *userInfo = notification.request.content.userInfo;
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    NSString *title = content.title;
    NSString *subTitle = content.subtitle;
    UNNotificationSound *sound = content.sound;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 应用在前台收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}", body, title, subTitle, badge, sound, userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    //清除角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    NSNumber *badge = content.badge;
    NSString *body = content.body;
    NSString *title = content.title;
    NSString *subTitle = content.subtitle;
    UNNotificationSound *sound = content.sound;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 前台收到远程通知:%@", userInfo);
    } else {
        // 判断为本地通知
        NSLog(@"iOS10 应用在后台点击推送消息收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}", body, title, subTitle, badge, sound, userInfo);
    }
    NSString *actionIdentifile = response.actionIdentifier;
    if ([actionIdentifile isEqualToString:kNotificationActionIdentifileStar]) {
        [self showAlertView:@"点了赞"];
    } else if ([actionIdentifile isEqualToString:kNotificationActionIdentifileComment]) {
        [self showAlertView:[(UNTextInputNotificationResponse *)response userText]];
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}
#pragma mark - iOS9 及之前方法
// (iOS9及之前)本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"%@", notification.userInfo);
    [self showAlertView:@"用户没点击按钮直接点的推送消息进来的/或者该app在前台状态时收到推送消息"];
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge -= notification.applicationIconBadgeNumber;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}

//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容
- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void(^)())completionHandler
{
    if ([identifier isEqualToString:kNotificationActionIdentifileStar]) {
        [self showAlertView:@"点了赞"];
    } else if ([identifier isEqualToString:kNotificationActionIdentifileComment]) {
        [self showAlertView:[NSString stringWithFormat:@"用户评论为:%@", responseInfo[UIUserNotificationActionResponseTypedTextKey]]];
    }
    
    completionHandler();
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self verifyPassword];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)showAlertView:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.window.rootViewController showDetailViewController:alert sender:nil];
}

@end
