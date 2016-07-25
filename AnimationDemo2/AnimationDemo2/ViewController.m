//
//  ViewController.m
//  AnimationDemo2
//
//  Created by 李龙 on 16/7/25.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "LLSilderMenuView.h"

@interface ViewController ()

@property (nonatomic,strong) LLSilderMenuView *helperSideView;
@end

@implementation ViewController{
    CGFloat _screenW;
    CGFloat _screenH;
    UIWindow *keyWindow;
}

static CGFloat const EXTRAAREA = 250.f;

- (void)viewDidLoad {
    [super viewDidLoad];

    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = self.view.frame;
    blurView.alpha = 0.5f;
    [self.view addSubview:blurView];
    
}

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
//    
//    _screenW = [UIScreen mainScreen].bounds.size.width;
//    _screenH = [UIScreen mainScreen].bounds.size.height;
//    keyWindow = [UIApplication sharedApplication].keyWindow;
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_screenW-150, _screenH*0.5, 100, 50)];
//    [button  setTitle:@"Tigger" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:0];
//    [button addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
//    
//    
//    
//   UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
//    blurView.frame = keyWindow.frame;
//    blurView.alpha = 0.0f;
//    [self.view addSubview:blurView];
//    
//    
//    LLSilderMenuView *helperSideView = [LLSilderMenuView new];
//    helperSideView.frame = CGRectMake(-keyWindow.frame.size.width/2-EXTRAAREA, 0, keyWindow.frame.size.width/2+EXTRAAREA, keyWindow.frame.size.height);
//    helperSideView.backgroundColor = [UIColor blueColor];
//    _helperSideView = helperSideView;
//    [keyWindow insertSubview:helperSideView aboveSubview:self.view];
//}


- (void)btnOnClick:(UIButton *)btn{
    
  
    
   [UIView animateWithDuration:0.3 animations:^{
       
        _helperSideView.frame = self.view.bounds;
       
   }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
