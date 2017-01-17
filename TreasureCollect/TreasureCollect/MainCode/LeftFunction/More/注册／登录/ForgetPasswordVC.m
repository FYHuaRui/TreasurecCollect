//
//  ForgetPasswordVC.m
//  TreasureCollect
//
//  Created by 杨鹏 on 2016/12/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ForgetPasswordVC.h"

@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC

//第一次页面加载进行验证码请求的smYzmId
static int smYzmId = 0;

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
    self.title = @"忘记密码";
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
    //辞去键盘手势
    UITapGestureRecognizer *resignTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTap:)];
    [self.view addGestureRecognizer:resignTap];
    
    //手机号的输入框
    UIImageView *phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 60, self.view.frame.size.width-50, 40)];
    phoneImage.image = [UIImage imageNamed:@"icon_iphon"];
    phoneImage.userInteractionEnabled = YES;
    [self.view addSubview:phoneImage];
    
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, phoneImage.frame.size.width-150, 30)];
    self.phoneField.delegate = self;
    self.phoneField.placeholder = @"请输入手机号";
    self.phoneField.tag = 1001;
    self.phoneField.clearButtonMode = UITextFieldViewModeAlways;
    self.phoneField.font = [UIFont systemFontOfSize:12];
    self.phoneField.textAlignment = NSTextAlignmentLeft;
    self.phoneField.keyboardType = UIKeyboardTypeDecimalPad;
    [phoneImage addSubview:self.phoneField];
    
    [self.phoneField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    //获取验证码的按钮
    UIButton *yzmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    yzmBtn.tag = 1101;
    yzmBtn.frame = CGRectMake(self.phoneField.left+self.phoneField.width, 0, phoneImage.width-self.phoneField.width-45, 40);
    [yzmBtn setTitle:@"获取短信验证" forState:UIControlStateNormal];
    [yzmBtn setTitleColor:[UIColor colorFromHexRGB:@"008fd0"] forState:UIControlStateNormal];
    [yzmBtn setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [yzmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [yzmBtn.layer setBorderWidth:1.0];
    yzmBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [yzmBtn addTarget:self action:@selector(getMessage) forControlEvents:UIControlEventTouchUpInside];
    yzmBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    yzmBtn.backgroundColor = [UIColor clearColor];
    yzmBtn.layer.cornerRadius = 20;
    yzmBtn.layer.masksToBounds = YES;
    [phoneImage addSubview:yzmBtn];
    
    //短信验证码输入框
    UIImageView *messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(phoneImage.frame.origin.x, phoneImage.frame.origin.y+phoneImage.frame.size.height+20, phoneImage.frame.size.width, phoneImage.frame.size.height)];
    messageImage.image = [UIImage imageNamed:@"duanxin"];
    messageImage.userInteractionEnabled = YES;
    [self.view addSubview:messageImage];
    
    self.messageField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, messageImage.frame.size.width-50, 30)];
    self.messageField.placeholder = @"请输入短信验证码";
    self.messageField.font = [UIFont systemFontOfSize:12];
    [messageImage addSubview:self.messageField];
    
    //设置密码
    UIImageView *pwImage = [[UIImageView alloc] initWithFrame:CGRectMake(messageImage.frame.origin.x, messageImage.frame.origin.y+messageImage.frame.size.height+20, messageImage.frame.size.width, messageImage.frame.size.height)];
    pwImage.image = [UIImage imageNamed:@"icon_lock"];
    pwImage.userInteractionEnabled = YES;
    [self.view addSubview:pwImage];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, messageImage.frame.size.width-50, 30)];
    self.password.placeholder = @"设置密码(6~16位，字母、数字组合)";
    self.password.font = [UIFont systemFontOfSize:12];
    self.password.secureTextEntry = YES;
    [pwImage addSubview:self.password];
    
    //确认密码
    UIImageView *pw2Image = [[UIImageView alloc] initWithFrame:CGRectMake(pwImage.frame.origin.x, pwImage.frame.origin.y+pwImage.frame.size.height+20, pwImage.frame.size.width, pwImage.frame.size.height)];
    pw2Image.userInteractionEnabled = YES;
    pw2Image.image = [UIImage imageNamed:@"icon_lock"];
    [self.view addSubview:pw2Image];
    
    self.password2 = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, messageImage.frame.size.width-80, 30)];
    self.password2.placeholder = @"请确认密码(6~16位，字母、数字组合)";
    self.password2.font = [UIFont systemFontOfSize:12];
    self.password2.secureTextEntry = YES;
    [pw2Image addSubview:self.password2];
    
    //查看密码按钮
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(self.password2.frame.origin.x+self.password2.width+2, self.password2.frame.origin.y+8, 22.5, 14);
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [pw2Image addSubview:checkBtn];
    
    //修改按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.tag = 1102;
    nextBtn.frame = CGRectMake(self.view.center.x-phoneImage.frame.size.width/2+25, pw2Image.frame.origin.y+pw2Image.frame.size.height+20, phoneImage.frame.size.width-50, phoneImage.frame.size.height);
    [nextBtn setTitle:@"修改" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(changePassWord) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 20;
    nextBtn.userInteractionEnabled = NO;
    nextBtn.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    [self.view addSubview:nextBtn];
}


//返回按钮
- (void)returnClicked
{
    NSLogTC(@"返回按钮点击了");
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 @功能：辞去键盘响应
 @参数：当前手饰
 @返回值：无
 */
- (void)resignTap:(UITapGestureRecognizer*)gesture
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

//监听文本输入框内容的改变
- (void)textValueChanged
{
    UIButton *button = [self.view viewWithTag:1102];
    if ([self.phoneField.text length] == 11)
    {
        button.userInteractionEnabled = YES;
        button.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    }
    else
    {
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    }
}

/*
 @功能：查看密码
 @参数：当前按钮
 @返回值：无
 */
- (void)checkBtnClicked:(UIButton*)button
{
    static BOOL change = YES;
    if (change)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_show1"] forState:UIControlStateNormal];
        self.password.secureTextEntry = NO;
        self.password2.secureTextEntry = NO;
        change = NO;
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
        self.password.secureTextEntry = YES;
        self.password2.secureTextEntry = YES;
        change = YES;
    }
}


//获取短信验证码
- (void)getMessage
{
    if ([self.phoneField.text isEqualToString:@""])
    {
        [self hideSuccessHUD:@"手机号不能为空"];
    }
    else
    {
        //正规表达式 验证手机号合法性
        NSString *secretRegex = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
        if (![test evaluateWithObject:self.phoneField.text])
        {
            [self hideSuccessHUD:@"手机号不合法"];
        }
        else
        {
            //网络请求验证码
            NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,GETYZM];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[NSNumber numberWithInt:smYzmId] forKey:@"smYzmId"];
            [params setObject:[NSString stringWithString:self.phoneField.text] forKey:@"telephone"];
            NSLog(@"%@",params);
            [HttpTool post:url params:params success:^(id json) {
                NSLog(@"%@",json);
                NSArray *DataAry = [json objectForKey:@"NewSmYzm"];
                NSDictionary *newId = [DataAry firstObject];
                smYzmId = [[newId objectForKey:@"smYzmId"] intValue];
                NSArray *dataArr = [json objectForKey:@"RspMsg"];
                NSDictionary *imageDic = [dataArr firstObject];
                NSString *runMessage = [imageDic objectForKey:@"runMsg"];
                int a = [[imageDic objectForKey:@"runCode"] intValue];
                if (a == 110040)
                {
                    [self hideSuccessHUD:runMessage];
                }
            } failure:^(NSError *error) {
                NSLogTC(@"获取验证码失败：%@",error);
                [self hideSuccessHUD:@"验证码获取失败"];
            }];
        }
    }

}

//修改密码按钮响应事件
- (void)changePassWord
{
    if ([self.phoneField.text isEqualToString:@""])
    {
        [self hideSuccessHUD:@"手机号不能为空"];
    }
    else
    {
        //正规表达式 验证手机号合法性
        NSString *secretRegex = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
        if (![test evaluateWithObject:self.phoneField.text])
        {
            [self hideSuccessHUD:@"手机号不合法"];
        }
        else
        {
            if ([self.messageField.text isEqualToString:@""])
            {
                [self hideSuccessHUD:@"请输入短信验证码"];
            }
            else
            {
                if ([self.password.text isEqualToString:@""] && [self.password2.text isEqualToString:@""])
                {
                    [self hideSuccessHUD:@"请输入密码"];
                }
                else
                {
                    if ([self.password.text isEqualToString:self.password2.text])
                    {
                        //网络请求验证码
                        NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,CHANGEPW];
                        NSMutableDictionary *params = [NSMutableDictionary dictionary];
                        [params setObject:[NSNumber numberWithInt:smYzmId] forKey:@"smYzmId"];
                        [params setObject:[NSString stringWithString:self.messageField.text] forKey:@"smYzm"];
                        [params setObject:[NSString stringWithString:self.phoneField.text] forKey:@"telephone"];
                        [params setObject:[NSString stringWithString:self.password.text] forKey:@"password"];
                        [params setObject:[NSString stringWithString:self.password2.text] forKey:@"pwdConfirm"];
                        [HttpTool post:url params:params success:^(id json) {
                            NSLogTC(@"%@",json);
                            NSArray *dataArr = [json objectForKey:@"RspMsg"];
                            NSDictionary *imageDic = [dataArr firstObject];
                            NSString *runMessage = [imageDic objectForKey:@"runMsg"];
                            int a = [[imageDic objectForKey:@"runCode"] intValue];
                            if (a == 110040)
                            {
                                [self hideSuccessHUD:runMessage];
                            }
                            if (a == 100545)
                            {
                                [self hideSuccessHUD:runMessage];
                            }
                            if (a == 0)
                            {
                                [self hideSuccessHUD:runMessage];
                            }
                        } failure:^(NSError *error) {
                            NSLogTC(@"获取验证码失败：%@",error);
                            [self hideSuccessHUD:@"修改失败"];
                        }];
                        
                    }
                    else
                    {
                        [self hideSuccessHUD:@"密码不一致"];
                    }
                }
            }
        }
    }
}


@end
