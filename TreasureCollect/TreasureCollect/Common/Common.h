//
//  Common.h
//  TreasureCollect
//
//  Created by Apple on 2016/12/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#ifndef Common_h
#define Common_h

//管理接口和服务器地址
#define BASE_URL @"http://192.168.100.105:8080" //吉哥服务器
#define BASE_URL2 @"http://192.168.10.106:8080"//钱钱服务器

//登陆模块
#define LOGIN_URL @"/wsb/java/servlet/LoginSeleUser"

//图形验证码
#define GETREGISTIMAGE_URL @"/wsb/java/servlet/RegistGetImageYzm"
#define GETREGISTIMAGE_URL2 @"/wsb/java/servlet/RegistGetShortMsgYzm"//短信验证码


#endif /* Common_h */
