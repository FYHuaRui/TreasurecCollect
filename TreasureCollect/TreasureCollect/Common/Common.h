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
//#define BASE_URL @"http://112.74.169.207" //阿里云服务器
#define BASE_URL @"http://192.168.1.218:8080"

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
#define RECHARTE_URL @"/wsb/java/servlet/ChargeFromCust"//充值
#define AMTCHARGE @"/wsb/java/servlet/AmtTransfer"//体现

//买入卖出
#define BUYIN_URL @"/wsb/java/servlet/OpenPos"//买入

//个人中心

#define AmtIOSele @"/wsb/java/servlet/AmtIOSele"//资金流水
#define Exchange_URL @"/wsb/java/servlet/PosDetailSele"//交易明细
#define ChangeNickName @"/wsb/java/servlet/ChangeNickName" //修改昵称


#endif /* Common_h */
