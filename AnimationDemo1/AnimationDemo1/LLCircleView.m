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
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
    }
    return self;
}

@end
