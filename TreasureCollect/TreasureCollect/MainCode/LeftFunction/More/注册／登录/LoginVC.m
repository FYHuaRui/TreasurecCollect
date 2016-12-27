//
//  LoginVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

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


- (void)Daohang
{
    self.title = @"登录";
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
    //密码登录／短信验证登录
    UIButton *password = [UIButton buttonWithType:UIButtonTypeCustom];
    password.tag = 1001;
    [password setTitle:@"密码登录" forState:UIControlStateNormal];
    [password setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    password.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    [password addTarget:self action:@selector(passwordClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:password];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.tag = 1002;
    [messageBtn setTitle:@"短信登录" forState:UIControlStateNormal];
    [messageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    messageBtn.backgroundColor = [UIColor whiteColor];
    [messageBtn addTarget:self action:@selector(messageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBtn];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(messageBtn.mas_left).with.offset(0);
        make.height.mas_equalTo(@40);
        make.width.equalTo(messageBtn);
    }];
    
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(password.mas_right).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(-1);
        make.height.mas_equalTo(@40);
        make.width.equalTo(password);
    }];
    
    
    
}

//密码登录
- (void)passwordClicked
{
    UIButton *button = [self.view viewWithTag:1002];
    
}

//短信登录
- (void)messageBtnClicked
{
    
}



//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}


@end
