//
//  BallViewController.m
//  NewHaipei
//
//  Created by guopenglai on 2017/4/14.
//  Copyright © 2017年 guopenglai. All rights reserved.
//

#import "BallViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface BallViewController ()<UIAccelerometerDelegate>
{
    UIImageView *ballImg;

    CMMotionManager *motionManager;
    double x;
    double y;
}
@end

@implementation BallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNaviBar];

    x = 0.0;
    y = 0.0;
    
    motionManager = [[CMMotionManager alloc]init];
    
    //放一个小球在中央
    ballImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ball"]];
    ballImg.frame = CGRectMake(0, 0, 50, 50);
    ballImg.center = self.view.center;
    [self.view addSubview:ballImg];
    
    //更新频率
    motionManager.accelerometerUpdateInterval = 1/60;
    //检测确保我们设备上的加速器数据是可用的
    if (motionManager.accelerometerAvailable) {
        /*
         我们可以把所有有关CoreMotionManger的处理放到主队列中去。在实践中这样做会比让其在各自队列中调用好得多，起码不会让交互显得迟缓，不过我们需要回到主队列中更改一些元素。使用NSOperationQueue的addOperationWithblock方法即轻松实现
         */
        NSOperationQueue *queue = [[NSOperationQueue alloc]init];
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            //动态设置小球位置
//            double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) ;
            x = accelerometerData.acceleration.x+x;
            y = accelerometerData.acceleration.y+y;
            
            double posX = ballImg.center.x+(CGFloat)x;
            double posY = ballImg.center.y-(CGFloat)y;

            //碰到边框后的反弹处理
            if (posX<0) {
                posX=0;
                //碰到左边的边框后以0.4倍的速度反弹
                x = -0.4*x;
            }
            else if (posX>self.view.bounds.size.width)
            {
                posX=self.view.bounds.size.width;
                //碰到右边的边框后以0.4倍的速度反弹
                x = -0.4*x;
            }
            if (posY<0) {
                posY=0;
                //碰到上面的边框以0.4倍的速度反弹
                y = -0.4*y;
            }
            else if (posY>self.view.bounds.size.height)
            {
                posY=self.view.bounds.size.height;
                //碰到下面的边框以0.4倍的速度反弹
                y = -0.4*y;
            }

            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // update UI here
                ballImg.center = CGPointMake(posX, posY);
            }];
            
            
            
        }];
        

    }
    else
    {
        NSLog(@"加速传感器不可用");
    }
}
- (void)setupNaviBar {
    [self lzSetNavigationTitle:@"小球"];
    
    LZWeakSelf(ws)
    [self lzSetLeftButtonWithTitle:nil selectedImage:@"houtui" normalImage:@"houtui" actionBlock:^(UIButton *button) {
        LZLog(@"leftButton");
        
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    
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
