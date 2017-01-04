//
//  HRLivePlayer.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/16.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "HRLivePlayer.h"

@interface HRLivePlayer ()

@end

@implementation HRLivePlayer

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Daohang];//导航栏设置
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self Daohang];//导航栏设置
    [self initSubViews];//主要内容
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏设置
- (void)Daohang
{
    self.title = @"直播大厅";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    //左侧返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    [leftBtn addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}


//主要内容
- (void)initSubViews
{
    //直播大厅头图片展示
    UIImageView *titleImage = [[UIImageView alloc] init];
    titleImage.image = [UIImage imageNamed:@"banner_Live"];
    titleImage.userInteractionEnabled = YES;
    [self.view addSubview:titleImage];
    
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.right.equalTo(self.view).offset(0);
        make.height.mas_offset(@120);
    }];
    
    //图片上添加响应手势
    UITapGestureRecognizer  *titleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetTapClicked:)];
    [titleImage addGestureRecognizer:titleTap];
}


/*
 @功能：头图片首饰响应方法
 @参数：当前手势
 @返回值：无
 */
- (void)forgetTapClicked:(UITapGestureRecognizer*) tapGesture
{
    NSLogTC(@"图片点击了");
}



@end
