//
//  ViewController.m
//  AnimationDemo1
//
//  Created by 李龙 on 16/7/18.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "LLCircleView.h"

@interface ViewController ()

@property (nonatomic,strong) LLCircleView *cv;
@property (weak, nonatomic) IBOutlet UILabel *showNumberLabel;

@end

@implementation ViewController

- (IBAction)progressTouched:(UISlider *)sender {
    
    //UISlider
    CGFloat progress = sender.value;
    
    self.showNumberLabel.text = [NSString stringWithFormat:@"Current:  %f",progress];
    
    //首次进去
    self.cv.circleLayer.progress = progress;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cv = [[LLCircleView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-320/2, self.view.frame.size.height/2-320/2, 320, 320)];
    self.cv.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.cv];

    //首次进入
    self.cv.circleLayer.progress = 0.5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
