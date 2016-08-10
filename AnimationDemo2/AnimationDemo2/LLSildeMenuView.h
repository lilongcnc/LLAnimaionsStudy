//
//  LLSilderMenuView.h
//  AnimationDemo2
//
//  Created by 李龙 on 16/7/25.
//  Copyright © 2016年 李龙. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^MenuButtonOnClickBlock) (NSInteger index,NSString *title,NSInteger titleCounts);

@interface LLSildeMenuView : UIView

- (instancetype)initWithMenuTitles:(NSArray *)titleArray;

- (void)trigger;

@property (nonatomic,copy) MenuButtonOnClickBlock menuOnClickBlock;

@end
