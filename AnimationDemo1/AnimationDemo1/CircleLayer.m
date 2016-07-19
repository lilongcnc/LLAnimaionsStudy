//
//  CircleLayer.m
//  AnimationDemo1
//
//  Created by 李龙 on 16/7/19.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>

typedef enum MovingPoint {
    POINT_D,
    POINT_B,
} MovingPoint;

#define outsideRectSize 90




@interface CircleLayer ()
/**
 *  外接矩形
 */
@property (nonatomic,assign) CGRect outsideRect;

/**
 *  记录上次的progress，方便做差得出滑动方向
 */
@property(nonatomic,assign) CGFloat lastProgress;


/**
 *  实时记录滑动方向
 */
@property(nonatomic,assign) MovingPoint movePoint;


@end

@implementation CircleLayer

-(instancetype)init{
    self = [super init];
    
    if (self) {
        self.lastProgress = 0.5;
    }
    return self;
}


-(instancetype)initWithLayer:(CircleLayer *)layer{
    self = [super initWithLayer:layer];
    
    if (self) {
        self.progress = layer.progress;
        self.outsideRect = layer.outsideRect;
        self.lastProgress = layer.lastProgress;
        
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    
    //只要外接矩形在左侧，则改变B点；在右边，改变D点
    if (progress < 0.5) {
        //左滑
        self.movePoint = POINT_B;
        NSLog(@"B点动");
    }else{
        //右滑
        self.movePoint = POINT_D;
        NSLog(@"D点动");
    }
    
    self.lastProgress = progress;
    
    CGFloat origin_x = self.position.x - outsideRectSize*0.5 + (progress-0.5)*(self.frame.size.width - outsideRectSize);
    CGFloat origin_y = self.position.y - outsideRectSize*0.5;
    
    self.outsideRect = CGRectMake(origin_x, origin_y, outsideRectSize, outsideRectSize);

    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx{
    
    //A-C1,C2-B,B-C3......c8-A的长度,是一个固定值
    CGFloat offset = self.outsideRect.size.width/3.6; //3.6是一个数学家计算出来的近似约等之后的固定值,使得画出来的圆更接近圆弧
    
    //根据手势progress,计算出的ABCD点移动距离, 系数是: fabs(progress-0.5)*2,
    //Y=KX+B
    //0 <= movedDistance <= 外接矩形宽度*1/6
    CGFloat movedDistance = (self.outsideRect.size.width*1/6) * fabs(self.progress-0.5)*2;//1/6也是是一个自定义的固定值,接近1/2时候,A点越靠近中点
    
    //外接矩形的中心点
    CGPoint rectCenter = CGPointMake(self.outsideRect.origin.x+self.outsideRect.size.width/2, self.outsideRect.origin.y+self.outsideRect.size.height/2);
    
    //*2 是为了让D点在移动的时候移动距离区别于A点,也可以自定义*3,*6但是这样移动的太大了
    CGPoint pointA = CGPointMake(rectCenter.x, self.outsideRect.origin.y+movedDistance);
    CGPoint pointB = CGPointMake(self.movePoint == POINT_D ? rectCenter.x+self.outsideRect.size.width/2 : rectCenter.x+self.outsideRect.size.width/2 + movedDistance, rectCenter.y);
    CGPoint pointC = CGPointMake(rectCenter.x, rectCenter.y+self.outsideRect.size.height/2 - movedDistance);
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D ? self.outsideRect.origin.x - movedDistance*2 : self.outsideRect.origin.x, rectCenter.y);
    
    //根据A,B,C,D点和offset来确定c1,c2....c8等坐标
    CGPoint c1 = CGPointMake(pointA.x+offset, pointA.y);
    CGPoint c2 = CGPointMake(pointB.x, self.movePoint == POINT_D ? pointB.y-offset: pointB.y - offset + movedDistance);
    CGPoint c3 = CGPointMake(pointB.x, self.movePoint == POINT_D ? pointB.y+offset : pointB.y+offset - movedDistance);
    CGPoint c4 = CGPointMake(pointC.x + offset, pointC.y);
    CGPoint c5 = CGPointMake(pointC.x-offset, pointC.y);
    CGPoint c6 = CGPointMake(pointD.x, self.movePoint == POINT_D ? pointD.y+offset-movedDistance : pointD.y+offset);
    CGPoint c7 = CGPointMake(pointD.x, self.movePoint == POINT_D ? pointD.y - offset+movedDistance : pointD.y- offset);
    CGPoint c8 = CGPointMake(pointA.x-offset, pointA.y);
    
    //圆的边界(画圆)
    UIBezierPath *ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:c1 controlPoint2:c2];
    [ovalPath addCurveToPoint:pointC controlPoint1:c3 controlPoint2:c4];
    [ovalPath addCurveToPoint:pointD controlPoint1:c5 controlPoint2:c6];
    [ovalPath addCurveToPoint:pointA controlPoint1:c7 controlPoint2:c8];
    [ovalPath closePath];
    
    //外接虚线矩形
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.outsideRect];
    CGContextAddPath(ctx, rectPath.CGPath); //????
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(ctx, 1.0);
    CGFloat dash[] = {5.0,5.0};
    CGContextSetLineDash(ctx, 0.0, dash, 2); // 每个虚线的长度
    
    CGContextStrokePath(ctx); //给线条填充颜色
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineDash(ctx, 0, NULL, 0); //2
    CGContextDrawPath(ctx, kCGPathFillStroke); //同时给线条和线条保卫的内部区域填充颜色
    
    
    //-------------- 注意: 以下所有代码全是为了辅助观察 ------
    //标记出每个点,然后连线.方便观察,同时给所有的关键点染成白色,把辅助线的颜色染成白色
    CGContextSetFillColorWithColor(ctx, [UIColor yellowColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    NSArray *points = @[
                        [NSValue valueWithCGPoint:pointA],
                        [NSValue valueWithCGPoint:pointB],
                        [NSValue valueWithCGPoint:pointC],
                        [NSValue valueWithCGPoint:pointD],
                        [NSValue valueWithCGPoint:c1],
                        [NSValue valueWithCGPoint:c2],
                        [NSValue valueWithCGPoint:c3],
                        [NSValue valueWithCGPoint:c4],
                        [NSValue valueWithCGPoint:c5],
                        [NSValue valueWithCGPoint:c6],
                        [NSValue valueWithCGPoint:c7],
                        [NSValue valueWithCGPoint:c8],
                        ];
    [self drawPoint:points withContext:ctx];
    
    
    //链接辅助线
    UIBezierPath *helperline = [UIBezierPath bezierPath];
    [helperline moveToPoint:pointA];
    [helperline addLineToPoint:c1];
    [helperline addLineToPoint:c2];
    [helperline addLineToPoint:pointB];
    [helperline addLineToPoint:c3];
    [helperline addLineToPoint:c4];
    [helperline addLineToPoint:pointC];
    [helperline addLineToPoint:c5];
    [helperline addLineToPoint:c6];
    [helperline addLineToPoint:pointD];
    [helperline addLineToPoint:c7];
    [helperline addLineToPoint:c8];
    [helperline closePath];
    
    CGContextAddPath(ctx, helperline.CGPath);
    
    CGFloat dash2[] = {2.0,2.0};
    CGContextSetLineDash(ctx, 0.0, dash2, 2);
    CGContextStrokePath(ctx);//给辅助线条填充颜色
}



//一个提取出来的花店的饿方法: 在point位置画一个点,方便观察运动情况
- (void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx{
    
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        CGContextFillRect(ctx, CGRectMake(point.x - 2, point.y-2, 4, 4));
    }
}


@end
