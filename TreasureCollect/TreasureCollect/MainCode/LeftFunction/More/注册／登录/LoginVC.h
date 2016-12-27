//
//  LoginVC.h
//  TreasureCollect
//
//  Created by FYHR on 2016/12/26.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate>

@property (nonatomic, retain) UITextField       *phoneField;//手机号

@property (nonatomic, retain) UITextField       *pictureField;//图形验证

@property (nonatomic, retain) UITextField       *password;//密码

@property (nonatomic, retain) UITextField       *messageField;//短信验证

@end
