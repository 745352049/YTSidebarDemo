//
//  YTSidebarManager.m
//  YTSidebarDemo
//
//  Created by 水晶岛 on 2018/9/13.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "YTSidebarManager.h"

// 单例对象
static YTSidebarManager *sidebarManager = nil;
// 手势轻扫临界速度
CGFloat const YTLeftSlipCriticalVelocity = 800;
// 左滑手势触发距离
CGFloat const YTLeftSlipLeftSlipPanTriggerWidth = 50;

@interface YTSidebarManager ()<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

/** 用来左滑手势开始判断 */
@property (nonatomic, assign) CGFloat touchBeganX;
/** 是否已经显示左滑视图 */
@property (nonatomic, assign) BOOL showLeft;
/** 点击返回的遮罩view */
@property (nonatomic, strong) UIView *tapView;
/** 是否在交互中 */
@property (nonatomic, assign) BOOL interactive;
/** present or dismiss */
@property (nonatomic, assign) BOOL present;
/** 左滑视图宽度 */
@property (nonatomic, assign) CGFloat leftViewWidth;

@property (nonatomic, strong) UIViewController *leftVC;
@property (nonatomic, weak) UIViewController *coverVC;

@end

@implementation YTSidebarManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToKen;
    dispatch_once(&onceToKen, ^{
        sidebarManager = [[self alloc] init];
        sidebarManager.leftViewWidth = [UIScreen mainScreen].bounds.size.width * 0.8;
    });
    return sidebarManager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sidebarManager = [super allocWithZone:zone];
    });
    return sidebarManager;
}
- (id)copyWithZone:(NSZone *)zone {
    return sidebarManager;
}
- (instancetype)init {
    if (self = [super init]) {
        self.completionCurve = UIViewAnimationCurveLinear;
    }
    return self;
}
- (void)setLeftViewController:(UIViewController *)leftViewController coverViewController:(UIViewController *)coverViewController {
    self.leftVC = leftViewController;
    self.coverVC = coverViewController;
    [self.coverVC.view addSubview:self.tapView];
    // 转场代理
    self.leftVC.transitioningDelegate = self;
    // 侧滑手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.coverVC.view addGestureRecognizer:pan];
}
- (void)showLeftView {
    [self.coverVC presentViewController:self.leftVC animated:YES completion:nil];
}

- (void)dismissLeft {
    [self.leftVC dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 手势处理方法
- (void)pan:(UIPanGestureRecognizer *)pan {
    CGFloat offsetX = [pan translationInView:pan.view].x;
    // X轴速度
    CGFloat velocityX = [pan velocityInView:pan.view].x;
    CGFloat percent;
    if (self.showLeft) {
        // 坑点。千万不要超过1
        percent = MIN(-offsetX / self.leftViewWidth, 1);
    } else {
        percent = MIN(offsetX / self.leftViewWidth, 1);
    }
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.showLeft) {
                self.interactive = YES;
                [self.leftVC dismissViewControllerAnimated:YES completion:nil];
            } else {
                _touchBeganX = [pan locationInView:pan.view].x;
                if (_touchBeganX < YTLeftSlipLeftSlipPanTriggerWidth) {
                    self.interactive = YES;
                    [self.coverVC presentViewController:self.leftVC animated:YES completion:nil];
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self updateInteractiveTransition:percent];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            self.interactive = NO;
            // 判断是否需要转场
            BOOL shouldTransition = NO;
            // 1.present时
            // 1.1 速度正方向，>800，则正向转场
            // 1.2 速度反向时，<-800，则反向转场
            // 1.3 速度正向<800 或者 速度反向>-800， 判断percent是否大于0.5
            if (!self.showLeft) {
                if (velocityX > 0) {
                    if (velocityX > YTLeftSlipCriticalVelocity) {
                        shouldTransition = YES;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                } else {
                    if (velocityX < -YTLeftSlipCriticalVelocity) {
                        shouldTransition = NO;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                }
            } else {
                if (velocityX < 0) {
                    if (velocityX < -YTLeftSlipCriticalVelocity) {
                        shouldTransition = YES;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                } else {
                    if (velocityX > YTLeftSlipCriticalVelocity) {
                        shouldTransition = NO;
                    } else {
                        shouldTransition = percent > 0.5;
                    }
                }
            }
            // 2.dismiss时
            // 2.1 速度正向，<-800，则正向转场
            // 2.2 速度反向，>800，则反向转场
            // 2.3 速度正向>-800 或者 速度反向<800，判断percent是否大于0.5
            if (shouldTransition) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIViewControllerTransitioningDelegate代理方法
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.present = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.present = NO;
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactive ? self : nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return .3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.present) {
        // 基础操作，获取两个VC并把视图加在容器上
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        
        UIView *containerView = [transitionContext containerView];
        toVC.view.frame = CGRectMake(0, 0, self.leftViewWidth, containerView.frame.size.height);
        [containerView addSubview:toVC.view];
        [containerView sendSubviewToBack:toVC.view];
        
        // 动画block
        void(^animateBlock)(void) = ^{
            fromVC.view.frame = CGRectMake(self.leftViewWidth, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
            self.tapView.alpha = 1.f;
        };
        
        // 动画完成block
        void(^completeBlock)(void) = ^{
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                [containerView addSubview:fromVC.view];
                self.showLeft = YES;
            }
        };
        
        // 手势和普通动画做区别
        if (self.interactive) {
            // 呵呵🙃
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
        } else {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
            
        }
    } else {
        UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toVC.view];
        
        // 动画block
        void(^animateBlock)(void) = ^{
            toVC.view.frame = CGRectMake(0, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
            self.tapView.alpha = 0.f;
        };
        
        // 动画完成block
        void(^completeBlock)(void) = ^{
            if ([transitionContext transitionWasCancelled]) {
                [transitionContext completeTransition:NO];
            } else {
                [transitionContext completeTransition:YES];
                self.showLeft = NO;
            }
        };
        
        if (self.interactive) {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
        } else {
            [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
                animateBlock();
            } completion:^(BOOL finished) {
                completeBlock();
            }];
        }
    }
}

#pragma mark - setter/getter方法
- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] initWithFrame:self.coverVC.view.bounds];
        _tapView.backgroundColor = [UIColor colorWithWhite:0 alpha:.2f];
        _tapView.alpha = 0.f;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissLeft)];
        [_tapView addGestureRecognizer:tapGesture];
    }
    return _tapView;
}

@end
