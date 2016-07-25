//
//  CircleView.m
//  AnimationDemo1
//
//  Created by 李龙 on 16/7/19.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLCircleView.h"

@implementation LLCircleView

+ (Class)layerClass{
    return [CircleLayer class];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.circleLayer = [CircleLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width*1, frame.size.height*1);
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
//        self.circleLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
        
        /* Add 'layer' to the end of the receiver's sublayers array. If 'layer'
         * already has a superlayer, it will be removed before being added. */
        [self.layer addSublayer:self.circleLayer];
        
    }
    return self;
}

@end
