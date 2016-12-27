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

//第一次页面加载进行验证码请求的regID
static int regID = 0;

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
    
    //默认密码登录
    //手机号的输入框
    UIImageView *phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 60, self.view.frame.size.width-50, 40)];
    phoneImage.image = [UIImage imageNamed:@"icon_iphon"];
    phoneImage.userInteractionEnabled = YES;
    [self.view addSubview:phoneImage];
    
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, phoneImage.frame.size.width-50, 30)];
    self.phoneField.placeholder = @"请输入手机号";
    self.phoneField.font = [UIFont systemFontOfSize:12];
    self.phoneField.textAlignment = NSTextAlignmentLeft;
    [phoneImage addSubview:self.phoneField];
    
    //图形验证码输入框
    UIImageView *pictureImage = [[UIImageView alloc] initWithFrame:CGRectMake(phoneImage.frame.origin.x, phoneImage.frame.origin.y+phoneImage.frame.size.height+20, self.view.frame.size.width/2+20, phoneImage.frame.size.height)];
    pictureImage.image = [UIImage imageNamed:@"icon_tuxing"];
    pictureImage.userInteractionEnabled = YES;
    [self.view addSubview:pictureImage];
    
    self.pictureField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, pictureImage.frame.size.width-50, 30)];
    self.pictureField.placeholder = @"请输入图形验证码";
    self.pictureField.font = [UIFont systemFontOfSize:12];
    [pictureImage addSubview:self.pictureField];
    
    //图形验证码图片
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(pictureImage.frame.origin.x+pictureImage.frame.size.width+15, pictureImage.frame.origin.y, phoneImage.frame.size.width-pictureImage.frame.size.width-15, pictureImage.frame.size.height);
    imageBtn.backgroundColor = [UIColor lightGrayColor];
    [imageBtn addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.layer.cornerRadius = 15;
    imageBtn.layer.masksToBounds = YES;
    [self.view addSubview:imageBtn];
    
    //网络请求验证码
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,GETREGISTIMAGE_URL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:regID] forKey:@"regId"];
    [HttpTool post:url params:params success:^(id json) {
        NSArray *dataArr = [json objectForKey:@"strImgYzm"];
        NSDictionary *imageDic = [dataArr firstObject];
        NSString *imageString = [imageDic objectForKey:@"ImageYzm"];
        NSData *imageData = [GTMBase64 decodeString:imageString];
        UIImage *image = [UIImage imageWithData:imageData];
        [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        regID = [[imageDic objectForKey:@"regId"] intValue];
    } failure:^(NSError *error) {
        NSLogTC(@"获取验证码失败：%@",error);
    }];
    
    //密码输入框
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(pictureImage.frame.origin.x, pictureImage.frame.origin.y+pictureImage.frame.size.height+20, phoneImage.frame.size.width, phoneImage.frame.size.height)];
    passwordImage.image = [UIImage imageNamed:@"icon_lock"];
    passwordImage.userInteractionEnabled = YES;
    [self.view addSubview:passwordImage];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, passwordImage.frame.size.width-50, 30)];
    self.password.placeholder = @"请输入短信验证码";
    self.password.font = [UIFont systemFontOfSize:12];
    [passwordImage addSubview:self.password];
    
    //注册按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1002;
    nextBtn.frame = CGRectMake(self.view.center.x-phoneImage.frame.size.width/2+25, passwordImage.frame.origin.y+passwordImage.frame.size.height+20, phoneImage.frame.size.width-50, phoneImage.frame.size.height);
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 20;
    nextBtn.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    [self.view addSubview:nextBtn];
    
    //忘记密码
    
}

//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

//验证码更换
- (void)changePicture
{

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

//登录
- (void)loginBtnClicked
{
    
}

@end
