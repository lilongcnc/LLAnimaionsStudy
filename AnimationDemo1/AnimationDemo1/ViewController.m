//
//  ViewController.m
//  AnimationDemo1
//
//  Created by 李龙 on 16/7/18.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"


@interface ViewController ()
@property (nonatomic,assign) CGPoint movePoint;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic,assign) CGRect outsideRect;
@end

@implementation ViewController{
    CGPoint POINT_B;
    CGPoint POINT_D;
    
    CGFloat progress;
    
    CGFloat outsideRectSize; //外接矩形边长
}

- (IBAction)progressTouched:(UISlider *)sender {
    
    //UISlider
    progress = sender.value;
    
    if (progress < 0.5) {
        self.movePoint = POINT_B;
        NSLog(@"B点动");
    }else{
        
        self.movePoint = POINT_D;
        NSLog(@"D点动");
    }
    
    
    
    outsideRectSize = self.view.width;
    
    CGFloat origin_x = self.backView.x - outsideRectSize*0.5 + (progress-0.5)*(self.view.frame.size.width - outsideRectSize);
    CGFloat origin_y = self.backView.y - outsideRectSize*0.5;
    
    self.outsideRect = CGRectMake(origin_x, origin_y, outsideRectSize, outsideRectSize);
    
    
    
}

- (void)drawInContext:(CGContextRef)ctx{
    
    //A-C1,C2-B,B-C3......c8-A的长度
    CGFloat offset = self.outsideRect.size.width/3.6; //3.6是一个自定义的固定值,使得画出来的圆更接近圆弧
    
    CGFloat movedDistance = (self.outsideRect.size.width*1/6) * fabs(progress-0.5)*2;//1/6也是是一个自定义的固定值,接近1/2时候,A点越靠近中点
    
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x+self.outsideRect.size.width/2, self.outsideRect.origin.y+self.outsideRect.size.height/2);
    
    CGPoint pointA = CGPointMake(rectCenter.x, self.outsideRect.origin.y+movedDistance);
//    CGPoint pointB = cg
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
