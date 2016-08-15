

//
//  LLPaoPaoView.m
//  QQMessagePaoPao
//
//  Created by 李龙 on 16/8/15.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLPaoPaoView.h"

@implementation LLPaoPaoView{
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    
    CGPoint pointA;
    CGPoint pointB;
    CGPoint pointC;
    CGPoint pointD;
    CGPoint pointO;
    CGPoint pointP;
    
    CGPoint initialPoint;
    
    
    CGFloat r1;
    CGFloat r2;
    
    CGFloat centerDistance;
    CGFloat cosDigree; //con值
    CGFloat sinDigree; //sin值
    
    CGRect origionBackViewFrame;
    CGPoint origionBackViewCenter;
    
    
    CAShapeLayer *shapeLayer; //?????
    UIColor *fillColorForCute;
    UIBezierPath *cutePath;
    UIView *backView;
}



- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)view{
    self = [self initWithFrame:(CGRect){point.x,point.y,self.bubbleWidth,self.bubbleWidth}];
    if (self) {
        initialPoint = point;
        self.containerView = view;
        [self.containerView addSubview:self];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}


- (void)initSubView{
    shapeLayer = [CAShapeLayer layer];
    self.backgroundColor = [UIColor redColor];
    self.frontView = [[UIView alloc] initWithFrame:(CGRect){initialPoint.x,initialPoint.y,self.bubbleWidth,self.bubbleWidth}];
    
    //被拖拽的view
    r2 = self.frontView.bounds.size.width / 2;
    self.frontView.layer.cornerRadius = r2;
    self.frontView.backgroundColor = self.bubbleColor;
    
    //底部固定的View
    backView = [[UIView alloc] initWithFrame:self.frontView.frame];
    r1 = backView.frame.size.width / 2;
    backView.layer.cornerRadius = r1;
    backView.backgroundColor = self.bubbleColor;
    
    //数字文字
    self.bubbleLabel = [[UILabel alloc] init];
    self.bubbleLabel.frame = CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height);
    self.bubbleLabel.textColor = [UIColor whiteColor];
    self.bubbleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.frontView insertSubview:self.bubbleLabel atIndex:0];
    
    [self.containerView addSubview:backView];
    [self.containerView addSubview:self.frontView];
    
    
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2= self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    pointA = CGPointMake(x1 - r1, y1);
    pointB = CGPointMake(x1 + r1, y1);
    pointC = CGPointMake(x2 - r2, y2);
    pointD = CGPointMake(x2 + r2, y2);
    pointO = CGPointMake(x1 - r1, y1);
    pointP = CGPointMake(x2 + r2, y2);
    
    
    origionBackViewFrame = backView.frame;
    origionBackViewCenter = backView.center;
    
    backView.hidden = YES; //为了看到frontView的气泡晃动效果,需要展示隐藏backView
//    []//气泡晃动
    
    //增加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDragGesture:)];
    [self.frontView addGestureRecognizer:pan];
    
}

- (void)handleDragGesture:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self.containerView];
    
    if (ges.state == UIGestureRecognizerStateBegan){
        backView.hidden = NO;
        fillColorForCute = self.bubbleColor;
        
    }else if(ges.state == UIGestureRecognizerStateChanged){
        self.frontView.center = dragPoint;
        
        
        if (r1 <=6 ) {//这个是为了?????
            fillColorForCute = [UIColor clearColor];
            backView.hidden = YES;
            [shapeLayer removeFromSuperlayer];//????????????
        }
        
        [self displayLinkAction];
    }
    
}

- (void)displayLinkAction{
    
    //动态计算拖拽过程中的各个点的坐标
    x1 = backView.center.x;
    y1 = backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    centerDistance = sqrtf((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
    if (centerDistance == 0) {
        cosDigree = 1;
        sinDigree = 0;
    }else{
        cosDigree = (y2-y1)/centerDistance;
        sinDigree = (x2-x1)/centerDistance;
    }
    
    r1 = origionBackViewFrame.size.width / 2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);  // A
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree); // B
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree); // D
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);// C
    pointO = CGPointMake(pointA.x + (centerDistance / 2)*sinDigree, pointA.y + (centerDistance / 2)*cosDigree);
    pointP = CGPointMake(pointB.x + (centerDistance / 2)*sinDigree, pointB.y + (centerDistance / 2)*cosDigree);
    
    //重新绘制拖拽图形
     [self drawRect];
}

- (void)drawRect{
    //原来的底边图形
    backView.center = origionBackViewCenter;
    backView.bounds = CGRectMake(0, 0, r1*2, r1*2);
    backView.layer.cornerRadius = r1;
    
    //拖拽的曲线
    cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    if (backView.hidden == NO) {
        //???????
        shapeLayer.path = [cutePath CGPath];
        shapeLayer.fillColor = [fillColorForCute CGColor];
        [self.containerView.layer insertSublayer:shapeLayer below:self.frontView.layer];
        
    }
}



@end
