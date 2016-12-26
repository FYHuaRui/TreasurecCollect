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
#define BASE_URL @"http://192.168.100.105:8080" //吉哥服务器
#define BASE_URL2 @"http://192.168.10.66:8080"//钱钱服务器

//登陆模块
#define LOGIN_URL @"/wsb/java/servlet/LoginSeleUser"

//图形验证码
#define GETREGISTIMAGE_URL @"/wsb/java/servlet/RegisterGetImageYzm"
#define GETREGISTIMAGE_URL2 @"/wsb/java/servlet/RegisterGetShortMsgYzm"//短信验证码
#define GETREGISTIMAGE_URL3 @"/wsb/java/servlet/RegisterLastStep"//账号密码注册


//充值模块
#define RECHARTE_URL @"/Pingplusplus/ReceiptServlet"


#endif /* Common_h */
