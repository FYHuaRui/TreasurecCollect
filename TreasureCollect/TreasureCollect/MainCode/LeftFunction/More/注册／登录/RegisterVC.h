//
//  RegisterVC.h
//  TreasureCollect
//
//  Created by 杨鹏 on 2016/12/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : BaseViewController<UITextFieldDelegate>

@property (nonatomic, retain) UITextField       *phoneField;//手机号

@property (nonatomic, retain) UITextField       *pictureField;//图形验证

@property (nonatomic, retain) UITextField       *password;//密码

@property (nonatomic, retain) UITextField       *password2;//确认密码

@property (nonatomic, retain) UITextField       *messageField;//短信验证

//@property (nonatomic) int  regIdID;//图片验证码ID

@end
