//
//  AppDelegate.m
//  LLTwitterLoadAnimation
//
//  Created by 李龙 on 16/8/16.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     *  “ mask 一开始就存在，所以你可以在程序启动时就能透过 mask 看到后面的视图。”
     
     *                                     ------- 摘录来自: 杨骑滔（KittenYang）. “A GUIDE TO IOS ANIMATION”。 iBooks.
     */
    
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor colorWithRed:0.408 green:0.743 blue:0.997 alpha:1];
    
    UINavigationController *navc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    self.window.rootViewController = navc;
    
    
     //logo mask 添加一个遮罩,图片透明和不透明的地方反转
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"1"].CGImage; //必须是CGImageRef
    maskLayer.position = navc.view.center;
    maskLayer.bounds = CGRectMake(0, 0, 60, 60);
    navc.view.layer.mask = maskLayer; //为mask(CALayer)属性赋值之后,露出window是黑色的,必须通过改变self.window.background的颜色

    
    //白色的遮盖背景
    UIView *maskBackGrooundView = [[UIView alloc] initWithFrame:navc.view.bounds];
    maskBackGrooundView.backgroundColor = [UIColor whiteColor];
    [navc.view insertSubview:maskBackGrooundView atIndex:1];
    
    
    //logo mask 的放大动画
    CAKeyframeAnimation *logoMaskAnimation  = [CAKeyframeAnimation animationWithKeyPath:@"bounds"]; //animationWithKeyPath:@"bounds":指定layer的size发生动画
    logoMaskAnimation.duration = 1.0f;
    logoMaskAnimation.beginTime = CACurrentMediaTime() + 1.0f;//延迟一秒
    
    CGRect initalBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds = CGRectMake(0, 0, 2000, 2000);
    logoMaskAnimation.values = @[
                                 [NSValue valueWithCGRect:initalBounds],
                                 [NSValue valueWithCGRect:secondBounds],
                                 [NSValue valueWithCGRect:finalBounds],
                                 ];
    logoMaskAnimation.keyTimes =  @[@(0),@(0.5),@(1)];
    logoMaskAnimation.timingFunctions = @[
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                          ];
    
    logoMaskAnimation.removedOnCompletion = NO;
    logoMaskAnimation.fillMode = kCAFillModeForwards;
    [navc.view.layer.mask addAnimation:logoMaskAnimation forKey:@"logoMaskAnimation"];
    
    
    //白色背景图的的alpha值的变化动画
    [UIView animateWithDuration:0.1 delay:1.35 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        maskBackGrooundView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [maskBackGrooundView removeFromSuperview];
    }];
    
    
    //根控制器的view的放大效果
    [UIView animateWithDuration:0.25 delay:1.3 options:UIViewAnimationOptionTransitionNone animations:^{

        navc.view.transform = CGAffineTransformMakeScale(1.05, 1.05);//放大

    } completion:^(BOOL finished) {

        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

            navc.view.transform = CGAffineTransformIdentity;

        } completion:^(BOOL finished) {

            navc.view.layer.mask = nil; //遮罩清楚

        }];
        
    }];
    
    
    //在动画中,可以看到当放大动画的时候有一个图片蓝色的部分停留,这里我们有两个解决的办法,第一个是navc.view.layer.mask = nil这句代码往前提.  第二个是换一张中间完全镂空的,类似于杨骑滔给的五角星的中间不镂空的图片
    

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
