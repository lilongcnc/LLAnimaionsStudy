//
//  LLSilderMenuView.m
//  AnimationDemo2
//
//  Created by 李龙 on 16/7/25.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import "LLSilderMenuView.h"


static CGFloat const EXTRAAREA = 250.f;


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
        
        //_keyWindow = [UIApplication sharedApplication].keyWindow;
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        
        _blurView = ({
            UIVisualEffectView *visual = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:style]];
            visual.frame = _keyWindow.frame;
            visual.alpha = 0.0f;
            visual;
        });
        
        _helperSideView = ({
            UIView *sideView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
            sideView.backgroundColor = [UIColor redColor];
            [_keyWindow addSubview:sideView];
            sideView;
        });
        
        
        _helperCenterView = ({
            UIView *centerView = [[UIView alloc] initWithFrame:(CGRect){40,CGRectGetHeight(_keyWindow.frame)*0.5-20,40,40}];
            centerView.backgroundColor = [UIColor yellowColor];
            [_keyWindow addSubview:centerView];
            centerView;
        });
        
        
        self.frame = CGRectMake(-_keyWindow.frame.size.width/2 - EXTRAAREA, 0, _keyWindow.frame.size.width/2+EXTRAAREA, _keyWindow.frame.size.height);
//        self.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor redColor];
        [_keyWindow insertSubview:self belowSubview:_helperCenterView];
        
        
        _menuColor = menuColor;
        self.menuButtonHeight = height;
    }
    
    return self;
}


- (void)trigger{
    [_keyWindow insertSubview:_blurView belowSubview:self];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = self.bounds;
    }];
    
    
    
}


- (void)drawRect:(CGRect)rect {
}

@end

