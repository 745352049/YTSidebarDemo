//
//  YTNavigationViewController.m
//  YTSidebarDemo
//
//  Created by 水晶岛 on 2018/9/13.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "YTNavigationViewController.h"
#import "YTLeftPushViewController.h"
#import "YTSidebarManager.h"

@interface YTNavigationViewController ()

@end

@implementation YTNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [YTSidebarManager sharedManager].clickBlock = ^(NSInteger index) {
        [[YTSidebarManager sharedManager] dismissLeft];
        NSLog(@"%ld", (long)index);
        NSUInteger selectedIndex = self.tabBarController.selectedIndex;
        NSLog(@"%ld", (long)selectedIndex);
        // 拿到tabbar的当前分栏的NavigationController
        UINavigationController *selectedNav = [self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
        YTLeftPushViewController *leftPushVC = [[YTLeftPushViewController alloc] init];
        [selectedNav pushViewController:leftPushVC animated:YES];
    };
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
