//
//  YTTabBarViewController.m
//  YTSidebarDemo
//
//  Created by 水晶岛 on 2018/9/13.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "YTTabBarViewController.h"
#import "YTNavigationViewController.h"
#import "YTOneViewController.h"
#import "YTTwoViewController.h"
#import "YTThreeViewController.h"
#import "YTSidebarManager.h"
#import "YTLeftViewController.h"
#import "YTLeftPushViewController.h"

@interface YTTabBarViewController ()

@end

@implementation YTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:11];
    NSMutableDictionary *attrs1 = [NSMutableDictionary dictionary];
    attrs1[NSFontAttributeName] = attrs[NSFontAttributeName];
    attrs1[NSForegroundColorAttributeName] = [UIColor redColor];
    // 通过appearence设置tabBatItem的标题颜色,字体
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:attrs1 forState:UIControlStateSelected];
    
    YTOneViewController *one = [[YTOneViewController alloc] init];
    [self addchildControllersWithViewController:one Title:@"我的" image:@"mine-Normal" selectedImage:@"mine-Select"];
    
    YTTwoViewController *two = [[YTTwoViewController alloc] init];
    [self addchildControllersWithViewController:two Title:@"你的" image:@"mine-Normal" selectedImage:@"mine-Select"];
    
    YTThreeViewController *three = [[YTThreeViewController alloc] init];
    [self addchildControllersWithViewController:three Title:@"他的" image:@"mine-Normal" selectedImage:@"mine-Select"];
    
    [[YTSidebarManager sharedManager] setLeftViewController:[YTLeftViewController new] coverViewController:self];
}

/**
 *  添加子控制器
 */
- (void)addchildControllersWithViewController:(UIViewController*)vc Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    YTNavigationViewController *nav =  [[YTNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
