//
//  YTOneViewController.m
//  YTSidebarDemo
//
//  Created by 水晶岛 on 2018/9/13.
//  Copyright © 2018年 水晶岛. All rights reserved.
//

#import "YTOneViewController.h"

#import "YTSidebarManager.h"

@interface YTOneViewController ()

@end

@implementation YTOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的";
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 200, 100, 40);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
- (void)action {
    [[YTSidebarManager sharedManager] showLeftView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
