//
//  nickNameVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/15.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "nickNameVC.h"

@interface nickNameVC ()

@end

@implementation nickNameVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self DaoHang];//设置导航栏
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self DaoHang];//设置导航栏
    [self initSubView];//主页面显示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//导航栏
- (void)DaoHang
{
    self.title = @"修改昵称";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
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

//主页面显示
- (void)initSubView
{
    //添加一个UITextFile输入框
    self.nickName = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nickName.borderStyle = UITextBorderStyleRoundedRect;
    self.nickName.placeholder = @"昵称";
    self.nickName.font = [UIFont fontWithName:@"Arial" size:18];
    self.nickName.textColor = [UIColor blackColor];
    self.nickName.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nickName.text = @"大象1231231231";
    self.nickName.textAlignment = NSTextAlignmentLeft;
    self.nickName.delegate = self;
    self.nickName.backgroundColor = [UIColor clearColor];
    self.nickName.layer.cornerRadius = 3.0;
    [self.view addSubview:self.nickName];
    
    [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(30);
    }];
    
    //添加一个确认修改的按钮
    UIButton *yesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yesBtn.frame = CGRectZero;
    yesBtn.backgroundColor = [UIColor colorFromHexRGB:@"2887ee"];
    [yesBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [yesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    yesBtn.layer.cornerRadius = 3.0;
    [yesBtn addTarget:self action:@selector(yesBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yesBtn];
    
    [yesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(60);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(40);
    }];
    
}

//确认修改响应事件
- (void)yesBtnClicked
{
    NSLogTC(@"确认修改昵称");
}

@end
