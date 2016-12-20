//
//  RegisterVC.m
//  TreasureCollect
//
//  Created by 杨鹏 on 2016/12/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "RegisterVC.h"

@interface RegisterVC ()

@end

@implementation RegisterVC


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Daohang];//导航栏设置
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self Daohang];//导航栏设置
    [self initSubViews];//主要内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)Daohang
{
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.hidden = NO;
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回-灰"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}


//内容加载
- (void)initSubViews
{
    
}

//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
