//
//  LLSildeMenuButton.m
//  AnimationDemo2
//
//  Created by 李龙 on 16/8/10.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLSildeMenuButton.h"

@interface LLSildeMenuButton ()

@property (nonatomic,strong) NSString *buttonTitle;

@end

@implementation LLSildeMenuButton


- (instancetype)initWithTitle:(NSString *)title{
    
    self = [super init];
    if (self) {
        self.buttonTitle = title;
    }
    return self;
}




-(void)drawRect:(CGRect)rect{
    
    //创建画笔
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);//一个简便方法,直接添加一个矩形到一个路径
    //+++ 貌似这两句加上没什么好用啊 +++
    [self.buttonColor set];
    CGContextFillPath(ctx);
    //+++                        +++
    
    
    //画矩形轮廓
    UIBezierPath *roundedRectangPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 0.5,0.5) cornerRadius:rect.size.height*0.5];//CGRectInset(rect, 0.5,0.5)
//    [self.buttonColor setFill];
    [roundedRectangPath fill];
    [[UIColor whiteColor] setStroke];
    roundedRectangPath.lineWidth = 1;
    [roundedRectangPath stroke];
    
    //添加文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attr = @{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName:[UIFont systemFontOfSize:24.0f],NSForegroundColorAttributeName:[UIColor whiteColor]};
    CGSize size = [self.buttonTitle sizeWithAttributes:attr];
    
    
    CGRect r = CGRectMake(rect.origin.x,
                          rect.origin.y+(rect.size.height-size.height)*0.5,
                          rect.size.width,
                          size.height);
    
    [self.buttonTitle drawInRect:r withAttributes:attr];
    
}



- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    
    switch (tapCount) {
        case 1:
            self.buttonOnClickBlock();
            break;
            
        default:
            break;
    }
}


@end
