//
//  ViewController.m
//  LLPinTransitionDemo
//
//  Created by 李龙 on 16/8/17.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIViewControllerTransitioningDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //logo mask 添加一个遮罩,图片透明和不透明的地方反转
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
//
//    maskLayer.path
//    functionWithName:kCAMediaTimingFunctionEaseInEaseOut

    CALayer *maskLayer = [CAShapeLayer layer];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
