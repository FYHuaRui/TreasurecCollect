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
    //手机号的输入框
    UIImageView *phoneImage = [[UIImageView alloc] initWithFrame:CGRectZero];//CGRectMake(10, 60, self.view.frame.size.width-20, 40)];
    phoneImage.image = [UIImage imageNamed:@"手机号码"];
    [self.view addSubview:phoneImage];
    
    //图形验证码输入框
    UIImageView *pictureImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    pictureImage.image = [UIImage imageNamed:@"图形验证码"];
    [self.view addSubview:pictureImage];
    
    //图形验证码图片
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    imageBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:imageBtn];
    
    //短信验证码输入框
    UIImageView *messageImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    messageImage.image = [UIImage imageNamed:@"短信验证"];
    [self.view addSubview:messageImage];
    
    //获取验证码的按钮
    UIButton *yzmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yzmBtn.frame = CGRectZero;
    [yzmBtn setBackgroundImage:[UIImage imageNamed:@"图形验证码"] forState:UIControlStateNormal];
    [self.view addSubview:yzmBtn];
    
    //注册按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectZero;
    nextBtn.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    [self.view addSubview:nextBtn];
    
    //各控件布局约束
    [phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.mas_equalTo(40);
    }];
    
    [pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneImage).offset(20);
        make.left.equalTo(self.view).offset(25);
//        make.centerX.mas_equalTo(self.view.mas_centerX+40);
    }];
}

//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
