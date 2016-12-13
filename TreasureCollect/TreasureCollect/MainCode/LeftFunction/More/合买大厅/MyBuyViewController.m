//
//  MyBuyViewController.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MyBuyViewController.h"

@interface MyBuyViewController ()

@end

@implementation MyBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self Daohang];//导航栏设置
    [self initSubViews];//主要内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏设置
- (void)Daohang
{
    self.title = @"我的合买";
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


//主要内容
- (void)initSubViews
{
    //显示现货产品价格
    
}


//返回按钮响应事件
- (void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
