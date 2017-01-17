//
//  LoginVC.m
//  TreasureCollect
//
//  Created by FYHR on 2016/12/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LoginVC.h"
#import "ForgetPasswordVC.h"
#import "RegisterVC.h"
#import "HomeController.h"

@interface LoginVC ()

@end

@implementation LoginVC

//第一次页面加载进行验证码请求的regID
static int imgYzmId = 0;
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
    //辞去键盘手势
    UITapGestureRecognizer *resignTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTap:)];
    [self.view addGestureRecognizer:resignTap];
    
    //密码登录／短信验证登录
    UIButton *password = [UIButton buttonWithType:UIButtonTypeCustom];
    password.tag = 1001;
    [password setTitle:@"密码登录" forState:UIControlStateNormal];
    [password setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    password.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    password.userInteractionEnabled = NO;
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
    
    //添加一个底层view
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, self.view.height-40)];
    returnView.backgroundColor = [UIColor whiteColor];
    returnView.tag = 8888;
    [self.view addSubview:returnView];
    
    //默认密码登录
    UIView *phoneView = [[UIView alloc] initWithFrame:returnView.frame];
    phoneView.backgroundColor = [UIColor whiteColor];
    [returnView addSubview:phoneView];
    
    //手机号的输入框
    UIImageView *phoneImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, self.view.frame.size.width-50, 40)];
    phoneImage.image = [UIImage imageNamed:@"icon_iphon"];
    phoneImage.userInteractionEnabled = YES;
    [phoneView addSubview:phoneImage];
    
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, phoneImage.frame.size.width-50, 30)];
    self.phoneField.placeholder = @"请输入手机号";
    self.phoneField.font = [UIFont systemFontOfSize:12];
    self.phoneField.textAlignment = NSTextAlignmentLeft;
    self.phoneField.keyboardType = UIKeyboardTypeDecimalPad;
    [phoneImage addSubview:self.phoneField];
    
    //手机号满足11位，登录变颜色
    [self.phoneField addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    //图形验证码输入框
    UIImageView *pictureImage = [[UIImageView alloc] initWithFrame:CGRectMake(phoneImage.frame.origin.x, phoneImage.frame.origin.y+phoneImage.frame.size.height+20, self.view.frame.size.width/2+20, phoneImage.frame.size.height)];
    pictureImage.image = [UIImage imageNamed:@"icon_tuxing"];
    pictureImage.userInteractionEnabled = YES;
    [phoneView addSubview:pictureImage];
    
    self.pictureField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, pictureImage.frame.size.width-50, 30)];
    self.pictureField.placeholder = @"请输入图形验证码";
    self.pictureField.font = [UIFont systemFontOfSize:12];
    [pictureImage addSubview:self.pictureField];
    
    //图形验证码图片
    UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame = CGRectMake(pictureImage.frame.origin.x+pictureImage.frame.size.width+15, pictureImage.frame.origin.y, phoneImage.frame.size.width-pictureImage.frame.size.width-15, pictureImage.frame.size.height);
    imageBtn.backgroundColor = [UIColor lightGrayColor];
    [imageBtn addTarget:self action:@selector(ChangePicture:) forControlEvents:UIControlEventTouchUpInside];
    imageBtn.layer.cornerRadius = 15;
    imageBtn.layer.masksToBounds = YES;
    [phoneView addSubview:imageBtn];
    
    //网络请求验证码
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,GETREGISTIMAGE_URL4];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:imgYzmId] forKey:@"imgYzmId"];
    [HttpTool post:url params:params success:^(id json) {
        NSLog(@"%@",json);
        NSArray *dataArr = [json objectForKey:@"NewImgYzm"];
        NSDictionary *imageDic = [dataArr firstObject];
        NSString *imageString = [imageDic objectForKey:@"imgBase64"];
        NSData *imageData = [GTMBase64 decodeString:imageString];
        UIImage *image = [UIImage imageWithData:imageData];
        [imageBtn setBackgroundImage:image forState:UIControlStateNormal];
        imgYzmId = [[imageDic objectForKey:@"imgYzmId"] intValue];
    } failure:^(NSError *error) {
        NSLogTC(@"获取验证码失败：%@",error);
    }];
    
    //密码输入框
    UIImageView *passwordImage = [[UIImageView alloc] initWithFrame:CGRectMake(pictureImage.frame.origin.x, pictureImage.frame.origin.y+pictureImage.frame.size.height+20, phoneImage.frame.size.width, phoneImage.frame.size.height)];
    passwordImage.image = [UIImage imageNamed:@"icon_lock"];
    passwordImage.userInteractionEnabled = YES;
    [phoneView addSubview:passwordImage];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, passwordImage.frame.size.width-80, 30)];
    self.password.placeholder = @"请输入密码";
    self.password.font = [UIFont systemFontOfSize:12];
    self.password.secureTextEntry = YES;
    [passwordImage addSubview:self.password];
    
    //查看密码按钮
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.frame = CGRectMake(self.password.frame.origin.x+self.password.width+2, self.password.frame.origin.y+8, 22.5, 14);
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [passwordImage addSubview:checkBtn];
    
    //登录按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.tag = 1102;
    loginBtn.frame = CGRectMake(self.view.center.x-phoneImage.frame.size.width/2+25, passwordImage.frame.origin.y+passwordImage.frame.size.height+20, phoneImage.frame.size.width-50, phoneImage.frame.size.height);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    loginBtn.layer.cornerRadius = 20;
    loginBtn.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    [phoneView addSubview:loginBtn];
    
    //忘记密码
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(loginBtn.left+15, loginBtn.top+loginBtn.height+12, 80, 30)];
    questionView.backgroundColor = [UIColor clearColor];
    [phoneView addSubview:questionView];
    
    //添加问号
    UIImageView *qImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    qImageView.image = [UIImage imageNamed:@"question"];
    [questionView addSubview:qImageView];
    
    //忘记密码
    UILabel *aLab = [[UILabel alloc] initWithFrame:CGRectMake(qImageView.left+qImageView.width+5, qImageView.top, 60, qImageView.height)];
    aLab.text = @"忘记密码";
    aLab.textColor = [UIColor grayColor];
    aLab.font = [UIFont systemFontOfSize:14];
    [questionView addSubview:aLab];
    
    //点击收回更多界面
    UITapGestureRecognizer  *forgetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetTapClicked:)];
    [questionView addGestureRecognizer:forgetTap];
    
    //用户注册
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame = CGRectMake(loginBtn.left+loginBtn.width-95, questionView.top, questionView.width, questionView.height);
    [regBtn addTarget:self action:@selector(regBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [regBtn setTitle:@"新用户注册" forState:UIControlStateNormal];
    regBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [regBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [regBtn addTarget:self action:@selector(regBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:regBtn];
    
//===================================================================================================
    
    //短信验证码登录
    UIView *messageView = [[UIView alloc] initWithFrame:phoneView.frame];
    messageView.backgroundColor = [UIColor whiteColor];
    [returnView addSubview:messageView];

    //手机号的输入框
    UIImageView *phoneImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(25, 20, self.view.frame.size.width-50, 40)];
    phoneImage2.image = [UIImage imageNamed:@"icon_iphon"];
    phoneImage2.userInteractionEnabled = YES;
    [messageView addSubview:phoneImage2];
    
    self.phoneField2 = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, phoneImage2.frame.size.width-50, 30)];
    self.phoneField2.placeholder = @"请输入手机号";
    self.phoneField2.font = [UIFont systemFontOfSize:12];
    self.phoneField2.textAlignment = NSTextAlignmentLeft;
    self.phoneField2.keyboardType = UIKeyboardTypeDecimalPad;
    [phoneImage2 addSubview:self.phoneField2];
    
    //手机号满足11位，登录变颜色
    [self.phoneField2 addTarget:self action:@selector(textValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    //短信验证码输入框
    UIImageView *messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(phoneImage2.frame.origin.x, phoneImage2.frame.origin.y+phoneImage2.frame.size.height+20, self.view.frame.size.width/2+20, phoneImage2.frame.size.height)];
    messageImage.image = [UIImage imageNamed:@"icon_tuxing"];
    messageImage.userInteractionEnabled = YES;
    [messageView addSubview:messageImage];
    
    self.messageField = [[UITextField alloc] initWithFrame:CGRectMake(45, 5, messageImage.frame.size.width-50, 30)];
    self.messageField.placeholder = @"请输入短信验证码";
    self.messageField.font = [UIFont systemFontOfSize:12];
    [messageImage addSubview:self.messageField];
    
    //获取短信验证码
    UIButton *dxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dxBtn.frame = CGRectMake(messageImage.frame.origin.x+messageImage.frame.size.width+15, messageImage.frame.origin.y, phoneImage2.frame.size.width-messageImage.frame.size.width-15, messageImage.frame.size.height);
    [dxBtn addTarget:self action:@selector(receiveMessage) forControlEvents:UIControlEventTouchUpInside];
    [dxBtn setBackgroundImage:[UIImage imageNamed:@"messagebg"] forState:UIControlStateNormal];
    [dxBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    dxBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [dxBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [messageView addSubview:dxBtn];
    
    //登录按钮
    UIButton *loginBtn2= [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn2.tag = 1103;
    loginBtn2.frame = CGRectMake(messageView.center.x-phoneImage2.frame.size.width/2+25, messageImage.frame.origin.y+messageImage.frame.size.height+20, phoneImage2.frame.size.width-50, phoneImage2.frame.size.height);
    [loginBtn2 setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn2 addTarget:self action:@selector(messageLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    loginBtn2.layer.cornerRadius = 20;
    loginBtn2.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    [messageView addSubview:loginBtn2];
    
    //忘记密码
    UIView *questionView2 = [[UIView alloc] initWithFrame:CGRectMake(loginBtn2.left+15, loginBtn2.top+loginBtn2.height+12, 90, 30)];
    questionView2.backgroundColor = [UIColor clearColor];
    [messageView addSubview:questionView2];
    
    //添加问号
    UIImageView *qImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    qImageView2.image = [UIImage imageNamed:@"question"];
    [questionView2 addSubview:qImageView2];
    
    //忘记密码
    UILabel *aLab2 = [[UILabel alloc] initWithFrame:CGRectMake(qImageView2.left+qImageView2.width+5, qImageView2.top, 60, qImageView2.height)];
    aLab2.text = @"忘记密码";
    aLab2.textColor = [UIColor grayColor];
    aLab2.font = [UIFont systemFontOfSize:14];
    [questionView2 addSubview:aLab2];
    
    //忘记密码手势
    UITapGestureRecognizer  *forgetTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgetTapClicked:)];
    [questionView2 addGestureRecognizer:forgetTap2];
    
    //用户注册
    UIButton *regBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn2.frame = CGRectMake(loginBtn2.left+loginBtn2.width-95, questionView2.top, questionView2.width, questionView2.height);
    [regBtn2 addTarget:self action:@selector(regBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [regBtn2 setTitle:@"新用户注册" forState:UIControlStateNormal];
    regBtn2.titleLabel.font = [UIFont systemFontOfSize:14];
    [regBtn2 addTarget:self action:@selector(regBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [regBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [regBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [messageView addSubview:regBtn2];
    
    [returnView bringSubviewToFront:phoneView];
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
    //改变密码验证按钮状态
    if ([self.phoneField.text length] == 11)
    {
        UIButton *button = [self.view viewWithTag:1102];
        button.userInteractionEnabled = YES;
        button.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    }
    else
    {
        UIButton *button = [self.view viewWithTag:1102];
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    }
    
    //改变短信验证码登录按钮状态
    if ([self.phoneField2.text length] == 11)
    {
        UIButton *button = [self.view viewWithTag:1103];
        button.userInteractionEnabled = YES;
        button.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    }
    else
    {
        UIButton *button = [self.view viewWithTag:1103];
        button.userInteractionEnabled = NO;
        button.backgroundColor = [UIColor colorFromHexRGB:@"b4b4b4"];
    }

}

//验证码更换
- (void)ChangePicture:(UIButton*)button
{
    NSLogTC(@"更换验证码");
    //网络请求验证码
    NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,GETREGISTIMAGE_URL4];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:imgYzmId] forKey:@"imgYzmId"];
    [HttpTool post:url params:params success:^(id json) {
        NSArray *dataArr = [json objectForKey:@"NewImgYzm"];
        NSDictionary *imageDic = [dataArr firstObject];
        NSString *imageString = [imageDic objectForKey:@"imgBase64"];
        NSData *imageData = [GTMBase64 decodeString:imageString];
        UIImage *image = [UIImage imageWithData:imageData];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        imgYzmId = [[imageDic objectForKey:@"imgYzmId"] intValue];
    } failure:^(NSError *error) {
        NSLogTC(@"获取验证码失败：%@",error);
    }];
}

/*
 @功能：查看密码
 @参数：按钮
 @返回值：无
 */
- (void)checkBtnClicked:(UIButton*)button
{
    static BOOL change = YES;
    if (change)
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_show1"] forState:UIControlStateNormal];
        self.password.secureTextEntry = NO;
        change = NO;
    }
    else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateNormal];
        self.password.secureTextEntry = YES;
        change = YES;
    }
}


//密码登录
- (void)passwordClicked
{
    UIView *aView = [self.view viewWithTag:8888];
    //UIView基础动画
    [UIView beginAnimations:@"hello" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    //为parentView添加动画效果
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:aView cache:NO];
    
    //在parentView执⾏行动画的时候,调换两个视图的位置,以达到视图切换的效果
    [aView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView commitAnimations];
    
    UIButton *button = [self.view viewWithTag:1002];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.userInteractionEnabled = YES;
    
    UIButton *button2 = [self.view viewWithTag:1001];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    button2.userInteractionEnabled = NO;
}

//短信登录
- (void)messageBtnClicked
{
    UIView *aView = [self.view viewWithTag:8888];
    //UIView基础动画
    [UIView beginAnimations:@"hello" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    //为parentView添加动画效果
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:aView cache:NO];
    
    //在parentView执⾏行动画的时候,调换两个视图的位置,以达到视图切换的效果
    [aView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView commitAnimations];
    
    UIButton *button = [self.view viewWithTag:1001];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.userInteractionEnabled = YES;
    
    UIButton *button2 = [self.view viewWithTag:1002];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor colorFromHexRGB:@"008fd0"];
    button2.userInteractionEnabled = NO;
}

/*
 @功能：密码登录
 @参数：无
 @返回值：无
 */
- (void)loginBtnClicked
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
            if ([self.pictureField.text isEqualToString:@""])
            {
                [self hideSuccessHUD:@"请输入验证码"];
            }
            else
            {
                //网络请求验证码
                NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_Password];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[NSNumber numberWithInt:imgYzmId] forKey:@"imgYzmId"];
                [params setObject:[NSString stringWithString:self.pictureField.text] forKey:@"imgYzm"];
                [params setObject:[NSString stringWithString:self.phoneField.text] forKey:@"telephone"];
                [params setObject:[NSString stringWithString:self.password.text] forKey:@"password"];
                NSLog(@"%@",params);
                [HttpTool post:url params:params success:^(id json) {
                    NSLog(@"%@",json);
                    NSArray *dataArr = [json objectForKey:@"RspMsg"];
                    NSDictionary *imageDic = [dataArr firstObject];
                    NSString *runMessage = [imageDic objectForKey:@"runMsg"];
                    int a = [[imageDic objectForKey:@"runCode"] intValue];
                    if (a == 200001)//登录成功!
                    {
                        NSArray *userAry = [json objectForKey:@"CurrUser"];
                        NSDictionary *userDic = [userAry firstObject];
                        NSString *PhoneStr = [userDic objectForKey:@"telephone"];
                        
                        //返回的手机号与输入的手机号相同时，返回首页,并保存userId／nikeName
                        if ([PhoneStr isEqualToString:self.phoneField.text] || [PhoneStr isEqualToString:self.phoneField2.text])
                        {
                            //提醒用户登录成功
                            [self hideSuccessHUD:runMessage];
            
                            //子线程中保存用户数据，主线程放回首页
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                                [userInfo setObject:userAry forKey:@"userInfo"];
                       
                                BOOL isLogin = YES;
                                [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:@"isLogin"];
                                [[NSUserDefaults standardUserDefaults] synchronize];//同步本地数据
                            
                                //主线程
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //返回首页
                                    for (UIViewController *controller in self.navigationController.viewControllers) {
                                        if ([controller isKindOfClass:[HomeController class]]) {
                                            [self.navigationController popToViewController:controller animated:YES];
                                        }
                                    }
                                });
                            });
                        }
                        else
                        {
                            [self hideSuccessHUD:@"登录失败，请重新登录!"];
                        }
                        
                        
                    }
                    if (a == 110040)//该手机号没有注册, 不能用来登录
                    {
                        [self hideSuccessHUD:runMessage];
                    }
                    if (a == 110003)//您输入的图片验证码不对!
                    {
                        [self hideSuccessHUD:runMessage];
                    }
                    if (a == 110500)//密码不正确
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
}

#pragma mark - 单机手势相应事件
- (void)forgetTapClicked:(UITapGestureRecognizer*)gesture
{
    ForgetPasswordVC *forgetVC = [[ForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
    [self.view removeGestureRecognizer:gesture];
}

//新用户注册
- (void)regBtnClicked
{
    RegisterVC *registerVC = [[RegisterVC alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//获取短信验证码
- (void)receiveMessage
{
    NSLog(@"获取短信验证码");
    if ([self.phoneField2.text isEqualToString:@""])
    {
        [self hideSuccessHUD:@"手机号不能为空"];
    }
    else
    {
        //正规表达式 验证手机号合法性
        NSString *secretRegex = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
        if (![test evaluateWithObject:self.phoneField2.text])
        {
            [self hideSuccessHUD:@"手机号不合法"];
        }
        else
        {
            //网络请求验证码
            NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN_MSG];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[NSNumber numberWithInt:smYzmId] forKey:@"smYzmId"];
            [params setObject:[NSString stringWithString:self.phoneField2.text] forKey:@"telephone"];
            [HttpTool post:url params:params success:^(id json) {
                NSLog(@"123123%@",json);
                NSArray *dataArr = [json objectForKey:@"NewSmYzm"];
                NSDictionary *imageDic = [dataArr firstObject];
                smYzmId = [[imageDic objectForKey:@"smYzmId"] intValue];
                
                NSArray *messageAry = [json objectForKey:@"RspMsg"];
                NSDictionary *messageDic = [messageAry firstObject];
                NSString *runMessage = [messageDic objectForKey:@"runMsg"];
                int a = [[messageDic objectForKey:@"runCode"] intValue];
                if (a == 110004)//登录成功!
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

//短信验证码登录
- (void)messageLogin
{
    if ([self.phoneField2.text isEqualToString:@""])
    {
        [self hideSuccessHUD:@"手机号不能为空"];
    }
    else
    {
        //正规表达式 验证手机号合法性
        NSString *secretRegex = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(18[0-9]))\\d{8}$";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",secretRegex];
        if (![test evaluateWithObject:self.phoneField2.text])
        {
            [self hideSuccessHUD:@"手机号不合法"];
        }
        else
        {
            if ([self.phoneField2.text isEqualToString:@""])
            {
                [self hideSuccessHUD:@"请输入验证码"];
            }
            else
            {
                //网络请求验证码
                NSString *url = [NSString stringWithFormat:@"%@%@",BASE_URL,LOGIN];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:[NSNumber numberWithInt:smYzmId] forKey:@"smYzmId"];
                [params setObject:[NSString stringWithString:self.messageField.text] forKey:@"smYzm"];
                [params setObject:[NSString stringWithString:self.phoneField2.text] forKey:@"telephone"];
                NSLog(@"%@",params);
                [HttpTool post:url params:params success:^(id json) {
                    NSLog(@"%@",json);
                    NSArray *dataArr = [json objectForKey:@"RspMsg"];
                    NSDictionary *imageDic = [dataArr firstObject];
                    NSString *runMessage = [imageDic objectForKey:@"runMsg"];
                    int a = [[imageDic objectForKey:@"runCode"] intValue];
                    if (a == 200001)//登录成功!
                    {
                        NSArray *userAry = [json objectForKey:@"CurrUser"];
                        NSDictionary *userDic = [userAry firstObject];
                        NSString *PhoneStr = [userDic objectForKey:@"telephone"];
                        
                        //返回的手机号与输入的手机号相同时，返回首页,并保存userId／nikeName
                        if ([PhoneStr isEqualToString:self.phoneField.text] || [PhoneStr isEqualToString:self.phoneField2.text])
                        {
                            //提醒用户登录成功
                            [self hideSuccessHUD:runMessage];
                            
                            //子线程中保存用户数据，主线程放回首页
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
                                [userInfo setObject:userAry forKey:@"userInfo"];
                                
                                //主线程
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    //返回首页
                                    for (UIViewController *controller in self.navigationController.viewControllers) {
                                        if ([controller isKindOfClass:[HomeController class]]) {
                                            [self.navigationController popToViewController:controller animated:YES];
                                        }
                                    }
                                });
                            });
                        }
                        else
                        {
                            [self hideSuccessHUD:@"登录失败，请重新登录!"];
                        }
                    }
                    if (a == 110040)//该手机号没有注册, 不能用来登录
                    {
                        [self hideSuccessHUD:runMessage];
                    }
                    if (a == 110003)//您输入的图片验证码不对!
                    {
                        [self hideSuccessHUD:runMessage];
                    }
                    if (a == 110500)//密码不正确
                    {
                        [self hideSuccessHUD:runMessage];
                    }
                } failure:^(NSError *error) {
                    NSLogTC(@"获取验证码失败：%@",error);
                    [self hideSuccessHUD:@"登陆连接错误"];
                }];
            }
        }
    }
}

@end
