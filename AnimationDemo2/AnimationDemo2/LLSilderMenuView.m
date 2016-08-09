//
//  LLSilderMenuView.m
//  AnimationDemo2
//
//  Created by 李龙 on 16/7/25.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLSilderMenuView.h"


static CGFloat const EXTRAAREA = 50.f;
static const CGFloat EXTRAAREA2 = 50.f;



@interface LLSilderMenuView ()

@property (nonatomic,strong) UIVisualEffectView *blurView;
@property (nonatomic,strong) UIView *helperSideView;
@property (nonatomic,strong) UIView *helperCenterView;
@property (nonatomic,assign) CGFloat menuButtonHeight;
@end

@implementation LLSilderMenuView{
    UIWindow *_keyWindow;
    UIColor *_menuColor;
}


- (instancetype)initWithMenuTitles:(NSArray *)titleArray{
    return [self initWithTitle:titleArray withButtonsheight:40 withMenuColor:[UIColor cyanColor] withBackBlurStyle:UIBlurEffectStyleDark];
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
            [_keyWindow addSubview:sideView];
            sideView;
        });
        
        
        _helperCenterView = ({
            UIView *centerView = [[UIView alloc] initWithFrame:(CGRect){-40,CGRectGetHeight(_keyWindow.frame)*0.5-20,40,40}];
            centerView.backgroundColor = [UIColor yellowColor];
            [_keyWindow addSubview:centerView];
            centerView;
        });
        
        
        self.frame = CGRectMake(-_keyWindow.frame.size.width/2 - EXTRAAREA, 0, _keyWindow.frame.size.width/2+EXTRAAREA, _keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor redColor];
        [_keyWindow insertSubview:self belowSubview:_helperSideView];
        
        
        _menuColor = menuColor;
        self.menuButtonHeight = height;
    }
    
    return self;
}


#pragma mark ================ 弹出视图 ================
- (void)trigger{
    
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
        _blurView.alpha = 0.6f;
    }];
    
    //第二个辅助视图
    [UIView animateWithDuration:0.7f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
        
        _helperCenterView.center = _keyWindow.center;
        
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUntrigger:)];
        [_blurView addGestureRecognizer:tapGes];

    }];
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
    
    
    
    
}





- (void)drawRect:(CGRect)rect {
}

@end

