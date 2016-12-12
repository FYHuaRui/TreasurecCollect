//
//  LeftMainController.m
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LeftMainController.h"

@interface LeftMainController ()

@end

@implementation LeftMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self DaoHang];//导航栏设置
    [self initSubViews];//显示项目

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
 @功能:导航栏设置
 @参数:无
 @返回值
 */
- (void)DaoHang
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


/*
 @功能:显示项目
 @参数:无
 @返回值
 */
- (void)initSubViews
{
    NSLogTC(@"左侧界面");
}

@end
