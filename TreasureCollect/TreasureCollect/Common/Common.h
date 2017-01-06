//
//  Common.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#ifndef Common_h
#define Common_h


//pingPP回调配置
#define kUrlScheme      @"demoapp001"

//管理接口和服务器地址
#define BASE_URL @"http://192.168.100.218:8080" //吉哥服务器
#define BASE_URL2 @"http://192.168.10.66:8080"//钱钱服务器

//登陆模块
#define LOGIN_URL @"/wsb/java/servlet/LoginSeleUser"
#define LOGIN_Password @"/wsb/java/servlet/LoginByPassword"
#define LOGIN_MSG @"/wsb/java/servlet/LoginGetShortMsgYzm"
#define LOGIN @"/wsb/java/servlet/LoginByShortMsg"

//图形验证码
#define GETREGISTIMAGE_URL @"/wsb/java/servlet/RegisterGetImageYzm"//图片验证码
#define GETREGISTIMAGE_URL2 @"/wsb/java/servlet/RegisterGetShortMsgYzm"//短信验证码

#define GETREGISTIMAGE_URL3 @"/wsb/java/servlet/RegisterLastStep"//账号密码注册
#define GETREGISTIMAGE_URL4 @"/wsb/java/servlet/LoginGetImageYzm"//密码登录获取验证码

//忘记密码
#define GETYZM @"/wsb/java/servlet/ChangePwdGetShortYzm"
#define CHANGEPW @"/wsb/java/servlet/ChangePwd"

//充值模块
#define RECHARTE_URL @"/Pingplusplus/ReceiptServlet"
#define AMTCHARGE @"/wsb/java/servlet/AmtCharge"//支付接口


#endif /* Common_h */
