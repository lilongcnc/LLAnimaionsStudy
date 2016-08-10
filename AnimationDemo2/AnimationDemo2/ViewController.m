//
//  ViewController.m
//  AnimationDemo2
//
//  Created by 李龙 on 16/7/25.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "LLSildeMenuView.h"

@interface ViewController ()

@property (nonatomic,strong) LLSildeMenuView *silderMenuView;

@end

@implementation ViewController{
    CGFloat _screenW;
    CGFloat _screenH;
    UIWindow *keyWindow;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _screenW = [UIScreen mainScreen].bounds.size.width;
    _screenH = [UIScreen mainScreen].bounds.size.height;
    keyWindow = [UIApplication sharedApplication].keyWindow;
    
    
    _silderMenuView = ({
    
         LLSildeMenuView *silderView = [[LLSildeMenuView alloc] initWithMenuTitles:@[@"首页",@"消息",@"发布",@"个人",@"设置"]];
         silderView.menuOnClickBlock = ^(NSInteger index,NSString *title,NSInteger titleCounts){
    
            NSLog(@"index:%ld title:%@ titleCounts:%ld",index,title,titleCounts);
        };
         
         silderView;
    });
    
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_screenW-150, _screenH*0.5, 100, 50)];
    [button  setTitle:@"Tigger" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:0];
    [button addTarget:self action:@selector(btnOnClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}


- (void)btnOnClick1:(UIButton *)btn{
     [_silderMenuView trigger];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
