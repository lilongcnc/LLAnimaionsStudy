//
//  LLSilderMenuView.m
//  AnimationDemo2
//
//  Created by 李龙 on 16/7/25.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLSildeMenuView.h"
#import "LLSildeMenuButton.h"


static CGFloat const EXTRAAREA = 50.f;
static CGFloat const SPACE = 30.f;



@interface LLSildeMenuView ()

@property (nonatomic,strong) UIVisualEffectView *blurView;
@property (nonatomic,strong) UIView *helperSideView;
@property (nonatomic,strong) UIView *helperCenterView;
@property (nonatomic,assign) CGFloat menuButtonHeight;

@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic,assign) int animationCount;
@end

@implementation LLSildeMenuView{
    UIWindow *_keyWindow;
    UIColor *_menuColor;
    CGFloat diff; //控制器的位移
    BOOL triggered;
}


- (instancetype)initWithMenuTitles:(NSArray *)titleArray{
    return [self initWithTitle:titleArray withButtonsheight:40 withMenuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] withBackBlurStyle:UIBlurEffectStyleDark];
}


- (instancetype)initWithTitle:(NSArray *)titles withButtonsheight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style{
    self = [super init];
    
    if (self) {
        
        _keyWindow = [UIApplication sharedApplication].keyWindow;
        
        _blurView = ({
            UIVisualEffectView *visual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
            visual.frame = _keyWindow.frame;
            visual.alpha = 0.0f;
            visual;
        });
        
        
        _helperSideView = ({
            UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, 40, 40)];
            sideView.backgroundColor = [UIColor greenColor];
            sideView.hidden = YES;
            [_keyWindow addSubview:sideView];
            sideView;
        });
        
        
        _helperCenterView = ({
            UIView *centerView = [[UIView alloc] initWithFrame:(CGRect){-40,CGRectGetHeight(_keyWindow.frame)*0.5-20,40,40}];
            centerView.backgroundColor = [UIColor yellowColor];
            centerView.hidden = YES;
            [_keyWindow addSubview:centerView];
            centerView;
        });
        
        
        self.frame = CGRectMake(-_keyWindow.frame.size.width/2 - EXTRAAREA, 0, _keyWindow.frame.size.width/2+EXTRAAREA, _keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor redColor];
        [_keyWindow insertSubview:self belowSubview:_helperSideView];
        
        
        _menuColor = menuColor;
        self.menuButtonHeight = height;
        
        
        
        //添加菜单按钮
        [self addButtons:titles];
    }
    
    return self;
}


#pragma mark ================ 弹出视图 ================
- (void)trigger{
    
    if (!triggered) {
        [_keyWindow insertSubview:_blurView belowSubview:self];
        
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = self.bounds;
        }];
        
        //第一个辅助视图
        [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _helperSideView.center = CGPointMake(_keyWindow.center.x, _helperSideView.frame.size.height*0.5);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        //蒙版视图
        [UIView animateWithDuration:0.3f animations:^{
            _blurView.alpha = 0.8f;
        }];
        
        //第二个辅助视图
        [self beforeAnimation];
        [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            
            _helperCenterView.center = _keyWindow.center;
            
        } completion:^(BOOL finished) {
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUntrigger:)];
            [_blurView addGestureRecognizer:tapGes];
            [self finishAnimation];
        }];
        
        //按钮动画
       [self animateButtons];
      
        triggered = YES;
        
    }else{
        [self tapToUntrigger:nil];
    }
}

#pragma mark ================ 返回视图 ================
- (void)tapToUntrigger:(UITapGestureRecognizer *)tapGes{
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = CGRectMake(-_keyWindow.frame.size.width/2 - EXTRAAREA, 0, _keyWindow.frame.size.width/2+EXTRAAREA, _keyWindow.frame.size.height);
    }];
    
    [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options: UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        _helperSideView.center = (CGPoint){-40, 0};
                                           
     } completion:^(BOOL finished) {
        
         
     }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _blurView.alpha = 0.0f;
    }];
    
    
    [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        _helperCenterView.center = (CGPoint){-40,CGRectGetHeight(_keyWindow.frame)*0.5-20};
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    triggered = NO;
    
}


#pragma mark ================ CADisplayer定时器 ================
- (void)beforeAnimation{
    if (!self.displayLink) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount++;
}

- (void)finishAnimation{
    self.animationCount--;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

//计算diff
- (void)displayLinkAction:(CADisplayLink *)dis{
    
    //获取到动态变化时候的 helperSideView & helperCenterView 的frame变化(原文中提到:“我在 后面 提到了 Presentation Layer 的作用 —— 即可以实时获取 Layer 属性的当前值”)
    CALayer *sideHelperPresentationLayer = (CALayer *)[_helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer = (CALayer *)[_helperCenterView.layer presentationLayer];
    
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"] CGRectValue];
    
    
    diff = sideRect.origin.x - centerRect.origin.x;
    
    [self setNeedsDisplay];//（ 这个方法会触发 UIView 的 drawRect  或 CALayer 的 drawRectInContext ）”
}


//绘制菜单动态矩形区域
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //点A
    [path moveToPoint:CGPointMake(0,0)];
    //点B
    [path addLineToPoint:(CGPoint){_keyWindow.frame.size.width*0.5,0}];
    //点C(BC段)
    [path addQuadCurveToPoint:(CGPoint){_keyWindow.frame.size.width*0.5,_keyWindow.frame.size.height} controlPoint:(CGPoint){_keyWindow.frame.size.width*0.5+diff,_keyWindow.frame.size.height*0.5}];
    //点D
    [path addLineToPoint:(CGPoint){0,_keyWindow.frame.size.height}];
    [path closePath];
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddPath(ctx, path.CGPath);
    [_menuColor set];
    CGContextFillPath(ctx);
}





#pragma mark ================ 按钮部分 ================
-(void)animateButtons{
    
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        UIView *menuButton = self.subviews[i];
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            
            menuButton.transform =  CGAffineTransformIdentity;//设置量进行还原
            
        } completion:NULL];
    }
}


- (void)addButtons:(NSArray *)titleArry{
    
    if (titleArry.count %2 == 0) {
        NSInteger index_down = titleArry.count/2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i<titleArry.count; i++) {
            
            NSString *title = titleArry[i];
            LLSildeMenuButton *home_button = [[LLSildeMenuButton alloc] initWithTitle:title];
            
            
            // 从中间向向下两边依次添加按钮
            if (i >= titleArry.count / 2) {
                
                index_up ++;
                home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 + self.menuButtonHeight*index_up + SPACE*index_up + SPACE/2 + self.menuButtonHeight/2);
            }else{
                
                index_down --;
                home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - self.menuButtonHeight*index_down - SPACE*index_down - SPACE/2 - self.menuButtonHeight/2);
            }
            
            home_button.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, self.menuButtonHeight);
            home_button.buttonColor = _menuColor;
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            
            home_button.buttonOnClickBlock = ^(){
                
                [WeakSelf tapToUntrigger:nil];
                WeakSelf.menuOnClickBlock(i,title,titleArry.count);
            };
            
            
        }
        
    }else{
        
        NSInteger index = (titleArry.count - 1) /2 +1;
        for (NSInteger i = 0; i < titleArry.count; i++) {
            
            index --;
            NSString *title = titleArry[i];
            LLSildeMenuButton *home_button = [[LLSildeMenuButton alloc] initWithTitle:title];
            home_button.center = CGPointMake(_keyWindow.frame.size.width/4, _keyWindow.frame.size.height/2 - self.menuButtonHeight*index - 20*index);
            home_button.bounds = CGRectMake(0, 0, _keyWindow.frame.size.width/2 - 20*2, self.menuButtonHeight);
            home_button.buttonColor = _menuColor;
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            home_button.buttonOnClickBlock = ^(){
                
                [WeakSelf tapToUntrigger:nil];
                WeakSelf.menuOnClickBlock(i,title,titleArry.count);
            };
            
        }
    }
    
    
}

@end

