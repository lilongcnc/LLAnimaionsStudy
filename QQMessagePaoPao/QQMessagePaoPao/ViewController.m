//
//  ViewController.m
//  QQMessagePaoPao
//
//  Created by 李龙 on 16/8/15.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "LLPaoPaoView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LLPaoPaoView *cuteView = [[LLPaoPaoView alloc]initWithPoint:CGPointMake(25, [UIScreen mainScreen].bounds.size.height - 65) superView:self.view];
    cuteView.viscosity  = 20;
    cuteView.bubbleWidth = 30;
    cuteView.bubbleColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
    //    cuteView.backgroundColor = [UIColor greenColor];
    [cuteView initSubView];
    
    //注意：设置 'bubbleLabel.text' 一定要放在 '-setUp' 方法之后
    //Tips:When you set the 'bubbleLabel.text',you must set it after '-setUp'
    cuteView.bubbleLabel.text = @"1111111113";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
