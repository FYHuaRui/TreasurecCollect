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
#define BASE_URL @"http://112.74.169.207:80" //阿里云服务器

//登陆模块
#define LOGIN_URL @"/wsb/java/servlet/LoginSeleUser"
#define LOGIN_Password @"/wsb/java/servlet/LoginByPwd"
#define LOGIN_MSG @"/wsb/java/servlet/LoginGetSmYzm"
#define LOGIN @"/wsb/java/servlet/LoginBySm"

//图形验证码
#define GETREGISTIMAGE_URL @"/wsb/java/servlet/RegisterGetImgYzm"//图片验证码
#define GETREGISTIMAGE_URL2 @"/wsb/java/servlet/RegisterGetSmYzm"//短信验证码

#define GETREGISTIMAGE_URL3 @"/wsb/java/servlet/RegisterLastStep"//账号密码注册
#define GETREGISTIMAGE_URL4 @"/wsb/java/servlet/LoginGetImgYzm"//密码登录获取验证码

//忘记密码
#define GETYZM @"/wsb/java/servlet/UpdPwdGetSmYzm"
#define CHANGEPW @"/wsb/java/servlet/UpdPwd"

//充值模块
#define RECHARTE_URL @"/Pingplusplus/ReceiptServlet"
#define AMTCHARGE @"/wsb/java/servlet/AmtCharge"//支付接口

//修改用户昵称
#define ChangeNickName @"/wsb/java/servlet/ChangeNickName" //修改昵称

//资金流水
#define AmtIOSele @"/wsb/java/servlet/AmtIOSele"


#endif /* Common_h */
