//
//  FourthViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/12.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "FourthViewController.h"

#import "TouchIdUnlock.h"
#import "LZTouchIDViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "BallViewController.h"
#import "AboutViewController.h"
#import "iCloudViewController.h"
#import "LZNumSettingViewController.h"
#import "LZGestureSetupViewController.h"
#import "VideoListViewController.h"
@interface FourthViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *myTableView;
@property (strong, nonatomic)NSMutableArray *dataArray;
@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self lzSetNavigationTitle:@"设置"];
    [self myTableView];
}
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        
        if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotBySystem]) {
            
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"设置手势密码",@"设置数字密码",@"设置TouchID"],@[@"直播测试"],@[@"iCloud同步"],@[@"发送本地推送",@"取消发送本地推送"],@[@"小球加速运动并反弹样例"],@[@"关于我们"], nil];
        } else {
            
            _dataArray = [[NSMutableArray alloc]initWithObjects:@[@"设置手势密码",@"设置数字密码"],@[@"直播测试"],@[@"iCloud同步"],@[@"发送本地推送",@"取消发送本地推送"],@[@"小球加速运动并反弹样例"],@[@"关于我们"], nil];
        }
        
        //        ,@"设置数字密码"
        
        //  ,@[@"开启分组验证",@"开启详情验证",@"开启显示密码验证"]
        //验证选项先不加
    }
    
    return _dataArray;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellID"];
            cell.textLabel.textColor = LZColorFromHex(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        NSArray *arr = self.dataArray[indexPath.section];
        cell.textLabel.text = arr[indexPath.row];
        return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *titles = @[@"安全设置",@"直播测试",@"iCloud设置",@"推送测试",@"加速传感器测试",@"关于"];
    //    NSArray *titles = @[@"安全设置",@"设置验证选项",@"关于"];
    return titles[section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UINavigationController *nav = self.navigationController;
    
    if (indexPath.section == 3) {
        //推送测试
        switch (indexPath.row) {
            case 0:
            {
                //发送本地推送
                if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
                    [self sendiOS10LocalNotification];
                } else {
                    [self sendiOS8LocalNotification];
                }
            } break;
            case 1:
            {
                //取消发送本地推送
                for (UILocalNotification *obj in [UIApplication sharedApplication].scheduledLocalNotifications) {
                    if ([obj.userInfo.allKeys containsObject:kLocalNotificationKey]) {
                        [[UIApplication sharedApplication] cancelLocalNotification:obj];
                    }
                }
                //直接取消全部本地通知
                //[[UIApplication sharedApplication] cancelAllLocalNotifications];
            } break;
            default:
                break;
        }


    } else if (indexPath.section == 2) {
        //icloud设置
        iCloudViewController *icloudVC = [[iCloudViewController alloc]init];
        [self.navigationController pushViewController:icloudVC animated:YES];

    } else if (indexPath.section == 1){
        //分组管理
        VideoListViewController *videoVC = [[VideoListViewController alloc]init];
        [self.navigationController pushViewController:videoVC animated:YES];

    }else if (indexPath.section==4)
    {
        //小球加速运动并反弹样例
        BallViewController *ballVC = [[BallViewController alloc]init];
        [self.navigationController pushViewController:ballVC animated:YES];
        
        
    }else if (indexPath.section==5)
    {
       //关于
        AboutViewController *aboutVC = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:aboutVC animated:YES];
        
    }
    else {
        //安全设置
        switch (indexPath.row) {
            case 0:
            {
                LZGestureSetupViewController *gesture = [[LZGestureSetupViewController alloc]init];
                [nav pushViewController:gesture animated:YES];
            } break;
            case 1:
            {

                LZNumSettingViewController *number = [[LZNumSettingViewController alloc]init];
                
                [nav pushViewController:number animated:YES];
            } break;
            case 2:
            {
                LZTouchIDViewController *vc = [[LZTouchIDViewController alloc]init];
                [nav pushViewController:vc animated:YES];
            } break;
            default:
                break;
        }
    }
}
#pragma mark -- 发送推送
- (void)sendiOS10LocalNotification
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.body = @"Body:夏目友人帐";
    content.badge = @(1);
    content.title = @"Title:夏目·贵志";
    content.subtitle = @"SubTitle:郭蓬莱";
    content.categoryIdentifier = kNotificationCategoryIdentifile;
    content.userInfo = @{kLocalNotificationKey: @"iOS10推送"};
    //    content.launchImageName = @"xiamu";
    //推送附件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"mp4"];
    NSError *error = nil;
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"AttachmentIdentifile" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    content.attachments = @[attachment];
    
    //推送类型
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Test" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"iOS 10 发送推送， error：%@", error);
    }];
}

- (void)sendiOS8LocalNotification
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    //触发通知时间
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    //重复间隔
    //    localNotification.repeatInterval = kCFCalendarUnitMinute;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    //通知内容
    localNotification.alertBody = @"i am a test local notification";
    localNotification.applicationIconBadgeNumber = 1;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //通知参数
    localNotification.userInfo = @{kLocalNotificationKey: @"iOS8推送"};
    
    localNotification.category = kNotificationCategoryIdentifile;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
