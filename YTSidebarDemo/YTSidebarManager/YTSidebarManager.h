//
//  YTSidebarManager.h
//  YTSidebarDemo
//
//  Created by 水晶岛 on 2018/9/13.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^clickBlock)(NSInteger index);

@interface YTSidebarManager : UIPercentDrivenInteractiveTransition

/// 单例方法
+ (instancetype)sharedManager;
/// 设置左滑视图及主视图
- (void)setLeftViewController:(UIViewController *)leftViewController coverViewController:(UIViewController *)coverViewController;
/// 显示左滑视图
- (void)showLeftView;
/// 隐藏左滑视图
- (void)dismissLeft;
@property (nonatomic, strong) clickBlock clickBlock;

@end
