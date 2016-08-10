//
//  LLSildeMenuButton.h
//  AnimationDemo2
//
//  Created by 李龙 on 16/8/10.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLSildeMenuButton : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic,strong) UIColor *buttonColor;

@property (nonatomic,copy) void(^buttonOnClickBlock)();


@end
