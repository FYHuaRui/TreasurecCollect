//
//  WithdrawalController.h
//  TreasureCollect
//
//  Created by Apple on 2017/2/15.
//  Copyright © 2017年 Apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WithDrwwalCell.h"

@interface WithdrawalController : BaseViewController<UITableViewDelegate,UITableViewDataSource>{

    UIScrollView *_bgScrollView;
    
    UIImageView *_topImage;
    
    //输入金额
    UIView      *_countView;
    UILabel     *_countLabel;
    UITextField *_countTF;
    
    //注释
    UILabel     *_remaindLabel;
    
#warning 这里没有做银行卡号的验证
    //银行信息
    UITableView *_bankCardMsgTableView;
    //银行单元格标题
    NSArray     *_titleArr;
    NSArray     *_placeHoldArr;
    
    //手机验证信息
    UIView      *_validateView;
    UITextField *_phoneNumTf;
    UIButton    *_validateButton;
    
    UIView      *_validateInputView;
    UITextField *_validateTF;
    
    //提示信息
    UILabel     *_remindLabel;
    
    //确认按钮
    UIButton    *_withdrawalButton;
    
}

@end
